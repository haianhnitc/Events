import 'package:flutter_test/flutter_test.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/organizer/feedback/data/datasource/organizer_feedback_datasource.dart';
import 'package:events_app/feature/organizer/feedback/domain/usecase/organizer_feedback_params.dart';
import 'package:events_app/feature/feedback/data/model/feedback_model.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';

import '../../helpers/fake_data.dart';

class TestOrganizerFeedbackDatasource extends OrganizerFeedbackDatasourceImpl {
  ApiResponse<Map<String, dynamic>>? createQuestionStub;
  ApiResponse<Map<String, dynamic>>? getQuestionByIdStub;
  ApiResponse<Map<String, dynamic>>? getQuestionsStub;
  ApiResponse<Map<String, dynamic>>? deleteQuestionsStub;
  ApiResponse<Map<String, dynamic>>? getFeedbacksStub;
  ApiResponse<Map<String, dynamic>>? getFeedbackByIdStub;

  TestOrganizerFeedbackDatasource({
    this.createQuestionStub,
    this.getQuestionByIdStub,
    this.getQuestionsStub,
    this.deleteQuestionsStub,
    this.getFeedbacksStub,
    this.getFeedbackByIdStub,
  }) : super(client: StubRestClient());

  @override
  Future<ApiResponse<FeedbackQuestionModel>> createFeedbackQuestion(
      CreateFeedbackQuestionParams params) async {
    final envelope = createQuestionStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeFeedbackQuestionJson(),
        });
    return forwardEnvelopeResponse<FeedbackQuestionModel>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return FeedbackQuestionModel.fromJson(object);
      },
      fallbackError: 'Tạo câu hỏi feedback thất bại',
    );
  }

  @override
  Future<ApiResponse<FeedbackQuestionModel>> getFeedbackQuestionById(int id) async {
    final envelope = getQuestionByIdStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeFeedbackQuestionJson(id: id),
        });
    return forwardEnvelopeResponse<FeedbackQuestionModel>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return FeedbackQuestionModel.fromJson(object);
      },
      fallbackError: 'Lấy câu hỏi feedback thất bại',
    );
  }

  @override
  Future<ApiResponse<List<FeedbackQuestionModel>>> getFeedbackQuestions(
      int eventId) async {
    final envelope = getQuestionsStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': [fakeFeedbackQuestionJson()],
        });
    return forwardEnvelopeResponse<List<FeedbackQuestionModel>>(
      envelope,
      (object) {
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
      fallbackError: 'Lấy danh sách câu hỏi thất bại',
    );
  }

  @override
  Future<ApiResponse<void>> deleteFeedbackQuestions(List<int> questionIds) async {
    final envelope = deleteQuestionsStub ?? ApiResponse.success({
      'errorCode': 0,
      'statusCode': 200,
      'message': 'OK',
      'object': null,
    });
    return forwardEnvelopeResponse<void>(
      envelope,
      (_) {},
      fallbackError: 'Xóa câu hỏi thất bại',
    );
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> getFeedbacks({
    int? eventId,
    int? participantId,
    int page = 0,
    int size = 20,
  }) async {
    final envelope = getFeedbacksStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': [fakeFeedbackJson()],
            'totalElements': 1,
            'totalPages': 1,
            'page': 0,
            'size': 20,
          },
        });
    return forwardEnvelopeResponse<Map<String, dynamic>>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return object;
      },
      fallbackError: 'Lấy danh sách feedback thất bại',
    );
  }

  @override
  Future<ApiResponse<FeedbackModel>> getFeedbackById(int id) async {
    final envelope = getFeedbackByIdStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeFeedbackJson(id: id),
        });
    return forwardEnvelopeResponse<FeedbackModel>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return FeedbackModel.fromJson(object);
      },
      fallbackError: 'Lấy chi tiết feedback thất bại',
    );
  }
}

void main() {
  group('createFeedbackQuestion', () {
    test('success returns question', () async {
      final datasource = TestOrganizerFeedbackDatasource(
        createQuestionStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeFeedbackQuestionJson(),
        }),
      );

      final result = await datasource.createFeedbackQuestion(
        CreateFeedbackQuestionParams(
          eventId: 1,
          questionContent: 'How was the event?',
          questionType: FeedbackQuestionType.rating,
          isRequired: true,
        ),
      );

      result.when(
        success: (question) {
          expect(question.feedbackQuestionId, equals(1));
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
      final datasource = TestOrganizerFeedbackDatasource(
        createQuestionStub: const ApiResponse.badRequest(
          ApiResponseError(code: '400', message: 'Bad request', errors: []),
        ),
      );

      final result = await datasource.createFeedbackQuestion(
        CreateFeedbackQuestionParams(
          eventId: 1,
          questionContent: '',
          questionType: FeedbackQuestionType.text,
        ),
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

  group('getFeedbackQuestionById', () {
    test('success', () async {
      final datasource = TestOrganizerFeedbackDatasource(
        getQuestionByIdStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeFeedbackQuestionJson(),
        }),
      );

      final result = await datasource.getFeedbackQuestionById(1);

      result.when(
        success: (question) {
          expect(question.feedbackQuestionId, equals(1));
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
      final datasource = TestOrganizerFeedbackDatasource(
        getQuestionByIdStub: const ApiResponse.notFound(
          ApiResponseError(code: '404', message: 'Not found', errors: []),
        ),
      );

      final result = await datasource.getFeedbackQuestionById(999);

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

  group('getFeedbackQuestions', () {
    test('success list', () async {
      final datasource = TestOrganizerFeedbackDatasource(
        getQuestionsStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': [fakeFeedbackQuestionJson()],
        }),
      );

      final result = await datasource.getFeedbackQuestions(1);

      result.when(
        success: (questions) {
          expect(questions.length, equals(1));
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
      final datasource = TestOrganizerFeedbackDatasource(
        getQuestionsStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': <Map<String, dynamic>>[],
        }),
      );

      final result = await datasource.getFeedbackQuestions(1);

      result.when(
        success: (questions) {
          expect(questions, isEmpty);
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

  group('deleteFeedbackQuestions', () {
    test('success', () async {
      final datasource = TestOrganizerFeedbackDatasource(
        deleteQuestionsStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': null,
        }),
      );

      final result = await datasource.deleteFeedbackQuestions([1, 2, 3]);

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
      final datasource = TestOrganizerFeedbackDatasource(
        deleteQuestionsStub: const ApiResponse.notFound(
          ApiResponseError(code: '404', message: 'Not found', errors: []),
        ),
      );

      final result = await datasource.deleteFeedbackQuestions([999]);

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

  group('getFeedbacks', () {
    test('success paginated', () async {
      final datasource = TestOrganizerFeedbackDatasource(
        getFeedbacksStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': [fakeFeedbackJson()],
            'totalElements': 1,
            'totalPages': 1,
            'page': 0,
            'size': 20,
          },
        }),
      );

      final result = await datasource.getFeedbacks();

      result.when(
        success: (data) {
          expect(data['content'], isA<List>());
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

  group('getFeedbackById', () {
    test('success', () async {
      final datasource = TestOrganizerFeedbackDatasource(
        getFeedbackByIdStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeFeedbackJson(),
        }),
      );

      final result = await datasource.getFeedbackById(1);

      result.when(
        success: (feedback) {
          expect(feedback.attendanceFeedbackId, equals(1));
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
      final datasource = TestOrganizerFeedbackDatasource(
        getFeedbackByIdStub: const ApiResponse.notFound(
          ApiResponseError(code: '404', message: 'Not found', errors: []),
        ),
      );

      final result = await datasource.getFeedbackById(999);

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
