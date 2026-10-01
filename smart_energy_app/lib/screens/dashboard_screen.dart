import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const EnergyDashboardApp());

class EnergyDashboardApp extends StatelessWidget {
  const EnergyDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Energy Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFF3F4F6)),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Weather
  String condition = "--";
  String iconUrl = "";
  double temperature = 0.0;
  double humidity = 0.0;
  double cloud = 0.0;
  bool isLoadingWeather = true;

  // Prediction
  double predictedKWh = 0.0;
  double predictedBill = 0.0;
  String peakHour = "--";
  String topAppliance = "--";
  bool isLoadingPrediction = true;

  @override
  void initState() {
    super.initState();
    fetchWeather();
    fetchPrediction();
  }

  // ================= GET WEATHER =================
  Future<void> fetchWeather() async {
  try {
    // Using Open-Meteo API (free, no API key needed) for Mangalore coordinates
    final url = Uri.parse(
      "https://api.open-meteo.com/v1/forecast?latitude=12.9352&longitude=74.8597&current=temperature_2m,relative_humidity_2m,weather_code,cloud_cover",
    );

    final response = await http.get(url);

    print("Weather Status: ${response.statusCode}");
    print("Weather Data: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final current = data["current"] ?? {};

      // Convert WMO weather code to description
      final int weatherCode = current["weather_code"] ?? 0;
      final String conditionText = _getWeatherDescription(weatherCode);

      setState(() {
        temperature = (current["temperature_2m"] ?? 0).toDouble();
        humidity = (current["relative_humidity_2m"] ?? 0).toDouble();
        cloud = (current["cloud_cover"] ?? 0).toDouble();
        condition = conditionText;
        iconUrl = ""; // Open-Meteo doesn't provide icon URLs, UI will use condition text

        isLoadingWeather = false;
      });
    } else {
      throw Exception("Weather API Error: ${response.statusCode}");
    }
  } catch (e) {
    print("Weather Fetch Error: $e");
    setState(() {
      isLoadingWeather = false;
      iconUrl = "";
      condition = "Unavailable";
    });
  }
}

// Convert WMO weather code to readable description
String _getWeatherDescription(int code) {
  switch (code) {
    case 0: return "Clear sky";
    case 1: case 2: return "Mostly clear";
    case 3: return "Overcast";
    case 45: case 48: return "Foggy";
    case 51: case 53: case 55: return "Drizzle";
    case 61: case 63: case 65: return "Rain";
    case 71: case 73: case 75: return "Snow";
    case 77: return "Snow grains";
    case 80: case 81: case 82: return "Rain showers";
    case 85: case 86: return "Snow showers";
    case 95: case 96: case 99: return "Thunderstorm";
    default: return "Unknown";
  }
}
  
    // ================= GET PREDICTION FROM BACKEND =================
  Future<void> fetchPrediction() async {
    try {
      final url = Uri.parse("http://10.41.82.142:8000/predict"); // 👈 IMPORTANT

      final body = jsonEncode({
        "mode": "daily",
        "year": DateTime.now().year,
        "month": DateTime.now().month,
        "day": DateTime.now().day,
      });

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      print("Backend status: ${response.statusCode}");
      print("Backend data: ${response.body}");

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final data = result["data"];

        setState(() {
          predictedKWh = (data["totalConsumption"] ?? 0.0).toDouble();
          predictedBill = (data["predictedBill"] ?? 0.0).toDouble();
          peakHour = data["peakHour"] ?? "--";
          topAppliance = data["topAppliance"] ?? "--";
          isLoadingPrediction = false;
        });
      } else {
        setState(() => isLoadingPrediction = false);
      }
      
    } catch (e) {
      print("Prediction Error: $e");
      setState(() => isLoadingPrediction = false);
    }
  }

  // ====================== UI ======================
  @override
  Widget build(BuildContext context) {
    final today = "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [Padding(padding: const EdgeInsets.only(right: 16), child: Text(today))],
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          isLoadingWeather
              ? const Center(child: CircularProgressIndicator())
              : WeatherCard(temp: temperature, humidity: humidity, cloud: cloud, condition: condition, iconUrl: iconUrl),

          const SizedBox(height: 20),

          isLoadingPrediction
              ? const Center(child: CircularProgressIndicator())
              : PredictionCard(
                  predictedKWh: predictedKWh,
                  predictedBill: predictedBill,
                  peakHour: peakHour,
                  topAppliance: topAppliance,
                ),
        ]),
      ),
    );
  }
}


// ================= WEATHER WIDGET FIXED =================
class WeatherCard extends StatelessWidget {
  final double temp, humidity, cloud;
  final String condition, iconUrl;

  const WeatherCard({
    super.key,
    required this.temp,
    required this.humidity,
    required this.cloud,
    required this.condition,
    required this.iconUrl,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasValidIcon = iconUrl.isNotEmpty && iconUrl.startsWith("http");

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(colors: [Color(0xFF4A90E2), Color(0xFF63B8FF)]),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                "Today's Weather",
                style: TextStyle(color: Colors.white, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (hasValidIcon)
              Image.network(
                iconUrl,
                width: 35,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.cloud, color: Colors.white, size: 30),
              )
            else
              const Icon(Icons.cloud, color: Colors.white, size: 30),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                condition,
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            )
          ],
        ),
        const SizedBox(height: 8),
        Text(
          "${temp.toStringAsFixed(1)}°C",
          style: const TextStyle(fontSize: 46, color: Colors.white),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            _detail(Icons.water_drop, "Humidity: ${humidity.toStringAsFixed(0)}%"),
            const SizedBox(width: 15),
            _detail(Icons.cloud, "Cloud: ${cloud.toStringAsFixed(0)}%"),
          ],
        ),
      ]),
    );
  }

  Widget _detail(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}



// ================== PREDICTION WIDGET ==================
class PredictionCard extends StatelessWidget {
  final double predictedKWh, predictedBill;
  final String peakHour, topAppliance;

  const PredictionCard({
    super.key,
    required this.predictedKWh,
    required this.predictedBill,
    required this.peakHour,
    required this.topAppliance,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("Energy Prediction", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
          _rowItem("Total Consumption", "${predictedKWh.toStringAsFixed(2)} kWh"),
          _rowItem("Predicted Bill", "₹ ${predictedBill.toStringAsFixed(2)}"),
          _rowItem("Peak Hour", peakHour),
          _rowItem("Highest Appliance", topAppliance),
        ]),
      ),
    );
  }

  Widget _rowItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      ]),
    );
  }
}
