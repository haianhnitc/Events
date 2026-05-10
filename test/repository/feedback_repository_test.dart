import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/feedback/data/datasource/feedback_datasource.dart';
import 'package:events_app/feature/feedback/data/model/feedback_model.dart';
import 'package:events_app/feature/feedback/data/repository/feedback_repository_impl.dart';
import 'package:events_app/feature/feedback/domain/entity/feedback_entity.dart';
import 'package:events_app/feature/feedback/domain/usecase/feedback_usecase_params.dart';
import 'package:events_app/feature/feedback/domain/usecase/submit_feedback_params.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/fake_data.dart';
import '../helpers/mock_rest_client.dart';

class MockFeedbackDatasource extends Mock implements FeedbackDatasource {}

void main() {
  late MockFeedbackDatasource mockDatasource;
  late FeedbackRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockFeedbackDatasource();
    repository = FeedbackRepositoryImpl(mockDatasource);
  });

  group('getFeedbackQuestions', () {
    test('trả về list feedback question entity khi datasource thành công',
        () async {
      final models = [
        FeedbackQuestionModel.fromJson(fakeFeedbackQuestionJson(id: 1)),
        FeedbackQuestionModel.fromJson(fakeFeedbackQuestionJson(id: 2)),
      ];
      when(() => mockDatasource.getFeedbackQuestions(
            any(),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => successResponse(models));

      final result = await repository.getFeedbackQuestions(
        const GetFeedbackQuestionsParams(eventId: 1),
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entities) {
          expect(entities.length, equals(2));
          expect(entities.first.feedbackQuestionId, equals(1));
          expect(entities.last.feedbackQuestionId, equals(2));
        },
      );
    });

    test('trả về empty list khi datasource trả empty', () async {
      when(() => mockDatasource.getFeedbackQuestions(
                any(),
                page: any(named: 'page'),
                size: any(named: 'size'),
              ))
          .thenAnswer(
              (_) async => successResponse<List<FeedbackQuestionModel>>([]));

      final result = await repository.getFeedbackQuestions(
        const GetFeedbackQuestionsParams(eventId: 1),
      );

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('Expected Right'), (entities) {
        expect(entities, isEmpty);
      });
    });

    test('trả về FailureEntity khi datasource trả unauthorized', () async {
      when(() => mockDatasource.getFeedbackQuestions(
                any(),
                page: any(named: 'page'),
                size: any(named: 'size'),
              ))
          .thenAnswer((_) async => errorResponse<List<FeedbackQuestionModel>>(
              unauthorizedResponse()));

      final result = await repository.getFeedbackQuestions(
        const GetFeedbackQuestionsParams(eventId: 1),
      );

      expect(result.isLeft(), isTrue);
    });

    test('maps models sang entities đúng', () async {
      final models = [
        FeedbackQuestionModel.fromJson(fakeFeedbackQuestionJson(id: 1)),
      ];
      when(() => mockDatasource.getFeedbackQuestions(
            any(),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => successResponse(models));

      final result = await repository.getFeedbackQuestions(
        const GetFeedbackQuestionsParams(eventId: 1),
      );

      result.fold(
        (_) => fail('Expected Right'),
        (entities) {
          expect(entities.first, isA<FeedbackQuestionEntity>());
          expect(entities.first.feedbackQuestionId, equals(1));
        },
      );
    });
  });

  group('submitFeedback', () {
    test('trả về feedback entity khi datasource thành công', () async {
      final model = FeedbackModel.fromJson(fakeFeedbackJson(id: 5));
      when(() => mockDatasource.submitFeedback(any()))
          .thenAnswer((_) async => successResponse(model));

      const params = SubmitFeedbackParams(eventId: 1, answers: []);
      final result = await repository.submitFeedback(params);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) => expect(entity.attendanceFeedbackId, equals(5)),
      );
    });

    test('trả về FailureEntity khi datasource trả badRequest', () async {
      when(() => mockDatasource.submitFeedback(any())).thenAnswer(
          (_) async => errorResponse<FeedbackModel>(badRequestResponse()));

      const params = SubmitFeedbackParams(eventId: 1, answers: []);
      final result = await repository.submitFeedback(params);

      expect(result.isLeft(), isTrue);
    });

    test('maps answer models sang entities đúng', () async {
      final model = FeedbackModel.fromJson(fakeFeedbackJson(id: 1));
      when(() => mockDatasource.submitFeedback(any()))
          .thenAnswer((_) async => successResponse(model));

      const params = SubmitFeedbackParams(eventId: 1, answers: []);
      final result = await repository.submitFeedback(params);

      result.fold(
        (_) => fail('Expected Right'),
        (entity) {
          expect(entity, isA<FeedbackEntity>());
          expect(entity.comment, equals('Great event!'));
        },
      );
    });
  });
}
