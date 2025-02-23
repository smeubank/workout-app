import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_tracker/features/workouts/domain/models/workout_template.dart';
import 'package:workout_tracker/features/workouts/domain/models/template_exercise.dart';
import 'package:workout_tracker/features/exercises/domain/models/exercise.dart';
import 'package:workout_tracker/features/workouts/data/repositories/supabase_workout_repository.dart';
import 'package:workout_tracker/features/workouts/core/exceptions/database_exception.dart';
import 'package:sentry/sentry.dart';

abstract class WorkoutsState {}

class WorkoutsInitial extends WorkoutsState {}
class WorkoutsLoading extends WorkoutsState {}
class WorkoutsSaving extends WorkoutsState {}
class WorkoutsLoaded extends WorkoutsState {
  final List<WorkoutTemplate> workouts;
  final List<Exercise> selectedExercises;
  final Map<String, TemplateExercise> exerciseConfigs;
  
  WorkoutsLoaded(this.workouts, {this.selectedExercises = const [], this.exerciseConfigs = const {}});
  
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

class WorkoutsCubit extends Cubit<WorkoutsState> {
  final _repository = SupabaseWorkoutRepository();

  WorkoutsCubit() : super(WorkoutsLoaded([], selectedExercises: [], exerciseConfigs: {}));

  Future<void> loadWorkouts() async {
    try {
      emit(WorkoutsLoading());
      final workouts = await _repository.getWorkoutTemplates();
      if (state is WorkoutsLoaded) {
        final currentState = state as WorkoutsLoaded;
        emit(currentState.copyWith(workouts: workouts));
      } else {
        emit(WorkoutsLoaded(workouts));
      }
    } catch (e, stackTrace) {
      await Sentry.captureException(e, stackTrace: stackTrace);
      emit(WorkoutsError(e.toString()));
    }
  }

  Future<void> createWorkout(WorkoutTemplate workout) async {
    try {
      emit(WorkoutsSaving());
      await _repository.createWorkoutTemplate(workout);
      await loadWorkouts();
    } catch (e, stackTrace) {
      if (e is DatabaseException) {
        await Sentry.captureException(
          e,
          stackTrace: stackTrace,
          hint: Hint.withMap(e.toSentry()),
        );
        emit(WorkoutsError(e.toString(), fieldErrors: {
          if (e.code == 'UNIQUE_VIOLATION') 'name': 'Name already exists',
        }));
      } else {
        await Sentry.captureException(e, stackTrace: stackTrace);
        emit(WorkoutsError('Failed to create workout'));
      }
    }
  }

  void addExercise(Exercise exercise) {
    if (state is WorkoutsLoaded) {
      final currentState = state as WorkoutsLoaded;
      emit(currentState.copyWith(
        selectedExercises: [...currentState.selectedExercises, exercise],
      ));
    }
  }

  void removeExercise(Exercise exercise) {
    if (state is WorkoutsLoaded) {
      final currentState = state as WorkoutsLoaded;
      emit(currentState.copyWith(
        selectedExercises: currentState.selectedExercises
            .where((e) => e.id != exercise.id)
            .toList(),
      ));
    }
  }

  void reorderExercises(int oldIndex, int newIndex) {
    if (state is WorkoutsLoaded) {
      final currentState = state as WorkoutsLoaded;
      final exercises = List<Exercise>.from(currentState.selectedExercises);
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final exercise = exercises.removeAt(oldIndex);
      exercises.insert(newIndex, exercise);
      emit(currentState.copyWith(selectedExercises: exercises));
    }
  }

  void updateSelectedExercises(List<Exercise> exercises) {
    if (state is WorkoutsLoaded) {
      final currentState = state as WorkoutsLoaded;
      emit(currentState.copyWith(
        selectedExercises: exercises,
      ));
    }
  }

  void clearSelectedExercises() {
    if (state is WorkoutsLoaded) {
      final currentState = state as WorkoutsLoaded;
      emit(currentState.copyWith(selectedExercises: const []));
    }
  }

  void updateExerciseConfig(String exerciseId, {
    int? sets,
    int? reps,
    double? weight,
  }) {
    if (state is WorkoutsLoaded) {
      final currentState = state as WorkoutsLoaded;
      final configs = Map<String, TemplateExercise>.from(currentState.exerciseConfigs);
      
      final existing = configs[exerciseId];
      configs[exerciseId] = TemplateExercise(
        id: '',
        templateId: '',
        exerciseId: exerciseId,
        sets: sets ?? existing?.sets ?? 3,
        reps: reps ?? existing?.reps ?? 10,
        weight: weight ?? existing?.weight,
        orderIndex: currentState.selectedExercises
            .indexWhere((e) => e.id == exerciseId),
      );
      
      emit(currentState.copyWith(exerciseConfigs: configs));
    }
  }

  void resetExerciseConfigs() {
    if (state is WorkoutsLoaded) {
      final currentState = state as WorkoutsLoaded;
      emit(currentState.copyWith(exerciseConfigs: {}));
    }
  }
} 