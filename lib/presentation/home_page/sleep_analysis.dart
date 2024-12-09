import 'package:cloud_firestore/cloud_firestore.dart';

class SleepAnalysis {
  Future<String> getSleepSummary(String userId) async {
    final collection = FirebaseFirestore.instance
        .collection('sleepData')
        .doc(userId)
        .collection('records');

    final querySnapshot = await collection
        .orderBy('date', descending: true)
        .limit(7)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return "You have no sleep data for the last 7 days. Start logging!";
    }

    int qualityScore = 0;

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      switch (data['sleepQuality']) {
        case 'Very Good':
          qualityScore += 5;
          break;
        case 'Good':
          qualityScore += 4;
          break;
        case 'Average':
          qualityScore += 3;
          break;
        case 'Poor':
          qualityScore += 2;
          break;
        case 'Very Poor':
          qualityScore += 1;
          break;
        default:
          qualityScore += 0;
      }
    }

    final averageQuality = qualityScore / querySnapshot.docs.length;

    // Dodajemy więcej wiadomości na podstawie zakresów
    if (averageQuality >= 4.5) {
      return "Excellent sleep! Keep maintaining your great habits.";
    } else if (averageQuality >= 4.0) {
      return "Your sleep quality has been good over the last 7 days. Keep it up!";
    } else if (averageQuality >= 3.5) {
      return "Your sleep is decent, but there's room for improvement. Focus on creating consistent bedtime habits.";
    } else if (averageQuality >= 3.0) {
      return "Your sleep quality has been average. Consider improving your sleep environment and routine.";
    } else if (averageQuality >= 2.0) {
      return "You have been sleeping poorly over the last 7 days. Prioritize your rest and avoid distractions before bed.";
    } else {
      return "Your sleep has been very poor. It's time to make significant changes to your habits and environment.";
    }
  }
}

