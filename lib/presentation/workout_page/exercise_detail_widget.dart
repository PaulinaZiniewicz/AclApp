import 'package:flutter/material.dart';
import 'dart:async';
import 'workout_plan.dart';

class ExerciseDetailWidget extends StatefulWidget {
  final Exercise exercise;
  final VoidCallback onFinish;
  final VoidCallback onBackToList;
  final VoidCallback onAllSetsCompleted; // New callback

  const ExerciseDetailWidget({
    super.key,
    required this.exercise,
    required this.onFinish,
    required this.onBackToList,
    required this.onAllSetsCompleted, // Pass this from parent
  });

  @override
  _ExerciseDetailWidgetState createState() => _ExerciseDetailWidgetState();
}

class _ExerciseDetailWidgetState extends State<ExerciseDetailWidget> {
  Timer? _timer;
  int? _remainingTime;
  List<bool> completedSets = [];

  @override
  void initState() {
    super.initState();
    completedSets = List<bool>.filled(widget.exercise.sets, false);
    if (widget.exercise.isTimed) {
      _remainingTime = widget.exercise.duration;
    }
  }
    void _checkAllSetsCompleted() {
        if (completedSets.every((set) => set)) {
          widget.onAllSetsCompleted(); 
    }
  }

  void _toggleSetCompletion(int index, bool? value) {
    setState(() {
      completedSets[index] = value ?? false;
    });
    _checkAllSetsCompleted(); 
  }
  void _startTimer() {
    if (widget.exercise.isTimed && _remainingTime != null && _remainingTime! > 0) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            if (_remainingTime! > 0) {
              _remainingTime = _remainingTime! - 1;
            } else {
              _timer?.cancel();
              _remainingTime = widget.exercise.duration;
            }
          });
        } else {
          _timer?.cancel();
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildTimerOrRepetitions() {
    if (widget.exercise.isTimed) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: _startTimer,
                child: const Icon(
                  Icons.play_arrow,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Text(
                 _remainingTime != null
                    ? "Remaining time: $_remainingTime s"
                    : "Duration: ${widget.exercise.duration} s",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSetsCheckboxes(),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Repetitions: ${widget.exercise.repetitions}",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          _buildSetsCheckboxes(),
        ],
      );
    }
  }

  Widget _buildSetsCheckboxes() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        "Sets: ${widget.exercise.sets}",
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      Row(
        children: List.generate(widget.exercise.sets, (index) {
          return Checkbox(
            value: completedSets[index],
            onChanged: (value) => _toggleSetCompletion(index, value),
            activeColor: const Color(0xFFF55022),
          );
        }),
      ),
    ],
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(18.0),
        padding: const EdgeInsets.all(18.0),
        decoration: BoxDecoration(
          color: const Color(0xFF3C536C),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Description
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF869FB5),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.exercise.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.exercise.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Exercise Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                widget.exercise.imagePath,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            // Timer or Repetitions
            _buildTimerOrRepetitions(),
            Text(
                  "${widget.exercise.purpose}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
