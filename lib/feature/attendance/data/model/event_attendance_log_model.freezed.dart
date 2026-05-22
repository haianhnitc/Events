// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_attendance_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventAttendanceLogModel _$EventAttendanceLogModelFromJson(
    Map<String, dynamic> json) {
  return _EventAttendanceLogModel.fromJson(json);
}

/// @nodoc
mixin _$EventAttendanceLogModel {
  int? get eventAttendanceLogId => throw _privateConstructorUsedError;
  AttendanceLogType? get type => throw _privateConstructorUsedError;
  ScanMethod? get scanMethod => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  bool? get isValid => throw _privateConstructorUsedError;
  DateTime? get createdTime => throw _privateConstructorUsedError;
  ParticipantModel? get eventParticipant => throw _privateConstructorUsedError;
  UserSummaryModel? get scannedByUser => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventAttendanceLogModelCopyWith<EventAttendanceLogModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventAttendanceLogModelCopyWith<$Res> {
  factory $EventAttendanceLogModelCopyWith(EventAttendanceLogModel value,
          $Res Function(EventAttendanceLogModel) then) =
      _$EventAttendanceLogModelCopyWithImpl<$Res, EventAttendanceLogModel>;
  @useResult
  $Res call(
      {int? eventAttendanceLogId,
      AttendanceLogType? type,
      ScanMethod? scanMethod,
      double? latitude,
      double? longitude,
      bool? isValid,
      DateTime? createdTime,
      ParticipantModel? eventParticipant,
      UserSummaryModel? scannedByUser});

  $ParticipantModelCopyWith<$Res>? get eventParticipant;
  $UserSummaryModelCopyWith<$Res>? get scannedByUser;
}

/// @nodoc
class _$EventAttendanceLogModelCopyWithImpl<$Res,
        $Val extends EventAttendanceLogModel>
    implements $EventAttendanceLogModelCopyWith<$Res> {
  _$EventAttendanceLogModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventAttendanceLogId = freezed,
    Object? type = freezed,
    Object? scanMethod = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? isValid = freezed,
    Object? createdTime = freezed,
    Object? eventParticipant = freezed,
    Object? scannedByUser = freezed,
  }) {
    return _then(_value.copyWith(
      eventAttendanceLogId: freezed == eventAttendanceLogId
          ? _value.eventAttendanceLogId
          : eventAttendanceLogId // ignore: cast_nullable_to_non_nullable
              as int?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AttendanceLogType?,
      scanMethod: freezed == scanMethod
          ? _value.scanMethod
          : scanMethod // ignore: cast_nullable_to_non_nullable
              as ScanMethod?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      isValid: freezed == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdTime: freezed == createdTime
          ? _value.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      eventParticipant: freezed == eventParticipant
          ? _value.eventParticipant
          : eventParticipant // ignore: cast_nullable_to_non_nullable
              as ParticipantModel?,
      scannedByUser: freezed == scannedByUser
          ? _value.scannedByUser
          : scannedByUser // ignore: cast_nullable_to_non_nullable
              as UserSummaryModel?,
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

  @override
  @pragma('vm:prefer-inline')
  $UserSummaryModelCopyWith<$Res>? get scannedByUser {
    if (_value.scannedByUser == null) {
      return null;
    }

    return $UserSummaryModelCopyWith<$Res>(_value.scannedByUser!, (value) {
      return _then(_value.copyWith(scannedByUser: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EventAttendanceLogModelImplCopyWith<$Res>
    implements $EventAttendanceLogModelCopyWith<$Res> {
  factory _$$EventAttendanceLogModelImplCopyWith(
          _$EventAttendanceLogModelImpl value,
          $Res Function(_$EventAttendanceLogModelImpl) then) =
      __$$EventAttendanceLogModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? eventAttendanceLogId,
      AttendanceLogType? type,
      ScanMethod? scanMethod,
      double? latitude,
      double? longitude,
      bool? isValid,
      DateTime? createdTime,
      ParticipantModel? eventParticipant,
      UserSummaryModel? scannedByUser});

  @override
  $ParticipantModelCopyWith<$Res>? get eventParticipant;
  @override
  $UserSummaryModelCopyWith<$Res>? get scannedByUser;
}

/// @nodoc
class __$$EventAttendanceLogModelImplCopyWithImpl<$Res>
    extends _$EventAttendanceLogModelCopyWithImpl<$Res,
        _$EventAttendanceLogModelImpl>
    implements _$$EventAttendanceLogModelImplCopyWith<$Res> {
  __$$EventAttendanceLogModelImplCopyWithImpl(
      _$EventAttendanceLogModelImpl _value,
      $Res Function(_$EventAttendanceLogModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventAttendanceLogId = freezed,
    Object? type = freezed,
    Object? scanMethod = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? isValid = freezed,
    Object? createdTime = freezed,
    Object? eventParticipant = freezed,
    Object? scannedByUser = freezed,
  }) {
    return _then(_$EventAttendanceLogModelImpl(
      eventAttendanceLogId: freezed == eventAttendanceLogId
          ? _value.eventAttendanceLogId
          : eventAttendanceLogId // ignore: cast_nullable_to_non_nullable
              as int?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AttendanceLogType?,
      scanMethod: freezed == scanMethod
          ? _value.scanMethod
          : scanMethod // ignore: cast_nullable_to_non_nullable
              as ScanMethod?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      isValid: freezed == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdTime: freezed == createdTime
          ? _value.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      eventParticipant: freezed == eventParticipant
          ? _value.eventParticipant
          : eventParticipant // ignore: cast_nullable_to_non_nullable
              as ParticipantModel?,
      scannedByUser: freezed == scannedByUser
          ? _value.scannedByUser
          : scannedByUser // ignore: cast_nullable_to_non_nullable
              as UserSummaryModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventAttendanceLogModelImpl implements _EventAttendanceLogModel {
  const _$EventAttendanceLogModelImpl(
      {this.eventAttendanceLogId,
      this.type,
      this.scanMethod,
      this.latitude,
      this.longitude,
      this.isValid,
      this.createdTime,
      this.eventParticipant,
      this.scannedByUser});

  factory _$EventAttendanceLogModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventAttendanceLogModelImplFromJson(json);

  @override
  final int? eventAttendanceLogId;
  @override
  final AttendanceLogType? type;
  @override
  final ScanMethod? scanMethod;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final bool? isValid;
  @override
  final DateTime? createdTime;
  @override
  final ParticipantModel? eventParticipant;
  @override
  final UserSummaryModel? scannedByUser;

  @override
  String toString() {
    return 'EventAttendanceLogModel(eventAttendanceLogId: $eventAttendanceLogId, type: $type, scanMethod: $scanMethod, latitude: $latitude, longitude: $longitude, isValid: $isValid, createdTime: $createdTime, eventParticipant: $eventParticipant, scannedByUser: $scannedByUser)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventAttendanceLogModelImpl &&
            (identical(other.eventAttendanceLogId, eventAttendanceLogId) ||
                other.eventAttendanceLogId == eventAttendanceLogId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.scanMethod, scanMethod) ||
                other.scanMethod == scanMethod) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.isValid, isValid) || other.isValid == isValid) &&
            (identical(other.createdTime, createdTime) ||
                other.createdTime == createdTime) &&
            (identical(other.eventParticipant, eventParticipant) ||
                other.eventParticipant == eventParticipant) &&
            (identical(other.scannedByUser, scannedByUser) ||
                other.scannedByUser == scannedByUser));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      eventAttendanceLogId,
      type,
      scanMethod,
      latitude,
      longitude,
      isValid,
      createdTime,
      eventParticipant,
      scannedByUser);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventAttendanceLogModelImplCopyWith<_$EventAttendanceLogModelImpl>
      get copyWith => __$$EventAttendanceLogModelImplCopyWithImpl<
          _$EventAttendanceLogModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventAttendanceLogModelImplToJson(
      this,
    );
  }
}

abstract class _EventAttendanceLogModel implements EventAttendanceLogModel {
  const factory _EventAttendanceLogModel(
      {final int? eventAttendanceLogId,
      final AttendanceLogType? type,
      final ScanMethod? scanMethod,
      final double? latitude,
      final double? longitude,
      final bool? isValid,
      final DateTime? createdTime,
      final ParticipantModel? eventParticipant,
      final UserSummaryModel? scannedByUser}) = _$EventAttendanceLogModelImpl;

  factory _EventAttendanceLogModel.fromJson(Map<String, dynamic> json) =
      _$EventAttendanceLogModelImpl.fromJson;

  @override
  int? get eventAttendanceLogId;
  @override
  AttendanceLogType? get type;
  @override
  ScanMethod? get scanMethod;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  bool? get isValid;
  @override
  DateTime? get createdTime;
  @override
  ParticipantModel? get eventParticipant;
  @override
  UserSummaryModel? get scannedByUser;
  @override
  @JsonKey(ignore: true)
  _$$EventAttendanceLogModelImplCopyWith<_$EventAttendanceLogModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
