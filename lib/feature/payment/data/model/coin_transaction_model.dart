import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/payment/domain/entity/coin_transaction_entity.dart';

class CoinTransactionModel {
  final int? transactionId;
  final int? amount;
  final String? referenceType;
  final int? referenceId;
  final int? balanceAfter;
  final String? createdTime;

  const CoinTransactionModel({
    this.transactionId,
    this.amount,
    this.referenceType,
    this.referenceId,
    this.balanceAfter,
    this.createdTime,
  });

  factory CoinTransactionModel.fromJson(Map<String, dynamic> json) {
    return CoinTransactionModel(
      transactionId: (json['transactionId'] as num?)?.toInt(),
      amount: (json['amount'] as num?)?.toInt(),
      referenceType: json['referenceType'] as String?,
      referenceId: (json['referenceId'] as num?)?.toInt(),
      balanceAfter: (json['balanceAfter'] as num?)?.toInt(),
      createdTime: json['createdTime'] as String?,
    );
  }

  CoinTransactionEntity toEntity() {
    DateTime? parsedTime;
    if (createdTime != null) {
      parsedTime = DateTime.tryParse(createdTime!);
    }
    return CoinTransactionEntity(
      transactionId: transactionId,
      amount: amount,
      referenceType: CoinReferenceTypeApiValue.fromApiValue(referenceType),
      referenceId: referenceId,
      balanceAfter: balanceAfter,
      createdTime: parsedTime,
    );
  }
}
