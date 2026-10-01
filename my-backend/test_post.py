import requests

url = 'http://127.0.0.1:8000/predict'
payload = {'mode': 'monthly', 'year': 2025, 'month': 1}
try:
    r = requests.post(url, json=payload, timeout=60)
    print('status', r.status_code)
    print(r.text)
except Exception as e:
    print('error', e)
