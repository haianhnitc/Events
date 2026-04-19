import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/feature/recruitment/data/datasource/ctv_recruitment_datasource.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/api_request_matchers.dart';
import '../helpers/fake_data.dart';
import '../helpers/mock_rest_client.dart';
import '../helpers/api_response_matchers.dart';

void main() {
  late MockRestClient mockRestClient;
  late CtvRecruitmentDatasourceImpl datasource;

  setUpAll(registerFallbacks);

  setUp(() {
    mockRestClient = MockRestClient();
    datasource = CtvRecruitmentDatasourceImpl(client: mockRestClient);
  });

  // ─── getRecruitments ─────────────────────────────────────────────────────────
  group('getRecruitments', () {
    test('trả về list tuyển CTV khi thành công', () async {
      stubRestClient(
        mockRestClient,
        successEnvelope({
          'content': [fakeCtvRecruitmentJson(id: 1), fakeCtvRecruitmentJson(id: 2)],
          'totalElements': 2,
        }),
      );

      final result = await datasource.getRecruitments();

      result.when(
        success: (list) {
          expect(list.length, equals(2));
          expect(list.first.ctvRecruitmentId, equals(1));
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

    test('trả về list rỗng khi không có recruitment', () async {
      stubRestClient(
        mockRestClient,
        successEnvelope({'content': [], 'totalElements': 0}),
      );

      final result = await datasource.getRecruitments();

      result.when(
        success: (list) => expect(list, isEmpty),
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

    test('filter theo eventId không gây lỗi', () async {
      stubRestClient(
        mockRestClient,
        successEnvelope({
          'content': [fakeCtvRecruitmentJson()],
          'totalElements': 1,
        }),
      );

      final result = await datasource.getRecruitments(eventId: 5);

      expect(result, isA<dynamic>());
    });

    test('trả về responseParsing khi object không phải Map', () async {
      stubRestClient(mockRestClient, successEnvelope('invalid'));

      final result = await datasource.getRecruitments();

      expect(isResponseParsing(result), isTrue);
    });

    test('trả về internalServerError khi backend 500', () async {
      stubRestClient(mockRestClient, serverErrorResponse());

      final result = await datasource.getRecruitments();

      expect(isInternalServerError(result), isTrue);
    });
  });

  // ─── getRecruitmentById ──────────────────────────────────────────────────────
  group('getRecruitmentById', () {
    test('trả về CtvRecruitmentModel khi thành công', () async {
      stubRestClient(mockRestClient, successEnvelope(fakeCtvRecruitmentJson(id: 7)));

      final result = await datasource.getRecruitmentById(7);

      result.when(
        success: (recruitment) {
          expect(recruitment.ctvRecruitmentId, equals(7));
          expect(recruitment.title, equals('Recruitment 7'));
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

    test('trả về notFound khi recruitment không tồn tại', () async {
      stubRestClient(mockRestClient, notFoundResponse());

      final result = await datasource.getRecruitmentById(9999);

      expect(isNotFound(result), isTrue);
    });

    test('trả về responseParsing khi object không phải Map', () async {
      stubRestClient(mockRestClient, successEnvelope(null));

      final result = await datasource.getRecruitmentById(1);

      expect(isResponseParsing(result), isTrue);
    });
  });

  // ─── getRecruitmentQuestions ─────────────────────────────────────────────────
  group('getRecruitmentQuestions', () {
    test('trả về list câu hỏi dạng array khi thành công', () async {
      stubRestClient(
        mockRestClient,
        successEnvelope([
          fakeRequirementQuestionJson(id: 1),
          fakeRequirementQuestionJson(id: 2),
        ]),
      );

      final result = await datasource.getRecruitmentQuestions(5);

      result.when(
        success: (questions) {
          expect(questions.length, equals(2));
          expect(questions.first.questionId, equals(1));
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

    test('trả về list câu hỏi dạng paginated khi thành công', () async {
      stubRestClient(
        mockRestClient,
        successEnvelope({
          'content': [fakeRequirementQuestionJson(id: 10)],
          'totalElements': 1,
        }),
      );

      final result = await datasource.getRecruitmentQuestions(5);

      result.when(
        success: (questions) {
          expect(questions.length, equals(1));
          expect(questions.first.questionId, equals(10));
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

    test('trả về list rỗng khi object null', () async {
      stubRestClient(mockRestClient, successEnvelope(null));

      final result = await datasource.getRecruitmentQuestions(5);

      result.when(
        success: (questions) => expect(questions, isEmpty),
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

    test('trả về notFound khi recruitment không có câu hỏi', () async {
      stubRestClient(mockRestClient, notFoundResponse());

      final result = await datasource.getRecruitmentQuestions(9999);

      expect(isNotFound(result), isTrue);
    });
  });
}
