import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../theme/custom_text_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../theme/custom_button_style.dart';
import 'widgets/sleep_duration_section.dart';
import 'widgets/sleep_quality_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SleepInputForm extends StatefulWidget {
  final VoidCallback onSave;

  const SleepInputForm({required this.onSave, super.key});

  @override
  _SleepInputFormState createState() => _SleepInputFormState();
}

class _SleepInputFormState extends State<SleepInputForm> {
  int _durationHours = 0; 
  int _durationMinutes = 0;
  String _sleepQuality = ''; 
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final date = DateTime.now().toIso8601String().split('T')[0];
    final collection = FirebaseFirestore.instance
        .collection('sleepData')
        .doc(user.uid)
        .collection('records');

    final doc = await collection.doc(date).get();

    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        _durationHours = data['durationHours'] ?? 0;
        _durationMinutes = data['durationMinutes'] ?? 0;
        _sleepQuality = data['sleepQuality'] ?? '';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final date = DateTime.now().toIso8601String().split('T')[0];
    final collection = FirebaseFirestore.instance
        .collection('sleepData')
        .doc(user.uid)
        .collection('records');

    await collection.doc(date).set({
      'date': date,
      'durationHours': _durationHours,
      'durationMinutes': _durationMinutes,
      'sleepQuality': _sleepQuality,
    }, SetOptions(merge: true));

    widget.onSave();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's Sleep",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            SleepDurationSection(
              durationHours: _durationHours,
              durationMinutes: _durationMinutes,
              isDataSaved: false,
              onDurationChanged: (hours, minutes) {
                setState(() {
                  _durationHours = hours;
                  _durationMinutes = minutes;
                });
              },
            ),
            const SizedBox(height: 30),
            SleepQualitySection(
              sleepQuality: _sleepQuality,
              isDataSaved: false,
              onQualityChanged: (quality) {
                setState(() {
                  _sleepQuality = quality;
                });
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: CustomElevatedButton(
                height: 35,
                width: 300,
                text: "Save",
                buttonStyle: CustomButtonStyles.fillPrimary,
                buttonTextStyle: CustomTextStyles.titleSmallBold,
                onPressed: _saveData,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
