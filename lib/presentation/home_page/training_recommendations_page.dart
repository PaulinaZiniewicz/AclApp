import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
        .where('completed', isEqualTo: true) // Tylko ukończone treningi
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
      // Beginner workout plan dodaje po 1 do kilku kategorii
      completedCount["Stability"] = completedCount["Stability"]! + 1;
      completedCount["Mobility"] = completedCount["Mobility"]! + 1;
      completedCount["Stretching"] = completedCount["Stretching"]! + 1;
    } else if (completedCount.containsKey(type)) {
      // Zwykłe treningi
      completedCount[type] = completedCount[type]! + 1;
    }
  }

    return completedCount;
  }

@override
Widget build(BuildContext context) {
  return SafeArea(
    child: Scaffold(
      body: Stack(
        children: [
          // Tło z logo
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
          // Główna zawartość
          Column(
            children: [
              AppBar(
                title: const Text("Training Recommendations"),
              ),
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
                          "No completed trainings in the last 7 days. Start completing your trainings!",
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
    ),
  );
}


  List<String> _generateRecommendations(Map<String, int> completedCount) {
    final recommendations = <String>[];

    completedCount.forEach((type, count) {
      switch (type) {
        case "Stability":
          recommendations.add(
              "You completed $count Stability sessions in the last 7 days. Try to complete at least 2 this week.");
          break;
        case "Mobility":
          recommendations.add(
              "You completed $count Mobility session${count != 1 ? 's' : ''} in the last 7 days. Aim for at least 1.");
          break;
        case "Football":
          recommendations.add(
              "You completed $count Football session${count != 1 ? 's' : ''} in the last 7 days. Don't exceed 4 per week.");
          break;
        case "Gym":
          recommendations.add(
              "You completed $count Gym session${count != 1 ? 's' : ''} in the last 7 days. Aim for at least 1 per week.");
          break;
        case "Stretching":
          recommendations.add(
              "You completed $count Stretching session${count != 1 ? 's' : ''} in the last 7 days. Try to do at least 1.");
          break;
        default:
          break;
      }
    });

    if (recommendations.isEmpty) {
      recommendations.add("Great job! You've completed all recommended trainings this week!");
    }

    return recommendations;
  }
}
