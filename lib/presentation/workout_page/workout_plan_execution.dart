import 'package:flutter/material.dart';
import 'dart:async';
import 'exercise_detail_widget.dart';
import 'workout_plan.dart';

class WorkoutPlanExecutionPage extends StatefulWidget {
  final WorkoutPlan trainingPlan;
  final int initialExerciseIndex; // Add a parameter for the starting exercise index

  const WorkoutPlanExecutionPage({
    super.key,
    required this.trainingPlan,
    required this.initialExerciseIndex, // Initialize with starting index
  });

  @override
  _WorkoutPlanExecutionPageState createState() => _WorkoutPlanExecutionPageState();
}

class _WorkoutPlanExecutionPageState extends State<WorkoutPlanExecutionPage> {
  late PageController _pageController;
  late int _currentIndex; // Initialize with starting index
  Timer? _transitionTimer;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialExerciseIndex; // Start from the selected exercise
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _transitionTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextExercise() {
    if (_currentIndex < widget.trainingPlan.exercises.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context); // Workout plan completed
    }
  }

  void _scheduleAutoTransition() {
    _transitionTimer?.cancel();
    _transitionTimer = Timer(const Duration(seconds: 1), _goToNextExercise);
  }

  void _onAllSetsCompleted() {
    _scheduleAutoTransition(); // Schedule transition after all sets are completed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trainingPlan.level),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.trainingPlan.exercises.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
          _transitionTimer?.cancel(); // Cancel any ongoing timers
        },
        itemBuilder: (context, index) {
          final exercise = widget.trainingPlan.exercises[index];
          return ExerciseDetailWidget(
            exercise: exercise,
            onFinish: _scheduleAutoTransition,
            onBackToList: () {
              Navigator.pop(context);
            },
            onAllSetsCompleted: _onAllSetsCompleted, // Pass callback to child
          );
        },
      ),
    );
  }
}
