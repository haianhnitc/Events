import 'package:flutter_test/flutter_test.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/organizer/recruitment/data/datasource/organizer_recruitment_datasource.dart';
import 'package:events_app/feature/organizer/recruitment/domain/usecase/organizer_recruitment_params.dart';
import 'package:events_app/feature/recruitment/data/model/ctv_recruitment_model.dart';

import '../../helpers/fake_data.dart';

class TestOrganizerRecruitmentDatasource extends OrganizerRecruitmentDatasourceImpl {
  ApiResponse<Map<String, dynamic>>? getRecruitmentsStub;
  ApiResponse<Map<String, dynamic>>? getByIdStub;
  ApiResponse<Map<String, dynamic>>? createStub;
  ApiResponse<Map<String, dynamic>>? updateStub;
  ApiResponse<Map<String, dynamic>>? closeStub;
  ApiResponse<Map<String, dynamic>>? deleteStub;

  TestOrganizerRecruitmentDatasource({
    this.getRecruitmentsStub,
    this.getByIdStub,
    this.createStub,
    this.updateStub,
    this.closeStub,
    this.deleteStub,
  }) : super(client: StubRestClient());

  @override
  Future<ApiResponse<List<CtvRecruitmentModel>>> getRecruitments({
    int? eventId,
    String? keyword,
    int page = 0,
    int size = 20,
  }) async {
    final envelope = getRecruitmentsStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': [fakeCtvRecruitmentJson()],
            'totalElements': 1,
            'totalPages': 1,
            'page': 0,
            'size': 20,
          },
        });
    return forwardEnvelopeResponse<List<CtvRecruitmentModel>>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        final content = object['content'] as List<dynamic>? ?? [];
        return content
            .map((e) => CtvRecruitmentModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
      fallbackError: 'Lấy danh sách tuyển CTV thất bại',
    );
  }

  @override
  Future<ApiResponse<CtvRecruitmentModel>> getRecruitmentById(int id) async {
    final envelope = getByIdStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeCtvRecruitmentJson(id: id),
        });
    return forwardEnvelopeResponse<CtvRecruitmentModel>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return CtvRecruitmentModel.fromJson(object);
      },
      fallbackError: 'Lấy chi tiết tuyển CTV thất bại',
    );
  }

  @override
  Future<ApiResponse<CtvRecruitmentModel>> createRecruitment(
      CreateRecruitmentParams params) async {
    final envelope = createStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeCtvRecruitmentJson(),
        });
    return forwardEnvelopeResponse<CtvRecruitmentModel>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return CtvRecruitmentModel.fromJson(object);
      },
      fallbackError: 'Tạo tuyển CTV thất bại',
    );
  }

  @override
  Future<ApiResponse<CtvRecruitmentModel>> updateRecruitment(
      int id, UpdateRecruitmentParams params) async {
    final envelope = updateStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeCtvRecruitmentJson(id: id),
        });
    return forwardEnvelopeResponse<CtvRecruitmentModel>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return CtvRecruitmentModel.fromJson(object);
      },
      fallbackError: 'Cập nhật tuyển CTV thất bại',
    );
  }

  @override
  Future<ApiResponse<void>> closeRecruitment(int id) async {
    final envelope = closeStub ?? ApiResponse.success({
      'errorCode': 0,
      'statusCode': 200,
      'message': 'OK',
      'object': null,
    });
    return forwardEnvelopeResponse<void>(
      envelope,
      (_) => null,
      fallbackError: 'Đóng tuyển CTV thất bại',
    );
  }

  @override
  Future<ApiResponse<void>> deleteRecruitment(int id) async {
    final envelope = deleteStub ?? ApiResponse.success({
      'errorCode': 0,
      'statusCode': 200,
      'message': 'OK',
      'object': null,
    });
    return forwardEnvelopeResponse<void>(
      envelope,
      (_) => null,
      fallbackError: 'Xóa tuyển CTV thất bại',
    );
  }
}

void main() {
  group('getRecruitments', () {
    test('success list', () async {
      final datasource = TestOrganizerRecruitmentDatasource(
        getRecruitmentsStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': [fakeCtvRecruitmentJson()],
            'totalElements': 1,
            'totalPages': 1,
            'page': 0,
            'size': 20,
          },
        }),
      );

      final result = await datasource.getRecruitments(page: 0, size: 20);

      result.when(
        success: (list) {
          expect(list.length, equals(1));
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

    test('empty', () async {
      final datasource = TestOrganizerRecruitmentDatasource(
        getRecruitmentsStub: ApiResponse.success({
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

      final result = await datasource.getRecruitments(page: 0, size: 20);

      result.when(
        success: (list) {
          expect(list, isEmpty);
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

  group('getRecruitmentById', () {
    test('success', () async {
      final datasource = TestOrganizerRecruitmentDatasource(
        getByIdStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeCtvRecruitmentJson(),
        }),
      );

      final result = await datasource.getRecruitmentById(1);

      result.when(
        success: (recruitment) {
          expect(recruitment.ctvRecruitmentId, equals(1));
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
      final datasource = TestOrganizerRecruitmentDatasource(
        getByIdStub: const ApiResponse.notFound(
          ApiResponseError(code: '404', message: 'Not found', errors: []),
        ),
      );

      final result = await datasource.getRecruitmentById(999);

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

  group('createRecruitment', () {
    test('success', () async {
      final datasource = TestOrganizerRecruitmentDatasource(
        createStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeCtvRecruitmentJson(),
        }),
      );

      final params = CreateRecruitmentParams(
        eventId: 1,
        title: 'Volunteer Recruitment',
        roleName: 'Event Volunteer',
        description: 'Help us organize',
        quantity: 10,
        rewardCoin: 100,
      );
      final result = await datasource.createRecruitment(params);

      result.when(
        success: (recruitment) {
          expect(recruitment.ctvRecruitmentId, equals(1));
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
      final datasource = TestOrganizerRecruitmentDatasource(
        createStub: const ApiResponse.badRequest(
          ApiResponseError(code: '400', message: 'Bad request', errors: []),
        ),
      );

      final params = CreateRecruitmentParams(eventId: 1, title: '');
      final result = await datasource.createRecruitment(params);

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

  group('updateRecruitment', () {
    test('success', () async {
      final datasource = TestOrganizerRecruitmentDatasource(
        updateStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeCtvRecruitmentJson(),
        }),
      );

      final params = UpdateRecruitmentParams(title: 'Updated Title');
      final result = await datasource.updateRecruitment(1, params);

      result.when(
        success: (recruitment) {
          expect(recruitment.ctvRecruitmentId, equals(1));
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
      final datasource = TestOrganizerRecruitmentDatasource(
        updateStub: const ApiResponse.notFound(
          ApiResponseError(code: '404', message: 'Not found', errors: []),
        ),
      );

      final params = UpdateRecruitmentParams(title: 'Updated');
      final result = await datasource.updateRecruitment(999, params);

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

  group('closeRecruitment', () {
    test('success', () async {
      final datasource = TestOrganizerRecruitmentDatasource(
        closeStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': null,
        }),
      );

      final result = await datasource.closeRecruitment(1);

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

    test('404', () async {
      final datasource = TestOrganizerRecruitmentDatasource(
        closeStub: const ApiResponse.notFound(
          ApiResponseError(code: '404', message: 'Not found', errors: []),
        ),
      );

      final result = await datasource.closeRecruitment(999);

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

  group('deleteRecruitment', () {
    test('success', () async {
      final datasource = TestOrganizerRecruitmentDatasource(
        deleteStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': null,
        }),
      );

      final result = await datasource.deleteRecruitment(1);

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

    test('404', () async {
      final datasource = TestOrganizerRecruitmentDatasource(
        deleteStub: const ApiResponse.notFound(
          ApiResponseError(code: '404', message: 'Not found', errors: []),
        ),
      );

      final result = await datasource.deleteRecruitment(999);

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
}
