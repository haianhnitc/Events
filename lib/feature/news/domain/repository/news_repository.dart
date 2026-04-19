import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/news/data/model/news_claim_response_model.dart';
import 'package:events_app/feature/news/domain/entity/news_entity.dart';

abstract class NewsRepository {
  Future<Either<FailureEntity, List<NewsEntity>>> getNewsList({
    int? page,
    int? size,
    String? keyword,
  });
  Future<Either<FailureEntity, NewsEntity>> getNewsById(int id);
  Future<Either<FailureEntity, NewsClaimResponseModel>> claimNews(int newsId);
}
