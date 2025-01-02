import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Do generowania dat

class TrainingAnalysis {
  Future<String> getTrainingSummary(String userId) async {

    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

   final today = DateTime.now();
    final last7Days = List.generate(
  7,
  (index) => DateFormat('yyyy-MM-dd').format(today.subtract(Duration(days: index))),
);

final snapshot = await FirebaseFirestore.instance
    .collection('trainings')
    .doc(userId) // Pobieramy dane użytkownika
    .collection('records')
    .where('completed', isEqualTo: true) // Tylko ukończone treningi
    .get();

    if (snapshot.docs.isEmpty) {
      return "No completed trainings found in the last 7 days. Start completing your trainings!";
    }

    // Zliczanie typów treningów
    Map<String, int> trainingCounts = {
      "Stability": 0,
      "Mobility": 0,
      "Football": 0,
      "Gym": 0,
      "Stretching": 0,
      "Beginner workout plan": 0,
    };

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final type = data['type'] as String?;

      if (type != null && trainingCounts.containsKey(type)) {
        trainingCounts[type] = trainingCounts[type]! + 1;
      }
    }

    // Kryteria oceny
    final meetsRecommendations = trainingCounts["Stability"]! >= 2 &&
        trainingCounts["Mobility"]! >= 1 &&
        trainingCounts["Football"]! >= 3 &&
        trainingCounts["Gym"]! >= 1 &&
        trainingCounts["Stretching"]! >= 1;

    final partiallyMeetsRecommendations = trainingCounts.values.any((count) => count > 0);

    // Generowanie odpowiedzi
    if (meetsRecommendations) {
      return "Great job! Your training routine is balanced and effective. Keep it up!";
    } else if (partiallyMeetsRecommendations) {
      return "You're doing well, but there's room for improvement. Focus on balancing all training aspects.";
    } else {
      return "Try to follow the training recommendations to optimize your performance.";
    }
  }
}