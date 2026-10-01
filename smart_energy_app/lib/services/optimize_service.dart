import 'dart:convert';
import 'package:http/http.dart' as http;

class OptimizeService {
  // ✔ CHANGE THIS BASE URL to match your server
  // For emulator use http://10.0.2.2:8000
  // For real device use http://<your_system_ip>:8000
  static const String baseUrl = "http://10.0.2.2:8000";

  // Main function to call /optimize API
  static Future<OptimizeResponse> optimizeEnergy({
    required int year,
    required int month,
    required double targetBill,
  }) async {
    final url = Uri.parse("$baseUrl/optimize");

    final body = jsonEncode({
      "year": year,
      "month": month,
      "target_bill": targetBill,
    });

    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    final response = await http.post(url, body: body, headers: headers);

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);

      if (jsonBody["status"] == "success") {
        return OptimizeResponse.fromJson(jsonBody["data"]);
      } else {
        throw Exception("Error: ${jsonBody['message']}");
      }
    } else {
      throw Exception("Server error: ${response.statusCode}\n${response.body}");
    }
  }
}


/// Response Model Class
class OptimizeResponse {
  final double predictedKWh;
  final double allowedKWh;
  final double optimizedKWh;
  final double optimizedBill;
  final double scaleFactorAvg;
  final List<ApplianceBreakdown> applianceBreakdown;

  OptimizeResponse({
    required this.predictedKWh,
    required this.allowedKWh,
    required this.optimizedKWh,
    required this.optimizedBill,
    required this.scaleFactorAvg,
    required this.applianceBreakdown,
  });

  factory OptimizeResponse.fromJson(Map<String, dynamic> json) {
    return OptimizeResponse(
      predictedKWh: (json["predicted_kWh"] as num).toDouble(),
      allowedKWh: (json["allowed_kWh"] as num).toDouble(),
      optimizedKWh: (json["optimized_kWh"] as num).toDouble(),
      optimizedBill: (json["optimized_bill"] as num).toDouble(),
      scaleFactorAvg: (json["scale_factor_avg"] as num).toDouble(),
      applianceBreakdown: (json["appliance_breakdown"] as List)
          .map((item) => ApplianceBreakdown.fromJson(item))
          .toList(),
    );
  }
}


/// Appliance Level Breakdown Model
class ApplianceBreakdown {
  final String appliance;
  final double originalKWh;
  final double scaleFactor;
  final double optimizedKWh;

  ApplianceBreakdown({
    required this.appliance,
    required this.originalKWh,
    required this.scaleFactor,
    required this.optimizedKWh,
  });

  factory ApplianceBreakdown.fromJson(Map<String, dynamic> json) {
    return ApplianceBreakdown(
      appliance: json["appliance"],
      originalKWh: (json["original_kWh"] as num).toDouble(),
      scaleFactor: (json["scale_factor"] as num).toDouble(),
      optimizedKWh: (json["optimized_kWh"] as num).toDouble(),
    );
  }
}
