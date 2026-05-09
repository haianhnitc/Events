import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/feedback/domain/entity/feedback_entity.dart';
import 'package:events_app/feature/feedback/domain/usecase/feedback_usecase.dart';
import 'package:events_app/feature/feedback/domain/usecase/feedback_usecase_params.dart';
import 'package:events_app/feature/feedback/domain/usecase/submit_feedback_params.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class FeedbackController extends GetxController {
  final GetFeedbackQuestionsUsecase _getQuestionsUsecase;
  final SubmitFeedbackUsecase _submitFeedbackUsecase;

  FeedbackController._({
    required GetFeedbackQuestionsUsecase getQuestionsUsecase,
    required SubmitFeedbackUsecase submitFeedbackUsecase,
  })  : _getQuestionsUsecase = getQuestionsUsecase,
        _submitFeedbackUsecase = submitFeedbackUsecase;

  factory FeedbackController() {
    return FeedbackController._(
      getQuestionsUsecase: networkGetIt<GetFeedbackQuestionsUsecase>(),
      submitFeedbackUsecase: networkGetIt<SubmitFeedbackUsecase>(),
    );
  }

  @visibleForTesting
  static FeedbackController internal({
    required GetFeedbackQuestionsUsecase getQuestionsUsecase,
    required SubmitFeedbackUsecase submitFeedbackUsecase,
  }) {
    return FeedbackController._(
      getQuestionsUsecase: getQuestionsUsecase,
      submitFeedbackUsecase: submitFeedbackUsecase,
    );
  }

  final RxList<FeedbackQuestionEntity> questions =
      <FeedbackQuestionEntity>[].obs;
  final RxMap<int, String> answers = <int, String>{}.obs;
  final RxMap<int, List<int>> selectedOptions = <int, List<int>>{}.obs;
  final RxString comment = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxBool hasSubmitted = false.obs;
  final RxInt currentEventId = 0.obs;

  static FeedbackController get to => Get.find<FeedbackController>();

  static FeedbackController ensureInstance() {
    if (!Get.isRegistered<FeedbackController>()) {
      Get.put(FeedbackController());
    }
    return Get.find<FeedbackController>();
  }

  Future<void> loadQuestions(int eventId) async {
    if (isLoading.value) return;
    currentEventId.value = eventId;
    isLoading.value = true;
    hasSubmitted.value = false;
    questions.clear();
    answers.clear();
    selectedOptions.clear();
    comment.value = '';

    final result = await _getQuestionsUsecase(
        GetFeedbackQuestionsParams(eventId: eventId));

    result.fold(
      (failure) {
        _handleFailure(failure);
        isLoading.value = false;
      },
      (data) {
        questions.assignAll(data);
        isLoading.value = false;
      },
    );
  }

  void setAnswer(int questionId, String value) {
    answers[questionId] = value;
    answers.refresh();
  }

  void toggleOption(int questionId, int optionId) {
    if (!selectedOptions.containsKey(questionId)) {
      selectedOptions[questionId] = [];
    }

    if (selectedOptions[questionId]!.contains(optionId)) {
      selectedOptions[questionId]!.remove(optionId);
    } else {
      selectedOptions[questionId]!.add(optionId);
    }
    selectedOptions.refresh();
  }

  void selectSingleOption(int questionId, int optionId) {
    selectedOptions[questionId] = [optionId];
    selectedOptions.refresh();
  }

  void setComment(String value) {
    comment.value = value;
  }

  bool isRequiredAnswered(FeedbackQuestionEntity question) {
    if (question.isRequired != true) return true;

    switch (question.questionType) {
      case FeedbackQuestionType.text:
        final answer = answers[question.feedbackQuestionId];
        return answer != null && answer.trim().isNotEmpty;
      case FeedbackQuestionType.rating:
        final answer = answers[question.feedbackQuestionId];
        return answer != null && answer.isNotEmpty;
      case FeedbackQuestionType.singleChoice:
        final options = selectedOptions[question.feedbackQuestionId];
        return options != null && options.isNotEmpty;
      case FeedbackQuestionType.multipleChoice:
        final options = selectedOptions[question.feedbackQuestionId];
        return options != null && options.isNotEmpty;
      default:
        return true;
    }
  }

  bool get canSubmit {
    for (final q in questions) {
      if (q.isRequired == true && !isRequiredAnswered(q)) {
        return false;
      }
    }
    return true;
  }

  Future<void> submitFeedback() async {
    if (!canSubmit) {
      AppSnackbarUtils.showError(
          'Thông báo', 'Vui lòng trả lời đầy đủ các câu hỏi bắt buộc');
      return;
    }

    if (isSubmitting.value) return;
    isSubmitting.value = true;

    final answerItems = <FeedbackAnswerItem>[];

    for (final q in questions) {
      final qId = q.feedbackQuestionId!;
      String? answerValue;
      List<int>? selectedOptionIds;

      switch (q.questionType) {
        case FeedbackQuestionType.text:
        case FeedbackQuestionType.rating:
          answerValue = answers[qId];
          break;
        case FeedbackQuestionType.singleChoice:
        case FeedbackQuestionType.multipleChoice:
          selectedOptionIds = selectedOptions[qId];
          break;
        default:
          break;
      }

      answerItems.add(FeedbackAnswerItem(
        questionId: qId,
        answerValue: answerValue,
        selectedOptionIds: selectedOptionIds,
      ));
    }

    final params = SubmitFeedbackParams(
      eventId: currentEventId.value,
      comment: comment.value.isEmpty ? null : comment.value,
      answers: answerItems,
    );

    final result = await _submitFeedbackUsecase(params);

    result.fold(
      (failure) {
        _handleFailure(failure);
        isSubmitting.value = false;
      },
      (_) {
        hasSubmitted.value = true;
        AppSnackbarUtils.showSuccess('Thành công', 'Gửi feedback thành công');
        isSubmitting.value = false;
      },
    );
  }

  void reset() {
    questions.clear();
    answers.clear();
    selectedOptions.clear();
    comment.value = '';
    hasSubmitted.value = false;
  }

  void _handleFailure(FailureEntity failure) {
    AuthController.handleFailure(failure);
  }
}
