import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/user_management/domain/entity/user_summary_entity.dart';

class TransactionEntity {
  final int? transactionId;
  final UserSummaryEntity? user;
  final TransactionReferenceType? referenceType;
  final int? referenceId;
  final String? referenceTitle;
  final int? originalAmount;
  final int? coinUsed;
  final int? finalAmount;
  final String? currency;
  final PaymentProvider? paymentProvider;
  final String? externalTransactionId;
  final TransactionStatus? status;
  final DateTime? paidAt;
  final DateTime? createdTime;

  TransactionEntity({
    this.transactionId,
    this.user,
    this.referenceType,
    this.referenceId,
    this.referenceTitle,
    this.originalAmount,
    this.coinUsed,
    this.finalAmount,
    this.currency,
    this.paymentProvider,
    this.externalTransactionId,
    this.status,
    this.paidAt,
    this.createdTime,
  });

  TransactionEntity copyWith({
    int? transactionId,
    UserSummaryEntity? user,
    TransactionReferenceType? referenceType,
    int? referenceId,
    String? referenceTitle,
    int? originalAmount,
    int? coinUsed,
    int? finalAmount,
    String? currency,
    PaymentProvider? paymentProvider,
    String? externalTransactionId,
    TransactionStatus? status,
    DateTime? paidAt,
    DateTime? createdTime,
  }) {
    return TransactionEntity(
      transactionId: transactionId ?? this.transactionId,
      user: user ?? this.user,
      referenceType: referenceType ?? this.referenceType,
      referenceId: referenceId ?? this.referenceId,
      referenceTitle: referenceTitle ?? this.referenceTitle,
      originalAmount: originalAmount ?? this.originalAmount,
      coinUsed: coinUsed ?? this.coinUsed,
      finalAmount: finalAmount ?? this.finalAmount,
      currency: currency ?? this.currency,
      paymentProvider: paymentProvider ?? this.paymentProvider,
      externalTransactionId: externalTransactionId ?? this.externalTransactionId,
      status: status ?? this.status,
      paidAt: paidAt ?? this.paidAt,
      createdTime: createdTime ?? this.createdTime,
    );
  }
}
