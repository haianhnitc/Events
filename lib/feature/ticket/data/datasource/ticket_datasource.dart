import 'package:events_app/api_template/api_provider.dart';
import 'package:events_app/api_template/api_path.dart';
import 'package:events_app/api_template/base_request/api_request.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/ticket/data/model/ticket_model.dart';
import 'package:injectable/injectable.dart';

abstract class TicketDatasource {
  Future<ApiResponse<List<TicketModel>>> getMyTickets(int userId, {int page, int size});
  Future<ApiResponse<TicketModel>> getTicketById(int id);
  Future<ApiResponse<TicketModel>> updateTicketStatus(int ticketId, String status);
}

@Injectable(as: TicketDatasource)
class TicketDatasourceImpl extends ApiProvider implements TicketDatasource {
  TicketDatasourceImpl({RestClient? client})
      : super(client: client ?? NRDRestClient());

  @override
  Future<ApiResponse<List<TicketModel>>> getMyTickets(
    int userId, {
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.tickets,
        (data) => Map<String, dynamic>.from(data as Map),
        queryParameters: {'userId': userId, 'page': page, 'size': size},
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

  @override
  Future<ApiResponse<TicketModel>> getTicketById(int id) async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.ticketDetail(id),
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<TicketModel>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return TicketModel.fromJson(object);
        },
        fallbackError: 'Lấy chi tiết vé thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<TicketModel>> updateTicketStatus(
    int ticketId,
    String status,
  ) async {
    try {
      final body = <String, dynamic>{'status': status};

      final response = await put<Map<String, dynamic>>(
        ApiPath.ticketDetail(ticketId),
        (data) => Map<String, dynamic>.from(data as Map),
        body: ApiRequestBody.json(body),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<TicketModel>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return TicketModel.fromJson(object);
        },
        fallbackError: 'Cập nhật trạng thái vé thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }
}
