import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/feature/news/data/datasource/notification_datasource.dart';
import 'package:events_app/feature/news/data/model/notification_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_data.dart';

class TestNotificationDatasource extends NotificationDatasourceImpl {
  ApiResponse<Map<String, dynamic>>? listStub;
  ApiResponse<Map<String, dynamic>>? byIdStub;
  ApiResponse<Map<String, dynamic>>? markAsReadStub;
  ApiResponse<Map<String, dynamic>>? markAllAsReadStub;

  TestNotificationDatasource({
    this.listStub,
    this.byIdStub,
    this.markAsReadStub,
    this.markAllAsReadStub,
  }) : super(client: null);

  @override
  Future<ApiResponse<List<NotificationModel>>> getNotificationList({
    int? page,
    int? size,
  }) async {
    final envelope = listStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': [fakeNotificationJson()],
          },
        });
    return forwardEnvelopeResponse<List<NotificationModel>>(
      envelope,
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
  }

  @override
  Future<ApiResponse<NotificationModel>> getNotificationById(int id) async {
    final envelope = byIdStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeNotificationJson(id: id),
        });
    return forwardEnvelopeResponse<NotificationModel>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return NotificationModel.fromJson(object);
      },
      fallbackError: 'Lấy chi tiết thông báo thất bại',
    );
  }

  @override
  Future<ApiResponse<void>> markAsRead(int id) async {
    final envelope = markAsReadStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': null,
        });
    return forwardEnvelopeResponse<void>(
      envelope,
      (_) => null,
      fallbackError: 'Cập nhật trạng thái thất bại',
    );
  }

  @override
  Future<ApiResponse<void>> markAllAsRead() async {
    final envelope = markAllAsReadStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': null,
        });
    return forwardEnvelopeResponse<void>(
      envelope,
      (_) => null,
      fallbackError: 'Cập nhật trạng thái thất bại',
    );
  }
}

void main() {
  group('getNotificationList', () {
    test('trả về list notification khi thành công', () async {
      final datasource = TestNotificationDatasource(
        listStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': [
              fakeNotificationJson(id: 1),
              fakeNotificationJson(id: 2),
            ],
          },
        }),
      );

      final result = await datasource.getNotificationList();

      result.when(
        success: (notifications) {
          expect(notifications.length, equals(2));
          expect(notifications.first.notificationId, equals(1));
        },
        unexpected: (_) => fail('Expected success'),
        badRequest: (_) => fail('Expected success'),
        unauthorized: (_) => fail('Expected success'),
        forbidden: (_) => fail('Expected success'),
        notFound: (_) => fail('Expected success'),
        conflict: (_) => fail('Expected success'),
        internalServerError: () => fail('Expected success'),
        badGateway: () => fail('Expected success'),
        serviceUnavailable: () => fail('Expected success'),
        gatewayTimeout: () => fail('Expected success'),
        canceled: () => fail('Expected success'),
        responseParsing: () => fail('Expected success'),
      );
    });

    test('trả về list rỗng khi không có notification', () async {
      final datasource = TestNotificationDatasource(
        listStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {'content': []},
        }),
      );

      final result = await datasource.getNotificationList();

      result.when(
        success: (notifications) => expect(notifications, isEmpty),
        unexpected: (_) => fail('Expected success'),
        badRequest: (_) => fail('Expected success'),
        unauthorized: (_) => fail('Expected success'),
        forbidden: (_) => fail('Expected success'),
        notFound: (_) => fail('Expected success'),
        conflict: (_) => fail('Expected success'),
        internalServerError: () => fail('Expected success'),
        badGateway: () => fail('Expected success'),
        serviceUnavailable: () => fail('Expected success'),
        gatewayTimeout: () => fail('Expected success'),
        canceled: () => fail('Expected success'),
        responseParsing: () => fail('Expected success'),
      );
    });

    test('trả về unauthorized khi chưa đăng nhập', () async {
      final datasource = TestNotificationDatasource(
        listStub: const ApiResponse.unauthorized(
          ApiResponseError(code: '401', message: 'Unauthorized', errors: []),
        ),
      );

      final result = await datasource.getNotificationList();

      expect(
        result.when(
          success: (_) => false,
          unauthorized: (_) => true,
          forbidden: (_) => false,
          notFound: (_) => false,
          badRequest: (_) => false,
          conflict: (_) => false,
          internalServerError: () => false,
          badGateway: () => false,
          serviceUnavailable: () => false,
          gatewayTimeout: () => false,
          canceled: () => false,
          responseParsing: () => false,
          unexpected: (_) => false,
        ),
        isTrue,
      );
    });

    test('trả về internalServerError khi backend 500', () async {
      final datasource = TestNotificationDatasource(
        listStub: const ApiResponse.internalServerError(),
      );

      final result = await datasource.getNotificationList();

      expect(
        result.when(
          success: (_) => false,
          internalServerError: () => true,
          badRequest: (_) => false,
          unauthorized: (_) => false,
          forbidden: (_) => false,
          notFound: (_) => false,
          conflict: (_) => false,
          badGateway: () => false,
          serviceUnavailable: () => false,
          gatewayTimeout: () => false,
          canceled: () => false,
          responseParsing: () => false,
          unexpected: (_) => false,
        ),
        isTrue,
      );
    });
  });

  group('getNotificationById', () {
    test('trả về NotificationModel khi thành công', () async {
      final datasource = TestNotificationDatasource(
        byIdStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeNotificationJson(id: 5),
        }),
      );

      final result = await datasource.getNotificationById(5);

      result.when(
        success: (notification) {
          expect(notification, isNotNull);
          expect(notification.notificationId, equals(5));
          expect(notification.title, equals('Notification 5'));
        },
        unexpected: (_) => fail('Expected success'),
        badRequest: (_) => fail('Expected success'),
        unauthorized: (_) => fail('Expected success'),
        forbidden: (_) => fail('Expected success'),
        notFound: (_) => fail('Expected success'),
        conflict: (_) => fail('Expected success'),
        internalServerError: () => fail('Expected success'),
        badGateway: () => fail('Expected success'),
        serviceUnavailable: () => fail('Expected success'),
        gatewayTimeout: () => fail('Expected success'),
        canceled: () => fail('Expected success'),
        responseParsing: () => fail('Expected success'),
      );
    });

    test('trả về notFound khi notification không tồn tại', () async {
      final datasource = TestNotificationDatasource(
        byIdStub: const ApiResponse.notFound(
          ApiResponseError(code: '404', message: 'Not found', errors: []),
        ),
      );

      final result = await datasource.getNotificationById(9999);

      expect(
        result.when(
          success: (_) => false,
          notFound: (_) => true,
          unauthorized: (_) => false,
          forbidden: (_) => false,
          badRequest: (_) => false,
          conflict: (_) => false,
          internalServerError: () => false,
          badGateway: () => false,
          serviceUnavailable: () => false,
          gatewayTimeout: () => false,
          canceled: () => false,
          responseParsing: () => false,
          unexpected: (_) => false,
        ),
        isTrue,
      );
    });

    test('trả về unauthorized khi chưa đăng nhập', () async {
      final datasource = TestNotificationDatasource(
        byIdStub: const ApiResponse.unauthorized(
          ApiResponseError(code: '401', message: 'Unauthorized', errors: []),
        ),
      );

      final result = await datasource.getNotificationById(1);

      expect(
        result.when(
          success: (_) => false,
          unauthorized: (_) => true,
          forbidden: (_) => false,
          notFound: (_) => false,
          badRequest: (_) => false,
          conflict: (_) => false,
          internalServerError: () => false,
          badGateway: () => false,
          serviceUnavailable: () => false,
          gatewayTimeout: () => false,
          canceled: () => false,
          responseParsing: () => false,
          unexpected: (_) => false,
        ),
        isTrue,
      );
    });
  });

  group('markAsRead', () {
    test('trả về success khi đánh dấu thành công', () async {
      final datasource = TestNotificationDatasource(
        markAsReadStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': null,
        }),
      );

      final result = await datasource.markAsRead(5);

      expect(
        result.when(
          success: (_) => true,
          badRequest: (_) => false,
          unauthorized: (_) => false,
          forbidden: (_) => false,
          notFound: (_) => false,
          conflict: (_) => false,
          internalServerError: () => false,
          badGateway: () => false,
          serviceUnavailable: () => false,
          gatewayTimeout: () => false,
          canceled: () => false,
          responseParsing: () => false,
          unexpected: (_) => false,
        ),
        isTrue,
      );
    });

    test('trả về notFound khi notification không tồn tại', () async {
      final datasource = TestNotificationDatasource(
        markAsReadStub: const ApiResponse.notFound(
          ApiResponseError(code: '404', message: 'Not found', errors: []),
        ),
      );

      final result = await datasource.markAsRead(9999);

      expect(
        result.when(
          success: (_) => false,
          notFound: (_) => true,
          unauthorized: (_) => false,
          forbidden: (_) => false,
          badRequest: (_) => false,
          conflict: (_) => false,
          internalServerError: () => false,
          badGateway: () => false,
          serviceUnavailable: () => false,
          gatewayTimeout: () => false,
          canceled: () => false,
          responseParsing: () => false,
          unexpected: (_) => false,
        ),
        isTrue,
      );
    });

    test('trả về unauthorized khi chưa đăng nhập', () async {
      final datasource = TestNotificationDatasource(
        markAsReadStub: const ApiResponse.unauthorized(
          ApiResponseError(code: '401', message: 'Unauthorized', errors: []),
        ),
      );

      final result = await datasource.markAsRead(1);

      expect(
        result.when(
          success: (_) => false,
          unauthorized: (_) => true,
          forbidden: (_) => false,
          notFound: (_) => false,
          badRequest: (_) => false,
          conflict: (_) => false,
          internalServerError: () => false,
          badGateway: () => false,
          serviceUnavailable: () => false,
          gatewayTimeout: () => false,
          canceled: () => false,
          responseParsing: () => false,
          unexpected: (_) => false,
        ),
        isTrue,
      );
    });
  });

  group('markAllAsRead', () {
    test('trả về success khi đánh dấu tất cả thành công', () async {
      final datasource = TestNotificationDatasource(
        markAllAsReadStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': null,
        }),
      );

      final result = await datasource.markAllAsRead();

      expect(
        result.when(
          success: (_) => true,
          badRequest: (_) => false,
          unauthorized: (_) => false,
          forbidden: (_) => false,
          notFound: (_) => false,
          conflict: (_) => false,
          internalServerError: () => false,
          badGateway: () => false,
          serviceUnavailable: () => false,
          gatewayTimeout: () => false,
          canceled: () => false,
          responseParsing: () => false,
          unexpected: (_) => false,
        ),
        isTrue,
      );
    });

    test('trả về unauthorized khi chưa đăng nhập', () async {
      final datasource = TestNotificationDatasource(
        markAllAsReadStub: const ApiResponse.unauthorized(
          ApiResponseError(code: '401', message: 'Unauthorized', errors: []),
        ),
      );

      final result = await datasource.markAllAsRead();

      expect(
        result.when(
          success: (_) => false,
          unauthorized: (_) => true,
          forbidden: (_) => false,
          notFound: (_) => false,
          badRequest: (_) => false,
          conflict: (_) => false,
          internalServerError: () => false,
          badGateway: () => false,
          serviceUnavailable: () => false,
          gatewayTimeout: () => false,
          canceled: () => false,
          responseParsing: () => false,
          unexpected: (_) => false,
        ),
        isTrue,
      );
    });
  });
}
