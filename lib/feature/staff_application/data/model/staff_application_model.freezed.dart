// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'staff_application_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StaffApplicationModel _$StaffApplicationModelFromJson(
    Map<String, dynamic> json) {
  return _StaffApplicationModel.fromJson(json);
}

/// @nodoc
mixin _$StaffApplicationModel {
  int? get applicationId => throw _privateConstructorUsedError;
  UserSummaryModel? get applicant => throw _privateConstructorUsedError;
  int? get eventId => throw _privateConstructorUsedError;
  String? get eventTitle => throw _privateConstructorUsedError;
  String? get roleName => throw _privateConstructorUsedError;
  String? get cvUrl => throw _privateConstructorUsedError;
  StaffApplicationStatus? get status => throw _privateConstructorUsedError;
  String? get rejectionReason => throw _privateConstructorUsedError;
  DateTime? get appliedTime => throw _privateConstructorUsedError;
  DateTime? get reviewedTime => throw _privateConstructorUsedError;
  List<ApplicationAnswerModel>? get applicationAnswers =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StaffApplicationModelCopyWith<StaffApplicationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StaffApplicationModelCopyWith<$Res> {
  factory $StaffApplicationModelCopyWith(StaffApplicationModel value,
          $Res Function(StaffApplicationModel) then) =
      _$StaffApplicationModelCopyWithImpl<$Res, StaffApplicationModel>;
  @useResult
  $Res call(
      {int? applicationId,
      UserSummaryModel? applicant,
      int? eventId,
      String? eventTitle,
      String? roleName,
      String? cvUrl,
      StaffApplicationStatus? status,
      String? rejectionReason,
      DateTime? appliedTime,
      DateTime? reviewedTime,
      List<ApplicationAnswerModel>? applicationAnswers});

  $UserSummaryModelCopyWith<$Res>? get applicant;
}

/// @nodoc
class _$StaffApplicationModelCopyWithImpl<$Res,
        $Val extends StaffApplicationModel>
    implements $StaffApplicationModelCopyWith<$Res> {
  _$StaffApplicationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? applicationId = freezed,
    Object? applicant = freezed,
    Object? eventId = freezed,
    Object? eventTitle = freezed,
    Object? roleName = freezed,
    Object? cvUrl = freezed,
    Object? status = freezed,
    Object? rejectionReason = freezed,
    Object? appliedTime = freezed,
    Object? reviewedTime = freezed,
    Object? applicationAnswers = freezed,
  }) {
    return _then(_value.copyWith(
      applicationId: freezed == applicationId
          ? _value.applicationId
          : applicationId // ignore: cast_nullable_to_non_nullable
              as int?,
      applicant: freezed == applicant
          ? _value.applicant
          : applicant // ignore: cast_nullable_to_non_nullable
              as UserSummaryModel?,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as int?,
      eventTitle: freezed == eventTitle
          ? _value.eventTitle
          : eventTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      roleName: freezed == roleName
          ? _value.roleName
          : roleName // ignore: cast_nullable_to_non_nullable
              as String?,
      cvUrl: freezed == cvUrl
          ? _value.cvUrl
          : cvUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as StaffApplicationStatus?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      appliedTime: freezed == appliedTime
          ? _value.appliedTime
          : appliedTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reviewedTime: freezed == reviewedTime
          ? _value.reviewedTime
          : reviewedTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      applicationAnswers: freezed == applicationAnswers
          ? _value.applicationAnswers
          : applicationAnswers // ignore: cast_nullable_to_non_nullable
              as List<ApplicationAnswerModel>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserSummaryModelCopyWith<$Res>? get applicant {
    if (_value.applicant == null) {
      return null;
    }

    return $UserSummaryModelCopyWith<$Res>(_value.applicant!, (value) {
      return _then(_value.copyWith(applicant: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StaffApplicationModelImplCopyWith<$Res>
    implements $StaffApplicationModelCopyWith<$Res> {
  factory _$$StaffApplicationModelImplCopyWith(
          _$StaffApplicationModelImpl value,
          $Res Function(_$StaffApplicationModelImpl) then) =
      __$$StaffApplicationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? applicationId,
      UserSummaryModel? applicant,
      int? eventId,
      String? eventTitle,
      String? roleName,
      String? cvUrl,
      StaffApplicationStatus? status,
      String? rejectionReason,
      DateTime? appliedTime,
      DateTime? reviewedTime,
      List<ApplicationAnswerModel>? applicationAnswers});

  @override
  $UserSummaryModelCopyWith<$Res>? get applicant;
}

/// @nodoc
class __$$StaffApplicationModelImplCopyWithImpl<$Res>
    extends _$StaffApplicationModelCopyWithImpl<$Res,
        _$StaffApplicationModelImpl>
    implements _$$StaffApplicationModelImplCopyWith<$Res> {
  __$$StaffApplicationModelImplCopyWithImpl(_$StaffApplicationModelImpl _value,
      $Res Function(_$StaffApplicationModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? applicationId = freezed,
    Object? applicant = freezed,
    Object? eventId = freezed,
    Object? eventTitle = freezed,
    Object? roleName = freezed,
    Object? cvUrl = freezed,
    Object? status = freezed,
    Object? rejectionReason = freezed,
    Object? appliedTime = freezed,
    Object? reviewedTime = freezed,
    Object? applicationAnswers = freezed,
  }) {
    return _then(_$StaffApplicationModelImpl(
      applicationId: freezed == applicationId
          ? _value.applicationId
          : applicationId // ignore: cast_nullable_to_non_nullable
              as int?,
      applicant: freezed == applicant
          ? _value.applicant
          : applicant // ignore: cast_nullable_to_non_nullable
              as UserSummaryModel?,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as int?,
      eventTitle: freezed == eventTitle
          ? _value.eventTitle
          : eventTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      roleName: freezed == roleName
          ? _value.roleName
          : roleName // ignore: cast_nullable_to_non_nullable
              as String?,
      cvUrl: freezed == cvUrl
          ? _value.cvUrl
          : cvUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as StaffApplicationStatus?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      appliedTime: freezed == appliedTime
          ? _value.appliedTime
          : appliedTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reviewedTime: freezed == reviewedTime
          ? _value.reviewedTime
          : reviewedTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      applicationAnswers: freezed == applicationAnswers
          ? _value._applicationAnswers
          : applicationAnswers // ignore: cast_nullable_to_non_nullable
              as List<ApplicationAnswerModel>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StaffApplicationModelImpl implements _StaffApplicationModel {
  const _$StaffApplicationModelImpl(
      {this.applicationId,
      this.applicant,
      this.eventId,
      this.eventTitle,
      this.roleName,
      this.cvUrl,
      this.status,
      this.rejectionReason,
      this.appliedTime,
      this.reviewedTime,
      final List<ApplicationAnswerModel>? applicationAnswers})
      : _applicationAnswers = applicationAnswers;

  factory _$StaffApplicationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StaffApplicationModelImplFromJson(json);

  @override
  final int? applicationId;
  @override
  final UserSummaryModel? applicant;
  @override
  final int? eventId;
  @override
  final String? eventTitle;
  @override
  final String? roleName;
  @override
  final String? cvUrl;
  @override
  final StaffApplicationStatus? status;
  @override
  final String? rejectionReason;
  @override
  final DateTime? appliedTime;
  @override
  final DateTime? reviewedTime;
  final List<ApplicationAnswerModel>? _applicationAnswers;
  @override
  List<ApplicationAnswerModel>? get applicationAnswers {
    final value = _applicationAnswers;
    if (value == null) return null;
    if (_applicationAnswers is EqualUnmodifiableListView)
      return _applicationAnswers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'StaffApplicationModel(applicationId: $applicationId, applicant: $applicant, eventId: $eventId, eventTitle: $eventTitle, roleName: $roleName, cvUrl: $cvUrl, status: $status, rejectionReason: $rejectionReason, appliedTime: $appliedTime, reviewedTime: $reviewedTime, applicationAnswers: $applicationAnswers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StaffApplicationModelImpl &&
            (identical(other.applicationId, applicationId) ||
                other.applicationId == applicationId) &&
            (identical(other.applicant, applicant) ||
                other.applicant == applicant) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.eventTitle, eventTitle) ||
                other.eventTitle == eventTitle) &&
            (identical(other.roleName, roleName) ||
                other.roleName == roleName) &&
            (identical(other.cvUrl, cvUrl) || other.cvUrl == cvUrl) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.appliedTime, appliedTime) ||
                other.appliedTime == appliedTime) &&
            (identical(other.reviewedTime, reviewedTime) ||
                other.reviewedTime == reviewedTime) &&
            const DeepCollectionEquality()
                .equals(other._applicationAnswers, _applicationAnswers));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      applicationId,
      applicant,
      eventId,
      eventTitle,
      roleName,
      cvUrl,
      status,
      rejectionReason,
      appliedTime,
      reviewedTime,
      const DeepCollectionEquality().hash(_applicationAnswers));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StaffApplicationModelImplCopyWith<_$StaffApplicationModelImpl>
      get copyWith => __$$StaffApplicationModelImplCopyWithImpl<
          _$StaffApplicationModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StaffApplicationModelImplToJson(
      this,
    );
  }
}

abstract class _StaffApplicationModel implements StaffApplicationModel {
  const factory _StaffApplicationModel(
          {final int? applicationId,
          final UserSummaryModel? applicant,
          final int? eventId,
          final String? eventTitle,
          final String? roleName,
          final String? cvUrl,
          final StaffApplicationStatus? status,
          final String? rejectionReason,
          final DateTime? appliedTime,
          final DateTime? reviewedTime,
          final List<ApplicationAnswerModel>? applicationAnswers}) =
      _$StaffApplicationModelImpl;

  factory _StaffApplicationModel.fromJson(Map<String, dynamic> json) =
      _$StaffApplicationModelImpl.fromJson;

  @override
  int? get applicationId;
  @override
  UserSummaryModel? get applicant;
  @override
  int? get eventId;
  @override
  String? get eventTitle;
  @override
  String? get roleName;
  @override
  String? get cvUrl;
  @override
  StaffApplicationStatus? get status;
  @override
  String? get rejectionReason;
  @override
  DateTime? get appliedTime;
  @override
  DateTime? get reviewedTime;
  @override
  List<ApplicationAnswerModel>? get applicationAnswers;
  @override
  @JsonKey(ignore: true)
  _$$StaffApplicationModelImplCopyWith<_$StaffApplicationModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ApplicationAnswerModel _$ApplicationAnswerModelFromJson(
    Map<String, dynamic> json) {
  return _ApplicationAnswerModel.fromJson(json);
}

/// @nodoc
mixin _$ApplicationAnswerModel {
  int? get id => throw _privateConstructorUsedError;
  int? get eventStaffApplicationId => throw _privateConstructorUsedError;
  int? get questionId => throw _privateConstructorUsedError;
  String? get questionText => throw _privateConstructorUsedError;
  RequirementQuestionType? get questionType =>
      throw _privateConstructorUsedError;
  String? get answerValue => throw _privateConstructorUsedError;
  List<int>? get selectedOptionIds => throw _privateConstructorUsedError;

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
      {int? id,
      int? eventStaffApplicationId,
      int? questionId,
      String? questionText,
      RequirementQuestionType? questionType,
      String? answerValue,
      List<int>? selectedOptionIds});
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
    Object? id = freezed,
    Object? eventStaffApplicationId = freezed,
    Object? questionId = freezed,
    Object? questionText = freezed,
    Object? questionType = freezed,
    Object? answerValue = freezed,
    Object? selectedOptionIds = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      eventStaffApplicationId: freezed == eventStaffApplicationId
          ? _value.eventStaffApplicationId
          : eventStaffApplicationId // ignore: cast_nullable_to_non_nullable
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
              as RequirementQuestionType?,
      answerValue: freezed == answerValue
          ? _value.answerValue
          : answerValue // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedOptionIds: freezed == selectedOptionIds
          ? _value.selectedOptionIds
          : selectedOptionIds // ignore: cast_nullable_to_non_nullable
              as List<int>?,
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
      {int? id,
      int? eventStaffApplicationId,
      int? questionId,
      String? questionText,
      RequirementQuestionType? questionType,
      String? answerValue,
      List<int>? selectedOptionIds});
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
    Object? id = freezed,
    Object? eventStaffApplicationId = freezed,
    Object? questionId = freezed,
    Object? questionText = freezed,
    Object? questionType = freezed,
    Object? answerValue = freezed,
    Object? selectedOptionIds = freezed,
  }) {
    return _then(_$ApplicationAnswerModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      eventStaffApplicationId: freezed == eventStaffApplicationId
          ? _value.eventStaffApplicationId
          : eventStaffApplicationId // ignore: cast_nullable_to_non_nullable
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
              as RequirementQuestionType?,
      answerValue: freezed == answerValue
          ? _value.answerValue
          : answerValue // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedOptionIds: freezed == selectedOptionIds
          ? _value._selectedOptionIds
          : selectedOptionIds // ignore: cast_nullable_to_non_nullable
              as List<int>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApplicationAnswerModelImpl implements _ApplicationAnswerModel {
  const _$ApplicationAnswerModelImpl(
      {this.id,
      this.eventStaffApplicationId,
      this.questionId,
      this.questionText,
      this.questionType,
      this.answerValue,
      final List<int>? selectedOptionIds})
      : _selectedOptionIds = selectedOptionIds;

  factory _$ApplicationAnswerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApplicationAnswerModelImplFromJson(json);

  @override
  final int? id;
  @override
  final int? eventStaffApplicationId;
  @override
  final int? questionId;
  @override
  final String? questionText;
  @override
  final RequirementQuestionType? questionType;
  @override
  final String? answerValue;
  final List<int>? _selectedOptionIds;
  @override
  List<int>? get selectedOptionIds {
    final value = _selectedOptionIds;
    if (value == null) return null;
    if (_selectedOptionIds is EqualUnmodifiableListView)
      return _selectedOptionIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ApplicationAnswerModel(id: $id, eventStaffApplicationId: $eventStaffApplicationId, questionId: $questionId, questionText: $questionText, questionType: $questionType, answerValue: $answerValue, selectedOptionIds: $selectedOptionIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplicationAnswerModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(
                    other.eventStaffApplicationId, eventStaffApplicationId) ||
                other.eventStaffApplicationId == eventStaffApplicationId) &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.questionText, questionText) ||
                other.questionText == questionText) &&
            (identical(other.questionType, questionType) ||
                other.questionType == questionType) &&
            (identical(other.answerValue, answerValue) ||
                other.answerValue == answerValue) &&
            const DeepCollectionEquality()
                .equals(other._selectedOptionIds, _selectedOptionIds));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      eventStaffApplicationId,
      questionId,
      questionText,
      questionType,
      answerValue,
      const DeepCollectionEquality().hash(_selectedOptionIds));

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
      {final int? id,
      final int? eventStaffApplicationId,
      final int? questionId,
      final String? questionText,
      final RequirementQuestionType? questionType,
      final String? answerValue,
      final List<int>? selectedOptionIds}) = _$ApplicationAnswerModelImpl;

  factory _ApplicationAnswerModel.fromJson(Map<String, dynamic> json) =
      _$ApplicationAnswerModelImpl.fromJson;

  @override
  int? get id;
  @override
  int? get eventStaffApplicationId;
  @override
  int? get questionId;
  @override
  String? get questionText;
  @override
  RequirementQuestionType? get questionType;
  @override
  String? get answerValue;
  @override
  List<int>? get selectedOptionIds;
  @override
  @JsonKey(ignore: true)
  _$$ApplicationAnswerModelImplCopyWith<_$ApplicationAnswerModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
