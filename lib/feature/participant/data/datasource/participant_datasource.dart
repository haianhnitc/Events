import 'package:events_app/api_template/api_provider.dart';
import 'package:events_app/api_template/api_path.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/participant/data/model/participant_model.dart';
import 'package:injectable/injectable.dart';

abstract class ParticipantDatasource {
  Future<ApiResponse<List<ParticipantModel>>> getMyParticipants(int userId, {int page, int size});
  Future<ApiResponse<ParticipantModel>> getParticipantById(int id);
}

@Injectable(as: ParticipantDatasource)
class ParticipantDatasourceImpl extends ApiProvider implements ParticipantDatasource {
  ParticipantDatasourceImpl({RestClient? client})
      : super(client: client ?? NRDRestClient());

  @override
  Future<ApiResponse<List<ParticipantModel>>> getMyParticipants(
    int userId, {
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.participants,
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
        fallbackError: 'Lấy danh sách tham gia thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<ParticipantModel>> getParticipantById(int id) async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.participantDetail(id),
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
        fallbackError: 'Lấy chi tiết tham gia thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }
}
