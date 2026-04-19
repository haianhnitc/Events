import 'package:events_app/api_template/api_provider.dart';
import 'package:events_app/api_template/api_path.dart';
import 'package:events_app/api_template/base_request/api_request.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/staff_application/data/model/staff_application_model.dart';
import 'package:events_app/feature/organizer/staff_application/domain/usecase/organizer_staff_application_params.dart';
import 'package:injectable/injectable.dart';

abstract class OrganizerStaffApplicationDatasource {
  Future<ApiResponse<List<StaffApplicationModel>>> getStaffApplications({
    int? eventId,
    String? keyword,
    int? status,
    int page,
    int size,
  });
  Future<ApiResponse<StaffApplicationModel>> getStaffApplicationById(int id);
  Future<ApiResponse<StaffApplicationModel>> approveStaffApplication(ApproveStaffApplicationParams params);
}

@Injectable(as: OrganizerStaffApplicationDatasource)
class OrganizerStaffApplicationDatasourceImpl extends ApiProvider implements OrganizerStaffApplicationDatasource {
  OrganizerStaffApplicationDatasourceImpl({RestClient? client})
      : super(client: client ?? NRDRestClient());

  @override
  Future<ApiResponse<List<StaffApplicationModel>>> getStaffApplications({
    int? eventId,
    String? keyword,
    int? status,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'size': size};
      if (eventId != null) queryParams['eventId'] = eventId;
      if (status != null) queryParams['status'] = status;
      if (keyword != null && keyword.isNotEmpty) queryParams['keyword'] = keyword;

      final response = await get<Map<String, dynamic>>(
        ApiPath.staffApplications,
        (data) => Map<String, dynamic>.from(data as Map),
        queryParameters: queryParams,
        requireAuth: true,
      );

      return forwardEnvelopeResponse<List<StaffApplicationModel>>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          final content = object['content'] as List<dynamic>? ?? [];
          return content
              .map((e) => StaffApplicationModel.fromJson(e as Map<String, dynamic>))
              .toList();
        },
        fallbackError: 'Lấy danh sách đơn ứng tuyển thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<StaffApplicationModel>> getStaffApplicationById(int id) async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.staffApplicationDetail(id),
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<StaffApplicationModel>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return StaffApplicationModel.fromJson(object);
        },
        fallbackError: 'Lấy chi tiết đơn thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<StaffApplicationModel>> approveStaffApplication(
    ApproveStaffApplicationParams params,
  ) async {
    try {
      final response = await put<Map<String, dynamic>>(
        ApiPath.staffApplicationApprove(params.applicationId),
        (data) => Map<String, dynamic>.from(data as Map),
        body: ApiRequestBody.json(params.toJson()),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<StaffApplicationModel>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return StaffApplicationModel.fromJson(object);
        },
        fallbackError: 'Duyệt đơn thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }
}
