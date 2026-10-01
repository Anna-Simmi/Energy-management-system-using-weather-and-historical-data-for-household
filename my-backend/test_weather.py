import requests

# Test 1: Current API key with auto:ip
print("=== Test 1: Current URL ===")
url1 = "https://api.weatherapi.com/v1/current.json?key=094c74c0c8154f6cb6055633251311&q=auto:ip&aqi=no"
try:
    r1 = requests.get(url1, timeout=10)
    print(f"Status: {r1.status_code}")
    print(f"Response: {r1.text[:500]}")
except Exception as e:
    print(f"Error: {e}")

# Test 2: Try Mangalore (fixed location)
print("\n=== Test 2: Mangalore (fixed location) ===")
url2 = "https://api.weatherapi.com/v1/current.json?key=094c74c0c8154f6cb6055633251311&q=Mangalore&aqi=no"
try:
    r2 = requests.get(url2, timeout=10)
    print(f"Status: {r2.status_code}")
    print(f"Response: {r2.text[:500]}")
except Exception as e:
    print(f"Error: {e}")

# Test 3: Try with a free API (open-meteo)
print("\n=== Test 3: Open-Meteo API (free, no key) ===")
url3 = "https://api.open-meteo.com/v1/forecast?latitude=12.9352&longitude=74.8597&current=temperature_2m,relative_humidity_2m,weather_code,cloud_cover"
try:
    r3 = requests.get(url3, timeout=10)
    print(f"Status: {r3.status_code}")
    print(f"Response: {r3.text[:500]}")
except Exception as e:
    print(f"Error: {e}")
