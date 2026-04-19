import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/payment/data/datasource/coin_datasource.dart';
import 'package:events_app/feature/payment/domain/entity/coin_transaction_entity.dart';
import 'package:events_app/feature/payment/domain/repository/coin_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CoinRepository)
class CoinRepositoryImpl implements CoinRepository {
  final CoinDatasource _datasource;

  CoinRepositoryImpl(this._datasource);

  @override
  Future<Either<FailureEntity, ({List<CoinTransactionEntity> items, int totalElements, int totalPages})>>
      getCoinHistory({
    int page = 0,
    int size = 20,
    String sort = 'createdTime,desc',
  }) async {
    final response = await _datasource.getCoinHistory(
      page: page,
      size: size,
      sort: sort,
    );
    return response.toEither().map((page) => (
      items: page.items.map((m) => m.toEntity()).toList(),
      totalElements: page.totalElements,
      totalPages: page.totalPages,
    ));
  }
}
