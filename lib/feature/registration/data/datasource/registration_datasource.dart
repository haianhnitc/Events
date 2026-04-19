import 'package:events_app/api_template/api_provider.dart';
import 'package:events_app/api_template/api_path.dart';
import 'package:events_app/api_template/base_request/api_request.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/participant/data/model/participant_model.dart';
import 'package:events_app/feature/registration/domain/usecase/registration_usecase.dart';
import 'package:injectable/injectable.dart';

abstract class RegistrationDatasource {
  Future<ApiResponse<ParticipantModel>> createRegistration(CreateRegistrationParams params);
  Future<ApiResponse<List<ParticipantModel>>> getMyRegistrations(int userId, {int page, int size});
  Future<ApiResponse<ParticipantModel>> getRegistrationById(int id);
  Future<ApiResponse<void>> cancelRegistration(int id);
}

@Injectable(as: RegistrationDatasource)
class RegistrationDatasourceImpl extends ApiProvider implements RegistrationDatasource {
  RegistrationDatasourceImpl({RestClient? client})
      : super(client: client ?? NRDRestClient());

  @override
  Future<ApiResponse<ParticipantModel>> createRegistration(
      CreateRegistrationParams params) async {
    try {
      final response = await post<Map<String, dynamic>>(
        ApiPath.registrations,
        (data) => Map<String, dynamic>.from(data as Map),
        body: ApiRequestBody.json(params.toJson()),
        requireAuth: true,
      );
      return forwardEnvelopeResponse<ParticipantModel>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return ParticipantModel.fromJson(object);
        },
        fallbackError: 'Đăng ký thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<List<ParticipantModel>>> getMyRegistrations(
    int userId, {
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.registrations,
        (data) => Map<String, dynamic>.from(data as Map),
        queryParameters: {'userId': userId, 'page': page, 'size': size},
        requireAuth: true,
      );
      return forwardEnvelopeResponse<List<ParticipantModel>>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          final content = object['content'] as List<dynamic>? ?? [];
          return content
              .map((e) => ParticipantModel.fromJson(e as Map<String, dynamic>))
              .toList();
        },
        fallbackError: 'Lấy danh sách đăng ký thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<ParticipantModel>> getRegistrationById(int id) async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.registrationDetail(id),
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: true,
      );
      return forwardEnvelopeResponse<ParticipantModel>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return ParticipantModel.fromJson(object);
        },
        fallbackError: 'Lấy chi tiết đăng ký thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<void>> cancelRegistration(int id) async {
    try {
      final response = await delete<Map<String, dynamic>>(
        ApiPath.registrationCancel(id),
        (data) => data == null ? <String, dynamic>{} : Map<String, dynamic>.from(data as Map),
        requireAuth: true,
      );
      return forwardEnvelopeResponse<void>(
        response,
        (_) => null,
        fallbackError: 'Hủy đăng ký thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }
}
