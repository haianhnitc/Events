import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:events_app/feature/payment/domain/entity/coin_transaction_entity.dart';
import 'package:events_app/feature/payment/domain/repository/coin_repository.dart';
import 'package:injectable/injectable.dart';

class CoinHistoryParams {
  final int page;
  final int size;
  final String sort;

  const CoinHistoryParams({
    this.page = 0,
    this.size = 20,
    this.sort = 'createdTime,desc',
  });
}

@injectable
class GetCoinHistoryUsecase
    implements UseCase<
        ({List<CoinTransactionEntity> items, int totalElements, int totalPages}),
        CoinHistoryParams> {
  final CoinRepository _repository;

  GetCoinHistoryUsecase(this._repository);

  @override
  Future<Either<FailureEntity, ({List<CoinTransactionEntity> items, int totalElements, int totalPages})>>
      call(CoinHistoryParams params) async {
    return await _repository.getCoinHistory(
      page: params.page,
      size: params.size,
      sort: params.sort,
    );
  }
}
