import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/attendance/data/datasource/attendance_datasource.dart';
import 'package:events_app/feature/attendance/data/model/attendance_model.dart';
import 'package:events_app/feature/attendance/data/model/event_attendance_log_model.dart';
import 'package:events_app/feature/attendance/domain/usecase/scan_qr_params.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/organizer/attendance/data/datasource/organizer_attendance_datasource.dart';
import 'package:events_app/feature/organizer/attendance/domain/usecase/organizer_attendance_params.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_data.dart';

class TestAttendanceDatasourceSupplemental extends AttendanceDatasourceImpl {
  ApiResponse<Map<String, dynamic>>? getEventQrStub;

  TestAttendanceDatasourceSupplemental({this.getEventQrStub})
      : super(client: StubRestClient());

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
}

class TestOrganizerAttendanceDatasourceForManual extends OrganizerAttendanceDatasourceImpl {
  ApiResponse<Map<String, dynamic>>? checkInStub;
  ApiResponse<Map<String, dynamic>>? checkOutStub;
  ApiResponse<Map<String, dynamic>>? logsStub;

  TestOrganizerAttendanceDatasourceForManual({
    this.checkInStub,
    this.checkOutStub,
    this.logsStub,
  }) : super(client: StubRestClient());

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
      fallbackError: 'Check-in thủ công thất bại',
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
    final envelope = logsStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': [fakeAttendanceLogJson(id: 1)],
            'totalElements': 1,
          },
        });
    return envelope;
  }
}

void main() {
  // ─── getEventQr ──────────────────────────────────────────────────────────
  group('getEventQr', () {
    test('trả về AttendanceQrModel khi thành công', () async {
      final datasource = TestAttendanceDatasourceSupplemental(
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
          expect(qr.eventId, equals(1));
          expect(qr.scanMethod, equals(ScanMethod.eventQr));
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

    test('trả về unauthorized khi 401', () async {
      final datasource = TestAttendanceDatasourceSupplemental(
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

    test('trả về internalServerError khi 500', () async {
      final datasource = TestAttendanceDatasourceSupplemental(
        getEventQrStub: const ApiResponse.internalServerError(),
      );

      final result = await datasource.getEventQr(1, 'CHECKIN');

      expect(
        result.when(
          success: (_) => false,
          internalServerError: () => true,
          unauthorized: (_) => false,
          forbidden: (_) => false,
          notFound: (_) => false,
          badRequest: (_) => false,
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

    test('trả về notFound khi 404', () async {
      final datasource = TestAttendanceDatasourceSupplemental(
        getEventQrStub: const ApiResponse.notFound(
          ApiResponseError(code: '404', message: 'Not found', errors: []),
        ),
      );

      final result = await datasource.getEventQr(9999, 'CHECKIN');

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

    test('trả về responseParsing khi object null', () async {
      final datasource = TestAttendanceDatasourceSupplemental(
        getEventQrStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': null,
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

  // ─── manualCheckIn ───────────────────────────────────────────────────────
  group('manualCheckIn', () {
    const params = OrganizerManualAttendanceParams(eventParticipantId: 42);

    test('trả về EventAttendanceLogModel khi thành công', () async {
      final datasource = TestOrganizerAttendanceDatasourceForManual(
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
          expect(log.eventAttendanceLogId, equals(1));
          expect(log.eventParticipant?.eventParticipantId, equals(42));
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

    test('trả về badRequest khi bad request', () async {
      final datasource = TestOrganizerAttendanceDatasourceForManual(
        checkInStub: const ApiResponse.badRequest(
          ApiResponseError(code: '400', message: 'Bad request', errors: []),
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

    test('trả về forbidden khi 403', () async {
      final datasource = TestOrganizerAttendanceDatasourceForManual(
        checkInStub: const ApiResponse.forbidden(
          ApiResponseError(code: '403', message: 'Forbidden', errors: []),
        ),
      );

      final result = await datasource.manualCheckIn(params);

      expect(
        result.when(
          success: (_) => false,
          forbidden: (_) => true,
          unauthorized: (_) => false,
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

  // ─── manualCheckOut ───────────────────────────────────────────────────────
  group('manualCheckOut', () {
    const params = OrganizerManualAttendanceParams(eventParticipantId: 42);

    test('trả về EventAttendanceLogModel khi thành công', () async {
      final datasource = TestOrganizerAttendanceDatasourceForManual(
        checkOutStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeAttendanceLogJson(),
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

    test('trả về notFound khi 404', () async {
      final datasource = TestOrganizerAttendanceDatasourceForManual(
        checkOutStub: const ApiResponse.notFound(
          ApiResponseError(code: '404', message: 'Not found', errors: []),
        ),
      );

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

  // ─── getAttendanceLogs ────────────────────────────────────────────────────
  group('getAttendanceLogs', () {
    test('trả về paginated content khi thành công', () async {
      final datasource = TestOrganizerAttendanceDatasourceForManual(
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

      final result = await datasource.getAttendanceLogs(eventId: 1, page: 0, size: 20);

      result.when(
        success: (data) {
          final content = data['content'] as List<dynamic>;
          expect(content.length, equals(2));
          final totalElements = data['totalElements'] as int;
          expect(totalElements, equals(2));
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

    test('trả về empty content khi không có log', () async {
      final datasource = TestOrganizerAttendanceDatasourceForManual(
        logsStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': <dynamic>[],
            'totalElements': 0,
          },
        }),
      );

      final result = await datasource.getAttendanceLogs();

      result.when(
        success: (data) {
          final content = data['content'] as List<dynamic>;
          expect(content, isEmpty);
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
