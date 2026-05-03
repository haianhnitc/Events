import 'package:events_app/api_template/api_provider.dart';
import 'package:events_app/api_template/api_path.dart';
import 'package:events_app/api_template/base_request/api_request.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/user_management/data/model/organization_profile_model.dart';
import 'package:events_app/feature/user_management/data/model/organization_dashboard_model.dart';
import 'package:events_app/feature/organizer/organization/domain/usecase/organization_params.dart';
import 'package:injectable/injectable.dart';

abstract class OrganizerOrganizationDatasource {
  Future<ApiResponse<OrganizationProfileModel>> updateProfile(
      int organizationId, OrganizationProfileUpdateParams params);
  Future<ApiResponse<OrganizationDashboardModel>> getDashboard(int organizationId);
}

@Injectable(as: OrganizerOrganizationDatasource)
class OrganizerOrganizationDatasourceImpl extends ApiProvider
    implements OrganizerOrganizationDatasource {
  OrganizerOrganizationDatasourceImpl({RestClient? client})
      : super(client: client ?? NRDRestClient());

  @override
  Future<ApiResponse<OrganizationProfileModel>> updateProfile(
      int organizationId, OrganizationProfileUpdateParams params) async {
    try {
      final response = await put<Map<String, dynamic>>(
        ApiPath.organizationDetail(organizationId),
        (data) => Map<String, dynamic>.from(data as Map),
        body: ApiRequestBody.json(params.toJson()),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<OrganizationProfileModel>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return OrganizationProfileModel.fromJson(object);
        },
        fallbackError: 'Cập nhật hồ sơ tổ chức thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<OrganizationDashboardModel>> getDashboard(int organizationId) async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.organizationDashboardById(organizationId),
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<OrganizationDashboardModel>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return OrganizationDashboardModel.fromJson(object);
        },
        fallbackError: 'Lấy dashboard thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }
}
