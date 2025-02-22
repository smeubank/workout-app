import '../models/workout.dart';
import '../models/workout_template.dart';
import '../models/template_exercise.dart';

abstract class WorkoutRepository {
  // Template operations
  Future<List<WorkoutTemplate>> getWorkoutTemplates();
  Future<WorkoutTemplate> getWorkoutTemplateById(String id);
  Future<WorkoutTemplate> createWorkoutTemplate(WorkoutTemplate template);
  Future<WorkoutTemplate> updateWorkoutTemplate(WorkoutTemplate template);
  Future<void> deleteWorkoutTemplate(String id);

  // Template exercise operations
  Future<List<TemplateExercise>> getTemplateExercises(String templateId);
  Future<TemplateExercise> addExerciseToTemplate(TemplateExercise exercise);
  Future<void> removeExerciseFromTemplate(String exerciseId);

  // Workout operations
  Future<List<Workout>> getWorkouts();
  Future<Workout> startWorkout(String? templateId);
  Future<Workout> endWorkout(String workoutId);
  Future<void> deleteWorkout(String id);
} 