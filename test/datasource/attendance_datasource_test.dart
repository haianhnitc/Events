import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/attendance/data/datasource/attendance_datasource.dart';
import 'package:events_app/feature/attendance/data/model/attendance_model.dart';
import 'package:events_app/feature/attendance/domain/usecase/scan_qr_params.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_data.dart';

class TestAttendanceDatasource extends AttendanceDatasourceImpl {
  ApiResponse<Map<String, dynamic>>? getStub;
  ApiResponse<Map<String, dynamic>>? scanStub;
  ApiResponse<Map<String, dynamic>>? selfCheckinStub;

  TestAttendanceDatasource({this.getStub, this.scanStub, this.selfCheckinStub})
      : super(client: StubRestClient());

  @override
  Future<ApiResponse<AttendanceQrModel>> getParticipantQr(int eventParticipantId) async {
    final envelope = getStub ??
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
      fallbackError: 'Lấy QR thất bại',
    );
  }

  @override
  Future<ApiResponse<AttendanceScanResultModel>> scanQr(ScanQrParams params) async {
    final envelope = scanStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeScanResultJson(action: 'CHECKIN'),
        });
    return forwardEnvelopeResponse<AttendanceScanResultModel>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return AttendanceScanResultModel.fromJson(object);
      },
      fallbackError: 'Quét QR thất bại',
    );
  }

  @override
  Future<ApiResponse<AttendanceQrModel>> getEventQr(int eventId, String action) async {
    return getParticipantQr(eventId);
  }

  @override
  Future<ApiResponse<AttendanceScanResultModel>> selfCheckin(ScanQrParams params) async {
    final envelope = selfCheckinStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeScanResultJson(action: 'CHECKIN'),
        });
    return forwardEnvelopeResponse<AttendanceScanResultModel>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return AttendanceScanResultModel.fromJson(object);
      },
      fallbackError: 'Self check-in thất bại',
    );
  }

}

void main() {
  // ─── getParticipantQr ───────────────────────────────────────────────────
  group('getParticipantQr', () {
    test('trả về qr model khi thành công', () async {
      final datasource = TestAttendanceDatasource(
        getStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeAttendanceQrJson(),
        }),
      );

      final result = await datasource.getParticipantQr(42);

      result.when(
        success: (qr) {
          expect(qr.qrContent, equals('QR_CONTENT_ABC'));
          expect(qr.eventParticipantId, equals(42));
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

    test('trả về notFound khi participant không tồn tại', () async {
      final datasource = TestAttendanceDatasource(
        getStub: const ApiResponse.notFound(
          ApiResponseError(code: '404', message: 'Not found', errors: []),
        ),
      );

      final result = await datasource.getParticipantQr(9999);

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
      final datasource = TestAttendanceDatasource(
        getStub: const ApiResponse.unauthorized(
          ApiResponseError(code: '401', message: 'Unauthorized', errors: []),
        ),
      );

      final result = await datasource.getParticipantQr(42);

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

    test('trả về responseParsing khi object không phải Map', () async {
      final datasource = TestAttendanceDatasource(
        getStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': 123,
        }),
      );

      final result = await datasource.getParticipantQr(42);

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

    test('trả về serviceUnavailable khi không có mạng', () async {
      final datasource = TestAttendanceDatasource(
        getStub: const ApiResponse.serviceUnavailable(),
      );

      final result = await datasource.getParticipantQr(42);

      expect(
        result.when(
          success: (_) => false,
          serviceUnavailable: () => true,
          badRequest: (_) => false,
          unauthorized: (_) => false,
          forbidden: (_) => false,
          notFound: (_) => false,
          conflict: (_) => false,
          internalServerError: () => false,
          badGateway: () => false,
          gatewayTimeout: () => false,
          canceled: () => false,
          responseParsing: () => false,
          unexpected: (_) => false,
        ),
        isTrue,
      );
    });
  });

  // ─── scanQr ──────────────────────────────────────────────────────────────
  group('scanQr', () {
    test('trả về scan result khi check-in thành công', () async {
      final datasource = TestAttendanceDatasource(
        scanStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeScanResultJson(action: 'CHECKIN'),
        }),
      );

      final params = ScanQrParams(
        qrContent: 'QR_CONTENT_ABC',
        eventParticipantId: 42,
      );

      final result = await datasource.scanQr(params);

      result.when(
        success: (scanResult) {
          expect(scanResult.action, equals(AttendanceAction.checkIn));
          expect(scanResult.message, equals('Check-in successful'));
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

    test('trả về scan result khi check-out thành công', () async {
      final datasource = TestAttendanceDatasource(
        scanStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeScanResultJson(action: 'CHECKOUT'),
        }),
      );

      final params = ScanQrParams(
        qrContent: 'QR_CONTENT_ABC',
        eventParticipantId: 42,
      );

      final result = await datasource.scanQr(params);

      result.when(
        success: (scanResult) {
          expect(scanResult.action, equals(AttendanceAction.checkOut));
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

    test('trả về badRequest khi QR không hợp lệ', () async {
      final datasource = TestAttendanceDatasource(
        scanStub: const ApiResponse.badRequest(
          ApiResponseError(code: '400', message: 'Bad request', errors: []),
        ),
      );

      final params = ScanQrParams(
        qrContent: 'INVALID_QR',
        eventParticipantId: 42,
      );

      final result = await datasource.scanQr(params);

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

    test('trả về unauthorized khi chưa đăng nhập', () async {
      final datasource = TestAttendanceDatasource(
        scanStub: const ApiResponse.unauthorized(
          ApiResponseError(code: '401', message: 'Unauthorized', errors: []),
        ),
      );

      final params = ScanQrParams(
        qrContent: 'QR_CONTENT_ABC',
        eventParticipantId: 42,
      );

      final result = await datasource.scanQr(params);

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

    test('trả về notFound khi event không tồn tại', () async {
      final datasource = TestAttendanceDatasource(
        scanStub: const ApiResponse.notFound(
          ApiResponseError(code: '404', message: 'Not found', errors: []),
        ),
      );

      final params = ScanQrParams(
        qrContent: 'QR_CONTENT_ABC',
        eventParticipantId: 42,
      );

      final result = await datasource.scanQr(params);

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

    test('trả về responseParsing khi object không phải Map', () async {
      final datasource = TestAttendanceDatasource(
        scanStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': 123,
        }),
      );

      final params = ScanQrParams(
        qrContent: 'QR_CONTENT_ABC',
        eventParticipantId: 42,
      );

      final result = await datasource.scanQr(params);

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

    test('trả về serviceUnavailable khi không có mạng', () async {
      final datasource = TestAttendanceDatasource(
        scanStub: const ApiResponse.serviceUnavailable(),
      );

      final params = ScanQrParams(
        qrContent: 'QR_CONTENT_ABC',
        eventParticipantId: 42,
      );

      final result = await datasource.scanQr(params);

      expect(
        result.when(
          success: (_) => false,
          serviceUnavailable: () => true,
          badRequest: (_) => false,
          unauthorized: (_) => false,
          forbidden: (_) => false,
          notFound: (_) => false,
          conflict: (_) => false,
          internalServerError: () => false,
          badGateway: () => false,
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
