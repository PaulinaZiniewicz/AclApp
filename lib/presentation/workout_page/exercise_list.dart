import 'package:flutter/material.dart';
import 'exercise_detail_widget.dart';
import 'workout_plan.dart';
import 'workout_plan_execution.dart';

class ExerciseListPage extends StatelessWidget {
  final WorkoutPlan trainingPlan;

  const ExerciseListPage({
    super.key,
    required this.trainingPlan,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: trainingPlan.exercises.length,
        itemBuilder: (context, index) {
          final exercise = trainingPlan.exercises[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: Image.asset(
                exercise.imagePath,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(exercise.name),
              subtitle: Text(exercise.purpose),
              onTap: () {
                // Navigate directly to the selected exercise
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutPlanExecutionPage(
                      trainingPlan: trainingPlan,
                      initialExerciseIndex: index, // Pass the index of the clicked exercise
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to WorkoutPlanExecutionPage starting from the first exercise
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkoutPlanExecutionPage(
                trainingPlan: trainingPlan,
                initialExerciseIndex: 0, // Start from the first exercise
              ),
            ),
          );
        },
        child: const Icon(Icons.play_arrow),
        tooltip: 'Start Workout',
      ),
    );
  }
}
