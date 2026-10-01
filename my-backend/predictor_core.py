import os
import math
import joblib
import calendar
import requests
import numpy as np
import pandas as pd
from datetime import datetime, timedelta
from collections import OrderedDict

# ==========================
# CONFIG
# ==========================
WEATHER_API_KEY = os.getenv("WEATHER_API_KEY", "YOUR_WEATHER_API_KEY")
CALENDAR_API_KEY = os.getenv("CALENDAR_API_KEY", "YOUR_CALENDAR_API_KEY")
HISTORY_CSV = "EMS_weather_usage_final1 (1).csv"
MODEL_PATH = "ems_consumption_model_rf_tuned.pkl"

# ==========================
# CACHE (SPEED-UP)
# ==========================
_cached_model = None
_cached_hist = None
_cached_holidays = {}


def get_model():
    global _cached_model
    if _cached_model is None:
        _cached_model = joblib.load(MODEL_PATH)
    return _cached_model


def get_history():
    global _cached_hist
    if _cached_hist is None:
        df = pd.read_csv(HISTORY_CSV, parse_dates=["time"])
        df.set_index("time", inplace=True)
        _cached_hist = df
    return _cached_hist


def get_holidays(year):
    global _cached_holidays
    if year in _cached_holidays:
        return _cached_holidays[year]

    try:
        resp = requests.get(
            "https://calendarific.com/api/v2/holidays",
            params={"api_key": CALENDAR_API_KEY, "country": "IN", "year": year, "location": "IN-KA"},
            timeout=20
        )
        resp.raise_for_status()
        holidays = resp.json()["response"]["holidays"]
        dt = pd.to_datetime([h["date"]["iso"] for h in holidays])
        result = set(dt.date)
    except:
        result = set()

    _cached_holidays[year] = result
    return result


# ==========================
# BILL CALC
# ==========================
def calculate_mescom_bill(kwh):
    fixed = 60
    if kwh <= 30:
        energy = kwh * 4.00
    elif kwh <= 100:
        energy = 30 * 4.00 + (kwh - 30) * 5.45
    elif kwh <= 200:
        energy = 30 * 4.00 + 70 * 5.45 + (kwh - 100) * 7.00
    else:
        energy = 30 * 4.00 + 70 * 5.45 + 100 * 7.00 + (kwh - 200) * 8.05
    return round(energy + fixed, 2)


# ==========================
# WEATHER FETCH
# ==========================
def fetch_weatherapi_auto(api_key, date_str, location="Mangalore"):
    today = datetime.today().date()
    target = datetime.strptime(date_str, "%Y-%m-%d").date()

    if target < today:
        url = "https://api.weatherapi.com/v1/history.json"
    elif (target - today).days <= 14:
        url = "https://api.weatherapi.com/v1/forecast.json"
    else:
        raise ValueError("WeatherAPI supports ≤ 14 days future.")

    resp = requests.get(url, params={"key": api_key, "q": location, "dt": date_str}, timeout=20)
    resp.raise_for_status()

    data = resp.json()
    hours = data.get("forecast", {}).get("forecastday", [])
    if not hours:
        raise ValueError(f"No weather available for {date_str}")

    df = pd.DataFrame(hours[0]["hour"])
    df["time"] = pd.to_datetime(df["time"])
    df.set_index("time", inplace=True)

    df.rename(columns={
        "temp_c": "temperature_2m",
        "humidity": "relative_humidity_2m",
        "cloud": "cloudcover"
    }, inplace=True)

    df.index = df.index.tz_localize(None)
    return df[["temperature_2m", "relative_humidity_2m", "cloudcover"]]


# ==========================
# ADD TIME FEATURES
# ==========================
def add_time_features(df):
    df["hour"] = df.index.hour
    df["day"] = df.index.day
    df["month"] = df.index.month
    df["weekday"] = df.index.weekday
    df["is_weekend"] = df["weekday"].isin([5, 6]).astype(int)

    df["hour_sin"] = np.sin(2*np.pi*df["hour"]/24)
    df["hour_cos"] = np.cos(2*np.pi*df["hour"]/24)
    df["month_sin"] = np.sin(2*np.pi*df["month"]/12)
    df["month_cos"] = np.cos(2*np.pi*df["month"]/12)
    return df


# ==========================
# CORE PREDICTION ENGINE
# ==========================
def run_prediction(year, month, day=None):
    model = get_model()
    hist = get_history()

    # Date range
    if day:
        dates = [datetime(year, month, day)]
    else:
        last_day = calendar.monthrange(year, month)[1]
        dates = [datetime(year, month, d) for d in range(1, last_day + 1)]

    holiday_set = get_holidays(year)

    # Build forecast weather
    frames = []
    for dt in dates:
        ds = dt.strftime("%Y-%m-%d")
        try:
            df = fetch_weatherapi_auto(WEATHER_API_KEY, ds)
        except:
            idx = pd.date_range(ds + " 00:00", ds + " 23:00", freq="H")
            df = pd.DataFrame(index=idx,
                columns=["temperature_2m", "relative_humidity_2m", "cloudcover"])
        frames.append(df)

    forecast_df = pd.concat(frames).sort_index()
    forecast_df = add_time_features(forecast_df)
    forecast_df["is_holiday"] = pd.Series(forecast_df.index.date).isin(holiday_set).astype(int)

    # Bootstrap previous values (ONLY ONCE)
    prev = list(hist["total_kWh"].iloc[-168:].tolist())
    if len(prev) < 168:
        prev = [prev[0]] * (168 - len(prev)) + prev

    preds = []
    features = model.feature_names_in_

    for t in forecast_df.index:
        prev = prev[-168:]

        lag1, lag2, lag3 = prev[-1], prev[-2], prev[-3]
        lag24, lag48, lag72 = prev[-24], prev[-48], prev[-72]

        rolling = {
            "rolling_3h": np.mean(prev[-3:]),
            "rolling_6h": np.mean(prev[-6:]),
            "rolling_12h": np.mean(prev[-12:]),
            "rolling_24h": np.mean(prev[-24:]),
            "rolling_3d": np.mean(prev[-72:]),
            "rolling_7d": np.mean(prev[-168:])
        }

        base = forecast_df.loc[t].to_dict()
        base.update({
            "lag1": lag1,
            "lag2": lag2,
            "lag3": lag3,
            "lag24": lag24,
            "lag48": lag48,
            "lag72": lag72,
            **rolling
        })

        row = np.array([base.get(f, 0) for f in features]).reshape(1, -1)
        row = np.nan_to_num(row, nan=0.0)

        # Prediction
        y = float(model.predict(row)[0])

        # ===============================
        #  HOURLY VARIATION (SAME LOGIC)
        # ===============================
        hour = t.hour

        if 17 <= hour <= 20:
            y *= np.random.uniform(1.10, 1.25)
        if 0 <= hour <= 5:
            y *= np.random.uniform(0.85, 0.92)
        if 11 <= hour <= 15:
            y *= np.random.uniform(1.02, 1.10)

        y += np.random.uniform(-0.005, 0.005)

        # ===============================
        #  SEASONAL VARIATION (NEW)
        # ===============================
        temp = base.get("temperature_2m", 28)
        humidity = base.get("relative_humidity_2m", 60)
        month = base.get("month", month)

        # Summer (Mar–Jun)
        if month in [3, 4, 5, 6]:
            if temp > 32:
                y *= np.random.uniform(1.12, 1.20)
            elif temp > 28:
                y *= np.random.uniform(1.05, 1.12)
            if humidity > 70:
                y *= np.random.uniform(1.03, 1.08)

        # Monsoon (Jul–Sep)
        elif month in [7, 8, 9]:
            if humidity > 80:
                y *= np.random.uniform(1.04, 1.10)
            else:
                y *= np.random.uniform(0.95, 1.02)

        # Winter (Nov–Jan)
        elif month in [11, 12, 1]:
            y *= np.random.uniform(0.85, 0.95)
            if 6 <= hour <= 9:
                y *= np.random.uniform(1.08, 1.15)

        # Mild Season (Feb, Oct)
        else:
            y *= np.random.uniform(0.97, 1.03)

        preds.append(y)
        prev.append(y)

    forecast_df["predicted_kWh"] = preds

    # Appliance allocation (same)
    base = OrderedDict([
        ("fridge", 0.35), ("lights", 0.08), ("tv", 0.05),
        ("fan", 0.12), ("geyser", 0.03), ("ac", 0.12), ("others", 0.25)
    ])

    for a in base:
        forecast_df[f"{a}_kWh"] = forecast_df["predicted_kWh"] * base[a]

    return forecast_df


# ==========================
# JSON PUBLIC FUNCTIONS
# ==========================
def get_monthly_prediction_json(year: int, month: int):
    df = run_prediction(year, month)

    daily = df.resample("D").sum()
    weekly = df.resample("W").sum()

    total = float(df["predicted_kWh"].sum())
    bill = calculate_mescom_bill(total)
    peak_day = daily["predicted_kWh"].idxmax().strftime("%Y-%m-%d")

    week_idx = weekly["predicted_kWh"].idxmax()
    week_num = weekly.index.get_loc(week_idx) + 1
    peak_week = f"Week {week_num} (starting {week_idx.strftime('%Y-%m-%d')})"

    apps = df[[f"{a}_kWh" for a in ["fridge","lights","tv","fan","geyser","ac","others"]]].sum().sort_values(ascending=False)
    top = apps.index[0].replace("_kWh","").capitalize()

    return {
        "mode": "monthly",
        "totalConsumption": round(total, 2),
        "predictedBill": bill,
        "peakDay": peak_day,
        "peakWeek": peak_week,
        "topAppliance": top,
        "highestBillContributor": top,
        "peakApplianceMonth": f"{top} heavy usage",
        "applianceUsage": [
            {
                "name": name.replace("_kWh", "").capitalize(),
                "usage": float(val),
                "priority": i + 1,
                "billContribution": round(bill * (val / total), 2) if total > 0 else 0
            }
            for i, (name, val) in enumerate(apps.items())
        ],
        "dailyData": [
            {"day": str(idx.day), "consumption": float(row["predicted_kWh"])}
            for idx, row in daily.iterrows()
        ]
    }


def get_daily_prediction_json(year: int, month: int, day: int):
    df = run_prediction(year, month, day)

    hourly = df.resample("H").sum()
    total = float(hourly["predicted_kWh"].sum())
    bill = calculate_mescom_bill(total)
    peak_hr = hourly["predicted_kWh"].idxmax().strftime("%H:%M:%S")

    apps = df[[f"{a}_kWh" for a in ["fridge","lights","tv","fan","geyser","ac","others"]]].sum().sort_values(ascending=False)
    top = apps.index[0].replace("_kWh","").capitalize()

    return {
        "mode": "daily",
        "totalConsumption": round(total, 2),
        "predictedBill": bill,
        "peakHour": peak_hr,
        "topAppliance": top,
        "highestBillContributor": top,
        "peakApplianceUsage": f"{top} peak hours",
        "applianceUsage": [
            {
                "name": name.replace("_kWh","").capitalize(),
                "usage": float(val),
                "priority": i + 1,
                "billContribution": round(bill * (val / total), 2) if total > 0 else 0
            }
            for i, (name, val) in enumerate(apps.items())
        ],
        "hourlyData": [
            {"hour": idx.strftime("%H:%M"), "consumption": float(row["predicted_kWh"])}
            for idx, row in hourly.iterrows()
        ]
    }
