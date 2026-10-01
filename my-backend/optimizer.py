# optimizer.py
import numpy as np
import pandas as pd
from predictor_core import run_prediction, calculate_mescom_bill

def pso_optimize(year: int, month: int, target_bill: float):
    # Step 1 -> Run monthly prediction & get consumption breakdown
    forecast_df = run_prediction(year, month)
    predicted_kwh = float(forecast_df["predicted_kWh"].sum())

    appliances = [
        "fridge_kWh","lights_kWh","tv_kWh","fan_kWh",
        "geyser_kWh","ac_kWh","others_kWh"
    ]
    original_usage = forecast_df[appliances].sum()  # monthly usage per appliance

    # Step 2 -> Convert target bill -> allowed kWh
    candidate_kwh = np.arange(0, 2000, 0.1)
    bills = np.array([calculate_mescom_bill(x) for x in candidate_kwh])
    idx = np.argmin(np.abs(bills - target_bill))
    allowed_kwh = float(candidate_kwh[idx])

    # PSO Setup
    NUM_PARTICLES = 30
    MAX_ITER = 40
    dim = len(appliances)
    particles = np.random.uniform(0.10, 1.00, (NUM_PARTICLES, dim))
    velocities = np.zeros((NUM_PARTICLES, dim))
    pbest = particles.copy()
    pbest_err = np.full(NUM_PARTICLES, np.inf)
    gbest, gbest_err = None, np.inf

    def fitness(scale):
        used = (original_usage.values * scale).sum()
        bill = calculate_mescom_bill(used)
        return abs(bill - target_bill)

    # PSO Loop
    for _ in range(MAX_ITER):
        for i in range(NUM_PARTICLES):
            err = fitness(particles[i])

            if err < pbest_err[i]:
                pbest_err[i], pbest[i] = err, particles[i].copy()

            if err < gbest_err:
                gbest_err, gbest = err, particles[i].copy()

        for i in range(NUM_PARTICLES):
            r1, r2 = np.random.rand(), np.random.rand()
            velocities[i] = (0.6 * velocities[i]
                             + 1.5 * r1 * (pbest[i] - particles[i])
                             + 1.5 * r2 * (gbest - particles[i]))

            particles[i] = np.clip(particles[i] + velocities[i], 0.10, 1.00)

    # Final values
    scale_vector = gbest
    optimized_usage = original_usage.values * scale_vector
    optimized_kwh = float(optimized_usage.sum())
    optimized_bill = calculate_mescom_bill(optimized_kwh)
    predicted_bill = calculate_mescom_bill(predicted_kwh)
    # Prepare JSON-safe breakdown
    breakdown = [
        {
            "appliance": appliances[i].replace("_kWh", "").capitalize(),
            "original_kWh": float(original_usage.values[i]),
            "scale_factor": float(scale_vector[i]),
            "optimized_kWh": float(optimized_usage[i])
        }
        for i in range(len(appliances))
    ]

    return {
        "predicted_kWh": round(predicted_kwh, 2),
        "predicted_bill": round(predicted_bill, 2),
        "allowed_kWh": round(allowed_kwh, 2),
        "optimized_kWh": round(optimized_kwh, 2),
        "optimized_bill": round(optimized_bill, 2),
        "scale_factor_avg": round(float(np.mean(scale_vector)), 6),
        "appliance_breakdown": breakdown
    }
