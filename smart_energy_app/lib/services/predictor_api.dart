import 'package:dio/dio.dart';

class PredictorApi {
  final dio = Dio(BaseOptions(
    baseUrl: "http://127.0.0.1:8000", // change to your server / ngrok url
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<Map<String, dynamic>> getDailyPrediction(int year, int month, int day) async {
    final response = await dio.get(
      "/predict/daily",
      queryParameters: {
        "year": year,
        "month": month,
        "day": day,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getMonthlyPrediction(int year, int month) async {
    final response = await dio.get(
      "/predict/monthly",
      queryParameters: {
        "year": year,
        "month": month,
      },
    );
    return response.data;
  }
}