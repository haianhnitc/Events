// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'application_answer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ApplicationAnswerModel _$ApplicationAnswerModelFromJson(
    Map<String, dynamic> json) {
  return _ApplicationAnswerModel.fromJson(json);
}

/// @nodoc
mixin _$ApplicationAnswerModel {
  int? get applicationAnswerId => throw _privateConstructorUsedError;
  int? get eventStaffApplicationId => throw _privateConstructorUsedError;
  int? get requirementQuestionId => throw _privateConstructorUsedError;
  String? get answerValue => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApplicationAnswerModelCopyWith<ApplicationAnswerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApplicationAnswerModelCopyWith<$Res> {
  factory $ApplicationAnswerModelCopyWith(ApplicationAnswerModel value,
          $Res Function(ApplicationAnswerModel) then) =
      _$ApplicationAnswerModelCopyWithImpl<$Res, ApplicationAnswerModel>;
  @useResult
  $Res call(
      {int? applicationAnswerId,
      int? eventStaffApplicationId,
      int? requirementQuestionId,
      String? answerValue});
}

/// @nodoc
class _$ApplicationAnswerModelCopyWithImpl<$Res,
        $Val extends ApplicationAnswerModel>
    implements $ApplicationAnswerModelCopyWith<$Res> {
  _$ApplicationAnswerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? applicationAnswerId = freezed,
    Object? eventStaffApplicationId = freezed,
    Object? requirementQuestionId = freezed,
    Object? answerValue = freezed,
  }) {
    return _then(_value.copyWith(
      applicationAnswerId: freezed == applicationAnswerId
          ? _value.applicationAnswerId
          : applicationAnswerId // ignore: cast_nullable_to_non_nullable
              as int?,
      eventStaffApplicationId: freezed == eventStaffApplicationId
          ? _value.eventStaffApplicationId
          : eventStaffApplicationId // ignore: cast_nullable_to_non_nullable
              as int?,
      requirementQuestionId: freezed == requirementQuestionId
          ? _value.requirementQuestionId
          : requirementQuestionId // ignore: cast_nullable_to_non_nullable
              as int?,
      answerValue: freezed == answerValue
          ? _value.answerValue
          : answerValue // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApplicationAnswerModelImplCopyWith<$Res>
    implements $ApplicationAnswerModelCopyWith<$Res> {
  factory _$$ApplicationAnswerModelImplCopyWith(
          _$ApplicationAnswerModelImpl value,
          $Res Function(_$ApplicationAnswerModelImpl) then) =
      __$$ApplicationAnswerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? applicationAnswerId,
      int? eventStaffApplicationId,
      int? requirementQuestionId,
      String? answerValue});
}

/// @nodoc
class __$$ApplicationAnswerModelImplCopyWithImpl<$Res>
    extends _$ApplicationAnswerModelCopyWithImpl<$Res,
        _$ApplicationAnswerModelImpl>
    implements _$$ApplicationAnswerModelImplCopyWith<$Res> {
  __$$ApplicationAnswerModelImplCopyWithImpl(
      _$ApplicationAnswerModelImpl _value,
      $Res Function(_$ApplicationAnswerModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? applicationAnswerId = freezed,
    Object? eventStaffApplicationId = freezed,
    Object? requirementQuestionId = freezed,
    Object? answerValue = freezed,
  }) {
    return _then(_$ApplicationAnswerModelImpl(
      applicationAnswerId: freezed == applicationAnswerId
          ? _value.applicationAnswerId
          : applicationAnswerId // ignore: cast_nullable_to_non_nullable
              as int?,
      eventStaffApplicationId: freezed == eventStaffApplicationId
          ? _value.eventStaffApplicationId
          : eventStaffApplicationId // ignore: cast_nullable_to_non_nullable
              as int?,
      requirementQuestionId: freezed == requirementQuestionId
          ? _value.requirementQuestionId
          : requirementQuestionId // ignore: cast_nullable_to_non_nullable
              as int?,
      answerValue: freezed == answerValue
          ? _value.answerValue
          : answerValue // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApplicationAnswerModelImpl implements _ApplicationAnswerModel {
  const _$ApplicationAnswerModelImpl(
      {this.applicationAnswerId,
      this.eventStaffApplicationId,
      this.requirementQuestionId,
      this.answerValue});

  factory _$ApplicationAnswerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApplicationAnswerModelImplFromJson(json);

  @override
  final int? applicationAnswerId;
  @override
  final int? eventStaffApplicationId;
  @override
  final int? requirementQuestionId;
  @override
  final String? answerValue;

  @override
  String toString() {
    return 'ApplicationAnswerModel(applicationAnswerId: $applicationAnswerId, eventStaffApplicationId: $eventStaffApplicationId, requirementQuestionId: $requirementQuestionId, answerValue: $answerValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplicationAnswerModelImpl &&
            (identical(other.applicationAnswerId, applicationAnswerId) ||
                other.applicationAnswerId == applicationAnswerId) &&
            (identical(
                    other.eventStaffApplicationId, eventStaffApplicationId) ||
                other.eventStaffApplicationId == eventStaffApplicationId) &&
            (identical(other.requirementQuestionId, requirementQuestionId) ||
                other.requirementQuestionId == requirementQuestionId) &&
            (identical(other.answerValue, answerValue) ||
                other.answerValue == answerValue));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, applicationAnswerId,
      eventStaffApplicationId, requirementQuestionId, answerValue);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApplicationAnswerModelImplCopyWith<_$ApplicationAnswerModelImpl>
      get copyWith => __$$ApplicationAnswerModelImplCopyWithImpl<
          _$ApplicationAnswerModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApplicationAnswerModelImplToJson(
      this,
    );
  }
}

abstract class _ApplicationAnswerModel implements ApplicationAnswerModel {
  const factory _ApplicationAnswerModel(
      {final int? applicationAnswerId,
      final int? eventStaffApplicationId,
      final int? requirementQuestionId,
      final String? answerValue}) = _$ApplicationAnswerModelImpl;

  factory _ApplicationAnswerModel.fromJson(Map<String, dynamic> json) =
      _$ApplicationAnswerModelImpl.fromJson;

  @override
  int? get applicationAnswerId;
  @override
  int? get eventStaffApplicationId;
  @override
  int? get requirementQuestionId;
  @override
  String? get answerValue;
  @override
  @JsonKey(ignore: true)
  _$$ApplicationAnswerModelImplCopyWith<_$ApplicationAnswerModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
