import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/feature/participant/data/model/participant_model.dart';
import 'package:events_app/feature/registration/data/datasource/registration_datasource.dart';
import 'package:events_app/feature/registration/domain/usecase/registration_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_data.dart';

class TestRegistrationDatasource extends RegistrationDatasourceImpl {
  ApiResponse<Map<String, dynamic>>? createStub;
  ApiResponse<Map<String, dynamic>>? getMyRegistrationsStub;
  ApiResponse<Map<String, dynamic>>? getRegistrationByIdStub;
  ApiResponse<Map<String, dynamic>>? cancelStub;
  Map<String, dynamic>? lastRequestBody;

  TestRegistrationDatasource({
    this.createStub,
    this.getMyRegistrationsStub,
    this.getRegistrationByIdStub,
    this.cancelStub,
  }) : super(client: null);

  @override
  Future<ApiResponse<ParticipantModel>> createRegistration(
      CreateRegistrationParams params) async {
    lastRequestBody = params.toJson();
    final envelope = createStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeParticipantJson(),
        });
    return forwardEnvelopeResponse<ParticipantModel>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return ParticipantModel.fromJson(object);
      },
      fallbackError: 'Đăng ký thất bại',
    );
  }

  @override
  Future<ApiResponse<List<ParticipantModel>>> getMyRegistrations(
    int userId, {
    int page = 0,
    int size = 20,
  }) async {
    final envelope = getMyRegistrationsStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': [fakeParticipantJson()],
            'totalElements': 1,
          },
        });
    return forwardEnvelopeResponse<List<ParticipantModel>>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        final content = object['content'] as List<dynamic>? ?? [];
        return content
            .map((e) => ParticipantModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
      fallbackError: 'Lấy danh sách đăng ký thất bại',
    );
  }

  @override
  Future<ApiResponse<ParticipantModel>> getRegistrationById(int id) async {
    final envelope = getRegistrationByIdStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeParticipantJson(id: id),
        });
    return forwardEnvelopeResponse<ParticipantModel>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return ParticipantModel.fromJson(object);
      },
      fallbackError: 'Lấy chi tiết đăng ký thất bại',
    );
  }

  @override
  Future<ApiResponse<void>> cancelRegistration(int id) async {
    final envelope = cancelStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': <String, dynamic>{},
        });
    return forwardEnvelopeResponse<void>(
      envelope,
      (_) => null,
      fallbackError: 'Hủy đăng ký thất bại',
    );
  }
}

void main() {
  group('createRegistration', () {
    test('trả về ParticipantModel khi thành công', () async {
      final datasource = TestRegistrationDatasource(
        createStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeParticipantJson(id: 100),
        }),
      );

      final result = await datasource.createRegistration(
        const CreateRegistrationParams(eventId: 1),
      );

      result.when(
        success: (participant) {
          expect(participant.eventParticipantId, equals(100));
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

    test('gửi đúng JSON body', () async {
      final datasource = TestRegistrationDatasource(
        createStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeParticipantJson(),
        }),
      );

      await datasource.createRegistration(
        const CreateRegistrationParams(eventId: 5),
      );

      expect(datasource.lastRequestBody, isNotNull);
      expect(datasource.lastRequestBody!['eventId'], equals(5));
    });

    test('trả về conflict khi đã đăng ký rồi', () async {
      final datasource = TestRegistrationDatasource(
        createStub: const ApiResponse.conflict(
          ApiResponseError(code: '409', message: 'Already registered', errors: null),
        ),
      );

      final result = await datasource.createRegistration(
        const CreateRegistrationParams(eventId: 1),
      );

      expect(
        result.when(
          success: (_) => false,
          conflict: (_) => true,
          badRequest: (_) => false,
          unauthorized: (_) => false,
          forbidden: (_) => false,
          notFound: (_) => false,
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

    test('trả về notFound khi sự kiện không tồn tại', () async {
      final datasource = TestRegistrationDatasource(
        createStub: const ApiResponse.notFound(
          ApiResponseError(code: '404', message: 'Event not found', errors: []),
        ),
      );

      final result = await datasource.createRegistration(
        const CreateRegistrationParams(eventId: 9999),
      );

      expect(
        result.when(
          success: (_) => false,
          notFound: (_) => true,
          badRequest: (_) => false,
          unauthorized: (_) => false,
          forbidden: (_) => false,
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

    test('trả về badRequest khi dữ liệu không hợp lệ', () async {
      final datasource = TestRegistrationDatasource(
        createStub: const ApiResponse.badRequest(
          ApiResponseError(code: '400', message: 'Bad request', errors: []),
        ),
      );

      final result = await datasource.createRegistration(
        const CreateRegistrationParams(eventId: 1),
      );

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

  group('getMyRegistrations', () {
    test('trả về list ParticipantModel khi thành công', () async {
      final datasource = TestRegistrationDatasource(
        getMyRegistrationsStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': [
              fakeParticipantJson(id: 1),
              fakeParticipantJson(id: 2),
            ],
            'totalElements': 2,
          },
        }),
      );

      final result = await datasource.getMyRegistrations(42);

      result.when(
        success: (registrations) {
          expect(registrations.length, equals(2));
          expect(registrations.first.eventParticipantId, equals(1));
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

    test('trả về list rỗng khi content rỗng', () async {
      final datasource = TestRegistrationDatasource(
        getMyRegistrationsStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {'content': [], 'totalElements': 0},
        }),
      );

      final result = await datasource.getMyRegistrations(42);

      result.when(
        success: (registrations) => expect(registrations, isEmpty),
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

  group('getRegistrationById', () {
    test('trả về ParticipantModel khi thành công', () async {
      final datasource = TestRegistrationDatasource(
        getRegistrationByIdStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeParticipantJson(id: 50),
        }),
      );

      final result = await datasource.getRegistrationById(50);

      result.when(
        success: (participant) {
          expect(participant.eventParticipantId, equals(50));
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

    test('trả về notFound khi đăng ký không tồn tại', () async {
      final datasource = TestRegistrationDatasource(
        getRegistrationByIdStub: const ApiResponse.notFound(
          ApiResponseError(code: '404', message: 'Not found', errors: []),
        ),
      );

      final result = await datasource.getRegistrationById(9999);

      expect(
        result.when(
          success: (_) => false,
          notFound: (_) => true,
          unauthorized: (_) => false,
          badRequest: (_) => false,
          forbidden: (_) => false,
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

  group('cancelRegistration', () {
    test('trả về void khi thành công', () async {
      final datasource = TestRegistrationDatasource(
        cancelStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': <String, dynamic>{},
        }),
      );

      final result = await datasource.cancelRegistration(50);

      result.when(
        success: (_) {},
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

    test('trả về notFound khi đăng ký không tồn tại', () async {
      final datasource = TestRegistrationDatasource(
        cancelStub: const ApiResponse.notFound(
          ApiResponseError(code: '404', message: 'Not found', errors: []),
        ),
      );

      final result = await datasource.cancelRegistration(9999);

      expect(
        result.when(
          success: (_) => false,
          notFound: (_) => true,
          unauthorized: (_) => false,
          badRequest: (_) => false,
          forbidden: (_) => false,
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

    test('trả về badRequest khi đăng ký đã bị hủy rồi', () async {
      final datasource = TestRegistrationDatasource(
        cancelStub: const ApiResponse.badRequest(
          ApiResponseError(code: '400', message: 'Already cancelled', errors: []),
        ),
      );

      final result = await datasource.cancelRegistration(50);

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
}
