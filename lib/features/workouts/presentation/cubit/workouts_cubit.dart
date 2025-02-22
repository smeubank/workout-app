import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_tracker/features/workouts/domain/models/workout_template.dart';
import 'package:workout_tracker/features/workouts/data/repositories/supabase_workout_repository.dart';

abstract class WorkoutsState {}

class WorkoutsInitial extends WorkoutsState {}
class WorkoutsLoading extends WorkoutsState {}
class WorkoutsLoaded extends WorkoutsState {
  final List<WorkoutTemplate> workouts;
  WorkoutsLoaded(this.workouts);
}
class WorkoutsError extends WorkoutsState {
  final String message;
  WorkoutsError(this.message);
}

class WorkoutsCubit extends Cubit<WorkoutsState> {
  final _repository = SupabaseWorkoutRepository();

  WorkoutsCubit() : super(WorkoutsInitial());

  Future<void> loadWorkouts() async {
    try {
      emit(WorkoutsLoading());
      final workouts = await _repository.getWorkoutTemplates();
      emit(WorkoutsLoaded(workouts));
    } catch (e) {
      emit(WorkoutsError(e.toString()));
    }
  }

  Future<void> createWorkout(WorkoutTemplate workout) async {
    try {
      await _repository.createWorkoutTemplate(workout);
      loadWorkouts();
    } catch (e) {
      emit(WorkoutsError(e.toString()));
    }
  }
} 