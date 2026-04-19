import 'package:events_app/api_template/api_provider.dart';
import 'package:events_app/api_template/api_path.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/event_management/data/model/event_model.dart';
import 'package:events_app/feature/event_management/data/model/event_summary_model.dart';
import 'package:injectable/injectable.dart';

abstract class EventDatasource {
  Future<ApiResponse<List<EventSummaryModel>>> getEvents({
    int? categoryId,
    int? status,
    int page,
    int size,
    String? keyword,
  });

  Future<ApiResponse<List<EventSummaryModel>>> getFeaturedEvents();

  Future<ApiResponse<EventModel>> getEventById(int id);
}

@Injectable(as: EventDatasource)
class EventDatasourceImpl extends ApiProvider implements EventDatasource {
  EventDatasourceImpl({RestClient? client})
      : super(client: client ?? NRDRestClient());

  @override
  Future<ApiResponse<List<EventSummaryModel>>> getEvents({
    int? categoryId,
    int? status,
    int page = 0,
    int size = 20,
    String? keyword,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'size': size,
      };
      if (categoryId != null) queryParams['categoryId'] = categoryId;
      if (status != null) queryParams['status'] = status;
      if (keyword != null && keyword.isNotEmpty) queryParams['keyword'] = keyword;

      final response = await get<Map<String, dynamic>>(
        ApiPath.events,
        (data) => Map<String, dynamic>.from(data as Map),
        queryParameters: queryParams,
        requireAuth: true,
      );

      return forwardEnvelopeResponse<List<EventSummaryModel>>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          final content = object['content'] as List<dynamic>? ?? [];
          return content
              .map((e) => EventSummaryModel.fromJson(e as Map<String, dynamic>))
              .toList();
        },
        fallbackError: 'Lấy danh sách sự kiện thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<List<EventSummaryModel>>> getFeaturedEvents() async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.eventsFeatured,
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: false,
      );

      return forwardEnvelopeResponse<List<EventSummaryModel>>(
        response,
        (object) {
          if (object is! List) {
            throw const FormatException('Expected a list payload');
          }
          return object
              .map((e) => EventSummaryModel.fromJson(e as Map<String, dynamic>))
              .toList();
        },
        fallbackError: 'Lấy danh sách sự kiện nổi bật thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<EventModel>> getEventById(int id) async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.eventDetail(id),
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<EventModel>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return EventModel.fromJson(object);
        },
        fallbackError: 'Lấy chi tiết sự kiện thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }
}
