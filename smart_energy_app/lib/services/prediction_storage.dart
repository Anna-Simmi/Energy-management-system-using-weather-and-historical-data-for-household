import 'package:cloud_firestore/cloud_firestore.dart';

class PredictionStorage {
  static Future<void> saveLatestPrediction(
      String userId, Map<String, dynamic> prediction) async {

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("predictions")
        .doc("latest")
        .set({
      "timestamp": FieldValue.serverTimestamp(),
      ...prediction, // saves all prediction values
    });
  }

  static Future<Map<String, dynamic>?> getLatestPrediction(String userId) async {
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("predictions")
        .doc("latest")
        .get();

    return doc.data();
  }
}
