import 'package:events_app/api_template/api_provider.dart';
import 'package:events_app/api_template/api_path.dart';
import 'package:events_app/api_template/base_request/api_request.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/recruitment/data/model/ctv_recruitment_model.dart';
import 'package:events_app/feature/organizer/recruitment/domain/usecase/organizer_recruitment_params.dart';
import 'package:injectable/injectable.dart';

abstract class OrganizerRecruitmentDatasource {
  Future<ApiResponse<List<CtvRecruitmentModel>>> getRecruitments({int? eventId, String? keyword, int page, int size});
  Future<ApiResponse<CtvRecruitmentModel>> getRecruitmentById(int id);
  Future<ApiResponse<CtvRecruitmentModel>> createRecruitment(CreateRecruitmentParams params);
  Future<ApiResponse<CtvRecruitmentModel>> updateRecruitment(int id, UpdateRecruitmentParams params);
  Future<ApiResponse<void>> closeRecruitment(int id);
  Future<ApiResponse<void>> deleteRecruitment(int id);
}

@Injectable(as: OrganizerRecruitmentDatasource)
class OrganizerRecruitmentDatasourceImpl extends ApiProvider implements OrganizerRecruitmentDatasource {
  OrganizerRecruitmentDatasourceImpl({RestClient? client})
      : super(client: client ?? NRDRestClient());

  @override
  Future<ApiResponse<List<CtvRecruitmentModel>>> getRecruitments({
    int? eventId,
    String? keyword,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'size': size};
      if (eventId != null) queryParams['eventId'] = eventId;
      if (keyword != null && keyword.isNotEmpty) queryParams['keyword'] = keyword;

      final response = await get<Map<String, dynamic>>(
        ApiPath.recruitments,
        (data) => Map<String, dynamic>.from(data as Map),
        queryParameters: queryParams,
        requireAuth: true,
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
        requireAuth: true,
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
  Future<ApiResponse<CtvRecruitmentModel>> createRecruitment(
    CreateRecruitmentParams params,
  ) async {
    try {
      final response = await post<Map<String, dynamic>>(
        ApiPath.recruitments,
        (data) => Map<String, dynamic>.from(data as Map),
        body: ApiRequestBody.json(params.toJson()),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<CtvRecruitmentModel>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return CtvRecruitmentModel.fromJson(object);
        },
        fallbackError: 'Tạo tuyển CTV thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<CtvRecruitmentModel>> updateRecruitment(
    int id,
    UpdateRecruitmentParams params,
  ) async {
    try {
      final response = await put<Map<String, dynamic>>(
        ApiPath.recruitmentDetail(id),
        (data) => Map<String, dynamic>.from(data as Map),
        body: ApiRequestBody.json(params.toJson()),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<CtvRecruitmentModel>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return CtvRecruitmentModel.fromJson(object);
        },
        fallbackError: 'Cập nhật tuyển CTV thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<void>> closeRecruitment(int id) async {
    try {
      final response = await patch<Map<String, dynamic>>(
        ApiPath.recruitmentClose(id),
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<void>(
        response,
        (_) => null,
        fallbackError: 'Đóng tuyển CTV thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<void>> deleteRecruitment(int id) async {
    try {
      final response = await delete<Map<String, dynamic>>(
        ApiPath.recruitmentDetail(id),
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<void>(
        response,
        (_) => null,
        fallbackError: 'Xóa tuyển CTV thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }
}
