# ⚡ Smart Energy Management System

A Flutter-based mobile application that predicts household electricity consumption and electricity bills using historical energy consumption and weather data.

## 🎯 Features

- ⚡ Electricity consumption prediction
- 💰 Electricity bill prediction
- 🌦️ Weather information
- 📊 Peak consumption analysis
- 🏠 Appliance-wise energy insights
- 📱 Interactive Flutter dashboard
- 🌡️ Weather-based energy analysis

## 🏗️ Technology Stack

| Component | Technology |
|---|---|
| Frontend | Flutter, Dart |
| Backend | Python, FastAPI |
| Machine Learning | Random Forest Regressor, Scikit-learn |
| Data Processing | Pandas, NumPy |
| Weather API | Open-Meteo |
| Database | Firebase, Firestore |
| Model Storage | Joblib |

## 🔄 System Workflow

```text
Historical Energy Data + Weather Data
                  ↓
          Data Preprocessing
                  ↓
         Feature Engineering
                  ↓
       Random Forest Regressor
                  ↓
     Energy Consumption Prediction
                  ↓
          Bill Calculation
                  ↓
           FastAPI Backend
                  ↓
         Flutter Mobile App
                  ↓
        Energy Insights & Results
```

## 🤖 Machine Learning

The system uses a Random Forest Regressor to predict household electricity consumption based on historical consumption patterns and weather-related information.

The processed data includes time-based and weather-related features that help the model identify electricity consumption patterns.

## 🌐 Backend

The backend is developed using FastAPI and provides REST API endpoints for communicating between the Flutter application and the Machine Learning model.

The backend handles:

- Prediction requests
- Model loading
- Energy consumption prediction
- Electricity bill calculation
- Returning prediction results to the mobile application

## 📱 Mobile Application

The Flutter application provides an interactive dashboard where users can view:

- Current weather conditions
- Predicted energy consumption
- Predicted electricity bill
- Peak consumption period
- Appliance-wise energy information

## 🚀 Installation and Setup

### 1. Clone the Repository

```bash
git clone https://github.com/Anna-Simmi/Energy-management-system-using-weather-and-historical-data-for-household.git
cd Energy-management-system-using-weather-and-historical-data-for-household
```

### 2. Backend Setup

Create and activate a Python virtual environment:

```bash
python -m venv .venv
```

Windows:

```bash
.venv\Scripts\activate
```

Install the required packages:

```bash
pip install -r requirements.txt
```

Start the FastAPI server:

```bash
uvicorn app:app --reload
```

### 3. Flutter Setup

Navigate to the Flutter application directory:

```bash
cd smart_energy_app
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

## 📂 Project Structure

```text
Energy-management-system-using-weather-and-historical-data-for-household/
│
├── smart_energy_app/
│   ├── lib/
│   ├── android/
│   ├── ios/
│   ├── web/
│   └── windows/
│
├── backend/
│
├── model/
│
├── dataset/
│
├── requirements.txt
└── README.md
```



## 📌 Project Type

Academic Major Project

**Smart Energy Management using Weather and Historical Data for Household**
