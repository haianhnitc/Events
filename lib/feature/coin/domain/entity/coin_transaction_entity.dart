import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class CoinTransactionEntity {
  final int? coinTransactionId;
  final int? userId;
  final int? amount;
  final int? balanceAfter;
  final CoinReferenceType? referenceType;
  final int? referenceId;
  final DateTime? createdTime;

  CoinTransactionEntity({
    this.coinTransactionId,
    this.userId,
    this.amount,
    this.balanceAfter,
    this.referenceType,
    this.referenceId,
    this.createdTime,
  });
}
