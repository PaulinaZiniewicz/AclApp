import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';


class TrainingRecommendationsPage extends StatelessWidget {
  final String userId;

  const TrainingRecommendationsPage({required this.userId, super.key});

  Future<Map<String, int>> _fetchTrainingData() async {
    final today = DateTime.now();
    final last7Days = List.generate(
      7,
      (index) => DateFormat('yyyy-MM-dd').format(today.subtract(Duration(days: index))),
    );

    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore
        .collection('trainings')
        .doc(userId)
        .collection('records')
        .where('completed', isEqualTo: true) // Fetch completed trainings
        .get();

    Map<String, int> completedCount = {
      "Stability": 0,
      "Mobility": 0,
      "Football": 0,
      "Gym": 0,
      "Stretching": 0,
    };

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final type = data['type'] ?? '';

      if (type == "Beginner workout plan") {
        completedCount["Stability"] = completedCount["Stability"]! + 1;
        completedCount["Mobility"] = completedCount["Mobility"]! + 1;
        completedCount["Stretching"] = completedCount["Stretching"]! + 1;
      } else if (completedCount.containsKey(type)) {
        completedCount[type] = completedCount[type]! + 1;
      }
    }

    return completedCount;
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Trainings Recommendations"),
    ),
    body: Stack(
          children: [
            // Background Logo
            Align(
              alignment: Alignment.center,
              child: Opacity(
                opacity: 0.1,
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 400,
                  height: 400,
                ),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: FutureBuilder<Map<String, int>>(
                    future: _fetchTrainingData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            "No completed trainings in the last 7 days. Start training to reach your goals!",
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      final completedCount = snapshot.data!;
                      final recommendations = _generateRecommendations(completedCount);

                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView.separated(
                          itemCount: recommendations.length,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: const Icon(Icons.check_circle, color: Colors.green),
                              title: Text(recommendations[index]),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
  );
  }

  List<String> _generateRecommendations(Map<String, int> completedCount) {
    final recommendations = <String>[];

    completedCount.forEach((type, count) {
      switch (type) {
        case "Stability":
          recommendations.add(
              "$count Stability sessions completed. We recommend at least 1 stability session per week to boost balance and posture.");
          break;
        case "Mobility":
          recommendations.add(
              "$count Mobility sessions done. Include fluid movements to improve flexibility and smooth motion. Try to complete 1 sesion per week.");
          break;
        case "Football":
          recommendations.add(
              "$count Football sessions achieved. Balance technical drills with recovery to maximize performance.");
          break;
        case "Gym":
          recommendations.add(
              "$count Gym workouts logged. Focus on strength and endurance training to support overall fitness. Try to complete 1 sesion per week.");
          break;
        case "Stretching":
          recommendations.add(
              "$count Stretching sessions done. Consistent stretching improves recovery and prevents stiffness. ");
          break;
      }
    });

    if (recommendations.isEmpty) {
      recommendations.add("Great effort! Stay consistent to hit your weekly training targets.");
    }

    return recommendations;
  }
}
