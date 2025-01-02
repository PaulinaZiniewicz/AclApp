import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../theme/theme_helper.dart';
import '../../core/utils/size_utils.dart';

class TrainingsListPage extends StatefulWidget {
  const TrainingsListPage({super.key});

  @override
  _TrainingsListPageState createState() => _TrainingsListPageState();
}

class _TrainingsListPageState extends State<TrainingsListPage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(
        child: Text(
          "User not logged in. Please log in to view your trainings.",
          style: TextStyle(fontSize: 16, color: theme.colorScheme.primary),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.maxFinite,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('trainings')
                .doc(user.uid)
                .collection('records')
                .orderBy('date', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    "No trainings found. Start adding some!",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              final trainings = snapshot.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return {
                  'id': doc.id,
                  'date': data['date'], // Data jako String
                  'type': data['type'],
                  'duration': data['duration'],
                  'completed': data['completed'],
                };
              }).toList();

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 12.h),
                itemCount: trainings.length,
                itemBuilder: (context, index) {
                  final training = trainings[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.all(16.h),
                    decoration: BoxDecoration(
                      color: training['completed']
                          ? theme.colorScheme.primary.withOpacity(0.1)
                          : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12.h),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6.h,
                          offset: Offset(0, 2.h),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Date: ${training['date']}",
                                style: theme.textTheme.bodyLarge,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                "Type: ${training['type']}",
                                style: theme.textTheme.bodyMedium,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                "Duration: ${training['duration']}",
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        Checkbox(
                          value: training['completed'],
                          onChanged: (bool? value) {
                            _updateTrainingStatus(user.uid, training['id'], value ?? false);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _updateTrainingStatus(String userId, String trainingId, bool completed) async {
    try {
      await FirebaseFirestore.instance
          .collection('trainings')
          .doc(userId)
          .collection('records')
          .doc(trainingId)
          .update({'completed': completed});

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Training status updated."),
      ));
    } catch (e) {
      print("Error updating training status: $e");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Failed to update training status."),
      ));
    }
  }
}
