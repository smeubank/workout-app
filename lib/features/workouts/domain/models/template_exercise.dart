import 'package:freezed_annotation/freezed_annotation.dart';

part 'template_exercise.freezed.dart';
part 'template_exercise.g.dart';

@freezed
class TemplateExercise with _$TemplateExercise {
  const factory TemplateExercise({
    required String id,
    required String templateId,
    required String exerciseId,
    int? sets,
    int? reps,
    double? weight,
    required int orderIndex,
  }) = _TemplateExercise;

  factory TemplateExercise.fromJson(Map<String, dynamic> json) => 
      _$TemplateExerciseFromJson(json);
} 