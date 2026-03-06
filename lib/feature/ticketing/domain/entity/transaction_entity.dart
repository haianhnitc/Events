import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class TransactionEntity {
  final int? transactionId;
  final int? userId;
  final TransactionStatus? status;
  final PaymentProvider? paymentProvider;
  final String? externalTransactionId;
  final int? originalAmount;
  final int? finalAmount;
  final int? coinUsed;
  final String? currency;
  final int? referenceId;
  final TransactionReferenceType? referenceType;
  final String? providerPayload;
  final String? rejectionReason;
  final String? extraData;
  final DateTime? paidAt;
  final DateTime? createdTime;

  TransactionEntity({
    this.transactionId,
    this.userId,
    this.status,
    this.paymentProvider,
    this.externalTransactionId,
    this.originalAmount,
    this.finalAmount,
    this.coinUsed,
    this.currency,
    this.referenceId,
    this.referenceType,
    this.providerPayload,
    this.rejectionReason,
    this.extraData,
    this.paidAt,
    this.createdTime,
  });
}
