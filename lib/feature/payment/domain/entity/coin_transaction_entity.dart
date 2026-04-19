import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class CoinTransactionEntity {
  final int? transactionId;
  final int? amount;
  final CoinReferenceType? referenceType;
  final int? referenceId;
  final int? balanceAfter;
  final DateTime? createdTime;

  CoinTransactionEntity({
    this.transactionId,
    this.amount,
    this.referenceType,
    this.referenceId,
    this.balanceAfter,
    this.createdTime,
  });

  bool get isPositive => (amount ?? 0) > 0;
  bool get isNegative => (amount ?? 0) < 0;

  String get formattedAmount {
    final val = amount ?? 0;
    return val >= 0 ? '+$val' : '$val';
  }
}
