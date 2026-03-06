import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import '../../domain/entity/coin_transaction_entity.dart';

part 'coin_transaction_model.freezed.dart';
part 'coin_transaction_model.g.dart';

@freezed
class CoinTransactionModel with _$CoinTransactionModel {
  const factory CoinTransactionModel({
    int? coinTransactionId,
    int? userId,
    @Default(0) int? amount,
    @Default(0) int? balanceAfter,
    CoinReferenceType? referenceType,
    int? referenceId,
    DateTime? createdTime,
  }) = _CoinTransactionModel;

  factory CoinTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$CoinTransactionModelFromJson(json);

  factory CoinTransactionModel.fromEntity(CoinTransactionEntity entity) {
    return CoinTransactionModel(
      coinTransactionId: entity.coinTransactionId,
      userId: entity.userId,
      amount: entity.amount,
      balanceAfter: entity.balanceAfter,
      referenceType: entity.referenceType,
      referenceId: entity.referenceId,
      createdTime: entity.createdTime,
    );
  }
}

extension CoinTransactionModelExtension on CoinTransactionModel {
  CoinTransactionEntity toEntity() {
    return CoinTransactionEntity(
      coinTransactionId: coinTransactionId,
      userId: userId,
      amount: amount,
      balanceAfter: balanceAfter,
      referenceType: referenceType,
      referenceId: referenceId,
      createdTime: createdTime,
    );
  }
}
