abstract class WorkoutsState {}

class WorkoutsInitial extends WorkoutsState {}
class WorkoutsLoading extends WorkoutsState {}
class WorkoutsSaving extends WorkoutsState {}

class WorkoutsLoaded extends WorkoutsState {
  final List<WorkoutTemplate> workouts;
  final List<Exercise> selectedExercises;
  final Map<String, TemplateExercise> exerciseConfigs;
  
  WorkoutsLoaded(
    this.workouts, {
    this.selectedExercises = const [],
    this.exerciseConfigs = const {},
  });
  
  WorkoutsLoaded copyWith({
    List<WorkoutTemplate>? workouts,
    List<Exercise>? selectedExercises,
    Map<String, TemplateExercise>? exerciseConfigs,
  }) {
    return WorkoutsLoaded(
      workouts ?? this.workouts,
      selectedExercises: selectedExercises ?? this.selectedExercises,
      exerciseConfigs: exerciseConfigs ?? this.exerciseConfigs,
    );
  }
}

class WorkoutsError extends WorkoutsState {
  final String message;
  final Map<String, String>? fieldErrors;
  WorkoutsError(this.message, {this.fieldErrors});
} 