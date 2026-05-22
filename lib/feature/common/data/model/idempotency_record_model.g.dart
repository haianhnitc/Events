// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'idempotency_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IdempotencyRecordModelImpl _$$IdempotencyRecordModelImplFromJson(
        Map<String, dynamic> json) =>
    _$IdempotencyRecordModelImpl(
      idempotencyRecordId: (json['idempotencyRecordId'] as num?)?.toInt(),
      idempotencyKey: json['idempotencyKey'] as String?,
      userId: (json['userId'] as num?)?.toInt(),
      operationType: json['operationType'] as String?,
      requestHash: json['requestHash'] as String?,
      responsePayload: json['responsePayload'] as String?,
      responseStatus: (json['responseStatus'] as num?)?.toInt(),
      referenceId: (json['referenceId'] as num?)?.toInt(),
      isSuccess: json['isSuccess'] as bool?,
      errorMessage: json['errorMessage'] as String?,
      createdTime: json['createdTime'] == null
          ? null
          : DateTime.parse(json['createdTime'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$$IdempotencyRecordModelImplToJson(
        _$IdempotencyRecordModelImpl instance) =>
    <String, dynamic>{
      'idempotencyRecordId': instance.idempotencyRecordId,
      'idempotencyKey': instance.idempotencyKey,
      'userId': instance.userId,
      'operationType': instance.operationType,
      'requestHash': instance.requestHash,
      'responsePayload': instance.responsePayload,
      'responseStatus': instance.responseStatus,
      'referenceId': instance.referenceId,
      'isSuccess': instance.isSuccess,
      'errorMessage': instance.errorMessage,
      'createdTime': instance.createdTime?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };
