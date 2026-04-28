import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/attendance/data/model/attendance_model.dart';
import 'package:events_app/feature/attendance/data/model/event_attendance_log_model.dart';
import 'package:events_app/feature/attendance/domain/usecase/scan_qr_params.dart';
import 'package:events_app/feature/organizer/attendance/data/datasource/organizer_attendance_datasource.dart';
import 'package:events_app/feature/organizer/attendance/domain/usecase/organizer_attendance_params.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_data.dart';

class TestOrganizerAttendanceDatasource extends OrganizerAttendanceDatasourceImpl {
  ApiResponse<Map<String, dynamic>>? eventQrStub;
  ApiResponse<Map<String, dynamic>>? participantQrStub;
  ApiResponse<Map<String, dynamic>>? checkInStub;
  ApiResponse<Map<String, dynamic>>? checkOutStub;
  ApiResponse<Map<String, dynamic>>? logsStub;

  TestOrganizerAttendanceDatasource({
    this.eventQrStub,
    this.participantQrStub,
    this.checkInStub,
    this.checkOutStub,
    this.logsStub,
  }) : super(client: StubRestClient());

  @override
  Future<ApiResponse<AttendanceQrModel>> getEventQr(int eventId, String action) async {
    final envelope = eventQrStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {...fakeAttendanceQrJson(), 'scanMethod': 'EVENT_QR'},
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
    final envelope = participantQrStub ??
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
      OrganizerManualAttendanceParams params) async {
    final envelope = checkInStub ??
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
      fallbackError: 'Check-in thất bại',
    );
  }

  @override
  Future<ApiResponse<EventAttendanceLogModel>> manualCheckOut(
      OrganizerManualAttendanceParams params) async {
    final envelope = checkOutStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {...fakeAttendanceLogJson(), 'type': 'CHECKOUT'},
        });
    return forwardEnvelopeResponse<EventAttendanceLogModel>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return EventAttendanceLogModel.fromJson(object);
      },
      fallbackError: 'Check-out thất bại',
    );
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> getAttendanceLogs({
    int? eventId,
    int page = 0,
    int size = 20,
  }) async {
    final envelope = logsStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': [fakeAttendanceLogJson(id: 1), fakeAttendanceLogJson(id: 2)],
            'totalElements': 2,
          },
        });
    return envelope;
  }
}

void main() {
  group('getEventQr', () {
    test('trả về AttendanceQrModel cho event khi thành công', () async {
      final datasource = TestOrganizerAttendanceDatasource(
        eventQrStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {...fakeAttendanceQrJson(), 'scanMethod': 'EVENT_QR'},
        }),
      );

      final result = await datasource.getEventQr(1, 'CHECKIN');

      result.when(
        success: (qr) {
          expect(qr.qrContent, equals('QR_CONTENT_ABC'));
          expect(qr.eventId, equals(1));
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

    test('trả về forbidden khi không phải organizer của event', () async {
      final datasource = TestOrganizerAttendanceDatasource(
        eventQrStub: const ApiResponse.forbidden(
          ApiResponseError(code: '403', message: 'Forbidden', errors: []),
        ),
      );

      final result = await datasource.getEventQr(1, 'CHECKIN');

      expect(
        result.when(
          success: (_) => false,
          forbidden: (_) => true,
          unauthorized: (_) => false,
          notFound: (_) => false,
          conflict: (_) => false,
          badRequest: (_) => false,
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

    test('trả về unauthorized khi không có token', () async {
      final datasource = TestOrganizerAttendanceDatasource(
        eventQrStub: const ApiResponse.unauthorized(
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
          conflict: (_) => false,
          badRequest: (_) => false,
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

    test('trả về responseParsing khi object không phải Map', () async {
      final datasource = TestOrganizerAttendanceDatasource(
        eventQrStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': 'invalid',
        }),
      );

      final result = await datasource.getEventQr(1, 'CHECKIN');

      expect(
        result.when(
          success: (_) => false,
          responseParsing: () => true,
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
          unexpected: (_) => false,
        ),
        isTrue,
      );
    });
  });

  group('getParticipantQr', () {
    test('trả về AttendanceQrModel cho participant khi thành công', () async {
      final datasource = TestOrganizerAttendanceDatasource(
        participantQrStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeAttendanceQrJson(),
        }),
      );

      final result = await datasource.getParticipantQr(42);

      result.when(
        success: (qr) => expect(qr.eventParticipantId, equals(42)),
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

    test('trả về notFound khi participant không tồn tại', () async {
      final datasource = TestOrganizerAttendanceDatasource(
        participantQrStub: const ApiResponse.notFound(
          ApiResponseError(code: '404', message: 'Not found', errors: []),
        ),
      );

      final result = await datasource.getParticipantQr(9999);

      expect(
        result.when(
          success: (_) => false,
          notFound: (_) => true,
          conflict: (_) => false,
          unauthorized: (_) => false,
          forbidden: (_) => false,
          badRequest: (_) => false,
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
    const params = OrganizerManualAttendanceParams(
      eventParticipantId: 42,
    );

    test('trả về EventAttendanceLogModel khi check-in thành công', () async {
      final datasource = TestOrganizerAttendanceDatasource(
        checkInStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeAttendanceLogJson(),
        }),
      );

      final result = await datasource.manualCheckIn(params);

      result.when(
        success: (log) {
          expect(log.eventParticipant?.eventParticipantId, equals(42));
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

    test('trả về badRequest khi participant đã check-in rồi', () async {
      final datasource = TestOrganizerAttendanceDatasource(
        checkInStub: const ApiResponse.badRequest(
          ApiResponseError(code: '400', message: 'Already checked in', errors: []),
        ),
      );

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

    test('trả về unauthorized khi không có quyền', () async {
      final datasource = TestOrganizerAttendanceDatasource(
        checkInStub: const ApiResponse.unauthorized(
          ApiResponseError(code: '401', message: 'Unauthorized', errors: []),
        ),
      );

      final result = await datasource.manualCheckIn(params);

      expect(
        result.when(
          success: (_) => false,
          unauthorized: (_) => true,
          forbidden: (_) => false,
          notFound: (_) => false,
          conflict: (_) => false,
          badRequest: (_) => false,
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

    test('trả về responseParsing khi object không phải Map', () async {
      final datasource = TestOrganizerAttendanceDatasource(
        checkInStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': 'invalid',
        }),
      );

      final result = await datasource.manualCheckIn(params);

      expect(
        result.when(
          success: (_) => false,
          responseParsing: () => true,
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
          unexpected: (_) => false,
        ),
        isTrue,
      );
    });
  });

  group('manualCheckOut', () {
    const params = OrganizerManualAttendanceParams(
      eventParticipantId: 42,
    );

    test('trả về EventAttendanceLogModel khi check-out thành công', () async {
      final datasource = TestOrganizerAttendanceDatasource(
        checkOutStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {...fakeAttendanceLogJson(), 'type': 'CHECKOUT'},
        }),
      );

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

    test('trả về badRequest khi participant chưa check-in', () async {
      final datasource = TestOrganizerAttendanceDatasource(
        checkOutStub: const ApiResponse.badRequest(
          ApiResponseError(code: '400', message: 'Not checked in', errors: []),
        ),
      );

      final result = await datasource.manualCheckOut(params);

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

  group('getAttendanceLogs', () {
    test('trả về list log khi thành công', () async {
      final datasource = TestOrganizerAttendanceDatasource(
        logsStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': [fakeAttendanceLogJson(id: 1), fakeAttendanceLogJson(id: 2)],
            'totalElements': 2,
          },
        }),
      );

      final result = await datasource.getAttendanceLogs(eventId: 1);

      result.when(
        success: (data) {
          final content = data['content'] as List<dynamic>? ?? [];
          expect(content.length, equals(2));
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

    test('trả về list rỗng khi không có log', () async {
      final datasource = TestOrganizerAttendanceDatasource(
        logsStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {'content': [], 'totalElements': 0},
        }),
      );

      final result = await datasource.getAttendanceLogs();

      result.when(
        success: (logs) => expect(logs, isEmpty),
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

    test('trả về unauthorized khi không có token', () async {
      final datasource = TestOrganizerAttendanceDatasource(
        logsStub: const ApiResponse.unauthorized(
          ApiResponseError(code: '401', message: 'Unauthorized', errors: []),
        ),
      );

      final result = await datasource.getAttendanceLogs();

      expect(
        result.when(
          success: (_) => false,
          unauthorized: (_) => true,
          forbidden: (_) => false,
          notFound: (_) => false,
          conflict: (_) => false,
          badRequest: (_) => false,
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

    test('trả về responseParsing khi object không phải Map', () async {
      final datasource = TestOrganizerAttendanceDatasource(
        logsStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': 'invalid',
        }),
      );

      final result = await datasource.getAttendanceLogs();

      expect(
        result.when(
          success: (_) => false,
          responseParsing: () => true,
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
          unexpected: (_) => false,
        ),
        isTrue,
      );
    });
  });
}
