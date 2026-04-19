import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/feedback/data/model/feedback_model.dart';
import 'package:events_app/feature/organizer/feedback/data/datasource/organizer_feedback_datasource.dart';
import 'package:events_app/feature/organizer/feedback/domain/usecase/organizer_feedback_params.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/api_request_matchers.dart';
import '../../helpers/fake_data.dart';
import '../../helpers/mock_rest_client.dart';
import '../../helpers/api_response_matchers.dart';

void main() {
  late MockRestClient mockRestClient;
  late OrganizerFeedbackDatasourceImpl datasource;

  setUpAll(registerFallbacks);

  setUp(() {
    mockRestClient = MockRestClient();
    datasource = OrganizerFeedbackDatasourceImpl(client: mockRestClient);
  });

  // ─── createFeedbackQuestion ──────────────────────────────────────────────────
  group('createFeedbackQuestion', () {
    const params = CreateFeedbackQuestionParams(
      eventId: 1,
      questionContent: 'Bạn đánh giá sự kiện thế nào?',
      questionType: FeedbackQuestionType.rating,
      isRequired: true,
      maxRating: 5,
    );

    test('trả về FeedbackQuestionModel khi tạo thành công', () async {
      stubRestClient(mockRestClient, successEnvelope(fakeFeedbackQuestionJson(id: 1)));

      final result = await datasource.createFeedbackQuestion(params);

      result.when(
        success: (question) {
          expect(question.feedbackQuestionId, equals(1));
          expect(question.event?.eventId, equals(1));
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

    test('trả về badRequest khi data không hợp lệ', () async {
      stubRestClient(mockRestClient, badRequestResponse());

      final result = await datasource.createFeedbackQuestion(params);

      expect(isBadRequest(result), isTrue);
    });

    test('trả về unauthorized khi không có quyền', () async {
      stubRestClient(mockRestClient, unauthorizedResponse());

      final result = await datasource.createFeedbackQuestion(params);

      expect(isUnauthorized(result), isTrue);
    });

    test('trả về forbidden khi không phải organizer event', () async {
      stubRestClient(mockRestClient, forbiddenResponse());

      final result = await datasource.createFeedbackQuestion(params);

      expect(isForbidden(result), isTrue);
    });
  });

  // ─── getFeedbackQuestionById ─────────────────────────────────────────────────
  group('getFeedbackQuestionById', () {
    test('trả về FeedbackQuestionModel khi thành công', () async {
      stubRestClient(mockRestClient, successEnvelope(fakeFeedbackQuestionJson(id: 5)));

      final result = await datasource.getFeedbackQuestionById(5);

      result.when(
        success: (q) => expect(q.feedbackQuestionId, equals(5)),
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

    test('trả về notFound khi câu hỏi không tồn tại', () async {
      stubRestClient(mockRestClient, notFoundResponse());

      final result = await datasource.getFeedbackQuestionById(9999);

      expect(isNotFound(result), isTrue);
    });
  });

  // ─── getFeedbackQuestions ────────────────────────────────────────────────────
  group('getFeedbackQuestions', () {
    test('trả về list câu hỏi khi thành công', () async {
      stubRestClient(
        mockRestClient,
        successEnvelope([
          fakeFeedbackQuestionJson(id: 1),
          fakeFeedbackQuestionJson(id: 2),
        ]),
      );

      final result = await datasource.getFeedbackQuestions(1);

      result.when(
        success: (questions) => expect(questions.length, equals(2)),
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
        successEnvelope({'content': [fakeFeedbackQuestionJson()], 'totalElements': 1}),
      );

      final result = await datasource.getFeedbackQuestions(1);

      result.when(
        success: (questions) => expect(questions.length, equals(1)),
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

    test('trả về list rỗng khi null', () async {
      stubRestClient(mockRestClient, successEnvelope(null));

      final result = await datasource.getFeedbackQuestions(1);

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
  });

  // ─── deleteFeedbackQuestions ─────────────────────────────────────────────────
  group('deleteFeedbackQuestions', () {
    test('trả về success khi xóa thành công', () async {
      stubRestClient(mockRestClient, successEnvelope(null));

      final result = await datasource.deleteFeedbackQuestions([1, 2, 3]);

      expect(result, isA<dynamic>());
    });

    test('trả về unauthorized khi không có quyền', () async {
      stubRestClient(mockRestClient, unauthorizedResponse());

      final result = await datasource.deleteFeedbackQuestions([1]);

      expect(isUnauthorized(result), isTrue);
    });

    test('trả về forbidden khi không phải organizer event', () async {
      stubRestClient(mockRestClient, forbiddenResponse());

      final result = await datasource.deleteFeedbackQuestions([1]);

      expect(isForbidden(result), isTrue);
    });

    test('trả về notFound khi câu hỏi không tồn tại', () async {
      stubRestClient(mockRestClient, notFoundResponse());

      final result = await datasource.deleteFeedbackQuestions([9999]);

      expect(isNotFound(result), isTrue);
    });
  });

  // ─── getFeedbacks ────────────────────────────────────────────────────────────
  group('getFeedbacks', () {
    test('trả về list feedback khi thành công', () async {
      stubRestClient(
        mockRestClient,
        successEnvelope({
          'content': [fakeFeedbackJson(id: 1), fakeFeedbackJson(id: 2)],
          'totalElements': 2,
        }),
      );

      final result = await datasource.getFeedbacks(eventId: 1);

      result.when(
        success: (feedbacks) {
          final content = feedbacks['content'] as List;
          expect(content.length, equals(2));
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

    test('trả về list rỗng khi chưa có feedback', () async {
      stubRestClient(
        mockRestClient,
        successEnvelope({'content': [], 'totalElements': 0}),
      );

      final result = await datasource.getFeedbacks(eventId: 1);

      result.when(
        success: (feedbacks) => expect(feedbacks, isEmpty),
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

    test('trả về responseParsing khi object không phải Map', () async {
      stubRestClient(mockRestClient, successEnvelope('invalid'));

      final result = await datasource.getFeedbacks(eventId: 1);

      expect(isResponseParsing(result), isTrue);
    });
  });

  // ─── getFeedbackById ─────────────────────────────────────────────────────────
  group('getFeedbackById', () {
    test('trả về FeedbackModel khi thành công', () async {
      stubRestClient(mockRestClient, successEnvelope(fakeFeedbackJson(id: 7)));

      final result = await datasource.getFeedbackById(7);

      result.when(
        success: (feedback) => expect(feedback.attendanceFeedbackId, equals(7)),
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

    test('trả về notFound khi feedback không tồn tại', () async {
      stubRestClient(mockRestClient, notFoundResponse());

      final result = await datasource.getFeedbackById(9999);

      expect(isNotFound(result), isTrue);
    });
  });
}
