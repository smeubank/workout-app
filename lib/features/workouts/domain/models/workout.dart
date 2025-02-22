import 'package:freezed_annotation/freezed_annotation.dart';
import 'workout_exercise.dart';

part 'workout.freezed.dart';
part 'workout.g.dart';

@freezed
class Workout with _$Workout {
  const factory Workout({
    required String id,
    required String userId,
    required String name,
    String? description,
    required DateTime startedAt,
    DateTime? completedAt,
    String? templateId,
    @Default([]) List<WorkoutExercise> exercises,
  }) = _Workout;

  factory Workout.fromJson(Map<String, dynamic> json) => _$WorkoutFromJson(json);
} 