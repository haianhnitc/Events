import 'package:flutter_test/flutter_test.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/organizer/attendance/data/datasource/organizer_attendance_datasource.dart';
import 'package:events_app/feature/organizer/attendance/domain/usecase/organizer_attendance_params.dart';
import 'package:events_app/feature/attendance/data/model/attendance_model.dart';
import 'package:events_app/feature/attendance/data/model/event_attendance_log_model.dart';

import '../../helpers/fake_data.dart';

class TestOrganizerAttendanceDatasource extends OrganizerAttendanceDatasourceImpl {
  ApiResponse<Map<String, dynamic>>? getEventQrStub;
  ApiResponse<Map<String, dynamic>>? getParticipantQrStub;
  ApiResponse<Map<String, dynamic>>? manualCheckInStub;
  ApiResponse<Map<String, dynamic>>? manualCheckOutStub;
  ApiResponse<Map<String, dynamic>>? getAttendanceLogsStub;

  TestOrganizerAttendanceDatasource({
    this.getEventQrStub,
    this.getParticipantQrStub,
    this.manualCheckInStub,
    this.manualCheckOutStub,
    this.getAttendanceLogsStub,
  }) : super(client: StubRestClient());

  @override
  Future<ApiResponse<AttendanceQrModel>> getEventQr(int eventId, String action) async {
    final envelope = getEventQrStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeAttendanceQrJson(),
        });
    return forwardEnvelopeResponse<AttendanceQrModel>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return AttendanceQrModel.fromJson(object);
      },
      fallbackError: 'Lấy QR event thất bại',
    );
  }

  @override
  Future<ApiResponse<AttendanceQrModel>> getParticipantQr(int eventParticipantId) async {
    final envelope = getParticipantQrStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeAttendanceQrJson(),
        });
    return forwardEnvelopeResponse<AttendanceQrModel>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return AttendanceQrModel.fromJson(object);
      },
      fallbackError: 'Lấy QR participant thất bại',
    );
  }

  @override
  Future<ApiResponse<EventAttendanceLogModel>> manualCheckIn(
    OrganizerManualAttendanceParams params,
  ) async {
    final envelope = manualCheckInStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeAttendanceLogJson(),
        });
    return forwardEnvelopeResponse<EventAttendanceLogModel>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return EventAttendanceLogModel.fromJson(object);
      },
      fallbackError: 'Check-in thủ công thất bại',
    );
  }

  @override
  Future<ApiResponse<EventAttendanceLogModel>> manualCheckOut(
    OrganizerManualAttendanceParams params,
  ) async {
    final envelope = manualCheckOutStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeAttendanceLogJson(),
        });
    return forwardEnvelopeResponse<EventAttendanceLogModel>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return EventAttendanceLogModel.fromJson(object);
      },
      fallbackError: 'Check-out thủ công thất bại',
    );
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> getAttendanceLogs({
    int? eventId,
    int page = 0,
    int size = 20,
  }) async {
    final envelope = getAttendanceLogsStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': [fakeAttendanceLogJson()],
            'totalElements': 1,
            'totalPages': 1,
            'page': 0,
            'size': 20,
          },
        });
    return forwardEnvelopeResponse<Map<String, dynamic>>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return object;
      },
      fallbackError: 'Lấy danh sách attendance thất bại',
    );
  }
}

void main() {
  group('getEventQr', () {
    test('success with CHECKIN action', () async {
      final datasource = TestOrganizerAttendanceDatasource(
        getEventQrStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeAttendanceQrJson(),
        }),
      );

      final result = await datasource.getEventQr(1, 'CHECKIN');

      result.when(
        success: (qr) {
          expect(qr.qrContent, equals('QR_CONTENT_ABC'));
          expect(qr.eventParticipantId, equals(42));
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

    test('success with CHECKOUT action', () async {
      final datasource = TestOrganizerAttendanceDatasource(
        getEventQrStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeAttendanceQrJson(),
        }),
      );

      final result = await datasource.getEventQr(1, 'CHECKOUT');

      result.when(
        success: (qr) {
          expect(qr.qrContent, equals('QR_CONTENT_ABC'));
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

    test('401', () async {
      final datasource = TestOrganizerAttendanceDatasource(
        getEventQrStub: const ApiResponse.unauthorized(
          ApiResponseError(code: '401', message: 'Unauthorized', errors: []),
        ),
      );

      final result = await datasource.getEventQr(1, 'CHECKIN');

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

    test('404', () async {
      final datasource = TestOrganizerAttendanceDatasource(
        getEventQrStub: const ApiResponse.notFound(
          ApiResponseError(code: '404', message: 'Not found', errors: []),
        ),
      );

      final result = await datasource.getEventQr(999, 'CHECKIN');

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
  });

  group('getParticipantQr', () {
    test('success', () async {
      final datasource = TestOrganizerAttendanceDatasource(
        getParticipantQrStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeAttendanceQrJson(),
        }),
      );

      final result = await datasource.getParticipantQr(1);

      result.when(
        success: (qr) {
          expect(qr.qrContent, equals('QR_CONTENT_ABC'));
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

    test('404', () async {
      final datasource = TestOrganizerAttendanceDatasource(
        getParticipantQrStub: const ApiResponse.notFound(
          ApiResponseError(code: '404', message: 'Not found', errors: []),
        ),
      );

      final result = await datasource.getParticipantQr(999);

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
  });

  group('manualCheckIn', () {
    test('success returns log', () async {
      final datasource = TestOrganizerAttendanceDatasource(
        manualCheckInStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeAttendanceLogJson(),
        }),
      );

      final params = OrganizerManualAttendanceParams(eventParticipantId: 1);
      final result = await datasource.manualCheckIn(params);

      result.when(
        success: (log) {
          expect(log.eventAttendanceLogId, equals(1));
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

    test('400 bad request', () async {
      final datasource = TestOrganizerAttendanceDatasource(
        manualCheckInStub: const ApiResponse.badRequest(
          ApiResponseError(code: '400', message: 'Bad request', errors: []),
        ),
      );

      final params = OrganizerManualAttendanceParams(eventParticipantId: 1);
      final result = await datasource.manualCheckIn(params);

      expect(
        result.when(
          success: (_) => false,
          badRequest: (_) => true,
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
  });

  group('manualCheckOut', () {
    test('success', () async {
      final datasource = TestOrganizerAttendanceDatasource(
        manualCheckOutStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeAttendanceLogJson(),
        }),
      );

      final params = OrganizerManualAttendanceParams(eventParticipantId: 1);
      final result = await datasource.manualCheckOut(params);

      result.when(
        success: (log) {
          expect(log.eventAttendanceLogId, equals(1));
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

    test('404', () async {
      final datasource = TestOrganizerAttendanceDatasource(
        manualCheckOutStub: const ApiResponse.notFound(
          ApiResponseError(code: '404', message: 'Not found', errors: []),
        ),
      );

      final params = OrganizerManualAttendanceParams(eventParticipantId: 999);
      final result = await datasource.manualCheckOut(params);

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
  });

  group('getAttendanceLogs', () {
    test('success returns paginated content', () async {
      final datasource = TestOrganizerAttendanceDatasource(
        getAttendanceLogsStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': [fakeAttendanceLogJson()],
            'totalElements': 1,
            'totalPages': 1,
            'page': 0,
            'size': 20,
          },
        }),
      );

      final result = await datasource.getAttendanceLogs();

      result.when(
        success: (data) {
          expect(data['content'], isA<List>());
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

    test('empty list', () async {
      final datasource = TestOrganizerAttendanceDatasource(
        getAttendanceLogsStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': <Map<String, dynamic>>[],
            'totalElements': 0,
            'totalPages': 0,
            'page': 0,
            'size': 20,
          },
        }),
      );

      final result = await datasource.getAttendanceLogs();

      result.when(
        success: (data) {
          expect(data['content'], isEmpty);
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
  });
}
