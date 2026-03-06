import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import '../../domain/entity/transaction_entity.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    int? transactionId,
    int? userId,
    @Default(TransactionStatus.pending) TransactionStatus? status,
    PaymentProvider? paymentProvider,
    String? externalTransactionId,
    @Default(0) int? originalAmount,
    @Default(0) int? finalAmount,
    @Default(0) int? coinUsed,
    String? currency,
    int? referenceId,
    TransactionReferenceType? referenceType,
    String? providerPayload,
    String? rejectionReason,
    String? extraData,
    DateTime? createdTime,
    DateTime? paidAt,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(
      transactionId: entity.transactionId,
      userId: entity.userId,
      status: entity.status,
      paymentProvider: entity.paymentProvider,
      externalTransactionId: entity.externalTransactionId,
      originalAmount: entity.originalAmount,
      finalAmount: entity.finalAmount,
      coinUsed: entity.coinUsed,
      currency: entity.currency,
      referenceId: entity.referenceId,
      referenceType: entity.referenceType,
      providerPayload: entity.providerPayload,
      rejectionReason: entity.rejectionReason,
      extraData: entity.extraData,
      createdTime: entity.createdTime,
      paidAt: entity.paidAt,
    );
  }
}

extension TransactionModelExtension on TransactionModel {
  TransactionEntity toEntity() {
    return TransactionEntity(
      transactionId: transactionId,
      userId: userId,
      status: status,
      paymentProvider: paymentProvider,
      externalTransactionId: externalTransactionId,
      originalAmount: originalAmount,
      finalAmount: finalAmount,
      coinUsed: coinUsed,
      currency: currency,
      referenceId: referenceId,
      referenceType: referenceType,
      providerPayload: providerPayload,
      rejectionReason: rejectionReason,
      extraData: extraData,
      createdTime: createdTime,
      paidAt: paidAt,
    );
  }
}
