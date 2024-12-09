class WorkoutPlan {
  final String level;
  final String description; 
  final String infoText; 
  final List<Exercise> exercises;

  WorkoutPlan({
    required this.level,
    required this.description,
    required this.infoText, 
    required this.exercises,
  });
}


class Exercise {
  final String name;
  final String description;
  final String purpose;
  final String imagePath; // Ścieżka do obrazu ćwiczenia
  final String repetitions;
  final int sets;
  final bool isTimed; // Czy ćwiczenie oparte na czasie
  final int? duration; // Czas w sekundach (opcjonalne)

  Exercise({
    required this.name,
    required this.description,
    required this.purpose,
    required this.imagePath,
    required this.repetitions,
    required this.sets,
    this.isTimed = false,
    this.duration,
  });
}
