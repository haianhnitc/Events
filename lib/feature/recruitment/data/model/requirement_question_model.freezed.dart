// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'requirement_question_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RequirementQuestionModel _$RequirementQuestionModelFromJson(
    Map<String, dynamic> json) {
  return _RequirementQuestionModel.fromJson(json);
}

/// @nodoc
mixin _$RequirementQuestionModel {
  int? get questionId => throw _privateConstructorUsedError;
  int? get ctvRecruitmentId => throw _privateConstructorUsedError;
  String? get questionText => throw _privateConstructorUsedError;
  RequirementQuestionType? get questionType =>
      throw _privateConstructorUsedError;
  bool? get isRequired => throw _privateConstructorUsedError;
  List<QuestionOptionModel>? get options => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RequirementQuestionModelCopyWith<RequirementQuestionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequirementQuestionModelCopyWith<$Res> {
  factory $RequirementQuestionModelCopyWith(RequirementQuestionModel value,
          $Res Function(RequirementQuestionModel) then) =
      _$RequirementQuestionModelCopyWithImpl<$Res, RequirementQuestionModel>;
  @useResult
  $Res call(
      {int? questionId,
      int? ctvRecruitmentId,
      String? questionText,
      RequirementQuestionType? questionType,
      bool? isRequired,
      List<QuestionOptionModel>? options});
}

/// @nodoc
class _$RequirementQuestionModelCopyWithImpl<$Res,
        $Val extends RequirementQuestionModel>
    implements $RequirementQuestionModelCopyWith<$Res> {
  _$RequirementQuestionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionId = freezed,
    Object? ctvRecruitmentId = freezed,
    Object? questionText = freezed,
    Object? questionType = freezed,
    Object? isRequired = freezed,
    Object? options = freezed,
  }) {
    return _then(_value.copyWith(
      questionId: freezed == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as int?,
      ctvRecruitmentId: freezed == ctvRecruitmentId
          ? _value.ctvRecruitmentId
          : ctvRecruitmentId // ignore: cast_nullable_to_non_nullable
              as int?,
      questionText: freezed == questionText
          ? _value.questionText
          : questionText // ignore: cast_nullable_to_non_nullable
              as String?,
      questionType: freezed == questionType
          ? _value.questionType
          : questionType // ignore: cast_nullable_to_non_nullable
              as RequirementQuestionType?,
      isRequired: freezed == isRequired
          ? _value.isRequired
          : isRequired // ignore: cast_nullable_to_non_nullable
              as bool?,
      options: freezed == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<QuestionOptionModel>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RequirementQuestionModelImplCopyWith<$Res>
    implements $RequirementQuestionModelCopyWith<$Res> {
  factory _$$RequirementQuestionModelImplCopyWith(
          _$RequirementQuestionModelImpl value,
          $Res Function(_$RequirementQuestionModelImpl) then) =
      __$$RequirementQuestionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? questionId,
      int? ctvRecruitmentId,
      String? questionText,
      RequirementQuestionType? questionType,
      bool? isRequired,
      List<QuestionOptionModel>? options});
}

/// @nodoc
class __$$RequirementQuestionModelImplCopyWithImpl<$Res>
    extends _$RequirementQuestionModelCopyWithImpl<$Res,
        _$RequirementQuestionModelImpl>
    implements _$$RequirementQuestionModelImplCopyWith<$Res> {
  __$$RequirementQuestionModelImplCopyWithImpl(
      _$RequirementQuestionModelImpl _value,
      $Res Function(_$RequirementQuestionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionId = freezed,
    Object? ctvRecruitmentId = freezed,
    Object? questionText = freezed,
    Object? questionType = freezed,
    Object? isRequired = freezed,
    Object? options = freezed,
  }) {
    return _then(_$RequirementQuestionModelImpl(
      questionId: freezed == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as int?,
      ctvRecruitmentId: freezed == ctvRecruitmentId
          ? _value.ctvRecruitmentId
          : ctvRecruitmentId // ignore: cast_nullable_to_non_nullable
              as int?,
      questionText: freezed == questionText
          ? _value.questionText
          : questionText // ignore: cast_nullable_to_non_nullable
              as String?,
      questionType: freezed == questionType
          ? _value.questionType
          : questionType // ignore: cast_nullable_to_non_nullable
              as RequirementQuestionType?,
      isRequired: freezed == isRequired
          ? _value.isRequired
          : isRequired // ignore: cast_nullable_to_non_nullable
              as bool?,
      options: freezed == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<QuestionOptionModel>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RequirementQuestionModelImpl implements _RequirementQuestionModel {
  const _$RequirementQuestionModelImpl(
      {this.questionId,
      this.ctvRecruitmentId,
      this.questionText,
      this.questionType,
      this.isRequired,
      final List<QuestionOptionModel>? options})
      : _options = options;

  factory _$RequirementQuestionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RequirementQuestionModelImplFromJson(json);

  @override
  final int? questionId;
  @override
  final int? ctvRecruitmentId;
  @override
  final String? questionText;
  @override
  final RequirementQuestionType? questionType;
  @override
  final bool? isRequired;
  final List<QuestionOptionModel>? _options;
  @override
  List<QuestionOptionModel>? get options {
    final value = _options;
    if (value == null) return null;
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'RequirementQuestionModel(questionId: $questionId, ctvRecruitmentId: $ctvRecruitmentId, questionText: $questionText, questionType: $questionType, isRequired: $isRequired, options: $options)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RequirementQuestionModelImpl &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.ctvRecruitmentId, ctvRecruitmentId) ||
                other.ctvRecruitmentId == ctvRecruitmentId) &&
            (identical(other.questionText, questionText) ||
                other.questionText == questionText) &&
            (identical(other.questionType, questionType) ||
                other.questionType == questionType) &&
            (identical(other.isRequired, isRequired) ||
                other.isRequired == isRequired) &&
            const DeepCollectionEquality().equals(other._options, _options));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      questionId,
      ctvRecruitmentId,
      questionText,
      questionType,
      isRequired,
      const DeepCollectionEquality().hash(_options));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RequirementQuestionModelImplCopyWith<_$RequirementQuestionModelImpl>
      get copyWith => __$$RequirementQuestionModelImplCopyWithImpl<
          _$RequirementQuestionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RequirementQuestionModelImplToJson(
      this,
    );
  }
}

abstract class _RequirementQuestionModel implements RequirementQuestionModel {
  const factory _RequirementQuestionModel(
          {final int? questionId,
          final int? ctvRecruitmentId,
          final String? questionText,
          final RequirementQuestionType? questionType,
          final bool? isRequired,
          final List<QuestionOptionModel>? options}) =
      _$RequirementQuestionModelImpl;

  factory _RequirementQuestionModel.fromJson(Map<String, dynamic> json) =
      _$RequirementQuestionModelImpl.fromJson;

  @override
  int? get questionId;
  @override
  int? get ctvRecruitmentId;
  @override
  String? get questionText;
  @override
  RequirementQuestionType? get questionType;
  @override
  bool? get isRequired;
  @override
  List<QuestionOptionModel>? get options;
  @override
  @JsonKey(ignore: true)
  _$$RequirementQuestionModelImplCopyWith<_$RequirementQuestionModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
