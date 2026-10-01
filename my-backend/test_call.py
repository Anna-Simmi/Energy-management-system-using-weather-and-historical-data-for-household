import traceback
try:
    from predictor_core import get_monthly_prediction_json, get_daily_prediction_json
    print('Calling get_monthly_prediction_json(2025,1)')
    res = get_monthly_prediction_json(2025,1)
    print('Success: keys ->', list(res.keys()))
    print('TotalConsumption:', res.get('totalConsumption'))
except Exception as e:
    print('Exception:')
    traceback.print_exc()
