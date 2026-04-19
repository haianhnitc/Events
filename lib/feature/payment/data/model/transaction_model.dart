import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/user_management/data/model/user_summary_model.dart';
import '../../domain/entity/transaction_entity.dart';
class TransactionModel {
  final int? transactionId;
  final UserSummaryModel? user;
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

  const TransactionModel({
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

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      transactionId: (json['transactionId'] as num?)?.toInt(),
      user: json['user'] is Map<String, dynamic>
          ? UserSummaryModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      referenceType: TransactionReferenceTypeApiValue.fromApiValue(
        json['referenceType'],
      ),
      referenceId: (json['referenceId'] as num?)?.toInt(),
      referenceTitle: json['referenceTitle'] as String?,
      originalAmount: (json['originalAmount'] as num?)?.toInt(),
      coinUsed: (json['coinUsed'] as num?)?.toInt(),
      finalAmount: (json['finalAmount'] as num?)?.toInt(),
      currency: json['currency'] as String?,
      paymentProvider: PaymentProviderApiValue.fromApiValue(
        json['paymentProvider'],
      ),
      externalTransactionId: json['externalTransactionId'] as String?,
      status: json['status'] == null
          ? null
          : TransactionStatus.values.firstWhere(
              (e) => e.name.toUpperCase() == '${json['status']}'.toUpperCase(),
              orElse: () => TransactionStatus.pending,
            ),
      paidAt: json['paidAt'] == null
          ? null
          : DateTime.tryParse(json['paidAt'].toString()),
      createdTime: json['createdTime'] == null
          ? null
          : DateTime.tryParse(json['createdTime'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'user': user?.toJson(),
      'referenceType': referenceType?.apiValue,
      'referenceId': referenceId,
      'referenceTitle': referenceTitle,
      'originalAmount': originalAmount,
      'coinUsed': coinUsed,
      'finalAmount': finalAmount,
      'currency': currency,
      'paymentProvider': paymentProvider?.apiValue,
      'externalTransactionId': externalTransactionId,
      'status': status?.name.toUpperCase(),
      'paidAt': paidAt?.toIso8601String(),
      'createdTime': createdTime?.toIso8601String(),
    };
  }

  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(
      transactionId: entity.transactionId,
      user: entity.user == null ? null : UserSummaryModel.fromEntity(entity.user!),
      referenceType: entity.referenceType,
      referenceId: entity.referenceId,
      referenceTitle: entity.referenceTitle,
      originalAmount: entity.originalAmount,
      coinUsed: entity.coinUsed,
      finalAmount: entity.finalAmount,
      currency: entity.currency,
      paymentProvider: entity.paymentProvider,
      externalTransactionId: entity.externalTransactionId,
      status: entity.status,
      paidAt: entity.paidAt,
      createdTime: entity.createdTime,
    );
  }
}

extension TransactionModelExtension on TransactionModel {
  TransactionEntity toEntity() {
    return TransactionEntity(
      transactionId: transactionId,
      user: user?.toEntity(),
      referenceType: referenceType,
      referenceId: referenceId,
      referenceTitle: referenceTitle,
      originalAmount: originalAmount,
      coinUsed: coinUsed,
      finalAmount: finalAmount,
      currency: currency,
      paymentProvider: paymentProvider,
      externalTransactionId: externalTransactionId,
      status: status,
      paidAt: paidAt,
      createdTime: createdTime,
    );
  }
}
