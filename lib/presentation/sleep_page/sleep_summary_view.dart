import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../theme/custom_text_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../theme/custom_button_style.dart';
import 'widgets/sleep_trend_chart.dart';

class SleepSummaryView extends StatelessWidget {
  final VoidCallback onEdit;

  const SleepSummaryView({required this.onEdit, super.key});

  Future<Map<String, dynamic>?> _fetchTodaySleepData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return null;

    final date = DateTime.now().toIso8601String().split('T')[0];
    final doc = await FirebaseFirestore.instance
        .collection('sleepData')
        .doc(user.uid)
        .collection('records')
        .doc(date)
        .get();

    if (!doc.exists) {
      // Jeśli brak danych, inicjalizuj dokument
      await FirebaseFirestore.instance
          .collection('sleepData')
          .doc(user.uid)
          .collection('records')
          .doc(date)
          .set({
        'date': date,
        'durationHours': 0,
        'durationMinutes': 0,
        'sleepQuality': 'Not recorded',
      });
    }

    return doc.exists ? doc.data() : null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _fetchTodaySleepData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData) {
          return _buildEmptySummary(context);
        } else {
          final data = snapshot.data!;
          final durationHours = data['durationHours'];
          final durationMinutes = data['durationMinutes'];
          final quality = data['sleepQuality'];

          return _buildSummary(context, durationHours, durationMinutes, quality);
        }
      },
    );
  }

  Widget _buildEmptySummary(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Sleep Summary",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 20),
          const Text("Duration: 0 hours, 0 minutes"),
          const Text("Quality: Not recorded"),
          const SizedBox(height: 20),
          const SleepTrendChart(),
          const SizedBox(height: 20),
          Center(
            child: CustomElevatedButton(
              height: 35,
              width: 300,
              text: "Edit",
              buttonStyle: CustomButtonStyles.fillPrimary,
              buttonTextStyle: CustomTextStyles.titleSmallBold,
              onPressed: onEdit,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(BuildContext context, int durationHours, int durationMinutes, String quality) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Sleep Summary",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 20),
          Text(
            "Duration: $durationHours hours, $durationMinutes minutes",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            "Quality: $quality",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          const SleepTrendChart(),
          const SizedBox(height: 20),
          Center(
            child: CustomElevatedButton(
              height: 35,
              width: 300,
              text: "Edit",
              buttonStyle: CustomButtonStyles.fillPrimary,
              buttonTextStyle: CustomTextStyles.titleSmallBold,
              onPressed: onEdit,
            ),
          ),
        ],
      ),
    );
  }
}
