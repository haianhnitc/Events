import 'package:events_app/api_template/api_provider.dart';
import 'package:events_app/api_template/api_path.dart';
import 'package:events_app/api_template/base_request/api_request.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/event_management/data/model/event_model.dart';
import 'package:events_app/feature/event_management/data/model/event_analytics_model.dart';
import 'package:events_app/feature/event_management/data/model/event_summary_model.dart';
import 'package:events_app/feature/organizer/event/domain/usecase/event_params.dart';
import 'package:injectable/injectable.dart';

abstract class OrganizerEventDatasource {
  Future<ApiResponse<EventSummaryPage>> getOrganizerEvents(
      OrganizerEventListParams params);
  Future<ApiResponse<EventModel>> createEvent(EventCreateParams params);
  Future<ApiResponse<EventModel>> updateEvent(
      int eventId, EventUpdateParams params);
  Future<ApiResponse<void>> deleteEvent(int eventId);
  Future<ApiResponse<EventModel>> publishEvent(int eventId);
  Future<ApiResponse<EventModel>> getEventById(int eventId);
  Future<ApiResponse<Map<String, dynamic>>> getEventStatistics(int eventId);
  Future<ApiResponse<EventAnalyticsModel>> getEventAnalytics(int eventId);
  Future<ApiResponse<Map<String, dynamic>>> createEventCategoryOption(
      EventCategoryOptionCreateParams params);
  Future<ApiResponse<Map<String, dynamic>>> updateEventCategoryOption(
      int eventId,
      int categoryOptionId,
      EventCategoryOptionUpdateParams params);
  Future<ApiResponse<void>> deleteEventCategoryOption(
      int eventId, int categoryOptionId);
}

class EventSummaryPage {
  final List<EventSummaryModel> content;
  final int totalElements;
  final int totalPages;
  final int page;
  final int size;

  const EventSummaryPage({
    required this.content,
    required this.totalElements,
    required this.totalPages,
    required this.page,
    required this.size,
  });
}

@Injectable(as: OrganizerEventDatasource)
class OrganizerEventDatasourceImpl extends ApiProvider
    implements OrganizerEventDatasource {
  OrganizerEventDatasourceImpl({RestClient? client})
      : super(client: client ?? NRDRestClient());

  @override
  Future<ApiResponse<EventSummaryPage>> getOrganizerEvents(
      OrganizerEventListParams params) async {
    try {
      final queryParams = <String, dynamic>{
        'organizerId': params.organizerId,
        'page': params.page,
        'size': params.size,
      };
      if (params.status != null) queryParams['status'] = params.status!.name;
      if (params.keyword != null && params.keyword!.isNotEmpty) {
        queryParams['keyword'] = params.keyword;
      }
      if (params.sortBy != null) queryParams['sortBy'] = params.sortBy;
      if (params.sortDirection != null) {
        queryParams['sortDirection'] = params.sortDirection;
      }

      final response = await get<Map<String, dynamic>>(
        ApiPath.events,
        (data) => Map<String, dynamic>.from(data as Map),
        queryParameters: queryParams,
        requireAuth: true,
      );

      return forwardEnvelopeResponse<EventSummaryPage>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          final contentList = object['content'] as List<dynamic>? ?? [];
          return EventSummaryPage(
            content: contentList
                .map((e) =>
                    EventSummaryModel.fromJson(e as Map<String, dynamic>))
                .toList(),
            totalElements: object['totalElements'] as int? ?? 0,
            totalPages: object['totalPages'] as int? ?? 0,
            page: object['page'] as int? ?? 0,
            size: object['size'] as int? ?? params.size,
          );
        },
        fallbackError: 'Không thể tải danh sách sự kiện',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<EventModel>> createEvent(EventCreateParams params) async {
    try {
      final response = await post<Map<String, dynamic>>(
        ApiPath.events,
        (data) => Map<String, dynamic>.from(data as Map),
        body: ApiRequestBody.json(params.toJson()),
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
        fallbackError: 'Tạo sự kiện thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<EventModel>> updateEvent(
      int eventId, EventUpdateParams params) async {
    try {
      final response = await put<Map<String, dynamic>>(
        ApiPath.eventDetail(eventId),
        (data) => Map<String, dynamic>.from(data as Map),
        body: ApiRequestBody.json(params.toJson()),
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
        fallbackError: 'Cập nhật sự kiện thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<void>> deleteEvent(int eventId) async {
    try {
      final response = await delete<Map<String, dynamic>>(
        ApiPath.eventDetail(eventId),
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<void>(
        response,
        (_) {},
        fallbackError: 'Xóa sự kiện thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<EventModel>> publishEvent(int eventId) async {
    try {
      final response = await post<Map<String, dynamic>>(
        ApiPath.eventPublish(eventId),
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
        fallbackError: 'Xuất bản sự kiện thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<EventModel>> getEventById(int eventId) async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.eventDetail(eventId),
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

  @override
  Future<ApiResponse<Map<String, dynamic>>> getEventStatistics(
      int eventId) async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.eventStatistics(eventId),
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<Map<String, dynamic>>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return object;
        },
        fallbackError: 'Lấy thống kê sự kiện thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<EventAnalyticsModel>> getEventAnalytics(
      int eventId) async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.eventAnalytics(eventId),
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<EventAnalyticsModel>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return EventAnalyticsModel.fromJson(object);
        },
        fallbackError: 'Lấy phân tích sự kiện thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> createEventCategoryOption(
      EventCategoryOptionCreateParams params) async {
    try {
      final response = await post<Map<String, dynamic>>(
        ApiPath.eventCategoryOptions,
        (data) => Map<String, dynamic>.from(data as Map),
        body: ApiRequestBody.json(params.toJson()),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<Map<String, dynamic>>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return object;
        },
        fallbackError: 'Tạo category option thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> updateEventCategoryOption(
      int eventId,
      int categoryOptionId,
      EventCategoryOptionUpdateParams params) async {
    try {
      final response = await put<Map<String, dynamic>>(
        ApiPath.eventCategoryOptionUpdate(eventId, categoryOptionId),
        (data) => Map<String, dynamic>.from(data as Map),
        body: ApiRequestBody.json(params.toJson()),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<Map<String, dynamic>>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return object;
        },
        fallbackError: 'Cập nhật category option thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<void>> deleteEventCategoryOption(
      int eventId, int categoryOptionId) async {
    try {
      final response = await delete<Map<String, dynamic>>(
        ApiPath.eventCategoryOptionUpdate(eventId, categoryOptionId),
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<void>(
        response,
        (_) {},
        fallbackError: 'Xóa category option thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }
}
