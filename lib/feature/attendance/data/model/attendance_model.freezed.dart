// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AttendanceQrModel _$AttendanceQrModelFromJson(Map<String, dynamic> json) {
  return _AttendanceQrModel.fromJson(json);
}

/// @nodoc
mixin _$AttendanceQrModel {
  String? get qrContent => throw _privateConstructorUsedError;
  ScanMethod? get scanMethod => throw _privateConstructorUsedError;
  int? get eventId => throw _privateConstructorUsedError;
  int? get eventParticipantId => throw _privateConstructorUsedError;
  DateTime? get issuedTime => throw _privateConstructorUsedError;
  DateTime? get expiryTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AttendanceQrModelCopyWith<AttendanceQrModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttendanceQrModelCopyWith<$Res> {
  factory $AttendanceQrModelCopyWith(
          AttendanceQrModel value, $Res Function(AttendanceQrModel) then) =
      _$AttendanceQrModelCopyWithImpl<$Res, AttendanceQrModel>;
  @useResult
  $Res call(
      {String? qrContent,
      ScanMethod? scanMethod,
      int? eventId,
      int? eventParticipantId,
      DateTime? issuedTime,
      DateTime? expiryTime});
}

/// @nodoc
class _$AttendanceQrModelCopyWithImpl<$Res, $Val extends AttendanceQrModel>
    implements $AttendanceQrModelCopyWith<$Res> {
  _$AttendanceQrModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? qrContent = freezed,
    Object? scanMethod = freezed,
    Object? eventId = freezed,
    Object? eventParticipantId = freezed,
    Object? issuedTime = freezed,
    Object? expiryTime = freezed,
  }) {
    return _then(_value.copyWith(
      qrContent: freezed == qrContent
          ? _value.qrContent
          : qrContent // ignore: cast_nullable_to_non_nullable
              as String?,
      scanMethod: freezed == scanMethod
          ? _value.scanMethod
          : scanMethod // ignore: cast_nullable_to_non_nullable
              as ScanMethod?,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as int?,
      eventParticipantId: freezed == eventParticipantId
          ? _value.eventParticipantId
          : eventParticipantId // ignore: cast_nullable_to_non_nullable
              as int?,
      issuedTime: freezed == issuedTime
          ? _value.issuedTime
          : issuedTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiryTime: freezed == expiryTime
          ? _value.expiryTime
          : expiryTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AttendanceQrModelImplCopyWith<$Res>
    implements $AttendanceQrModelCopyWith<$Res> {
  factory _$$AttendanceQrModelImplCopyWith(_$AttendanceQrModelImpl value,
          $Res Function(_$AttendanceQrModelImpl) then) =
      __$$AttendanceQrModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? qrContent,
      ScanMethod? scanMethod,
      int? eventId,
      int? eventParticipantId,
      DateTime? issuedTime,
      DateTime? expiryTime});
}

/// @nodoc
class __$$AttendanceQrModelImplCopyWithImpl<$Res>
    extends _$AttendanceQrModelCopyWithImpl<$Res, _$AttendanceQrModelImpl>
    implements _$$AttendanceQrModelImplCopyWith<$Res> {
  __$$AttendanceQrModelImplCopyWithImpl(_$AttendanceQrModelImpl _value,
      $Res Function(_$AttendanceQrModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? qrContent = freezed,
    Object? scanMethod = freezed,
    Object? eventId = freezed,
    Object? eventParticipantId = freezed,
    Object? issuedTime = freezed,
    Object? expiryTime = freezed,
  }) {
    return _then(_$AttendanceQrModelImpl(
      qrContent: freezed == qrContent
          ? _value.qrContent
          : qrContent // ignore: cast_nullable_to_non_nullable
              as String?,
      scanMethod: freezed == scanMethod
          ? _value.scanMethod
          : scanMethod // ignore: cast_nullable_to_non_nullable
              as ScanMethod?,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as int?,
      eventParticipantId: freezed == eventParticipantId
          ? _value.eventParticipantId
          : eventParticipantId // ignore: cast_nullable_to_non_nullable
              as int?,
      issuedTime: freezed == issuedTime
          ? _value.issuedTime
          : issuedTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiryTime: freezed == expiryTime
          ? _value.expiryTime
          : expiryTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AttendanceQrModelImpl implements _AttendanceQrModel {
  const _$AttendanceQrModelImpl(
      {this.qrContent,
      this.scanMethod,
      this.eventId,
      this.eventParticipantId,
      this.issuedTime,
      this.expiryTime});

  factory _$AttendanceQrModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AttendanceQrModelImplFromJson(json);

  @override
  final String? qrContent;
  @override
  final ScanMethod? scanMethod;
  @override
  final int? eventId;
  @override
  final int? eventParticipantId;
  @override
  final DateTime? issuedTime;
  @override
  final DateTime? expiryTime;

  @override
  String toString() {
    return 'AttendanceQrModel(qrContent: $qrContent, scanMethod: $scanMethod, eventId: $eventId, eventParticipantId: $eventParticipantId, issuedTime: $issuedTime, expiryTime: $expiryTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttendanceQrModelImpl &&
            (identical(other.qrContent, qrContent) ||
                other.qrContent == qrContent) &&
            (identical(other.scanMethod, scanMethod) ||
                other.scanMethod == scanMethod) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.eventParticipantId, eventParticipantId) ||
                other.eventParticipantId == eventParticipantId) &&
            (identical(other.issuedTime, issuedTime) ||
                other.issuedTime == issuedTime) &&
            (identical(other.expiryTime, expiryTime) ||
                other.expiryTime == expiryTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, qrContent, scanMethod, eventId,
      eventParticipantId, issuedTime, expiryTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AttendanceQrModelImplCopyWith<_$AttendanceQrModelImpl> get copyWith =>
      __$$AttendanceQrModelImplCopyWithImpl<_$AttendanceQrModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AttendanceQrModelImplToJson(
      this,
    );
  }
}

abstract class _AttendanceQrModel implements AttendanceQrModel {
  const factory _AttendanceQrModel(
      {final String? qrContent,
      final ScanMethod? scanMethod,
      final int? eventId,
      final int? eventParticipantId,
      final DateTime? issuedTime,
      final DateTime? expiryTime}) = _$AttendanceQrModelImpl;

  factory _AttendanceQrModel.fromJson(Map<String, dynamic> json) =
      _$AttendanceQrModelImpl.fromJson;

  @override
  String? get qrContent;
  @override
  ScanMethod? get scanMethod;
  @override
  int? get eventId;
  @override
  int? get eventParticipantId;
  @override
  DateTime? get issuedTime;
  @override
  DateTime? get expiryTime;
  @override
  @JsonKey(ignore: true)
  _$$AttendanceQrModelImplCopyWith<_$AttendanceQrModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AttendanceScanResultModel _$AttendanceScanResultModelFromJson(
    Map<String, dynamic> json) {
  return _AttendanceScanResultModel.fromJson(json);
}

/// @nodoc
mixin _$AttendanceScanResultModel {
  AttendanceAction? get action => throw _privateConstructorUsedError;
  int? get eventParticipantId => throw _privateConstructorUsedError;
  int? get attendanceLogId => throw _privateConstructorUsedError;
  DateTime? get checkInTime => throw _privateConstructorUsedError;
  DateTime? get checkOutTime => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  String? get participantName => throw _privateConstructorUsedError;
  ParticipantType? get participantType => throw _privateConstructorUsedError;
  int? get userId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AttendanceScanResultModelCopyWith<AttendanceScanResultModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttendanceScanResultModelCopyWith<$Res> {
  factory $AttendanceScanResultModelCopyWith(AttendanceScanResultModel value,
          $Res Function(AttendanceScanResultModel) then) =
      _$AttendanceScanResultModelCopyWithImpl<$Res, AttendanceScanResultModel>;
  @useResult
  $Res call(
      {AttendanceAction? action,
      int? eventParticipantId,
      int? attendanceLogId,
      DateTime? checkInTime,
      DateTime? checkOutTime,
      String? message,
      String? participantName,
      ParticipantType? participantType,
      int? userId});
}

/// @nodoc
class _$AttendanceScanResultModelCopyWithImpl<$Res,
        $Val extends AttendanceScanResultModel>
    implements $AttendanceScanResultModelCopyWith<$Res> {
  _$AttendanceScanResultModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? action = freezed,
    Object? eventParticipantId = freezed,
    Object? attendanceLogId = freezed,
    Object? checkInTime = freezed,
    Object? checkOutTime = freezed,
    Object? message = freezed,
    Object? participantName = freezed,
    Object? participantType = freezed,
    Object? userId = freezed,
  }) {
    return _then(_value.copyWith(
      action: freezed == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as AttendanceAction?,
      eventParticipantId: freezed == eventParticipantId
          ? _value.eventParticipantId
          : eventParticipantId // ignore: cast_nullable_to_non_nullable
              as int?,
      attendanceLogId: freezed == attendanceLogId
          ? _value.attendanceLogId
          : attendanceLogId // ignore: cast_nullable_to_non_nullable
              as int?,
      checkInTime: freezed == checkInTime
          ? _value.checkInTime
          : checkInTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      checkOutTime: freezed == checkOutTime
          ? _value.checkOutTime
          : checkOutTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      participantName: freezed == participantName
          ? _value.participantName
          : participantName // ignore: cast_nullable_to_non_nullable
              as String?,
      participantType: freezed == participantType
          ? _value.participantType
          : participantType // ignore: cast_nullable_to_non_nullable
              as ParticipantType?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AttendanceScanResultModelImplCopyWith<$Res>
    implements $AttendanceScanResultModelCopyWith<$Res> {
  factory _$$AttendanceScanResultModelImplCopyWith(
          _$AttendanceScanResultModelImpl value,
          $Res Function(_$AttendanceScanResultModelImpl) then) =
      __$$AttendanceScanResultModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AttendanceAction? action,
      int? eventParticipantId,
      int? attendanceLogId,
      DateTime? checkInTime,
      DateTime? checkOutTime,
      String? message,
      String? participantName,
      ParticipantType? participantType,
      int? userId});
}

/// @nodoc
class __$$AttendanceScanResultModelImplCopyWithImpl<$Res>
    extends _$AttendanceScanResultModelCopyWithImpl<$Res,
        _$AttendanceScanResultModelImpl>
    implements _$$AttendanceScanResultModelImplCopyWith<$Res> {
  __$$AttendanceScanResultModelImplCopyWithImpl(
      _$AttendanceScanResultModelImpl _value,
      $Res Function(_$AttendanceScanResultModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? action = freezed,
    Object? eventParticipantId = freezed,
    Object? attendanceLogId = freezed,
    Object? checkInTime = freezed,
    Object? checkOutTime = freezed,
    Object? message = freezed,
    Object? participantName = freezed,
    Object? participantType = freezed,
    Object? userId = freezed,
  }) {
    return _then(_$AttendanceScanResultModelImpl(
      action: freezed == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as AttendanceAction?,
      eventParticipantId: freezed == eventParticipantId
          ? _value.eventParticipantId
          : eventParticipantId // ignore: cast_nullable_to_non_nullable
              as int?,
      attendanceLogId: freezed == attendanceLogId
          ? _value.attendanceLogId
          : attendanceLogId // ignore: cast_nullable_to_non_nullable
              as int?,
      checkInTime: freezed == checkInTime
          ? _value.checkInTime
          : checkInTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      checkOutTime: freezed == checkOutTime
          ? _value.checkOutTime
          : checkOutTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      participantName: freezed == participantName
          ? _value.participantName
          : participantName // ignore: cast_nullable_to_non_nullable
              as String?,
      participantType: freezed == participantType
          ? _value.participantType
          : participantType // ignore: cast_nullable_to_non_nullable
              as ParticipantType?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AttendanceScanResultModelImpl implements _AttendanceScanResultModel {
  const _$AttendanceScanResultModelImpl(
      {this.action,
      this.eventParticipantId,
      this.attendanceLogId,
      this.checkInTime,
      this.checkOutTime,
      this.message,
      this.participantName,
      this.participantType,
      this.userId});

  factory _$AttendanceScanResultModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AttendanceScanResultModelImplFromJson(json);

  @override
  final AttendanceAction? action;
  @override
  final int? eventParticipantId;
  @override
  final int? attendanceLogId;
  @override
  final DateTime? checkInTime;
  @override
  final DateTime? checkOutTime;
  @override
  final String? message;
  @override
  final String? participantName;
  @override
  final ParticipantType? participantType;
  @override
  final int? userId;

  @override
  String toString() {
    return 'AttendanceScanResultModel(action: $action, eventParticipantId: $eventParticipantId, attendanceLogId: $attendanceLogId, checkInTime: $checkInTime, checkOutTime: $checkOutTime, message: $message, participantName: $participantName, participantType: $participantType, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttendanceScanResultModelImpl &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.eventParticipantId, eventParticipantId) ||
                other.eventParticipantId == eventParticipantId) &&
            (identical(other.attendanceLogId, attendanceLogId) ||
                other.attendanceLogId == attendanceLogId) &&
            (identical(other.checkInTime, checkInTime) ||
                other.checkInTime == checkInTime) &&
            (identical(other.checkOutTime, checkOutTime) ||
                other.checkOutTime == checkOutTime) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.participantName, participantName) ||
                other.participantName == participantName) &&
            (identical(other.participantType, participantType) ||
                other.participantType == participantType) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      action,
      eventParticipantId,
      attendanceLogId,
      checkInTime,
      checkOutTime,
      message,
      participantName,
      participantType,
      userId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AttendanceScanResultModelImplCopyWith<_$AttendanceScanResultModelImpl>
      get copyWith => __$$AttendanceScanResultModelImplCopyWithImpl<
          _$AttendanceScanResultModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AttendanceScanResultModelImplToJson(
      this,
    );
  }
}

abstract class _AttendanceScanResultModel implements AttendanceScanResultModel {
  const factory _AttendanceScanResultModel(
      {final AttendanceAction? action,
      final int? eventParticipantId,
      final int? attendanceLogId,
      final DateTime? checkInTime,
      final DateTime? checkOutTime,
      final String? message,
      final String? participantName,
      final ParticipantType? participantType,
      final int? userId}) = _$AttendanceScanResultModelImpl;

  factory _AttendanceScanResultModel.fromJson(Map<String, dynamic> json) =
      _$AttendanceScanResultModelImpl.fromJson;

  @override
  AttendanceAction? get action;
  @override
  int? get eventParticipantId;
  @override
  int? get attendanceLogId;
  @override
  DateTime? get checkInTime;
  @override
  DateTime? get checkOutTime;
  @override
  String? get message;
  @override
  String? get participantName;
  @override
  ParticipantType? get participantType;
  @override
  int? get userId;
  @override
  @JsonKey(ignore: true)
  _$$AttendanceScanResultModelImplCopyWith<_$AttendanceScanResultModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
