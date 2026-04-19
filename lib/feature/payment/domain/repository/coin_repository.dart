import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/payment/domain/entity/coin_transaction_entity.dart';

abstract class CoinRepository {
  Future<Either<FailureEntity, ({List<CoinTransactionEntity> items, int totalElements, int totalPages})>>
      getCoinHistory({
    int page = 0,
    int size = 20,
    String sort = 'createdTime,desc',
  });
}
