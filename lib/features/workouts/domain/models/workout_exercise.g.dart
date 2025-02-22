// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkoutExerciseImpl _$$WorkoutExerciseImplFromJson(
  Map<String, dynamic> json,
) => _$WorkoutExerciseImpl(
  id: json['id'] as String,
  workoutId: json['workoutId'] as String,
  exerciseId: json['exerciseId'] as String,
  order: (json['order'] as num).toInt(),
  sets:
      (json['sets'] as List<dynamic>)
          .map((e) => WorkoutSet.fromJson(e as Map<String, dynamic>))
          .toList(),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$$WorkoutExerciseImplToJson(
  _$WorkoutExerciseImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'workoutId': instance.workoutId,
  'exerciseId': instance.exerciseId,
  'order': instance.order,
  'sets': instance.sets,
  'notes': instance.notes,
};

_$WorkoutSetImpl _$$WorkoutSetImplFromJson(Map<String, dynamic> json) =>
    _$WorkoutSetImpl(
      reps: (json['reps'] as num).toInt(),
      weight: (json['weight'] as num).toDouble(),
      completed: json['completed'] as bool,
    );

Map<String, dynamic> _$$WorkoutSetImplToJson(_$WorkoutSetImpl instance) =>
    <String, dynamic>{
      'reps': instance.reps,
      'weight': instance.weight,
      'completed': instance.completed,
    };
