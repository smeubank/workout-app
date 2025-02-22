import '../models/exercise.dart';

abstract class ExerciseRepository {
  Future<List<Exercise>> getExercises();
  Future<Exercise> getExerciseById(String id);
  Future<Exercise> createExercise(Exercise exercise);
  Future<Exercise> updateExercise(Exercise exercise);
  Future<void> deleteExercise(String id);
} 