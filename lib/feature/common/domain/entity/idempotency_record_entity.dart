class IdempotencyRecordEntity {
  final int? idempotencyRecordId;
  final String? idempotencyKey;
  final int? userId;
  final String? operationType;
  final String? requestHash;
  final String? responsePayload;
  final int? responseStatus;
  final int? referenceId;
  final bool? isSuccess;
  final String? errorMessage;
  final DateTime? createdTime;
  final DateTime? expiresAt;

  IdempotencyRecordEntity({
    this.idempotencyRecordId,
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
    this.expiresAt,
  });
}
