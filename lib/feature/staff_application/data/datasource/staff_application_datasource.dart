import 'package:events_app/api_template/api_provider.dart';
import 'package:events_app/api_template/api_path.dart';
import 'package:events_app/api_template/base_request/api_request.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/staff_application/data/model/staff_application_model.dart';
import 'package:events_app/feature/staff_application/domain/usecase/apply_ctv_params.dart';
import 'package:injectable/injectable.dart';

abstract class StaffApplicationDatasource {
  Future<ApiResponse<StaffApplicationModel>> createApplication(ApplyCtvParams params);
  Future<ApiResponse<StaffApplicationModel>> getApplicationById(int id);
}

@Injectable(as: StaffApplicationDatasource)
class StaffApplicationDatasourceImpl extends ApiProvider implements StaffApplicationDatasource {
  StaffApplicationDatasourceImpl({RestClient? client})
      : super(client: client ?? NRDRestClient());

  @override
  Future<ApiResponse<StaffApplicationModel>> createApplication(
    ApplyCtvParams params,
  ) async {
    try {
      final response = await post<Map<String, dynamic>>(
        ApiPath.staffApplications,
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
        fallbackError: 'Gửi đơn ứng tuyển thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<StaffApplicationModel>> getApplicationById(int id) async {
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
}
