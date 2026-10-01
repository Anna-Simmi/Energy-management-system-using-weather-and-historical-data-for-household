import requests
import json

url = 'http://127.0.0.1:8000/predict'
payload = {
    'mode': 'daily',
    'year': 2025,
    'month': 1,
    'day': 7
}

try:
    r = requests.post(url, json=payload, timeout=60)
    print('Status:', r.status_code)
    if r.status_code == 200:
        data = r.json()
        print('Response:', json.dumps(data, indent=2)[:1000])
    else:
        print('Error:', r.text[:500])
except Exception as e:
    print('Request failed:', e)
