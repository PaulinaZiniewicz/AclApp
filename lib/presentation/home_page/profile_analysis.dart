import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileAnalysis {
  Future<String> getProfileSummary() async {
    // Get the currently logged-in user
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return "User is not logged in. Please log in to access your profile data.";
    }

    // Fetch user's profile data from Firestore
    final docSnapshot = await FirebaseFirestore.instance
        .collection('usersParam')
        .doc(user.uid) // Use the dynamic userId
        .get();

    if (!docSnapshot.exists) {
      return "No profile data found. Please complete your profile!";
    }

    final data = docSnapshot.data() ?? {};
    final int age = data['age'] ?? 0;
    final int weight = data['weight'] ?? 0; // in kilograms
    final int height = data['height'] ?? 0; // in centimeters
    final String injury = data['selectedInjury'] ?? "No injury";

    // Validate the inputsą
    if (weight <= 0 || height <= 0) {
      return "Invalid weight or height data. Please update your profile!";
    }

    // Calculate BMI
    final double heightInMeters = height / 100.0; // Convert cm to meters
    final double bmi = weight / (heightInMeters * heightInMeters);

    // Build analysis based on BMI and other parameters
    String analysis = "";

    // Age check
    if (age < 18) {
      analysis += "- You are under 18. Ensure training intensity is age-appropriate.\n";
    }

    // BMI analysis
    analysis += "BMI: ${bmi.toStringAsFixed(1)}\n";

    // Recommendations based on BMI category
    if (bmi < 18.5) {
      analysis += "Your BMI is below the healthy range. Consider a balanced diet to gain weight healthily.\n";
    } else if (bmi >= 18.5 && bmi <= 24.9) {
      analysis += "Your BMI is in the healthy range. Maintain your current lifestyle.\n";
    } else if (bmi >= 25 && bmi <= 29.9) {
      analysis += "Your BMI is above the healthy range (overweight). Consider regular exercise and dietary adjustments.\n";
    } else if (bmi >= 30) {
      analysis += "Your BMI is in the obese range. Consult a healthcare provider for a tailored plan.";
    }

    return analysis;
  }
}
