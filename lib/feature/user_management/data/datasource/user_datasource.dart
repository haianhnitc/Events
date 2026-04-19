import 'package:events_app/api_template/api_path.dart';
import 'package:events_app/api_template/api_provider.dart';
import 'package:events_app/api_template/base_request/api_request.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/user_management/data/model/user_model.dart';
import 'package:events_app/feature/user_management/domain/usecase/update_current_user_usecase.dart';
import 'package:injectable/injectable.dart';

abstract class UserDatasource {
  Future<ApiResponse<UserModel?>> getCurrentUser();

  Future<ApiResponse<UserModel?>> updateCurrentUser(
      UpdateCurrentUserParams params);

  Future<ApiResponse<Map<String, dynamic>>> getUserParticipatedEvents({
    required int userId,
    String? participantType,
    int page = 0,
    int size = 20,
  });
}

@Injectable(as: UserDatasource)
class UserDatasourceImpl extends ApiProvider implements UserDatasource {
  UserDatasourceImpl({RestClient? client})
      : super(client: client ?? NRDRestClient());

  @override
  Future<ApiResponse<UserModel?>> getCurrentUser() async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.usersMe,
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<UserModel?>(
        response,
        (object) {
          if (object == null) return null;
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return UserModel.fromJson(object);
        },
        fallbackError: 'Lấy thông tin user thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<UserModel?>> updateCurrentUser(
      UpdateCurrentUserParams params) async {
    try {
      final response = await put<Map<String, dynamic>>(
        ApiPath.usersMe,
        (data) => Map<String, dynamic>.from(data as Map),
        body: ApiRequestBody.json(params.toJson()),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<UserModel?>(
        response,
        (object) {
          if (object == null) return null;
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return UserModel.fromJson(object);
        },
        fallbackError: 'Cập nhật thông tin thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> getUserParticipatedEvents({
    required int userId,
    String? participantType,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'size': size};
      if (participantType != null) queryParams['participantType'] = participantType;

      final response = await get<Map<String, dynamic>>(
        ApiPath.userParticipatedEvents(userId),
        (data) => Map<String, dynamic>.from(data as Map),
        queryParameters: queryParams,
        requireAuth: true,
      );

      return forwardEnvelopeResponse<Map<String, dynamic>>(
        response,
        (object) => object as Map<String, dynamic>,
        fallbackError: 'Lấy lịch sử tham dự thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }
}
