import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:events_app/feature/news/data/model/news_claim_response_model.dart';
import 'package:events_app/feature/news/domain/entity/news_entity.dart';
import 'package:events_app/feature/news/domain/repository/news_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetNewsListUsecase implements UseCase<List<NewsEntity>, GetNewsListParams> {
  final NewsRepository _repository;

  GetNewsListUsecase(this._repository);

  @override
  Future<Either<FailureEntity, List<NewsEntity>>> call(GetNewsListParams params) async {
    return await _repository.getNewsList(
      page: params.page,
      size: params.size,
      keyword: params.keyword,
    );
  }
}

@injectable
class GetNewsByIdUsecase implements UseCase<NewsEntity, int> {
  final NewsRepository _repository;

  GetNewsByIdUsecase(this._repository);

  @override
  Future<Either<FailureEntity, NewsEntity>> call(int id) async {
    return await _repository.getNewsById(id);
  }
}

class GetNewsListParams {
  final int? page;
  final int? size;
  final String? keyword;

  const GetNewsListParams({
    this.page,
    this.size,
    this.keyword,
  });
}

@injectable
class ClaimNewsUsecase implements UseCase<NewsClaimResponseModel, int> {
  final NewsRepository _repository;

  ClaimNewsUsecase(this._repository);

  @override
  Future<Either<FailureEntity, NewsClaimResponseModel>> call(int newsId) async {
    return await _repository.claimNews(newsId);
  }
}
