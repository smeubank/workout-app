// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TemplateExerciseImpl _$$TemplateExerciseImplFromJson(
  Map<String, dynamic> json,
) => _$TemplateExerciseImpl(
  id: json['id'] as String,
  templateId: json['template_id'] as String,
  exerciseId: json['exercise_id'] as String,
  sets: (json['sets'] as num?)?.toInt(),
  reps: (json['reps'] as num?)?.toInt(),
  weight: (json['weight'] as num?)?.toDouble(),
  orderIndex: (json['order_index'] as num).toInt(),
);

Map<String, dynamic> _$$TemplateExerciseImplToJson(
  _$TemplateExerciseImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'template_id': instance.templateId,
  'exercise_id': instance.exerciseId,
  'sets': instance.sets,
  'reps': instance.reps,
  'weight': instance.weight,
  'order_index': instance.orderIndex,
};
