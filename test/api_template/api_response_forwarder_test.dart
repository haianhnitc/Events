import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/base_response/api_envelope.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/api_response_matchers.dart';

// ─── Simple test model ────────────────────────────────────────────────────────
class _TestModel {
  final int id;
  final String name;

  const _TestModel({required this.id, required this.name});

  factory _TestModel.fromJson(Map<String, dynamic> json) {
    return _TestModel(id: json['id'] as int, name: json['name'] as String);
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────
ApiResponse<Map<String, dynamic>> _successWith(Object? object) {
  return ApiResponse.success({
    'errorCode': 0,
    'statusCode': 200,
    'message': 'OK',
    'object': object,
  });
}

ApiResponse<Map<String, dynamic>> _backendError({
  int errorCode = -1,
  String message = 'Error',
}) {
  return ApiResponse.success({
    'errorCode': errorCode,
    'statusCode': 400,
    'message': message,
    'object': null,
  });
}

_TestModel _parseModel(Object? object) {
  if (object is! Map<String, dynamic>) {
    throw const FormatException('Not a map');
  }
  return _TestModel.fromJson(object);
}

void main() {
  // ─── forwardEnvelopeResponse ────────────────────────────────────────────────
  group('forwardEnvelopeResponse', () {
    test('trả về success(model) khi errorCode=0 và object hợp lệ', () {
      final response = _successWith({'id': 1, 'name': 'Test'});

      final result = forwardEnvelopeResponse<_TestModel>(
        response,
        _parseModel,
        fallbackError: 'failed',
      );

      result.when(
        success: (model) {
          expect(model.id, equals(1));
          expect(model.name, equals('Test'));
        },
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
        unexpected: (_) => fail('Expected success'),
      );
    });

    test('trả về unexpected khi errorCode != 0 và object có thể parse (null-safe parser)', () {
      // Dùng null-tolerant parser để tránh FormatException che khuất lỗi backend
      final response = ApiResponse<Map<String, dynamic>>.success({
        'errorCode': -1,
        'statusCode': 400,
        'message': 'Something went wrong',
        'object': {'id': 0, 'name': ''},  // object hợp lệ nhưng errorCode != 0
      });

      final result = forwardEnvelopeResponse<_TestModel>(
        response,
        _parseModel,
        fallbackError: 'fallback error',
      );

      result.when(
        unexpected: (error) {
          expect(error.code, equals('-1'));
          expect(error.message, equals('Something went wrong'));
        },
        success: (_) => fail('Expected unexpected'),
        badRequest: (_) => fail('Expected unexpected'),
        unauthorized: (_) => fail('Expected unexpected'),
        forbidden: (_) => fail('Expected unexpected'),
        notFound: (_) => fail('Expected unexpected'),
        conflict: (_) => fail('Expected unexpected'),
        internalServerError: () => fail('Expected unexpected'),
        badGateway: () => fail('Expected unexpected'),
        serviceUnavailable: () => fail('Expected unexpected'),
        gatewayTimeout: () => fail('Expected unexpected'),
        canceled: () => fail('Expected unexpected'),
        responseParsing: () => fail('Expected unexpected — parser should not fail when errorCode != 0'),
      );
    });

    test('trả về responseParsing khi errorCode != 0 và object null gây FormatException', () {
      // Đây là behavior thực: object=null, parser throw FormatException → responseParsing
      final response = _backendError(errorCode: -1, message: 'Backend error');

      final result = forwardEnvelopeResponse<_TestModel>(
        response,
        _parseModel,  // throws FormatException khi object=null
        fallbackError: 'fallback',
      );

      expect(isResponseParsing(result), isTrue);
    });

    test('trả về responseParsing khi object không parse được (FormatException)', () {
      final response = _successWith('not-a-map');

      final result = forwardEnvelopeResponse<_TestModel>(
        response,
        _parseModel,
        fallbackError: 'failed',
      );

      expect(isResponseParsing(result), isTrue);
    });

    test('forward lỗi HTTP 401 → unauthorized', () {
      final response = ApiResponse<Map<String, dynamic>>.unauthorized(
        ApiResponseError(code: '401', message: 'Unauthorized', errors: []),
      );

      final result = forwardEnvelopeResponse<_TestModel>(
        response,
        _parseModel,
        fallbackError: 'failed',
      );

      expect(isUnauthorized(result), isTrue);
    });

    test('forward lỗi HTTP 403 → forbidden', () {
      final response = ApiResponse<Map<String, dynamic>>.forbidden(
        ApiResponseError(code: '403', message: 'Forbidden', errors: []),
      );

      final result = forwardEnvelopeResponse<_TestModel>(
        response,
        _parseModel,
        fallbackError: 'failed',
      );

      expect(isForbidden(result), isTrue);
    });

    test('forward lỗi HTTP 404 → notFound', () {
      final response = ApiResponse<Map<String, dynamic>>.notFound(
        ApiResponseError(code: '404', message: 'Not found', errors: []),
      );

      final result = forwardEnvelopeResponse<_TestModel>(
        response,
        _parseModel,
        fallbackError: 'failed',
      );

      expect(isNotFound(result), isTrue);
    });

    test('forward lỗi HTTP 500 → internalServerError', () {
      final response = ApiResponse<Map<String, dynamic>>.internalServerError();

      final result = forwardEnvelopeResponse<_TestModel>(
        response,
        _parseModel,
        fallbackError: 'failed',
      );

      expect(isInternalServerError(result), isTrue);
    });

    test('forward lỗi badGateway → badGateway', () {
      final response = ApiResponse<Map<String, dynamic>>.badGateway();

      final result = forwardEnvelopeResponse<_TestModel>(
        response,
        _parseModel,
        fallbackError: 'failed',
      );

      expect(isBadGateway(result), isTrue);
    });

    test('forward canceled → canceled', () {
      final response = ApiResponse<Map<String, dynamic>>.canceled();

      final result = forwardEnvelopeResponse<_TestModel>(
        response,
        _parseModel,
        fallbackError: 'failed',
      );

      expect(isCanceled(result), isTrue);
    });

    test('trả về unexpected với fallbackError khi errorCode != 0 và message null (với object parse được)', () {
      // Khi message null, fallbackError được dùng
      final response = ApiResponse<Map<String, dynamic>>.success({
        'errorCode': -1,
        'statusCode': 400,
        'message': null,
        'object': {'id': 1, 'name': 'dummy'},  // object hợp lệ để tránh FormatException
      });

      final result = forwardEnvelopeResponse<_TestModel>(
        response,
        _parseModel,
        fallbackError: 'Custom fallback error',
      );

      result.when(
        unexpected: (error) => expect(error.message, equals('Custom fallback error')),
        success: (_) => fail('Expected unexpected'),
        badRequest: (_) => fail('Expected unexpected'),
        unauthorized: (_) => fail('Expected unexpected'),
        forbidden: (_) => fail('Expected unexpected'),
        notFound: (_) => fail('Expected unexpected'),
        conflict: (_) => fail('Expected unexpected'),
        internalServerError: () => fail('Expected unexpected'),
        badGateway: () => fail('Expected unexpected'),
        serviceUnavailable: () => fail('Expected unexpected'),
        gatewayTimeout: () => fail('Expected unexpected'),
        canceled: () => fail('Expected unexpected'),
        responseParsing: () => fail('Expected unexpected'),
      );
    });
  });

  // ─── ApiEnvelope ─────────────────────────────────────────────────────────────
  group('ApiEnvelope', () {
    test('isSuccess = true khi errorCode = 0', () {
      final envelope = ApiEnvelope<String>(
        errorCode: 0,
        statusCode: 200,
        message: 'OK',
        object: 'data',
      );

      expect(envelope.isSuccess, isTrue);
    });

    test('isSuccess = false khi errorCode != 0', () {
      final envelope = ApiEnvelope<String>(
        errorCode: -1,
        statusCode: 400,
        message: 'Error',
        object: null,
      );

      expect(envelope.isSuccess, isFalse);
    });

    test('isSuccess = false khi errorCode = null', () {
      final envelope = ApiEnvelope<String>(
        errorCode: null,
        statusCode: 200,
        message: 'OK',
        object: null,
      );

      expect(envelope.isSuccess, isFalse);
    });

    test('fromJson parse đúng tất cả fields', () {
      final json = {
        'errorCode': 0,
        'statusCode': 200,
        'message': 'Success',
        'object': {'id': 42, 'name': 'Model'},
      };

      final envelope = ApiEnvelope<_TestModel>.fromJson(json, (obj) {
        return _TestModel.fromJson(obj as Map<String, dynamic>);
      });

      expect(envelope.errorCode, equals(0));
      expect(envelope.statusCode, equals(200));
      expect(envelope.message, equals('Success'));
      expect(envelope.object, isNotNull);
      expect(envelope.object!.id, equals(42));
    });
  });

  // ─── toEither extension ───────────────────────────────────────────────────────
  group('ApiResponse.toEither()', () {
    test('success → Right(model)', () {
      final response = ApiResponse<int>.success(42);

      final result = response.toEither();

      expect(result, equals(const Right<FailureEntity, int>(42)));
    });

    test('unauthorized → Left(serverFailure(401))', () {
      final response = ApiResponse<Map<String, dynamic>>.unauthorized(
        ApiResponseError(code: '401', message: 'Unauthorized', errors: []),
      );

      final result = response.toEither();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => failure.when(
          serverFailure: (code, message) {
            expect(code, equals('401'));
            expect(message, equals('Unauthorized'));
          },
          dataParsingFailure: () => fail('Expected serverFailure'),
          noConnectionFailure: () => fail('Expected serverFailure'),
          systemFailure: (_, __) => fail('Expected serverFailure'),
        ),
        (r) => fail('Expected Left'),
      );
    });

    test('forbidden → Left(serverFailure(403))', () {
      final response = ApiResponse<Map<String, dynamic>>.forbidden(
        ApiResponseError(code: '403', message: 'Forbidden', errors: []),
      );

      final result = response.toEither();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => failure.when(
          serverFailure: (code, _) => expect(code, equals('403')),
          dataParsingFailure: () => fail('Expected serverFailure'),
          noConnectionFailure: () => fail('Expected serverFailure'),
          systemFailure: (_, __) => fail('Expected serverFailure'),
        ),
        (r) => fail('Expected Left'),
      );
    });

    test('internalServerError → Left(serverFailure(500))', () {
      final response = ApiResponse<Map<String, dynamic>>.internalServerError();

      final result = response.toEither();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => failure.when(
          serverFailure: (code, _) => expect(code, equals('500')),
          dataParsingFailure: () => fail('Expected serverFailure'),
          noConnectionFailure: () => fail('Expected serverFailure'),
          systemFailure: (_, __) => fail('Expected serverFailure'),
        ),
        (r) => fail('Expected Left'),
      );
    });

    test('badGateway → Left(serverFailure(502))', () {
      final response = ApiResponse<Map<String, dynamic>>.badGateway();
      final result = response.toEither();
      expect(result.isLeft(), isTrue);
    });

    test('serviceUnavailable → Left(serverFailure(503))', () {
      final response = ApiResponse<Map<String, dynamic>>.serviceUnavailable();
      final result = response.toEither();
      expect(result.isLeft(), isTrue);
    });

    test('gatewayTimeout → Left(serverFailure(504))', () {
      final response = ApiResponse<Map<String, dynamic>>.gatewayTimeout();
      final result = response.toEither();
      expect(result.isLeft(), isTrue);
    });

    test('canceled → Left(serverFailure(CANCEL))', () {
      final response = ApiResponse<Map<String, dynamic>>.canceled();

      final result = response.toEither();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => failure.when(
          serverFailure: (code, _) => expect(code, equals('CANCEL')),
          dataParsingFailure: () => fail('Expected serverFailure'),
          noConnectionFailure: () => fail('Expected serverFailure'),
          systemFailure: (_, __) => fail('Expected serverFailure'),
        ),
        (r) => fail('Expected Left'),
      );
    });

    test('responseParsing → Left(dataParsingFailure)', () {
      final response = ApiResponse<Map<String, dynamic>>.responseParsing();

      final result = response.toEither();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => failure.when(
          serverFailure: (_, __) => fail('Expected dataParsingFailure'),
          dataParsingFailure: () => expect(true, isTrue),
          noConnectionFailure: () => fail('Expected dataParsingFailure'),
          systemFailure: (_, __) => fail('Expected dataParsingFailure'),
        ),
        (r) => fail('Expected Left'),
      );
    });

    test('unexpected → Left(serverFailure với code và message)', () {
      final response = ApiResponse<Map<String, dynamic>>.unexpected(
        ApiResponseError(code: 'CUSTOM_CODE', message: 'Custom error', errors: null),
      );

      final result = response.toEither();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => failure.when(
          serverFailure: (code, message) {
            expect(code, equals('CUSTOM_CODE'));
            expect(message, equals('Custom error'));
          },
          dataParsingFailure: () => fail('Expected serverFailure'),
          noConnectionFailure: () => fail('Expected serverFailure'),
          systemFailure: (_, __) => fail('Expected serverFailure'),
        ),
        (r) => fail('Expected Left'),
      );
    });

    test('notFound → Left(serverFailure(404))', () {
      final response = ApiResponse<Map<String, dynamic>>.notFound(
        ApiResponseError(code: '404', message: 'Not found', errors: []),
      );

      final result = response.toEither();

      expect(result.isLeft(), isTrue);
    });
  });

  // ─── toEitherUnit extension ────────────────────────────────────────────────
  group('ApiResponse.toEitherUnit()', () {
    test('success → Right(unit) bất kể payload là gì', () {
      final response = ApiResponse<Map<String, dynamic>>.success({'ignored': true});

      final result = response.toEitherUnit();

      expect(result, equals(const Right<FailureEntity, Unit>(unit)));
    });

    test('internalServerError → Left(serverFailure(500))', () {
      final response = ApiResponse<Map<String, dynamic>>.internalServerError();

      final result = response.toEitherUnit();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => failure.when(
          serverFailure: (code, _) => expect(code, equals('500')),
          dataParsingFailure: () => fail('Expected serverFailure'),
          noConnectionFailure: () => fail('Expected serverFailure'),
          systemFailure: (_, __) => fail('Expected serverFailure'),
        ),
        (r) => fail('Expected Left'),
      );
    });

    test('unauthorized → Left', () {
      final response = ApiResponse<Map<String, dynamic>>.unauthorized(
        ApiResponseError(code: '401', message: 'Unauth', errors: []),
      );
      final result = response.toEitherUnit();
      expect(result.isLeft(), isTrue);
    });
  });

  // ─── forwardOnSuccess ────────────────────────────────────────────────────────
  group('forwardOnSuccess', () {
    test('gọi onSuccess khi response là success', () async {
      final response = ApiResponse<int>.success(10);

      final result = await forwardOnSuccess<int, String>(
        response,
        (value) async => ApiResponse.success('value-is-$value'),
      );

      result.when(
        success: (str) => expect(str, equals('value-is-10')),
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
        unexpected: (_) => fail('Expected success'),
      );
    });

    test('không gọi onSuccess khi response là failure — forward nguyên lỗi', () async {
      bool onSuccessCalled = false;
      final response = ApiResponse<int>.unauthorized(
        ApiResponseError(code: '401', message: 'Auth error', errors: []),
      );

      final result = await forwardOnSuccess<int, String>(
        response,
        (value) async {
          onSuccessCalled = true;
          return ApiResponse<String>.success('ok');
        },
      );

      expect(onSuccessCalled, isFalse);
      expect(isUnauthorized(result), isTrue);
    });

    test('forward lỗi internalServerError qua onSuccess', () async {
      final response = ApiResponse<int>.internalServerError();

      final result = await forwardOnSuccess<int, String>(
        response,
        (value) async => ApiResponse<String>.success('ok'),
      );

      expect(isInternalServerError(result), isTrue);
    });
  });
}
