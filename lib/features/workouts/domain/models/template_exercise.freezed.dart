// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'template_exercise.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TemplateExercise _$TemplateExerciseFromJson(Map<String, dynamic> json) {
  return _TemplateExercise.fromJson(json);
}

/// @nodoc
mixin _$TemplateExercise {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'template_id')
  String get templateId => throw _privateConstructorUsedError;
  @JsonKey(name: 'exercise_id')
  String get exerciseId => throw _privateConstructorUsedError;
  int? get sets => throw _privateConstructorUsedError;
  int? get reps => throw _privateConstructorUsedError;
  double? get weight => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_index')
  int get orderIndex => throw _privateConstructorUsedError;

  /// Serializes this TemplateExercise to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TemplateExercise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TemplateExerciseCopyWith<TemplateExercise> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemplateExerciseCopyWith<$Res> {
  factory $TemplateExerciseCopyWith(
    TemplateExercise value,
    $Res Function(TemplateExercise) then,
  ) = _$TemplateExerciseCopyWithImpl<$Res, TemplateExercise>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'template_id') String templateId,
    @JsonKey(name: 'exercise_id') String exerciseId,
    int? sets,
    int? reps,
    double? weight,
    @JsonKey(name: 'order_index') int orderIndex,
  });
}

/// @nodoc
class _$TemplateExerciseCopyWithImpl<$Res, $Val extends TemplateExercise>
    implements $TemplateExerciseCopyWith<$Res> {
  _$TemplateExerciseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TemplateExercise
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? templateId = null,
    Object? exerciseId = null,
    Object? sets = freezed,
    Object? reps = freezed,
    Object? weight = freezed,
    Object? orderIndex = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            templateId:
                null == templateId
                    ? _value.templateId
                    : templateId // ignore: cast_nullable_to_non_nullable
                        as String,
            exerciseId:
                null == exerciseId
                    ? _value.exerciseId
                    : exerciseId // ignore: cast_nullable_to_non_nullable
                        as String,
            sets:
                freezed == sets
                    ? _value.sets
                    : sets // ignore: cast_nullable_to_non_nullable
                        as int?,
            reps:
                freezed == reps
                    ? _value.reps
                    : reps // ignore: cast_nullable_to_non_nullable
                        as int?,
            weight:
                freezed == weight
                    ? _value.weight
                    : weight // ignore: cast_nullable_to_non_nullable
                        as double?,
            orderIndex:
                null == orderIndex
                    ? _value.orderIndex
                    : orderIndex // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TemplateExerciseImplCopyWith<$Res>
    implements $TemplateExerciseCopyWith<$Res> {
  factory _$$TemplateExerciseImplCopyWith(
    _$TemplateExerciseImpl value,
    $Res Function(_$TemplateExerciseImpl) then,
  ) = __$$TemplateExerciseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'template_id') String templateId,
    @JsonKey(name: 'exercise_id') String exerciseId,
    int? sets,
    int? reps,
    double? weight,
    @JsonKey(name: 'order_index') int orderIndex,
  });
}

/// @nodoc
class __$$TemplateExerciseImplCopyWithImpl<$Res>
    extends _$TemplateExerciseCopyWithImpl<$Res, _$TemplateExerciseImpl>
    implements _$$TemplateExerciseImplCopyWith<$Res> {
  __$$TemplateExerciseImplCopyWithImpl(
    _$TemplateExerciseImpl _value,
    $Res Function(_$TemplateExerciseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TemplateExercise
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? templateId = null,
    Object? exerciseId = null,
    Object? sets = freezed,
    Object? reps = freezed,
    Object? weight = freezed,
    Object? orderIndex = null,
  }) {
    return _then(
      _$TemplateExerciseImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        templateId:
            null == templateId
                ? _value.templateId
                : templateId // ignore: cast_nullable_to_non_nullable
                    as String,
        exerciseId:
            null == exerciseId
                ? _value.exerciseId
                : exerciseId // ignore: cast_nullable_to_non_nullable
                    as String,
        sets:
            freezed == sets
                ? _value.sets
                : sets // ignore: cast_nullable_to_non_nullable
                    as int?,
        reps:
            freezed == reps
                ? _value.reps
                : reps // ignore: cast_nullable_to_non_nullable
                    as int?,
        weight:
            freezed == weight
                ? _value.weight
                : weight // ignore: cast_nullable_to_non_nullable
                    as double?,
        orderIndex:
            null == orderIndex
                ? _value.orderIndex
                : orderIndex // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TemplateExerciseImpl implements _TemplateExercise {
  const _$TemplateExerciseImpl({
    required this.id,
    @JsonKey(name: 'template_id') required this.templateId,
    @JsonKey(name: 'exercise_id') required this.exerciseId,
    this.sets,
    this.reps,
    this.weight,
    @JsonKey(name: 'order_index') required this.orderIndex,
  });

  factory _$TemplateExerciseImpl.fromJson(Map<String, dynamic> json) =>
      _$$TemplateExerciseImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'template_id')
  final String templateId;
  @override
  @JsonKey(name: 'exercise_id')
  final String exerciseId;
  @override
  final int? sets;
  @override
  final int? reps;
  @override
  final double? weight;
  @override
  @JsonKey(name: 'order_index')
  final int orderIndex;

  @override
  String toString() {
    return 'TemplateExercise(id: $id, templateId: $templateId, exerciseId: $exerciseId, sets: $sets, reps: $reps, weight: $weight, orderIndex: $orderIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemplateExerciseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            (identical(other.exerciseId, exerciseId) ||
                other.exerciseId == exerciseId) &&
            (identical(other.sets, sets) || other.sets == sets) &&
            (identical(other.reps, reps) || other.reps == reps) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    templateId,
    exerciseId,
    sets,
    reps,
    weight,
    orderIndex,
  );

  /// Create a copy of TemplateExercise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TemplateExerciseImplCopyWith<_$TemplateExerciseImpl> get copyWith =>
      __$$TemplateExerciseImplCopyWithImpl<_$TemplateExerciseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TemplateExerciseImplToJson(this);
  }
}

abstract class _TemplateExercise implements TemplateExercise {
  const factory _TemplateExercise({
    required final String id,
    @JsonKey(name: 'template_id') required final String templateId,
    @JsonKey(name: 'exercise_id') required final String exerciseId,
    final int? sets,
    final int? reps,
    final double? weight,
    @JsonKey(name: 'order_index') required final int orderIndex,
  }) = _$TemplateExerciseImpl;

  factory _TemplateExercise.fromJson(Map<String, dynamic> json) =
      _$TemplateExerciseImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'template_id')
  String get templateId;
  @override
  @JsonKey(name: 'exercise_id')
  String get exerciseId;
  @override
  int? get sets;
  @override
  int? get reps;
  @override
  double? get weight;
  @override
  @JsonKey(name: 'order_index')
  int get orderIndex;

  /// Create a copy of TemplateExercise
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TemplateExerciseImplCopyWith<_$TemplateExerciseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
