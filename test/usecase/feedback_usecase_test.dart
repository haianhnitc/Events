import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/feedback/domain/entity/feedback_entity.dart';
import 'package:events_app/feature/feedback/domain/repository/feedback_repository.dart';
import 'package:events_app/feature/feedback/domain/usecase/feedback_usecase.dart';
import 'package:events_app/feature/feedback/domain/usecase/feedback_usecase_params.dart';
import 'package:events_app/feature/feedback/domain/usecase/submit_feedback_params.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFeedbackRepository extends Mock implements FeedbackRepository {}

class FakeGetFeedbackQuestionsParams extends Fake implements GetFeedbackQuestionsParams {}
class FakeSubmitFeedbackParams extends Fake implements SubmitFeedbackParams {}

void main() {
  late MockFeedbackRepository mockRepository;
  late GetFeedbackQuestionsUsecase getFeedbackQuestionsUsecase;
  late SubmitFeedbackUsecase submitFeedbackUsecase;

  setUpAll(() {
    registerFallbackValue(FakeGetFeedbackQuestionsParams());
    registerFallbackValue(FakeSubmitFeedbackParams());
  });

  setUp(() {
    mockRepository = MockFeedbackRepository();
    getFeedbackQuestionsUsecase = GetFeedbackQuestionsUsecase(mockRepository);
    submitFeedbackUsecase = SubmitFeedbackUsecase(mockRepository);
  });

  group('GetFeedbackQuestionsUsecase', () {
    test('trả về list feedback question entity khi repository thành công', () async {
      final entities = [
        FeedbackQuestionEntity(
          feedbackQuestionId: 1,
          questionContent: 'Câu hỏi 1',
        ),
        FeedbackQuestionEntity(
          feedbackQuestionId: 2,
          questionContent: 'Câu hỏi 2',
        ),
      ];
      when(() => mockRepository.getFeedbackQuestions(
            any(),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => Right(entities));

      final result = await getFeedbackQuestionsUsecase(
        const GetFeedbackQuestionsParams(eventId: 1),
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (questions) {
          expect(questions.length, equals(2));
          expect(questions.first.feedbackQuestionId, equals(1));
        },
      );
    });

    test('trả về empty list khi repository trả rỗng', () async {
      when(() => mockRepository.getFeedbackQuestions(
            any(),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => const Right([]));

      final result = await getFeedbackQuestionsUsecase(
        const GetFeedbackQuestionsParams(eventId: 1),
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (questions) => expect(questions, isEmpty),
      );
    });

    test('trả về failure khi repository thất bại', () async {
      when(() => mockRepository.getFeedbackQuestions(
            any(),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async =>
              const Left(FailureEntity.serverFailure('500', 'Server error')));

      final result = await getFeedbackQuestionsUsecase(
        const GetFeedbackQuestionsParams(eventId: 1),
      );

      expect(result.isLeft(), isTrue);
    });
  });

  group('SubmitFeedbackUsecase', () {
    test('trả về feedback entity khi repository thành công', () async {
      final entity = FeedbackEntity(attendanceFeedbackId: 5);
      when(() => mockRepository.submitFeedback(any()))
          .thenAnswer((_) async => Right(entity));

      final params = SubmitFeedbackParams(eventId: 1, answers: []);
      final result = await submitFeedbackUsecase(params);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (feedback) => expect(feedback.attendanceFeedbackId, equals(5)),
      );
    });

    test('trả về Left khi repository trả badRequest', () async {
      when(() => mockRepository.submitFeedback(any()))
          .thenAnswer((_) async =>
              const Left(FailureEntity.serverFailure('400', 'Bad request')));

      final params = SubmitFeedbackParams(eventId: 1, answers: []);
      final result = await submitFeedbackUsecase(params);

      expect(result.isLeft(), isTrue);
    });

    test('trả về Left khi repository trả notFound', () async {
      when(() => mockRepository.submitFeedback(any()))
          .thenAnswer((_) async =>
              const Left(FailureEntity.serverFailure('404', 'Not found')));

      final params = SubmitFeedbackParams(eventId: 9999, answers: []);
      final result = await submitFeedbackUsecase(params);

      expect(result.isLeft(), isTrue);
    });
  });
}
