import 'package:events_app/api_template/api_provider.dart';
import 'package:events_app/api_template/api_path.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/news/data/model/news_claim_response_model.dart';
import 'package:events_app/feature/news/data/model/news_model.dart';
import 'package:injectable/injectable.dart';

abstract class NewsDatasource {
  Future<ApiResponse<List<NewsModel>>> getNewsList({
    int? page,
    int? size,
    String? keyword,
  });
  Future<ApiResponse<NewsModel>> getNewsById(int id);
  Future<ApiResponse<NewsClaimResponseModel>> claimNews(int newsId);
}

@Injectable(as: NewsDatasource)
class NewsDatasourceImpl extends ApiProvider implements NewsDatasource {
  NewsDatasourceImpl({RestClient? client})
      : super(client: client ?? NRDRestClient());

  @override
  Future<ApiResponse<List<NewsModel>>> getNewsList({
    int? page,
    int? size,
    String? keyword,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (page != null) queryParams['page'] = page;
      if (size != null) queryParams['size'] = size;
      if (keyword != null && keyword.isNotEmpty) queryParams['keyword'] = keyword;

      final response = await get<Map<String, dynamic>>(
        ApiPath.news,
        (data) => Map<String, dynamic>.from(data as Map),
        queryParameters: queryParams,
        requireAuth: false,
      );

      return forwardEnvelopeResponse<List<NewsModel>>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          final content = object['content'] as List<dynamic>? ?? [];
          return content
              .map((e) => NewsModel.fromJson(e as Map<String, dynamic>))
              .toList();
        },
        fallbackError: 'Lấy danh sách tin tức thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<NewsModel>> getNewsById(int id) async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.newsDetail(id),
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: false,
      );

      return forwardEnvelopeResponse<NewsModel>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return NewsModel.fromJson(object);
        },
        fallbackError: 'Lấy chi tiết tin tức thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<NewsClaimResponseModel>> claimNews(int newsId) async {
    try {
      final response = await post<Map<String, dynamic>>(
        ApiPath.newsClaim(newsId),
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<NewsClaimResponseModel>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return NewsClaimResponseModel.fromJson(object);
        },
        fallbackError: 'Nhận coin thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }
}
