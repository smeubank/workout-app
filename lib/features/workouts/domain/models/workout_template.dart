import 'package:freezed_annotation/freezed_annotation.dart';
import 'template_exercise.dart';
import 'package:workout_tracker/features/exercises/domain/models/exercise.dart';

part 'workout_template.freezed.dart';
part 'workout_template.g.dart';

@freezed
class WorkoutTemplate with _$WorkoutTemplate {
  const factory WorkoutTemplate({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String name,
    String? description,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @Default([]) List<TemplateExercise> exercises,
  }) = _WorkoutTemplate;

  factory WorkoutTemplate.fromJson(Map<String, dynamic> json) =>
      _$WorkoutTemplateFromJson(json);
}