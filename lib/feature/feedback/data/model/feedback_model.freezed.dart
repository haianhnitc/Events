// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feedback_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FeedbackOptionModel _$FeedbackOptionModelFromJson(Map<String, dynamic> json) {
  return _FeedbackOptionModel.fromJson(json);
}

/// @nodoc
mixin _$FeedbackOptionModel {
  int? get optionId => throw _privateConstructorUsedError;
  int? get questionId => throw _privateConstructorUsedError;
  String? get optionValue => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FeedbackOptionModelCopyWith<FeedbackOptionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedbackOptionModelCopyWith<$Res> {
  factory $FeedbackOptionModelCopyWith(
          FeedbackOptionModel value, $Res Function(FeedbackOptionModel) then) =
      _$FeedbackOptionModelCopyWithImpl<$Res, FeedbackOptionModel>;
  @useResult
  $Res call({int? optionId, int? questionId, String? optionValue});
}

/// @nodoc
class _$FeedbackOptionModelCopyWithImpl<$Res, $Val extends FeedbackOptionModel>
    implements $FeedbackOptionModelCopyWith<$Res> {
  _$FeedbackOptionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? optionId = freezed,
    Object? questionId = freezed,
    Object? optionValue = freezed,
  }) {
    return _then(_value.copyWith(
      optionId: freezed == optionId
          ? _value.optionId
          : optionId // ignore: cast_nullable_to_non_nullable
              as int?,
      questionId: freezed == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as int?,
      optionValue: freezed == optionValue
          ? _value.optionValue
          : optionValue // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FeedbackOptionModelImplCopyWith<$Res>
    implements $FeedbackOptionModelCopyWith<$Res> {
  factory _$$FeedbackOptionModelImplCopyWith(_$FeedbackOptionModelImpl value,
          $Res Function(_$FeedbackOptionModelImpl) then) =
      __$$FeedbackOptionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? optionId, int? questionId, String? optionValue});
}

/// @nodoc
class __$$FeedbackOptionModelImplCopyWithImpl<$Res>
    extends _$FeedbackOptionModelCopyWithImpl<$Res, _$FeedbackOptionModelImpl>
    implements _$$FeedbackOptionModelImplCopyWith<$Res> {
  __$$FeedbackOptionModelImplCopyWithImpl(_$FeedbackOptionModelImpl _value,
      $Res Function(_$FeedbackOptionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? optionId = freezed,
    Object? questionId = freezed,
    Object? optionValue = freezed,
  }) {
    return _then(_$FeedbackOptionModelImpl(
      optionId: freezed == optionId
          ? _value.optionId
          : optionId // ignore: cast_nullable_to_non_nullable
              as int?,
      questionId: freezed == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as int?,
      optionValue: freezed == optionValue
          ? _value.optionValue
          : optionValue // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FeedbackOptionModelImpl implements _FeedbackOptionModel {
  const _$FeedbackOptionModelImpl(
      {this.optionId, this.questionId, this.optionValue});

  factory _$FeedbackOptionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedbackOptionModelImplFromJson(json);

  @override
  final int? optionId;
  @override
  final int? questionId;
  @override
  final String? optionValue;

  @override
  String toString() {
    return 'FeedbackOptionModel(optionId: $optionId, questionId: $questionId, optionValue: $optionValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedbackOptionModelImpl &&
            (identical(other.optionId, optionId) ||
                other.optionId == optionId) &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.optionValue, optionValue) ||
                other.optionValue == optionValue));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, optionId, questionId, optionValue);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedbackOptionModelImplCopyWith<_$FeedbackOptionModelImpl> get copyWith =>
      __$$FeedbackOptionModelImplCopyWithImpl<_$FeedbackOptionModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedbackOptionModelImplToJson(
      this,
    );
  }
}

abstract class _FeedbackOptionModel implements FeedbackOptionModel {
  const factory _FeedbackOptionModel(
      {final int? optionId,
      final int? questionId,
      final String? optionValue}) = _$FeedbackOptionModelImpl;

  factory _FeedbackOptionModel.fromJson(Map<String, dynamic> json) =
      _$FeedbackOptionModelImpl.fromJson;

  @override
  int? get optionId;
  @override
  int? get questionId;
  @override
  String? get optionValue;
  @override
  @JsonKey(ignore: true)
  _$$FeedbackOptionModelImplCopyWith<_$FeedbackOptionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FeedbackAnswerModel _$FeedbackAnswerModelFromJson(Map<String, dynamic> json) {
  return _FeedbackAnswerModel.fromJson(json);
}

/// @nodoc
mixin _$FeedbackAnswerModel {
  int? get id => throw _privateConstructorUsedError;
  int? get questionId => throw _privateConstructorUsedError;
  String? get questionText => throw _privateConstructorUsedError;
  FeedbackQuestionType? get questionType => throw _privateConstructorUsedError;
  String? get answerValue => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FeedbackAnswerModelCopyWith<FeedbackAnswerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedbackAnswerModelCopyWith<$Res> {
  factory $FeedbackAnswerModelCopyWith(
          FeedbackAnswerModel value, $Res Function(FeedbackAnswerModel) then) =
      _$FeedbackAnswerModelCopyWithImpl<$Res, FeedbackAnswerModel>;
  @useResult
  $Res call(
      {int? id,
      int? questionId,
      String? questionText,
      FeedbackQuestionType? questionType,
      String? answerValue});
}

/// @nodoc
class _$FeedbackAnswerModelCopyWithImpl<$Res, $Val extends FeedbackAnswerModel>
    implements $FeedbackAnswerModelCopyWith<$Res> {
  _$FeedbackAnswerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? questionId = freezed,
    Object? questionText = freezed,
    Object? questionType = freezed,
    Object? answerValue = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      questionId: freezed == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as int?,
      questionText: freezed == questionText
          ? _value.questionText
          : questionText // ignore: cast_nullable_to_non_nullable
              as String?,
      questionType: freezed == questionType
          ? _value.questionType
          : questionType // ignore: cast_nullable_to_non_nullable
              as FeedbackQuestionType?,
      answerValue: freezed == answerValue
          ? _value.answerValue
          : answerValue // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FeedbackAnswerModelImplCopyWith<$Res>
    implements $FeedbackAnswerModelCopyWith<$Res> {
  factory _$$FeedbackAnswerModelImplCopyWith(_$FeedbackAnswerModelImpl value,
          $Res Function(_$FeedbackAnswerModelImpl) then) =
      __$$FeedbackAnswerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      int? questionId,
      String? questionText,
      FeedbackQuestionType? questionType,
      String? answerValue});
}

/// @nodoc
class __$$FeedbackAnswerModelImplCopyWithImpl<$Res>
    extends _$FeedbackAnswerModelCopyWithImpl<$Res, _$FeedbackAnswerModelImpl>
    implements _$$FeedbackAnswerModelImplCopyWith<$Res> {
  __$$FeedbackAnswerModelImplCopyWithImpl(_$FeedbackAnswerModelImpl _value,
      $Res Function(_$FeedbackAnswerModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? questionId = freezed,
    Object? questionText = freezed,
    Object? questionType = freezed,
    Object? answerValue = freezed,
  }) {
    return _then(_$FeedbackAnswerModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      questionId: freezed == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as int?,
      questionText: freezed == questionText
          ? _value.questionText
          : questionText // ignore: cast_nullable_to_non_nullable
              as String?,
      questionType: freezed == questionType
          ? _value.questionType
          : questionType // ignore: cast_nullable_to_non_nullable
              as FeedbackQuestionType?,
      answerValue: freezed == answerValue
          ? _value.answerValue
          : answerValue // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FeedbackAnswerModelImpl implements _FeedbackAnswerModel {
  const _$FeedbackAnswerModelImpl(
      {this.id,
      this.questionId,
      this.questionText,
      this.questionType,
      this.answerValue});

  factory _$FeedbackAnswerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedbackAnswerModelImplFromJson(json);

  @override
  final int? id;
  @override
  final int? questionId;
  @override
  final String? questionText;
  @override
  final FeedbackQuestionType? questionType;
  @override
  final String? answerValue;

  @override
  String toString() {
    return 'FeedbackAnswerModel(id: $id, questionId: $questionId, questionText: $questionText, questionType: $questionType, answerValue: $answerValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedbackAnswerModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.questionText, questionText) ||
                other.questionText == questionText) &&
            (identical(other.questionType, questionType) ||
                other.questionType == questionType) &&
            (identical(other.answerValue, answerValue) ||
                other.answerValue == answerValue));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, questionId, questionText, questionType, answerValue);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedbackAnswerModelImplCopyWith<_$FeedbackAnswerModelImpl> get copyWith =>
      __$$FeedbackAnswerModelImplCopyWithImpl<_$FeedbackAnswerModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedbackAnswerModelImplToJson(
      this,
    );
  }
}

abstract class _FeedbackAnswerModel implements FeedbackAnswerModel {
  const factory _FeedbackAnswerModel(
      {final int? id,
      final int? questionId,
      final String? questionText,
      final FeedbackQuestionType? questionType,
      final String? answerValue}) = _$FeedbackAnswerModelImpl;

  factory _FeedbackAnswerModel.fromJson(Map<String, dynamic> json) =
      _$FeedbackAnswerModelImpl.fromJson;

  @override
  int? get id;
  @override
  int? get questionId;
  @override
  String? get questionText;
  @override
  FeedbackQuestionType? get questionType;
  @override
  String? get answerValue;
  @override
  @JsonKey(ignore: true)
  _$$FeedbackAnswerModelImplCopyWith<_$FeedbackAnswerModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FeedbackQuestionModel _$FeedbackQuestionModelFromJson(
    Map<String, dynamic> json) {
  return _FeedbackQuestionModel.fromJson(json);
}

/// @nodoc
mixin _$FeedbackQuestionModel {
  int? get feedbackQuestionId => throw _privateConstructorUsedError;
  EventSummaryModel? get event => throw _privateConstructorUsedError;
  String? get questionContent => throw _privateConstructorUsedError;
  FeedbackQuestionType? get questionType => throw _privateConstructorUsedError;
  bool? get isRequired => throw _privateConstructorUsedError;
  List<FeedbackOptionModel>? get options => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FeedbackQuestionModelCopyWith<FeedbackQuestionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedbackQuestionModelCopyWith<$Res> {
  factory $FeedbackQuestionModelCopyWith(FeedbackQuestionModel value,
          $Res Function(FeedbackQuestionModel) then) =
      _$FeedbackQuestionModelCopyWithImpl<$Res, FeedbackQuestionModel>;
  @useResult
  $Res call(
      {int? feedbackQuestionId,
      EventSummaryModel? event,
      String? questionContent,
      FeedbackQuestionType? questionType,
      bool? isRequired,
      List<FeedbackOptionModel>? options});

  $EventSummaryModelCopyWith<$Res>? get event;
}

/// @nodoc
class _$FeedbackQuestionModelCopyWithImpl<$Res,
        $Val extends FeedbackQuestionModel>
    implements $FeedbackQuestionModelCopyWith<$Res> {
  _$FeedbackQuestionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? feedbackQuestionId = freezed,
    Object? event = freezed,
    Object? questionContent = freezed,
    Object? questionType = freezed,
    Object? isRequired = freezed,
    Object? options = freezed,
  }) {
    return _then(_value.copyWith(
      feedbackQuestionId: freezed == feedbackQuestionId
          ? _value.feedbackQuestionId
          : feedbackQuestionId // ignore: cast_nullable_to_non_nullable
              as int?,
      event: freezed == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as EventSummaryModel?,
      questionContent: freezed == questionContent
          ? _value.questionContent
          : questionContent // ignore: cast_nullable_to_non_nullable
              as String?,
      questionType: freezed == questionType
          ? _value.questionType
          : questionType // ignore: cast_nullable_to_non_nullable
              as FeedbackQuestionType?,
      isRequired: freezed == isRequired
          ? _value.isRequired
          : isRequired // ignore: cast_nullable_to_non_nullable
              as bool?,
      options: freezed == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<FeedbackOptionModel>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $EventSummaryModelCopyWith<$Res>? get event {
    if (_value.event == null) {
      return null;
    }

    return $EventSummaryModelCopyWith<$Res>(_value.event!, (value) {
      return _then(_value.copyWith(event: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FeedbackQuestionModelImplCopyWith<$Res>
    implements $FeedbackQuestionModelCopyWith<$Res> {
  factory _$$FeedbackQuestionModelImplCopyWith(
          _$FeedbackQuestionModelImpl value,
          $Res Function(_$FeedbackQuestionModelImpl) then) =
      __$$FeedbackQuestionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? feedbackQuestionId,
      EventSummaryModel? event,
      String? questionContent,
      FeedbackQuestionType? questionType,
      bool? isRequired,
      List<FeedbackOptionModel>? options});

  @override
  $EventSummaryModelCopyWith<$Res>? get event;
}

/// @nodoc
class __$$FeedbackQuestionModelImplCopyWithImpl<$Res>
    extends _$FeedbackQuestionModelCopyWithImpl<$Res,
        _$FeedbackQuestionModelImpl>
    implements _$$FeedbackQuestionModelImplCopyWith<$Res> {
  __$$FeedbackQuestionModelImplCopyWithImpl(_$FeedbackQuestionModelImpl _value,
      $Res Function(_$FeedbackQuestionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? feedbackQuestionId = freezed,
    Object? event = freezed,
    Object? questionContent = freezed,
    Object? questionType = freezed,
    Object? isRequired = freezed,
    Object? options = freezed,
  }) {
    return _then(_$FeedbackQuestionModelImpl(
      feedbackQuestionId: freezed == feedbackQuestionId
          ? _value.feedbackQuestionId
          : feedbackQuestionId // ignore: cast_nullable_to_non_nullable
              as int?,
      event: freezed == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as EventSummaryModel?,
      questionContent: freezed == questionContent
          ? _value.questionContent
          : questionContent // ignore: cast_nullable_to_non_nullable
              as String?,
      questionType: freezed == questionType
          ? _value.questionType
          : questionType // ignore: cast_nullable_to_non_nullable
              as FeedbackQuestionType?,
      isRequired: freezed == isRequired
          ? _value.isRequired
          : isRequired // ignore: cast_nullable_to_non_nullable
              as bool?,
      options: freezed == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<FeedbackOptionModel>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FeedbackQuestionModelImpl implements _FeedbackQuestionModel {
  const _$FeedbackQuestionModelImpl(
      {this.feedbackQuestionId,
      this.event,
      this.questionContent,
      this.questionType,
      this.isRequired,
      final List<FeedbackOptionModel>? options})
      : _options = options;

  factory _$FeedbackQuestionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedbackQuestionModelImplFromJson(json);

  @override
  final int? feedbackQuestionId;
  @override
  final EventSummaryModel? event;
  @override
  final String? questionContent;
  @override
  final FeedbackQuestionType? questionType;
  @override
  final bool? isRequired;
  final List<FeedbackOptionModel>? _options;
  @override
  List<FeedbackOptionModel>? get options {
    final value = _options;
    if (value == null) return null;
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'FeedbackQuestionModel(feedbackQuestionId: $feedbackQuestionId, event: $event, questionContent: $questionContent, questionType: $questionType, isRequired: $isRequired, options: $options)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedbackQuestionModelImpl &&
            (identical(other.feedbackQuestionId, feedbackQuestionId) ||
                other.feedbackQuestionId == feedbackQuestionId) &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.questionContent, questionContent) ||
                other.questionContent == questionContent) &&
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
      feedbackQuestionId,
      event,
      questionContent,
      questionType,
      isRequired,
      const DeepCollectionEquality().hash(_options));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedbackQuestionModelImplCopyWith<_$FeedbackQuestionModelImpl>
      get copyWith => __$$FeedbackQuestionModelImplCopyWithImpl<
          _$FeedbackQuestionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedbackQuestionModelImplToJson(
      this,
    );
  }
}

abstract class _FeedbackQuestionModel implements FeedbackQuestionModel {
  const factory _FeedbackQuestionModel(
      {final int? feedbackQuestionId,
      final EventSummaryModel? event,
      final String? questionContent,
      final FeedbackQuestionType? questionType,
      final bool? isRequired,
      final List<FeedbackOptionModel>? options}) = _$FeedbackQuestionModelImpl;

  factory _FeedbackQuestionModel.fromJson(Map<String, dynamic> json) =
      _$FeedbackQuestionModelImpl.fromJson;

  @override
  int? get feedbackQuestionId;
  @override
  EventSummaryModel? get event;
  @override
  String? get questionContent;
  @override
  FeedbackQuestionType? get questionType;
  @override
  bool? get isRequired;
  @override
  List<FeedbackOptionModel>? get options;
  @override
  @JsonKey(ignore: true)
  _$$FeedbackQuestionModelImplCopyWith<_$FeedbackQuestionModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

FeedbackModel _$FeedbackModelFromJson(Map<String, dynamic> json) {
  return _FeedbackModel.fromJson(json);
}

/// @nodoc
mixin _$FeedbackModel {
  int? get attendanceFeedbackId => throw _privateConstructorUsedError;
  ParticipantModel? get eventParticipant => throw _privateConstructorUsedError;
  List<FeedbackAnswerModel>? get feedbackAnswers =>
      throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  DateTime? get createdTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FeedbackModelCopyWith<FeedbackModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedbackModelCopyWith<$Res> {
  factory $FeedbackModelCopyWith(
          FeedbackModel value, $Res Function(FeedbackModel) then) =
      _$FeedbackModelCopyWithImpl<$Res, FeedbackModel>;
  @useResult
  $Res call(
      {int? attendanceFeedbackId,
      ParticipantModel? eventParticipant,
      List<FeedbackAnswerModel>? feedbackAnswers,
      String? comment,
      DateTime? createdTime});

  $ParticipantModelCopyWith<$Res>? get eventParticipant;
}

/// @nodoc
class _$FeedbackModelCopyWithImpl<$Res, $Val extends FeedbackModel>
    implements $FeedbackModelCopyWith<$Res> {
  _$FeedbackModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? attendanceFeedbackId = freezed,
    Object? eventParticipant = freezed,
    Object? feedbackAnswers = freezed,
    Object? comment = freezed,
    Object? createdTime = freezed,
  }) {
    return _then(_value.copyWith(
      attendanceFeedbackId: freezed == attendanceFeedbackId
          ? _value.attendanceFeedbackId
          : attendanceFeedbackId // ignore: cast_nullable_to_non_nullable
              as int?,
      eventParticipant: freezed == eventParticipant
          ? _value.eventParticipant
          : eventParticipant // ignore: cast_nullable_to_non_nullable
              as ParticipantModel?,
      feedbackAnswers: freezed == feedbackAnswers
          ? _value.feedbackAnswers
          : feedbackAnswers // ignore: cast_nullable_to_non_nullable
              as List<FeedbackAnswerModel>?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      createdTime: freezed == createdTime
          ? _value.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ParticipantModelCopyWith<$Res>? get eventParticipant {
    if (_value.eventParticipant == null) {
      return null;
    }

    return $ParticipantModelCopyWith<$Res>(_value.eventParticipant!, (value) {
      return _then(_value.copyWith(eventParticipant: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FeedbackModelImplCopyWith<$Res>
    implements $FeedbackModelCopyWith<$Res> {
  factory _$$FeedbackModelImplCopyWith(
          _$FeedbackModelImpl value, $Res Function(_$FeedbackModelImpl) then) =
      __$$FeedbackModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? attendanceFeedbackId,
      ParticipantModel? eventParticipant,
      List<FeedbackAnswerModel>? feedbackAnswers,
      String? comment,
      DateTime? createdTime});

  @override
  $ParticipantModelCopyWith<$Res>? get eventParticipant;
}

/// @nodoc
class __$$FeedbackModelImplCopyWithImpl<$Res>
    extends _$FeedbackModelCopyWithImpl<$Res, _$FeedbackModelImpl>
    implements _$$FeedbackModelImplCopyWith<$Res> {
  __$$FeedbackModelImplCopyWithImpl(
      _$FeedbackModelImpl _value, $Res Function(_$FeedbackModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? attendanceFeedbackId = freezed,
    Object? eventParticipant = freezed,
    Object? feedbackAnswers = freezed,
    Object? comment = freezed,
    Object? createdTime = freezed,
  }) {
    return _then(_$FeedbackModelImpl(
      attendanceFeedbackId: freezed == attendanceFeedbackId
          ? _value.attendanceFeedbackId
          : attendanceFeedbackId // ignore: cast_nullable_to_non_nullable
              as int?,
      eventParticipant: freezed == eventParticipant
          ? _value.eventParticipant
          : eventParticipant // ignore: cast_nullable_to_non_nullable
              as ParticipantModel?,
      feedbackAnswers: freezed == feedbackAnswers
          ? _value._feedbackAnswers
          : feedbackAnswers // ignore: cast_nullable_to_non_nullable
              as List<FeedbackAnswerModel>?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      createdTime: freezed == createdTime
          ? _value.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FeedbackModelImpl implements _FeedbackModel {
  const _$FeedbackModelImpl(
      {this.attendanceFeedbackId,
      this.eventParticipant,
      final List<FeedbackAnswerModel>? feedbackAnswers,
      this.comment,
      this.createdTime})
      : _feedbackAnswers = feedbackAnswers;

  factory _$FeedbackModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedbackModelImplFromJson(json);

  @override
  final int? attendanceFeedbackId;
  @override
  final ParticipantModel? eventParticipant;
  final List<FeedbackAnswerModel>? _feedbackAnswers;
  @override
  List<FeedbackAnswerModel>? get feedbackAnswers {
    final value = _feedbackAnswers;
    if (value == null) return null;
    if (_feedbackAnswers is EqualUnmodifiableListView) return _feedbackAnswers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? comment;
  @override
  final DateTime? createdTime;

  @override
  String toString() {
    return 'FeedbackModel(attendanceFeedbackId: $attendanceFeedbackId, eventParticipant: $eventParticipant, feedbackAnswers: $feedbackAnswers, comment: $comment, createdTime: $createdTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedbackModelImpl &&
            (identical(other.attendanceFeedbackId, attendanceFeedbackId) ||
                other.attendanceFeedbackId == attendanceFeedbackId) &&
            (identical(other.eventParticipant, eventParticipant) ||
                other.eventParticipant == eventParticipant) &&
            const DeepCollectionEquality()
                .equals(other._feedbackAnswers, _feedbackAnswers) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.createdTime, createdTime) ||
                other.createdTime == createdTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      attendanceFeedbackId,
      eventParticipant,
      const DeepCollectionEquality().hash(_feedbackAnswers),
      comment,
      createdTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedbackModelImplCopyWith<_$FeedbackModelImpl> get copyWith =>
      __$$FeedbackModelImplCopyWithImpl<_$FeedbackModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedbackModelImplToJson(
      this,
    );
  }
}

abstract class _FeedbackModel implements FeedbackModel {
  const factory _FeedbackModel(
      {final int? attendanceFeedbackId,
      final ParticipantModel? eventParticipant,
      final List<FeedbackAnswerModel>? feedbackAnswers,
      final String? comment,
      final DateTime? createdTime}) = _$FeedbackModelImpl;

  factory _FeedbackModel.fromJson(Map<String, dynamic> json) =
      _$FeedbackModelImpl.fromJson;

  @override
  int? get attendanceFeedbackId;
  @override
  ParticipantModel? get eventParticipant;
  @override
  List<FeedbackAnswerModel>? get feedbackAnswers;
  @override
  String? get comment;
  @override
  DateTime? get createdTime;
  @override
  @JsonKey(ignore: true)
  _$$FeedbackModelImplCopyWith<_$FeedbackModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
