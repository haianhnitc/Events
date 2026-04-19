import 'package:events_app/api_template/api_provider.dart';
import 'package:events_app/api_template/api_path.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/recruitment/data/model/ctv_recruitment_model.dart';
import 'package:events_app/feature/recruitment/data/model/requirement_question_model.dart';
import 'package:injectable/injectable.dart';

abstract class CtvRecruitmentDatasource {
  Future<ApiResponse<List<CtvRecruitmentModel>>> getRecruitments(
      {int? eventId, int page, int size});
  Future<ApiResponse<CtvRecruitmentModel>> getRecruitmentById(int id);
  Future<ApiResponse<List<RequirementQuestionModel>>> getRecruitmentQuestions(
      int recruitmentId);
}

@Injectable(as: CtvRecruitmentDatasource)
class CtvRecruitmentDatasourceImpl extends ApiProvider
    implements CtvRecruitmentDatasource {
  CtvRecruitmentDatasourceImpl({RestClient? client})
      : super(client: client ?? NRDRestClient());

  @override
  Future<ApiResponse<List<CtvRecruitmentModel>>> getRecruitments({
    int? eventId,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'size': size,
      };
      if (eventId != null) queryParams['eventId'] = eventId;

      final response = await get<Map<String, dynamic>>(
        ApiPath.recruitments,
        (data) => Map<String, dynamic>.from(data as Map),
        queryParameters: queryParams,
        requireAuth: false,
      );

      return forwardEnvelopeResponse<List<CtvRecruitmentModel>>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          final content = object['content'] as List<dynamic>? ?? [];
          return content
              .map((e) => CtvRecruitmentModel.fromJson(e as Map<String, dynamic>))
              .toList();
        },
        fallbackError: 'Lấy danh sách tuyển CTV thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<CtvRecruitmentModel>> getRecruitmentById(int id) async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.recruitmentDetail(id),
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: false,
      );

      return forwardEnvelopeResponse<CtvRecruitmentModel>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return CtvRecruitmentModel.fromJson(object);
        },
        fallbackError: 'Lấy chi tiết tuyển CTV thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<List<RequirementQuestionModel>>> getRecruitmentQuestions(
      int recruitmentId) async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.recruitmentQuestions(recruitmentId),
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: false,
      );

      return forwardEnvelopeResponse<List<RequirementQuestionModel>>(
        response,
        (object) {
          if (object == null) return <RequirementQuestionModel>[];
          if (object is List<dynamic>) {
            return object
                .map((e) => RequirementQuestionModel.fromJson(
                    e as Map<String, dynamic>))
                .toList();
          }
          if (object is Map<String, dynamic>) {
            final content = object['content'] as List<dynamic>? ?? [];
            return content
                .map((e) => RequirementQuestionModel.fromJson(
                    e as Map<String, dynamic>))
                .toList();
          }
          throw const FormatException('Invalid object payload');
        },
        fallbackError: 'Lấy câu hỏi tuyển dụng thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }
}
