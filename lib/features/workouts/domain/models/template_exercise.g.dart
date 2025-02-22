// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TemplateExerciseImpl _$$TemplateExerciseImplFromJson(
  Map<String, dynamic> json,
) => _$TemplateExerciseImpl(
  id: json['id'] as String,
  templateId: json['templateId'] as String,
  exerciseId: json['exerciseId'] as String,
  sets: (json['sets'] as num?)?.toInt(),
  reps: (json['reps'] as num?)?.toInt(),
  weight: (json['weight'] as num?)?.toDouble(),
  orderIndex: (json['orderIndex'] as num).toInt(),
);

Map<String, dynamic> _$$TemplateExerciseImplToJson(
  _$TemplateExerciseImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'templateId': instance.templateId,
  'exerciseId': instance.exerciseId,
  'sets': instance.sets,
  'reps': instance.reps,
  'weight': instance.weight,
  'orderIndex': instance.orderIndex,
};
