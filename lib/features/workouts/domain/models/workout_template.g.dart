// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkoutTemplateImpl _$$WorkoutTemplateImplFromJson(
  Map<String, dynamic> json,
) => _$WorkoutTemplateImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  exercises:
      (json['exercises'] as List<dynamic>?)
          ?.map((e) => TemplateExercise.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$WorkoutTemplateImplToJson(
  _$WorkoutTemplateImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'name': instance.name,
  'description': instance.description,
  'createdAt': instance.createdAt.toIso8601String(),
  'exercises': instance.exercises,
};
