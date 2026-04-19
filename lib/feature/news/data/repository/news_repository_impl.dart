import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/news/data/datasource/news_datasource.dart';
import 'package:events_app/feature/news/data/model/news_claim_response_model.dart';
import 'package:events_app/feature/news/data/model/news_model.dart';
import 'package:events_app/feature/news/domain/entity/news_entity.dart';
import 'package:events_app/feature/news/domain/repository/news_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: NewsRepository)
class NewsRepositoryImpl implements NewsRepository {
  final NewsDatasource _datasource;

  NewsRepositoryImpl(this._datasource);

  @override
  Future<Either<FailureEntity, List<NewsEntity>>> getNewsList({
    int? page,
    int? size,
    String? keyword,
  }) async {
    final response = await _datasource.getNewsList(
      page: page,
      size: size,
      keyword: keyword,
    );
    return response.toEither().map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }

  @override
  Future<Either<FailureEntity, NewsEntity>> getNewsById(int id) async {
    final response = await _datasource.getNewsById(id);
    return response.toEitherNullable().map((m) => m.toEntity());
  }

  @override
  Future<Either<FailureEntity, NewsClaimResponseModel>> claimNews(int newsId) async {
    final response = await _datasource.claimNews(newsId);
    return response.toEitherNullable();
  }
}
