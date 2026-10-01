import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.170.208.142:8000";

  static Future<Map<String, dynamic>> fetchPrediction({
    required String mode,
    required int year,
    required int month,
    int? day,
  }) async {
    final url = Uri.parse("$baseUrl/predict");

    final body = {
      "mode": mode,
      "year": year,
      "month": month,
      if (mode == "daily") "day": day
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["data"];
    } else {
      throw Exception("API Error: ${response.body}");
    }
  }
}
