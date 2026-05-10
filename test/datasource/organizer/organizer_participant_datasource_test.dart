import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/participant/data/model/participant_model.dart';
import 'package:events_app/feature/organizer/participant/data/datasource/organizer_participant_datasource.dart';
import 'package:events_app/feature/organizer/participant/domain/usecase/organizer_participant_params.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_data.dart';

class TestOrganizerParticipantDatasource
    extends OrganizerParticipantDatasourceImpl {
  ApiResponse<Map<String, dynamic>>? participantsStub;
  ApiResponse<Map<String, dynamic>>? byIdStub;
  ApiResponse<Map<String, dynamic>>? createStub;
  ApiResponse<Map<String, dynamic>>? deleteStub;

  TestOrganizerParticipantDatasource({
    this.participantsStub,
    this.byIdStub,
    this.createStub,
    this.deleteStub,
  }) : super(client: StubRestClient());

  @override
  Future<ApiResponse<List<ParticipantModel>>> getParticipants({
    int? eventId,
    String? participantType,
    int page = 0,
    int size = 20,
  }) async {
    final envelope = participantsStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': [fakeParticipantJson(), fakeParticipantJson(id: 2)],
            'totalElements': 2,
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
      fallbackError: 'Lấy danh sách participant thất bại',
    );
  }

  @override
  Future<ApiResponse<ParticipantModel>> getParticipantById(int id) async {
    final envelope = byIdStub ??
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
      fallbackError: 'Lấy chi tiết participant thất bại',
    );
  }

  @override
  Future<ApiResponse<ParticipantModel>> createParticipant(
      CreateOrganizerParticipantParams params) async {
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
      fallbackError: 'Tạo participant thất bại',
    );
  }

  @override
  Future<ApiResponse<void>> deleteParticipant(int id) async {
    final envelope = deleteStub ??
        const ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': null,
        });
    return forwardEnvelopeResponse<void>(
      envelope,
      (_) {},
      fallbackError: 'Xóa participant thất bại',
    );
  }
}

void main() {
  group('getParticipants', () {
    test('trả về list participant khi thành công', () async {
      final datasource = TestOrganizerParticipantDatasource(
        participantsStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': [fakeParticipantJson(id: 1), fakeParticipantJson(id: 2)],
            'totalElements': 2,
          },
        }),
      );

      final result = await datasource.getParticipants();

      result.when(
        success: (list) {
          expect(list.length, equals(2));
          expect(list.first.eventParticipantId, equals(1));
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

    test('filter theo eventId và participantType không gây lỗi', () async {
      final datasource = TestOrganizerParticipantDatasource(
        participantsStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': [fakeParticipantJson()],
            'totalElements': 1,
          },
        }),
      );

      final result = await datasource.getParticipants(
        eventId: 1,
        participantType: 'ATTENDEE',
        page: 0,
        size: 10,
      );

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

    test('trả về list rỗng khi không có participant', () async {
      final datasource = TestOrganizerParticipantDatasource(
        participantsStub: const ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {'content': [], 'totalElements': 0},
        }),
      );

      final result = await datasource.getParticipants(eventId: 1);

      result.when(
        success: (list) => expect(list, isEmpty),
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

    test('trả về unauthorized khi không có quyền', () async {
      final datasource = TestOrganizerParticipantDatasource(
        participantsStub: const ApiResponse.unauthorized(
          ApiResponseError(code: '401', message: 'Unauthorized', errors: []),
        ),
      );

      final result = await datasource.getParticipants();

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

  group('getParticipantById', () {
    test('trả về ParticipantModel khi thành công', () async {
      final datasource = TestOrganizerParticipantDatasource(
        byIdStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeParticipantJson(id: 5),
        }),
      );

      final result = await datasource.getParticipantById(5);

      result.when(
        success: (participant) {
          expect(participant.eventParticipantId, equals(5));
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
      final datasource = TestOrganizerParticipantDatasource(
        byIdStub: const ApiResponse.notFound(
          ApiResponseError(code: '404', message: 'Not found', errors: []),
        ),
      );

      final result = await datasource.getParticipantById(9999);

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

  group('createParticipant', () {
    const params = CreateOrganizerParticipantParams(
      eventId: 1,
      userId: 10,
      participantType: ParticipantType.attendee,
    );

    test('trả về ParticipantModel khi tạo thành công', () async {
      final datasource = TestOrganizerParticipantDatasource(
        createStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeParticipantJson(),
        }),
      );

      final result = await datasource.createParticipant(params);

      result.when(
        success: (participant) {
          expect(participant.eventParticipantId, equals(1));
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

    test('trả về badRequest khi user đã tham gia event', () async {
      final datasource = TestOrganizerParticipantDatasource(
        createStub: const ApiResponse.badRequest(
          ApiResponseError(code: '400', message: 'Already joined', errors: []),
        ),
      );

      final result = await datasource.createParticipant(params);

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

  group('deleteParticipant', () {
    test('trả về success khi xóa thành công', () async {
      final datasource = TestOrganizerParticipantDatasource(
        deleteStub: const ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': null,
        }),
      );

      final result = await datasource.deleteParticipant(42);

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

    test('trả về notFound khi participant không tồn tại', () async {
      final datasource = TestOrganizerParticipantDatasource(
        deleteStub: const ApiResponse.notFound(
          ApiResponseError(code: '404', message: 'Not found', errors: []),
        ),
      );

      final result = await datasource.deleteParticipant(9999);

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

    test('trả về forbidden khi không có quyền xóa', () async {
      final datasource = TestOrganizerParticipantDatasource(
        deleteStub: const ApiResponse.forbidden(
          ApiResponseError(code: '403', message: 'Forbidden', errors: []),
        ),
      );

      final result = await datasource.deleteParticipant(42);

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
}
