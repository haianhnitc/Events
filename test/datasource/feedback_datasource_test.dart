import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/feedback/data/datasource/feedback_datasource.dart';
import 'package:events_app/feature/feedback/data/model/feedback_model.dart';
import 'package:events_app/feature/feedback/domain/usecase/submit_feedback_params.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_data.dart';

class TestFeedbackDatasource extends FeedbackDatasourceImpl {
  ApiResponse<Map<String, dynamic>>? questionsStub;
  ApiResponse<Map<String, dynamic>>? submitStub;

  TestFeedbackDatasource({this.questionsStub, this.submitStub})
      : super(client: StubRestClient());

  @override
  Future<ApiResponse<List<FeedbackQuestionModel>>> getFeedbackQuestions(
    int eventId, {
    int page = 0,
    int size = 20,
  }) async {
    final envelope = questionsStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': [fakeFeedbackQuestionJson(), fakeFeedbackQuestionJson(id: 2)],
        });
    return forwardEnvelopeResponse<List<FeedbackQuestionModel>>(
      envelope,
      (object) {
        if (object == null) return <FeedbackQuestionModel>[];
        if (object is List<dynamic>) {
          return object
              .map((e) => FeedbackQuestionModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        if (object is Map<String, dynamic>) {
          final content = object['content'] as List<dynamic>? ?? [];
          return content
              .map((e) => FeedbackQuestionModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        throw const FormatException('Invalid object payload');
      },
      fallbackError: 'Lấy câu hỏi feedback thất bại',
    );
  }

  @override
  Future<ApiResponse<FeedbackModel>> submitFeedback(SubmitFeedbackParams params) async {
    final envelope = submitStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeFeedbackJson(),
        });
    return forwardEnvelopeResponse<FeedbackModel>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return FeedbackModel.fromJson(object);
      },
      fallbackError: 'Gửi feedback thất bại',
    );
  }
}

void main() {
  // ─── getFeedbackQuestions ────────────────────────────────────────────────
  group('getFeedbackQuestions', () {
    test('trả về list question khi thành công', () async {
      final datasource = TestFeedbackDatasource(
        questionsStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': [
            fakeFeedbackQuestionJson(id: 1),
            fakeFeedbackQuestionJson(id: 2),
          ],
        }),
      );

      final result = await datasource.getFeedbackQuestions(1, page: 0, size: 20);

      result.when(
        success: (questions) {
          expect(questions.length, equals(2));
          expect(questions.first.feedbackQuestionId, equals(1));
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

    test('trả về empty list khi object là null', () async {
      final datasource = TestFeedbackDatasource(
        questionsStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': null,
        }),
      );

      final result = await datasource.getFeedbackQuestions(1, page: 0, size: 20);

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

    test('trả về list từ paginated envelope', () async {
      final datasource = TestFeedbackDatasource(
        questionsStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': [fakeFeedbackQuestionJson(id: 1)],
          },
        }),
      );

      final result = await datasource.getFeedbackQuestions(1, page: 0, size: 20);

      result.when(
        success: (questions) => expect(questions.length, equals(1)),
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

    test('trả về notFound khi event không tồn tại', () async {
      final datasource = TestFeedbackDatasource(
        questionsStub: const ApiResponse.notFound(
          ApiResponseError(code: '404', message: 'Not found', errors: []),
        ),
      );

      final result = await datasource.getFeedbackQuestions(9999);

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

    test('trả về responseParsing khi object không hợp lệ', () async {
      final datasource = TestFeedbackDatasource(
        questionsStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': 'invalid',
        }),
      );

      final result = await datasource.getFeedbackQuestions(1, page: 0, size: 20);

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
      final datasource = TestFeedbackDatasource(
        questionsStub: const ApiResponse.serviceUnavailable(),
      );

      final result = await datasource.getFeedbackQuestions(1, page: 0, size: 20);

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

  // ─── submitFeedback ─────────────────────────────────────────────────────
  group('submitFeedback', () {
    test('trả về feedback model khi thành công', () async {
      final datasource = TestFeedbackDatasource(
        submitStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeFeedbackJson(id: 5),
        }),
      );

      final params = SubmitFeedbackParams(
        eventId: 1,
        answers: [],
      );

      final result = await datasource.submitFeedback(params);

      result.when(
        success: (feedback) {
          expect(feedback.attendanceFeedbackId, equals(5));
          expect(feedback.comment, equals('Great event!'));
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

    test('trả về unauthorized khi chưa đăng nhập', () async {
      final datasource = TestFeedbackDatasource(
        submitStub: const ApiResponse.unauthorized(
          ApiResponseError(code: '401', message: 'Unauthorized', errors: []),
        ),
      );

      final params = SubmitFeedbackParams(
        eventId: 1,
        answers: [],
      );

      final result = await datasource.submitFeedback(params);

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

    test('trả về badRequest khi params không hợp lệ', () async {
      final datasource = TestFeedbackDatasource(
        submitStub: const ApiResponse.badRequest(
          ApiResponseError(code: '400', message: 'Bad request', errors: []),
        ),
      );

      final params = SubmitFeedbackParams(
        eventId: 1,
        answers: [],
      );

      final result = await datasource.submitFeedback(params);

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

    test('trả về responseParsing khi object không phải Map', () async {
      final datasource = TestFeedbackDatasource(
        submitStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': 123,
        }),
      );

      final params = SubmitFeedbackParams(
        eventId: 1,
        answers: [],
      );

      final result = await datasource.submitFeedback(params);

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
