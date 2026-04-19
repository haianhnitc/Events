import 'package:events_app/api_template/api_provider.dart';
import 'package:events_app/api_template/api_path.dart';
import 'package:events_app/api_template/base_request/api_request.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/participant/data/model/participant_model.dart';
import 'package:events_app/feature/ticket/data/model/ticket_model.dart';
import 'package:events_app/feature/organizer/participant/domain/usecase/organizer_participant_params.dart';
import 'package:injectable/injectable.dart';

abstract class OrganizerParticipantDatasource {
  Future<ApiResponse<List<ParticipantModel>>> getParticipants({
    int? eventId,
    String? participantType,
    int page,
    int size,
  });
  Future<ApiResponse<ParticipantModel>> getParticipantById(int id);
  Future<ApiResponse<ParticipantModel>> createParticipant(CreateOrganizerParticipantParams params);
  Future<ApiResponse<void>> deleteParticipant(int id);
  Future<ApiResponse<List<TicketModel>>> getTickets({int? eventId, int page, int size});
}

@Injectable(as: OrganizerParticipantDatasource)
class OrganizerParticipantDatasourceImpl extends ApiProvider implements OrganizerParticipantDatasource {
  OrganizerParticipantDatasourceImpl({RestClient? client})
      : super(client: client ?? NRDRestClient());

  @override
  Future<ApiResponse<List<ParticipantModel>>> getParticipants({
    int? eventId,
    String? participantType,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'size': size};
      if (eventId != null) queryParams['eventId'] = eventId;
      if (participantType != null) queryParams['participantType'] = participantType;

      final response = await get<Map<String, dynamic>>(
        ApiPath.participants,
        (data) => Map<String, dynamic>.from(data as Map),
        queryParameters: queryParams,
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
        fallbackError: 'Lấy danh sách participant thất bại',
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
        fallbackError: 'Lấy chi tiết participant thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<ParticipantModel>> createParticipant(
    CreateOrganizerParticipantParams params,
  ) async {
    try {
      final response = await post<Map<String, dynamic>>(
        ApiPath.participants,
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
        fallbackError: 'Tạo participant thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<void>> deleteParticipant(int id) async {
    try {
      final response = await delete<Map<String, dynamic>>(
        ApiPath.participantDetail(id),
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<void>(
        response,
        (_) => null,
        fallbackError: 'Xóa participant thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<List<TicketModel>>> getTickets({
    int? eventId,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'size': size};
      if (eventId != null) queryParams['eventId'] = eventId;

      final response = await get<Map<String, dynamic>>(
        ApiPath.tickets,
        (data) => Map<String, dynamic>.from(data as Map),
        queryParameters: queryParams,
        requireAuth: true,
      );

      return forwardEnvelopeResponse<List<TicketModel>>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          final content = object['content'] as List<dynamic>? ?? [];
          return content
              .map((e) => TicketModel.fromJson(e as Map<String, dynamic>))
              .toList();
        },
        fallbackError: 'Lấy danh sách vé thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }
}
