import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_exercise.freezed.dart';
part 'workout_exercise.g.dart';

@freezed
class WorkoutExercise with _$WorkoutExercise {
  const factory WorkoutExercise({
    required String id,
    required String workoutId,
    required String exerciseId,
    required int order,
    required List<WorkoutSet> sets,
    String? notes,
  }) = _WorkoutExercise;

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) =>
      _$WorkoutExerciseFromJson(json);
}

@freezed
class WorkoutSet with _$WorkoutSet {
  const factory WorkoutSet({
    required int reps,
    required double weight,
    required bool completed,
  }) = _WorkoutSet;

  factory WorkoutSet.fromJson(Map<String, dynamic> json) =>
      _$WorkoutSetFromJson(json);
} 