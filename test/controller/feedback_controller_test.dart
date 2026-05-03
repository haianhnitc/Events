import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/feedback/domain/entity/feedback_entity.dart';
import 'package:events_app/feature/feedback/domain/usecase/feedback_usecase.dart';
import 'package:events_app/feature/feedback/domain/usecase/feedback_usecase_params.dart';
import 'package:events_app/feature/feedback/domain/usecase/submit_feedback_params.dart';
import 'package:events_app/feature/feedback/presentation/controller/feedback_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

class MockGetFeedbackQuestionsUsecase extends Mock implements GetFeedbackQuestionsUsecase {}
class MockSubmitFeedbackUsecase extends Mock implements SubmitFeedbackUsecase {}

class FakeGetFeedbackQuestionsParams extends Fake implements GetFeedbackQuestionsParams {}
class FakeSubmitFeedbackParams extends Fake implements SubmitFeedbackParams {}

void main() {
  late MockGetFeedbackQuestionsUsecase mockGetQuestionsUsecase;
  late MockSubmitFeedbackUsecase mockSubmitFeedbackUsecase;
  late FeedbackController controller;

  FeedbackQuestionEntity makeQuestion({
    int id = 1,
    FeedbackQuestionType type = FeedbackQuestionType.text,
    bool isRequired = false,
  }) {
    return FeedbackQuestionEntity(
      feedbackQuestionId: id,
      questionContent: 'Question $id',
      questionType: type,
      isRequired: isRequired,
    );
  }

  setUpAll(() {
    registerFallbackValue(FakeGetFeedbackQuestionsParams());
    registerFallbackValue(FakeSubmitFeedbackParams());
  });

  setUp(() async {
    Get.testMode = true;
    await networkGetIt.reset();

    mockGetQuestionsUsecase = MockGetFeedbackQuestionsUsecase();
    mockSubmitFeedbackUsecase = MockSubmitFeedbackUsecase();

    controller = FeedbackController.internal(
      getQuestionsUsecase: mockGetQuestionsUsecase,
      submitFeedbackUsecase: mockSubmitFeedbackUsecase,
    );
  });

  tearDown(() async {
    Get.reset();
    await networkGetIt.reset();
  });

  group('initial state', () {
    test('questions rỗng khi khởi tạo', () {
      expect(controller.questions, isEmpty);
    });

    test('answers rỗng khi khởi tạo', () {
      expect(controller.answers, isEmpty);
    });

    test('hasSubmitted = false khi khởi tạo', () {
      expect(controller.hasSubmitted.value, isFalse);
    });
  });

  group('setAnswer', () {
    test('cập nhật answers map với questionId và value', () {
      controller.setAnswer(1, 'My answer');

      expect(controller.answers[1], equals('My answer'));
    });

    test('ghi đè answer trước đó cho cùng questionId', () {
      controller.setAnswer(1, 'First answer');
      controller.setAnswer(1, 'Second answer');

      expect(controller.answers[1], equals('Second answer'));
    });
  });

  group('toggleOption', () {
    test('thêm optionId khi chưa được chọn', () {
      controller.toggleOption(1, 10);

      expect(controller.selectedOptions[1], contains(10));
    });

    test('bỏ optionId khi đã được chọn', () {
      controller.toggleOption(1, 10);
      controller.toggleOption(1, 10);

      expect(controller.selectedOptions[1], isNot(contains(10)));
    });

    test('hỗ trợ multiple selections cho cùng question', () {
      controller.toggleOption(1, 10);
      controller.toggleOption(1, 20);
      controller.toggleOption(1, 30);

      expect(controller.selectedOptions[1]?.length, equals(3));
      expect(controller.selectedOptions[1], containsAll([10, 20, 30]));
    });
  });

  group('canSubmit', () {
    test('false khi required question chưa trả lời', () {
      controller.questions.add(makeQuestion(id: 1, isRequired: true));

      expect(controller.canSubmit, isFalse);
    });

    test('true khi tất cả required questions đã trả lời', () {
      controller.questions.add(makeQuestion(id: 1, isRequired: true, type: FeedbackQuestionType.text));
      controller.setAnswer(1, 'Answer');

      expect(controller.canSubmit, isTrue);
    });

    test('true khi không có required question', () {
      controller.questions.add(makeQuestion(id: 1, isRequired: false));

      expect(controller.canSubmit, isTrue);
    });

    test('false khi required singleChoice chưa chọn', () {
      controller.questions.add(makeQuestion(id: 1, isRequired: true, type: FeedbackQuestionType.singleChoice));

      expect(controller.canSubmit, isFalse);
    });

    test('true khi required singleChoice đã chọn', () {
      controller.questions.add(makeQuestion(id: 1, isRequired: true, type: FeedbackQuestionType.singleChoice));
      controller.toggleOption(1, 10);

      expect(controller.canSubmit, isTrue);
    });

    test('false khi required multipleChoice chưa chọn', () {
      controller.questions.add(makeQuestion(id: 1, isRequired: true, type: FeedbackQuestionType.multipleChoice));

      expect(controller.canSubmit, isFalse);
    });

    test('true khi required multipleChoice đã chọn', () {
      controller.questions.add(makeQuestion(id: 1, isRequired: true, type: FeedbackQuestionType.multipleChoice));
      controller.toggleOption(1, 10);

      expect(controller.canSubmit, isTrue);
    });
  });

  group('loadQuestions', () {
    test('thành công thì populate questions list', () async {
      final questions = [
        makeQuestion(id: 1),
        makeQuestion(id: 2),
      ];
      when(() => mockGetQuestionsUsecase(any()))
          .thenAnswer((_) async => Right(questions));

      await controller.loadQuestions(1);

      expect(controller.questions.length, equals(2));
      expect(controller.hasSubmitted.value, isFalse);
      verify(() => mockGetQuestionsUsecase(any())).called(1);
    });

    test('thất bại thì propagates error (isLoading = false)', () async {
      when(() => mockGetQuestionsUsecase(any()))
          .thenAnswer((_) async => const Left(FailureEntity.serverFailure('500', 'error')));

      await controller.loadQuestions(1);

      expect(controller.isLoading.value, isFalse);
    });
  });

  group('submitFeedback', () {
    test('thành công thì sets hasSubmitted = true', () async {
      controller.questions.add(makeQuestion(id: 1));
      controller.setAnswer(1, 'Answer');
      when(() => mockSubmitFeedbackUsecase(any()))
          .thenAnswer((_) async => Right(FeedbackEntity(attendanceFeedbackId: 1)));

      await controller.submitFeedback();

      expect(controller.hasSubmitted.value, isTrue);
    });

    test('thất bại thì không set hasSubmitted', () async {
      controller.questions.add(makeQuestion(id: 1));
      when(() => mockSubmitFeedbackUsecase(any()))
          .thenAnswer((_) async => const Left(FailureEntity.serverFailure('500', 'error')));

      await controller.submitFeedback();

      expect(controller.hasSubmitted.value, isFalse);
    });

    test('gọi usecase với đúng params', () async {
      controller.questions.add(makeQuestion(id: 1, type: FeedbackQuestionType.text));
      controller.setAnswer(1, 'Answer');
      controller.comment.value = 'Great event!';
      when(() => mockSubmitFeedbackUsecase(any()))
          .thenAnswer((_) async => Right(FeedbackEntity()));

      await controller.submitFeedback();

      verify(() => mockSubmitFeedbackUsecase(any())).called(1);
    });
  });

  group('comment', () {
    test('setter cập nhật comment value', () {
      controller.setComment('Good');

      expect(controller.comment.value, equals('Good'));
    });

    test('getter trả về comment value', () {
      controller.comment.value = 'Excellent!';

      expect(controller.comment.value, equals('Excellent!'));
    });
  });
}
