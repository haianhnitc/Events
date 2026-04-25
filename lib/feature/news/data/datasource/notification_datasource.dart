import 'package:events_app/api_template/api_provider.dart';
import 'package:events_app/api_template/api_path.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/news/data/model/notification_model.dart';
import 'package:injectable/injectable.dart';

abstract class NotificationDatasource {
  Future<ApiResponse<List<NotificationModel>>> getNotificationList({
    int? page,
    int? size,
  });
  Future<ApiResponse<NotificationModel>> getNotificationById(int id);
  Future<ApiResponse<void>> markAsRead(int id);
  Future<ApiResponse<void>> markAllAsRead();
}

@Injectable(as: NotificationDatasource)
class NotificationDatasourceImpl extends ApiProvider implements NotificationDatasource {
  NotificationDatasourceImpl({RestClient? client})
      : super(client: client ?? NRDRestClient());

  @override
  Future<ApiResponse<List<NotificationModel>>> getNotificationList({
    int? page,
    int? size,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (page != null) queryParams['page'] = page;
      if (size != null) queryParams['size'] = size;

      final response = await get<Map<String, dynamic>>(
        ApiPath.notifications,
        (data) => Map<String, dynamic>.from(data as Map),
        queryParameters: queryParams,
        requireAuth: true,
      );

      return forwardEnvelopeResponse<List<NotificationModel>>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          final content = object['content'] as List<dynamic>? ?? [];
          return content
              .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
              .toList();
        },
        fallbackError: 'Lấy danh sách thông báo thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<NotificationModel>> getNotificationById(int id) async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.notificationDetail(id),
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<NotificationModel>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return NotificationModel.fromJson(object);
        },
        fallbackError: 'Lấy chi tiết thông báo thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<void>> markAsRead(int id) async {
    try {
      final response = await put<Map<String, dynamic>>(
        '${ApiPath.notificationDetail(id)}/read',
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<void>(
        response,
        (_) => null,
        fallbackError: 'Cập nhật trạng thái thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<void>> markAllAsRead() async {
    try {
      final response = await put<Map<String, dynamic>>(
        '${ApiPath.notifications}/read-all',
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<void>(
        response,
        (_) => null,
        fallbackError: 'Cập nhật trạng thái thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }
}
