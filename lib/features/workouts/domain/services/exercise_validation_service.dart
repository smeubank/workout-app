class ExerciseValidationResult {
  final bool isValid;
  final Map<String, String> errors;

  ExerciseValidationResult(this.isValid, this.errors);
}

class ExerciseValidationService {
  ExerciseValidationResult validateTemplateExercises(List<TemplateExercise> exercises) {
    final errors = <String, String>{};
    
    if (exercises.isEmpty) {
      errors['exercises'] = 'At least one exercise is required';
      return ExerciseValidationResult(false, errors);
    }

    for (var i = 0; i < exercises.length; i++) {
      final exercise = exercises[i];
      
      if (exercise.sets != null && (exercise.sets! < 1 || exercise.sets! > 10)) {
        errors['sets_$i'] = 'Sets must be between 1 and 10';
      }
      
      if (exercise.reps != null && (exercise.reps! < 1 || exercise.reps! > 100)) {
        errors['reps_$i'] = 'Reps must be between 1 and 100';
      }
      
      if (exercise.weight != null && exercise.weight! < 0) {
        errors['weight_$i'] = 'Weight cannot be negative';
      }
    }

    return ExerciseValidationResult(errors.isEmpty, errors);
  }
} 