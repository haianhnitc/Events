// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ParticipantModel _$ParticipantModelFromJson(Map<String, dynamic> json) {
  return _ParticipantModel.fromJson(json);
}

/// @nodoc
mixin _$ParticipantModel {
  int? get eventParticipantId => throw _privateConstructorUsedError;
  int? get eventId => throw _privateConstructorUsedError;
  UserSummaryModel? get user => throw _privateConstructorUsedError;
  String? get participantQrContent => throw _privateConstructorUsedError;
  DateTime? get participantQrIssuedAt => throw _privateConstructorUsedError;
  ParticipantType? get participantType => throw _privateConstructorUsedError;
  int? get ticketId => throw _privateConstructorUsedError;
  ParticipantStatus? get status => throw _privateConstructorUsedError;
  bool? get hasCheckedIn => throw _privateConstructorUsedError;
  DateTime? get registeredTime => throw _privateConstructorUsedError;
  DateTime? get checkInTime => throw _privateConstructorUsedError;
  DateTime? get checkOutTime => throw _privateConstructorUsedError;
  bool? get isCheckOut => throw _privateConstructorUsedError;
  bool? get hasFeedback => throw _privateConstructorUsedError;
  DateTime? get feedbackSubmittedTime => throw _privateConstructorUsedError;
  int? get applicationId => throw _privateConstructorUsedError;
  int? get recruitmentId => throw _privateConstructorUsedError;
  String? get eventTitle => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ParticipantModelCopyWith<ParticipantModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParticipantModelCopyWith<$Res> {
  factory $ParticipantModelCopyWith(
          ParticipantModel value, $Res Function(ParticipantModel) then) =
      _$ParticipantModelCopyWithImpl<$Res, ParticipantModel>;
  @useResult
  $Res call(
      {int? eventParticipantId,
      int? eventId,
      UserSummaryModel? user,
      String? participantQrContent,
      DateTime? participantQrIssuedAt,
      ParticipantType? participantType,
      int? ticketId,
      ParticipantStatus? status,
      bool? hasCheckedIn,
      DateTime? registeredTime,
      DateTime? checkInTime,
      DateTime? checkOutTime,
      bool? isCheckOut,
      bool? hasFeedback,
      DateTime? feedbackSubmittedTime,
      int? applicationId,
      int? recruitmentId,
      String? eventTitle});

  $UserSummaryModelCopyWith<$Res>? get user;
}

/// @nodoc
class _$ParticipantModelCopyWithImpl<$Res, $Val extends ParticipantModel>
    implements $ParticipantModelCopyWith<$Res> {
  _$ParticipantModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventParticipantId = freezed,
    Object? eventId = freezed,
    Object? user = freezed,
    Object? participantQrContent = freezed,
    Object? participantQrIssuedAt = freezed,
    Object? participantType = freezed,
    Object? ticketId = freezed,
    Object? status = freezed,
    Object? hasCheckedIn = freezed,
    Object? registeredTime = freezed,
    Object? checkInTime = freezed,
    Object? checkOutTime = freezed,
    Object? isCheckOut = freezed,
    Object? hasFeedback = freezed,
    Object? feedbackSubmittedTime = freezed,
    Object? applicationId = freezed,
    Object? recruitmentId = freezed,
    Object? eventTitle = freezed,
  }) {
    return _then(_value.copyWith(
      eventParticipantId: freezed == eventParticipantId
          ? _value.eventParticipantId
          : eventParticipantId // ignore: cast_nullable_to_non_nullable
              as int?,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as int?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserSummaryModel?,
      participantQrContent: freezed == participantQrContent
          ? _value.participantQrContent
          : participantQrContent // ignore: cast_nullable_to_non_nullable
              as String?,
      participantQrIssuedAt: freezed == participantQrIssuedAt
          ? _value.participantQrIssuedAt
          : participantQrIssuedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      participantType: freezed == participantType
          ? _value.participantType
          : participantType // ignore: cast_nullable_to_non_nullable
              as ParticipantType?,
      ticketId: freezed == ticketId
          ? _value.ticketId
          : ticketId // ignore: cast_nullable_to_non_nullable
              as int?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ParticipantStatus?,
      hasCheckedIn: freezed == hasCheckedIn
          ? _value.hasCheckedIn
          : hasCheckedIn // ignore: cast_nullable_to_non_nullable
              as bool?,
      registeredTime: freezed == registeredTime
          ? _value.registeredTime
          : registeredTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      checkInTime: freezed == checkInTime
          ? _value.checkInTime
          : checkInTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      checkOutTime: freezed == checkOutTime
          ? _value.checkOutTime
          : checkOutTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCheckOut: freezed == isCheckOut
          ? _value.isCheckOut
          : isCheckOut // ignore: cast_nullable_to_non_nullable
              as bool?,
      hasFeedback: freezed == hasFeedback
          ? _value.hasFeedback
          : hasFeedback // ignore: cast_nullable_to_non_nullable
              as bool?,
      feedbackSubmittedTime: freezed == feedbackSubmittedTime
          ? _value.feedbackSubmittedTime
          : feedbackSubmittedTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      applicationId: freezed == applicationId
          ? _value.applicationId
          : applicationId // ignore: cast_nullable_to_non_nullable
              as int?,
      recruitmentId: freezed == recruitmentId
          ? _value.recruitmentId
          : recruitmentId // ignore: cast_nullable_to_non_nullable
              as int?,
      eventTitle: freezed == eventTitle
          ? _value.eventTitle
          : eventTitle // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserSummaryModelCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserSummaryModelCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ParticipantModelImplCopyWith<$Res>
    implements $ParticipantModelCopyWith<$Res> {
  factory _$$ParticipantModelImplCopyWith(_$ParticipantModelImpl value,
          $Res Function(_$ParticipantModelImpl) then) =
      __$$ParticipantModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? eventParticipantId,
      int? eventId,
      UserSummaryModel? user,
      String? participantQrContent,
      DateTime? participantQrIssuedAt,
      ParticipantType? participantType,
      int? ticketId,
      ParticipantStatus? status,
      bool? hasCheckedIn,
      DateTime? registeredTime,
      DateTime? checkInTime,
      DateTime? checkOutTime,
      bool? isCheckOut,
      bool? hasFeedback,
      DateTime? feedbackSubmittedTime,
      int? applicationId,
      int? recruitmentId,
      String? eventTitle});

  @override
  $UserSummaryModelCopyWith<$Res>? get user;
}

/// @nodoc
class __$$ParticipantModelImplCopyWithImpl<$Res>
    extends _$ParticipantModelCopyWithImpl<$Res, _$ParticipantModelImpl>
    implements _$$ParticipantModelImplCopyWith<$Res> {
  __$$ParticipantModelImplCopyWithImpl(_$ParticipantModelImpl _value,
      $Res Function(_$ParticipantModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventParticipantId = freezed,
    Object? eventId = freezed,
    Object? user = freezed,
    Object? participantQrContent = freezed,
    Object? participantQrIssuedAt = freezed,
    Object? participantType = freezed,
    Object? ticketId = freezed,
    Object? status = freezed,
    Object? hasCheckedIn = freezed,
    Object? registeredTime = freezed,
    Object? checkInTime = freezed,
    Object? checkOutTime = freezed,
    Object? isCheckOut = freezed,
    Object? hasFeedback = freezed,
    Object? feedbackSubmittedTime = freezed,
    Object? applicationId = freezed,
    Object? recruitmentId = freezed,
    Object? eventTitle = freezed,
  }) {
    return _then(_$ParticipantModelImpl(
      eventParticipantId: freezed == eventParticipantId
          ? _value.eventParticipantId
          : eventParticipantId // ignore: cast_nullable_to_non_nullable
              as int?,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as int?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserSummaryModel?,
      participantQrContent: freezed == participantQrContent
          ? _value.participantQrContent
          : participantQrContent // ignore: cast_nullable_to_non_nullable
              as String?,
      participantQrIssuedAt: freezed == participantQrIssuedAt
          ? _value.participantQrIssuedAt
          : participantQrIssuedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      participantType: freezed == participantType
          ? _value.participantType
          : participantType // ignore: cast_nullable_to_non_nullable
              as ParticipantType?,
      ticketId: freezed == ticketId
          ? _value.ticketId
          : ticketId // ignore: cast_nullable_to_non_nullable
              as int?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ParticipantStatus?,
      hasCheckedIn: freezed == hasCheckedIn
          ? _value.hasCheckedIn
          : hasCheckedIn // ignore: cast_nullable_to_non_nullable
              as bool?,
      registeredTime: freezed == registeredTime
          ? _value.registeredTime
          : registeredTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      checkInTime: freezed == checkInTime
          ? _value.checkInTime
          : checkInTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      checkOutTime: freezed == checkOutTime
          ? _value.checkOutTime
          : checkOutTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCheckOut: freezed == isCheckOut
          ? _value.isCheckOut
          : isCheckOut // ignore: cast_nullable_to_non_nullable
              as bool?,
      hasFeedback: freezed == hasFeedback
          ? _value.hasFeedback
          : hasFeedback // ignore: cast_nullable_to_non_nullable
              as bool?,
      feedbackSubmittedTime: freezed == feedbackSubmittedTime
          ? _value.feedbackSubmittedTime
          : feedbackSubmittedTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      applicationId: freezed == applicationId
          ? _value.applicationId
          : applicationId // ignore: cast_nullable_to_non_nullable
              as int?,
      recruitmentId: freezed == recruitmentId
          ? _value.recruitmentId
          : recruitmentId // ignore: cast_nullable_to_non_nullable
              as int?,
      eventTitle: freezed == eventTitle
          ? _value.eventTitle
          : eventTitle // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ParticipantModelImpl implements _ParticipantModel {
  const _$ParticipantModelImpl(
      {this.eventParticipantId,
      this.eventId,
      this.user,
      this.participantQrContent,
      this.participantQrIssuedAt,
      this.participantType,
      this.ticketId,
      this.status,
      this.hasCheckedIn,
      this.registeredTime,
      this.checkInTime,
      this.checkOutTime,
      this.isCheckOut,
      this.hasFeedback,
      this.feedbackSubmittedTime,
      this.applicationId,
      this.recruitmentId,
      this.eventTitle});

  factory _$ParticipantModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ParticipantModelImplFromJson(json);

  @override
  final int? eventParticipantId;
  @override
  final int? eventId;
  @override
  final UserSummaryModel? user;
  @override
  final String? participantQrContent;
  @override
  final DateTime? participantQrIssuedAt;
  @override
  final ParticipantType? participantType;
  @override
  final int? ticketId;
  @override
  final ParticipantStatus? status;
  @override
  final bool? hasCheckedIn;
  @override
  final DateTime? registeredTime;
  @override
  final DateTime? checkInTime;
  @override
  final DateTime? checkOutTime;
  @override
  final bool? isCheckOut;
  @override
  final bool? hasFeedback;
  @override
  final DateTime? feedbackSubmittedTime;
  @override
  final int? applicationId;
  @override
  final int? recruitmentId;
  @override
  final String? eventTitle;

  @override
  String toString() {
    return 'ParticipantModel(eventParticipantId: $eventParticipantId, eventId: $eventId, user: $user, participantQrContent: $participantQrContent, participantQrIssuedAt: $participantQrIssuedAt, participantType: $participantType, ticketId: $ticketId, status: $status, hasCheckedIn: $hasCheckedIn, registeredTime: $registeredTime, checkInTime: $checkInTime, checkOutTime: $checkOutTime, isCheckOut: $isCheckOut, hasFeedback: $hasFeedback, feedbackSubmittedTime: $feedbackSubmittedTime, applicationId: $applicationId, recruitmentId: $recruitmentId, eventTitle: $eventTitle)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParticipantModelImpl &&
            (identical(other.eventParticipantId, eventParticipantId) ||
                other.eventParticipantId == eventParticipantId) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.participantQrContent, participantQrContent) ||
                other.participantQrContent == participantQrContent) &&
            (identical(other.participantQrIssuedAt, participantQrIssuedAt) ||
                other.participantQrIssuedAt == participantQrIssuedAt) &&
            (identical(other.participantType, participantType) ||
                other.participantType == participantType) &&
            (identical(other.ticketId, ticketId) ||
                other.ticketId == ticketId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.hasCheckedIn, hasCheckedIn) ||
                other.hasCheckedIn == hasCheckedIn) &&
            (identical(other.registeredTime, registeredTime) ||
                other.registeredTime == registeredTime) &&
            (identical(other.checkInTime, checkInTime) ||
                other.checkInTime == checkInTime) &&
            (identical(other.checkOutTime, checkOutTime) ||
                other.checkOutTime == checkOutTime) &&
            (identical(other.isCheckOut, isCheckOut) ||
                other.isCheckOut == isCheckOut) &&
            (identical(other.hasFeedback, hasFeedback) ||
                other.hasFeedback == hasFeedback) &&
            (identical(other.feedbackSubmittedTime, feedbackSubmittedTime) ||
                other.feedbackSubmittedTime == feedbackSubmittedTime) &&
            (identical(other.applicationId, applicationId) ||
                other.applicationId == applicationId) &&
            (identical(other.recruitmentId, recruitmentId) ||
                other.recruitmentId == recruitmentId) &&
            (identical(other.eventTitle, eventTitle) ||
                other.eventTitle == eventTitle));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      eventParticipantId,
      eventId,
      user,
      participantQrContent,
      participantQrIssuedAt,
      participantType,
      ticketId,
      status,
      hasCheckedIn,
      registeredTime,
      checkInTime,
      checkOutTime,
      isCheckOut,
      hasFeedback,
      feedbackSubmittedTime,
      applicationId,
      recruitmentId,
      eventTitle);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ParticipantModelImplCopyWith<_$ParticipantModelImpl> get copyWith =>
      __$$ParticipantModelImplCopyWithImpl<_$ParticipantModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ParticipantModelImplToJson(
      this,
    );
  }
}

abstract class _ParticipantModel implements ParticipantModel {
  const factory _ParticipantModel(
      {final int? eventParticipantId,
      final int? eventId,
      final UserSummaryModel? user,
      final String? participantQrContent,
      final DateTime? participantQrIssuedAt,
      final ParticipantType? participantType,
      final int? ticketId,
      final ParticipantStatus? status,
      final bool? hasCheckedIn,
      final DateTime? registeredTime,
      final DateTime? checkInTime,
      final DateTime? checkOutTime,
      final bool? isCheckOut,
      final bool? hasFeedback,
      final DateTime? feedbackSubmittedTime,
      final int? applicationId,
      final int? recruitmentId,
      final String? eventTitle}) = _$ParticipantModelImpl;

  factory _ParticipantModel.fromJson(Map<String, dynamic> json) =
      _$ParticipantModelImpl.fromJson;

  @override
  int? get eventParticipantId;
  @override
  int? get eventId;
  @override
  UserSummaryModel? get user;
  @override
  String? get participantQrContent;
  @override
  DateTime? get participantQrIssuedAt;
  @override
  ParticipantType? get participantType;
  @override
  int? get ticketId;
  @override
  ParticipantStatus? get status;
  @override
  bool? get hasCheckedIn;
  @override
  DateTime? get registeredTime;
  @override
  DateTime? get checkInTime;
  @override
  DateTime? get checkOutTime;
  @override
  bool? get isCheckOut;
  @override
  bool? get hasFeedback;
  @override
  DateTime? get feedbackSubmittedTime;
  @override
  int? get applicationId;
  @override
  int? get recruitmentId;
  @override
  String? get eventTitle;
  @override
  @JsonKey(ignore: true)
  _$$ParticipantModelImplCopyWith<_$ParticipantModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
