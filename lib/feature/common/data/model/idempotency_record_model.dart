import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/idempotency_record_entity.dart';

part 'idempotency_record_model.freezed.dart';
part 'idempotency_record_model.g.dart';

@freezed
class IdempotencyRecordModel with _$IdempotencyRecordModel {
  const factory IdempotencyRecordModel({
    int? idempotencyRecordId,
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
    DateTime? expiresAt,
  }) = _IdempotencyRecordModel;

  factory IdempotencyRecordModel.fromJson(Map<String, dynamic> json) =>
      _$IdempotencyRecordModelFromJson(json);

  factory IdempotencyRecordModel.fromEntity(IdempotencyRecordEntity entity) {
    return IdempotencyRecordModel(
      idempotencyRecordId: entity.idempotencyRecordId,
      idempotencyKey: entity.idempotencyKey,
      userId: entity.userId,
      operationType: entity.operationType,
      requestHash: entity.requestHash,
      responsePayload: entity.responsePayload,
      responseStatus: entity.responseStatus,
      referenceId: entity.referenceId,
      isSuccess: entity.isSuccess,
      errorMessage: entity.errorMessage,
      createdTime: entity.createdTime,
      expiresAt: entity.expiresAt,
    );
  }
}

extension IdempotencyRecordModelExtension on IdempotencyRecordModel {
  IdempotencyRecordEntity toEntity() {
    return IdempotencyRecordEntity(
      idempotencyRecordId: idempotencyRecordId,
      idempotencyKey: idempotencyKey,
      userId: userId,
      operationType: operationType,
      requestHash: requestHash,
      responsePayload: responsePayload,
      responseStatus: responseStatus,
      referenceId: referenceId,
      isSuccess: isSuccess,
      errorMessage: errorMessage,
      createdTime: createdTime,
      expiresAt: expiresAt,
    );
  }
}
