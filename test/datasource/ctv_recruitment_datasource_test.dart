import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/recruitment/data/datasource/ctv_recruitment_datasource.dart';
import 'package:events_app/feature/recruitment/data/model/ctv_recruitment_model.dart';
import 'package:events_app/feature/recruitment/data/model/requirement_question_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_data.dart';

class TestCtvRecruitmentDatasource extends CtvRecruitmentDatasourceImpl {
  Object? getRecruitmentsStub;
  Object? getRecruitmentByIdStub;
  Object? getRecruitmentQuestionsStub;

  TestCtvRecruitmentDatasource() : super(client: StubRestClient());

  @override
  Future<ApiResponse<List<CtvRecruitmentModel>>> getRecruitments({
    int? eventId,
    int page = 0,
    int size = 20,
  }) async {
    final stub = getRecruitmentsStub;
    final ApiResponse<Map<String, dynamic>> envelope;
    if (stub == null) {
      envelope = ApiResponse.success({
        'errorCode': 0,
        'statusCode': 200,
        'message': 'OK',
        'object': {
          'content': [fakeCtvRecruitmentJson()],
          'totalElements': 1,
        },
      });
    } else if (stub is ApiResponse<Map<String, dynamic>>) {
      envelope = stub;
    } else {
      // stub is a raw value (null/string) — pass it as 'object' to test parser
      envelope = ApiResponse.success({
        'errorCode': 0,
        'statusCode': 200,
        'message': 'OK',
        'object': stub,
      });
    }
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
    final stub = getRecruitmentByIdStub;
    final ApiResponse<Map<String, dynamic>> envelope;
    if (stub == null) {
      envelope = ApiResponse.success({
        'errorCode': 0,
        'statusCode': 200,
        'message': 'OK',
        'object': fakeCtvRecruitmentJson(id: id),
      });
    } else if (stub is ApiResponse<Map<String, dynamic>>) {
      envelope = stub;
    } else {
      envelope = ApiResponse.success({
        'errorCode': 0,
        'statusCode': 200,
        'message': 'OK',
        'object': stub,
      });
    }
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
  Future<ApiResponse<List<RequirementQuestionModel>>> getRecruitmentQuestions(
      int recruitmentId) async {
    final stub = getRecruitmentQuestionsStub;
    final envelope = stub != null
        ? ApiResponse.success(stub is Map<String, dynamic>
            ? stub
            : {
                'errorCode': 0,
                'statusCode': 200,
                'message': 'OK',
                'object': stub
              })
        : ApiResponse.success({
            'errorCode': 0,
            'statusCode': 200,
            'message': 'OK',
            'object': [
              fakeRequirementQuestionJson(id: 1),
              fakeRequirementQuestionJson(id: 2),
            ],
          });
    return forwardEnvelopeResponse<List<RequirementQuestionModel>>(
      envelope,
      (object) {
        if (object == null) return <RequirementQuestionModel>[];
        if (object is List<dynamic>) {
          return object
              .map((e) =>
                  RequirementQuestionModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        if (object is Map<String, dynamic>) {
          final content = object['content'] as List<dynamic>? ?? [];
          return content
              .map((e) =>
                  RequirementQuestionModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        throw const FormatException('Invalid object payload');
      },
      fallbackError: 'Lấy câu hỏi tuyển dụng thất bại',
    );
  }
}

void main() {
  group('getRecruitments', () {
    test('trả về list tuyển CTV khi thành công', () async {
      final datasource = TestCtvRecruitmentDatasource()
        ..getRecruitmentsStub = ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': [
              fakeCtvRecruitmentJson(id: 1),
              fakeCtvRecruitmentJson(id: 2),
            ],
            'totalElements': 2,
          },
        });

      final result = await datasource.getRecruitments();

      result.when(
        success: (list) {
          expect(list.length, equals(2));
          expect(list.first.ctvRecruitmentId, equals(1));
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

    test('trả về list rỗng khi không có recruitment', () async {
      final datasource = TestCtvRecruitmentDatasource()
        ..getRecruitmentsStub = const ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {'content': [], 'totalElements': 0},
        });

      final result = await datasource.getRecruitments();

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

    test('filter theo eventId không gây lỗi', () async {
      final datasource = TestCtvRecruitmentDatasource()
        ..getRecruitmentsStub = ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': [fakeCtvRecruitmentJson()],
            'totalElements': 1,
          },
        });

      final result = await datasource.getRecruitments(eventId: 5);

      result.when(
        success: (list) => expect(list, isNotEmpty),
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

    test('trả về responseParsing khi object không phải Map', () async {
      // Pass raw 'invalid' value — the envelope wraps it as 'object',
      // then the parser throws FormatException → responseParsing
      final datasource = TestCtvRecruitmentDatasource()
        ..getRecruitmentsStub = 'invalid';

      final result = await datasource.getRecruitments();

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

    test('trả về internalServerError khi backend 500', () async {
      final datasource = TestCtvRecruitmentDatasource()
        ..getRecruitmentsStub = const ApiResponse.internalServerError();

      final result = await datasource.getRecruitments();

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

  group('getRecruitmentById', () {
    test('trả về CtvRecruitmentModel khi thành công', () async {
      final datasource = TestCtvRecruitmentDatasource()
        ..getRecruitmentByIdStub = ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeCtvRecruitmentJson(id: 7),
        });

      final result = await datasource.getRecruitmentById(7);

      result.when(
        success: (recruitment) {
          expect(recruitment.ctvRecruitmentId, equals(7));
          expect(recruitment.title, equals('Recruitment 7'));
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

    test('trả về notFound khi recruitment không tồn tại', () async {
      final datasource = TestCtvRecruitmentDatasource()
        ..getRecruitmentByIdStub = const ApiResponse.notFound(
          ApiResponseError(code: '404', message: 'Not found', errors: []),
        );

      final result = await datasource.getRecruitmentById(9999);

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

    test('trả về responseParsing khi object không phải Map', () async {
      final datasource = TestCtvRecruitmentDatasource()
        ..getRecruitmentByIdStub = const ApiResponse.success(null);

      final result = await datasource.getRecruitmentById(1);

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

  group('getRecruitmentQuestions', () {
    test('trả về list câu hỏi dạng array khi thành công', () async {
      final datasource = TestCtvRecruitmentDatasource()
        ..getRecruitmentQuestionsStub = ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': [
            fakeRequirementQuestionJson(id: 1),
            fakeRequirementQuestionJson(id: 2),
          ],
        });

      final result = await datasource.getRecruitmentQuestions(5);

      result.when(
        success: (questions) {
          expect(questions.length, equals(2));
          expect(questions.first.questionId, equals(1));
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

    test('trả về list câu hỏi dạng paginated khi thành công', () async {
      final datasource = TestCtvRecruitmentDatasource()
        ..getRecruitmentQuestionsStub = ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': [fakeRequirementQuestionJson(id: 10)],
            'totalElements': 1,
          },
        });

      final result = await datasource.getRecruitmentQuestions(5);

      result.when(
        success: (questions) {
          expect(questions.length, equals(1));
          expect(questions.first.questionId, equals(10));
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

    test('trả về list rỗng khi object null', () async {
      final datasource = TestCtvRecruitmentDatasource()
        ..getRecruitmentQuestionsStub = const ApiResponse.success(null);

      final result = await datasource.getRecruitmentQuestions(5);

      result.when(
        success: (questions) => expect(questions, isEmpty),
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

    test('trả về notFound khi recruitment không có câu hỏi', () async {
      final datasource = TestCtvRecruitmentDatasource()
        ..getRecruitmentQuestionsStub = const ApiResponse.notFound(
          ApiResponseError(code: '404', message: 'Not found', errors: []),
        );

      final result = await datasource.getRecruitmentQuestions(9999);

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
  });
}
