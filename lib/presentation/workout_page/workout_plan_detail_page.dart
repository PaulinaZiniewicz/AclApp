import 'package:flutter/material.dart';
import 'exercise_list.dart';
import 'info_card.dart';
import 'workout_plan.dart';

class WorkoutPlanDetailPage extends StatefulWidget {
  final WorkoutPlan trainingPlan;

  const WorkoutPlanDetailPage({super.key, required this.trainingPlan});

  @override
  _WorkoutPlanDetailPageState createState() => _WorkoutPlanDetailPageState();
}

class _WorkoutPlanDetailPageState extends State<WorkoutPlanDetailPage> {
  int currentIndex = 0;

  void _goToInfoPage() {
    setState(() {
      currentIndex = 0;
    });
  }

  void _goToListPage() {
    setState(() {
      currentIndex = 1;
    });
  }

  void _goToExerciseDetail(Exercise exercise) {
    setState(() {
      currentIndex = 2;
    });
    _exercise = exercise;
  }

  Exercise? _exercise;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trainingPlan.level),
        leading: currentIndex != 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (currentIndex == 2) {
                    _goToListPage();
                  } else {
                    _goToInfoPage();
                  }
                },
              )
            : null,
      ),
      body: IndexedStack(
        index: currentIndex,
        children: [
          // InfoCard View
          InfoCard(
            level: widget.trainingPlan.level,
            infoText: widget.trainingPlan.infoText,
            onArrowTap: _goToListPage,
          ),
          // ExerciseListPage View
          ExerciseListPage(
            trainingPlan: widget.trainingPlan,
          ),
          
        ],
      ),
    );
  }
}
