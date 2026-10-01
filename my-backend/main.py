from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from predictor_core import (
    get_daily_prediction_json,
    get_monthly_prediction_json
)
from optimizer import pso_optimize

# ---------------------------
# Request Models
# ---------------------------
class PredictionRequest(BaseModel):
    mode: str            # "daily" | "monthly"
    year: int
    month: int
    day: int | None = None   # required only if daily


class OptimizeRequest(BaseModel):
    year: int
    month: int
    target_bill: float


# ---------------------------
# FastAPI Application Setup
# ---------------------------
app = FastAPI(
    title="Energy Predictor + Optimizer API",
    version="2.0.0",
    description="Backend with Prediction + PSO Optimization for EMS"
)


@app.get("/")
def root():
    return {"message": "Energy Predictor & Optimizer API is running 🚀"}


# ---------------------------
# PREDICTION ENDPOINT
# ---------------------------
@app.post("/predict")
def predict(req: PredictionRequest):
    try:
        mode = req.mode.lower()

        if mode not in ["daily", "monthly"]:
            raise HTTPException(status_code=400, detail="mode must be 'daily' or 'monthly'")

        if mode == "daily":
            if req.day is None:
                raise HTTPException(status_code=400, detail="day is required for daily mode")

            result = get_daily_prediction_json(req.year, req.month, req.day)

        else:  # monthly
            result = get_monthly_prediction_json(req.year, req.month)

        return {"status": "success", "data": result}

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Prediction failed: {str(e)}")


# ---------------------------
# OPTIMIZATION ENDPOINT (PSO)
# ---------------------------
@app.post("/optimize")
def optimize(req: OptimizeRequest):
    try:
        result = pso_optimize(req.year, req.month, req.target_bill)
        return {"status": "success", "data": result}

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Optimization failed: {str(e)}")
