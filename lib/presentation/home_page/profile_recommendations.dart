import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileRecommendationsPage extends StatelessWidget {
  final String userId;

  const ProfileRecommendationsPage({required this.userId, super.key});

  Future<Map<String, String>> _fetchProfileData() async {
    final firestore = FirebaseFirestore.instance;
    final userDoc = await firestore.collection('usersParam').doc(userId).get();

    if (!userDoc.exists) {
      return {"error": "No profile data found. Please complete your profile to receive personalized recommendations!"};
    }

    final data = userDoc.data() ?? {};
    final String injuryStatus = data['selectedInjury'] ?? "No injury";
    final int weight = data['weight'] ?? 0;
    final int height = data['height'] ?? 0;
    final int age = data['age'] ?? 0;

    String bmiRecommendation = "";
    String injuryRecommendation = "";

    
    // Calculate BMI
    if (weight > 0 && height > 0) {
      final double heightInMeters = height / 100.0;

      if (height > 0) {
        final double targetWeightMin = 18.5 * heightInMeters * heightInMeters;
        final double targetWeightMax = 24.9 * heightInMeters * heightInMeters;
        bmiRecommendation =
            "For your height and age, your weight should be between ${targetWeightMin.toStringAsFixed(1)} kg and ${targetWeightMax.toStringAsFixed(1)} kg.";
      }
    } else {
      bmiRecommendation = "Invalid weight or height data. Please update your profile for better recommendations.";
    }

    // Injury-specific recommendations
    if (injuryStatus.toLowerCase() == "no injury") {
      injuryRecommendation =
          "Your profile indicates no current injuries. Stick to your training plan, maintain consistency, and focus on balancing all aspects of your training.";
    } else {
      injuryRecommendation =
          "Your profile indicates an injury: $injuryStatus. Prioritize rest, consult a healthcare professional, and focus on recovery by avoiding strenuous activities.";
    }

    return {
      "bmi": bmiRecommendation,
      "injury": injuryRecommendation,
    };
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Profile Recommendations"),
    ),
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
        FutureBuilder<Map<String, String>>(
          future: _fetchProfileData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            final data = snapshot.data;
            if (data == null || data.containsKey("error")) {
              return Center(
                child: Text(data?["error"] ?? "An unknown error occurred."),
              );
            }

            final recommendations = [
              data["bmi"]!,
              data["injury"]!,
            ];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.separated(
                itemCount: recommendations.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.person, color: Colors.blue),
                    title: Text(recommendations[index]),
                  );
                },
              ),
            );
          },
        ),
      ],
    ),
  );
}
}