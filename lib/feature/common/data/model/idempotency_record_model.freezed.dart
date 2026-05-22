// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'idempotency_record_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

IdempotencyRecordModel _$IdempotencyRecordModelFromJson(
    Map<String, dynamic> json) {
  return _IdempotencyRecordModel.fromJson(json);
}

/// @nodoc
mixin _$IdempotencyRecordModel {
  int? get idempotencyRecordId => throw _privateConstructorUsedError;
  String? get idempotencyKey => throw _privateConstructorUsedError;
  int? get userId => throw _privateConstructorUsedError;
  String? get operationType => throw _privateConstructorUsedError;
  String? get requestHash => throw _privateConstructorUsedError;
  String? get responsePayload => throw _privateConstructorUsedError;
  int? get responseStatus => throw _privateConstructorUsedError;
  int? get referenceId => throw _privateConstructorUsedError;
  bool? get isSuccess => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  DateTime? get createdTime => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $IdempotencyRecordModelCopyWith<IdempotencyRecordModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IdempotencyRecordModelCopyWith<$Res> {
  factory $IdempotencyRecordModelCopyWith(IdempotencyRecordModel value,
          $Res Function(IdempotencyRecordModel) then) =
      _$IdempotencyRecordModelCopyWithImpl<$Res, IdempotencyRecordModel>;
  @useResult
  $Res call(
      {int? idempotencyRecordId,
      String? idempotencyKey,
      int? userId,
      String? operationType,
      String? requestHash,
      String? responsePayload,
      int? responseStatus,
      int? referenceId,
      bool? isSuccess,
      String? errorMessage,
      DateTime? createdTime,
      DateTime? expiresAt});
}

/// @nodoc
class _$IdempotencyRecordModelCopyWithImpl<$Res,
        $Val extends IdempotencyRecordModel>
    implements $IdempotencyRecordModelCopyWith<$Res> {
  _$IdempotencyRecordModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idempotencyRecordId = freezed,
    Object? idempotencyKey = freezed,
    Object? userId = freezed,
    Object? operationType = freezed,
    Object? requestHash = freezed,
    Object? responsePayload = freezed,
    Object? responseStatus = freezed,
    Object? referenceId = freezed,
    Object? isSuccess = freezed,
    Object? errorMessage = freezed,
    Object? createdTime = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(_value.copyWith(
      idempotencyRecordId: freezed == idempotencyRecordId
          ? _value.idempotencyRecordId
          : idempotencyRecordId // ignore: cast_nullable_to_non_nullable
              as int?,
      idempotencyKey: freezed == idempotencyKey
          ? _value.idempotencyKey
          : idempotencyKey // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      operationType: freezed == operationType
          ? _value.operationType
          : operationType // ignore: cast_nullable_to_non_nullable
              as String?,
      requestHash: freezed == requestHash
          ? _value.requestHash
          : requestHash // ignore: cast_nullable_to_non_nullable
              as String?,
      responsePayload: freezed == responsePayload
          ? _value.responsePayload
          : responsePayload // ignore: cast_nullable_to_non_nullable
              as String?,
      responseStatus: freezed == responseStatus
          ? _value.responseStatus
          : responseStatus // ignore: cast_nullable_to_non_nullable
              as int?,
      referenceId: freezed == referenceId
          ? _value.referenceId
          : referenceId // ignore: cast_nullable_to_non_nullable
              as int?,
      isSuccess: freezed == isSuccess
          ? _value.isSuccess
          : isSuccess // ignore: cast_nullable_to_non_nullable
              as bool?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      createdTime: freezed == createdTime
          ? _value.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IdempotencyRecordModelImplCopyWith<$Res>
    implements $IdempotencyRecordModelCopyWith<$Res> {
  factory _$$IdempotencyRecordModelImplCopyWith(
          _$IdempotencyRecordModelImpl value,
          $Res Function(_$IdempotencyRecordModelImpl) then) =
      __$$IdempotencyRecordModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? idempotencyRecordId,
      String? idempotencyKey,
      int? userId,
      String? operationType,
      String? requestHash,
      String? responsePayload,
      int? responseStatus,
      int? referenceId,
      bool? isSuccess,
      String? errorMessage,
      DateTime? createdTime,
      DateTime? expiresAt});
}

/// @nodoc
class __$$IdempotencyRecordModelImplCopyWithImpl<$Res>
    extends _$IdempotencyRecordModelCopyWithImpl<$Res,
        _$IdempotencyRecordModelImpl>
    implements _$$IdempotencyRecordModelImplCopyWith<$Res> {
  __$$IdempotencyRecordModelImplCopyWithImpl(
      _$IdempotencyRecordModelImpl _value,
      $Res Function(_$IdempotencyRecordModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idempotencyRecordId = freezed,
    Object? idempotencyKey = freezed,
    Object? userId = freezed,
    Object? operationType = freezed,
    Object? requestHash = freezed,
    Object? responsePayload = freezed,
    Object? responseStatus = freezed,
    Object? referenceId = freezed,
    Object? isSuccess = freezed,
    Object? errorMessage = freezed,
    Object? createdTime = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(_$IdempotencyRecordModelImpl(
      idempotencyRecordId: freezed == idempotencyRecordId
          ? _value.idempotencyRecordId
          : idempotencyRecordId // ignore: cast_nullable_to_non_nullable
              as int?,
      idempotencyKey: freezed == idempotencyKey
          ? _value.idempotencyKey
          : idempotencyKey // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      operationType: freezed == operationType
          ? _value.operationType
          : operationType // ignore: cast_nullable_to_non_nullable
              as String?,
      requestHash: freezed == requestHash
          ? _value.requestHash
          : requestHash // ignore: cast_nullable_to_non_nullable
              as String?,
      responsePayload: freezed == responsePayload
          ? _value.responsePayload
          : responsePayload // ignore: cast_nullable_to_non_nullable
              as String?,
      responseStatus: freezed == responseStatus
          ? _value.responseStatus
          : responseStatus // ignore: cast_nullable_to_non_nullable
              as int?,
      referenceId: freezed == referenceId
          ? _value.referenceId
          : referenceId // ignore: cast_nullable_to_non_nullable
              as int?,
      isSuccess: freezed == isSuccess
          ? _value.isSuccess
          : isSuccess // ignore: cast_nullable_to_non_nullable
              as bool?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      createdTime: freezed == createdTime
          ? _value.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IdempotencyRecordModelImpl implements _IdempotencyRecordModel {
  const _$IdempotencyRecordModelImpl(
      {this.idempotencyRecordId,
      this.idempotencyKey,
      this.userId,
      this.operationType,
      this.requestHash,
      this.responsePayload,
      this.responseStatus,
      this.referenceId,
      this.isSuccess,
      this.errorMessage,
      this.createdTime,
      this.expiresAt});

  factory _$IdempotencyRecordModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$IdempotencyRecordModelImplFromJson(json);

  @override
  final int? idempotencyRecordId;
  @override
  final String? idempotencyKey;
  @override
  final int? userId;
  @override
  final String? operationType;
  @override
  final String? requestHash;
  @override
  final String? responsePayload;
  @override
  final int? responseStatus;
  @override
  final int? referenceId;
  @override
  final bool? isSuccess;
  @override
  final String? errorMessage;
  @override
  final DateTime? createdTime;
  @override
  final DateTime? expiresAt;

  @override
  String toString() {
    return 'IdempotencyRecordModel(idempotencyRecordId: $idempotencyRecordId, idempotencyKey: $idempotencyKey, userId: $userId, operationType: $operationType, requestHash: $requestHash, responsePayload: $responsePayload, responseStatus: $responseStatus, referenceId: $referenceId, isSuccess: $isSuccess, errorMessage: $errorMessage, createdTime: $createdTime, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IdempotencyRecordModelImpl &&
            (identical(other.idempotencyRecordId, idempotencyRecordId) ||
                other.idempotencyRecordId == idempotencyRecordId) &&
            (identical(other.idempotencyKey, idempotencyKey) ||
                other.idempotencyKey == idempotencyKey) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.operationType, operationType) ||
                other.operationType == operationType) &&
            (identical(other.requestHash, requestHash) ||
                other.requestHash == requestHash) &&
            (identical(other.responsePayload, responsePayload) ||
                other.responsePayload == responsePayload) &&
            (identical(other.responseStatus, responseStatus) ||
                other.responseStatus == responseStatus) &&
            (identical(other.referenceId, referenceId) ||
                other.referenceId == referenceId) &&
            (identical(other.isSuccess, isSuccess) ||
                other.isSuccess == isSuccess) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.createdTime, createdTime) ||
                other.createdTime == createdTime) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      idempotencyRecordId,
      idempotencyKey,
      userId,
      operationType,
      requestHash,
      responsePayload,
      responseStatus,
      referenceId,
      isSuccess,
      errorMessage,
      createdTime,
      expiresAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$IdempotencyRecordModelImplCopyWith<_$IdempotencyRecordModelImpl>
      get copyWith => __$$IdempotencyRecordModelImplCopyWithImpl<
          _$IdempotencyRecordModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IdempotencyRecordModelImplToJson(
      this,
    );
  }
}

abstract class _IdempotencyRecordModel implements IdempotencyRecordModel {
  const factory _IdempotencyRecordModel(
      {final int? idempotencyRecordId,
      final String? idempotencyKey,
      final int? userId,
      final String? operationType,
      final String? requestHash,
      final String? responsePayload,
      final int? responseStatus,
      final int? referenceId,
      final bool? isSuccess,
      final String? errorMessage,
      final DateTime? createdTime,
      final DateTime? expiresAt}) = _$IdempotencyRecordModelImpl;

  factory _IdempotencyRecordModel.fromJson(Map<String, dynamic> json) =
      _$IdempotencyRecordModelImpl.fromJson;

  @override
  int? get idempotencyRecordId;
  @override
  String? get idempotencyKey;
  @override
  int? get userId;
  @override
  String? get operationType;
  @override
  String? get requestHash;
  @override
  String? get responsePayload;
  @override
  int? get responseStatus;
  @override
  int? get referenceId;
  @override
  bool? get isSuccess;
  @override
  String? get errorMessage;
  @override
  DateTime? get createdTime;
  @override
  DateTime? get expiresAt;
  @override
  @JsonKey(ignore: true)
  _$$IdempotencyRecordModelImplCopyWith<_$IdempotencyRecordModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
