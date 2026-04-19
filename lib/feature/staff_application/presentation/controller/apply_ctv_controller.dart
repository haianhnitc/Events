import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/recruitment/domain/entity/ctv_recruitment_entity.dart';
import 'package:events_app/feature/recruitment/domain/usecase/ctv_recruitment_usecase.dart';
import 'package:events_app/feature/recruitment/domain/entity/requirement_question_entity.dart';
import 'package:events_app/feature/staff_application/domain/usecase/apply_ctv_params.dart';
import 'package:events_app/feature/staff_application/domain/usecase/staff_application_usecase.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:get/get.dart';

class ApplyCtvController extends GetxController {
  final GetRecruitmentsUsecase _getRecruitmentsUsecase =
      networkGetIt<GetRecruitmentsUsecase>();
  final CreateStaffApplicationUsecase _createApplicationUsecase =
      networkGetIt<CreateStaffApplicationUsecase>();
  final GetRecruitmentQuestionsUsecase _getRecruitmentQuestionsUsecase =
      networkGetIt<GetRecruitmentQuestionsUsecase>();

  final RxList<CtvRecruitmentEntity> recruitments = <CtvRecruitmentEntity>[].obs;
  final Rx<CtvRecruitmentEntity?> selectedRecruitment = Rx<CtvRecruitmentEntity?>(null);
  final RxList<RequirementQuestionEntity> questions = <RequirementQuestionEntity>[].obs;
  final RxMap<int, String> textAnswers = <int, String>{}.obs;
  final RxMap<int, int> singleChoiceAnswers = <int, int>{}.obs;
  final RxMap<int, List<int>> multipleChoiceAnswers = <int, List<int>>{}.obs;
  final RxString cvUrl = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxBool isLoadingQuestions = false.obs;
  final RxBool hasApplied = false.obs;

  static ApplyCtvController get to => Get.find<ApplyCtvController>();

  static ApplyCtvController ensureInstance() {
    if (!Get.isRegistered<ApplyCtvController>()) {
      Get.put(ApplyCtvController());
    }
    return Get.find<ApplyCtvController>();
  }

  @override
  void onInit() {
    super.onInit();
    loadOpenRecruitments();
  }

  Future<void> loadOpenRecruitments({int? eventId}) async {
    if (isLoading.value) return;
    isLoading.value = true;

    final result = await _getRecruitmentsUsecase(
      GetRecruitmentsParams(eventId: eventId, page: 0, size: 50),
    );

    result.fold(
      (failure) {
        _handleFailure(failure);
        isLoading.value = false;
      },
      (data) {
        final openRecruitments = data.where((r) => r.isOpen == true).toList();
        final canApply = openRecruitments
            .where((r) =>
                r.userEventState == UserEventState.none ||
                r.userEventState == UserEventState.ctvRejected)
            .toList();
        recruitments.assignAll(canApply);
        isLoading.value = false;
      },
    );
  }

  Future<void> selectRecruitment(CtvRecruitmentEntity recruitment) async {
    selectedRecruitment.value = recruitment;
    resetAnswers();
    await _loadQuestionsForRecruitment(recruitment.ctvRecruitmentId!);
  }

  void clearSelection() {
    selectedRecruitment.value = null;
    questions.clear();
    resetAnswers();
  }

  Future<void> _loadQuestionsForRecruitment(int recruitmentId) async {
    isLoadingQuestions.value = true;
    final result = await _getRecruitmentQuestionsUsecase(recruitmentId);
    result.fold(
      (failure) {
        _handleFailure(failure);
        questions.clear();
      },
      (data) {
        questions.assignAll(data);
      },
    );
    isLoadingQuestions.value = false;
  }

  void setTextAnswer(int questionId, String value) {
    textAnswers[questionId] = value;
  }

  void setSingleChoice(int questionId, int optionId) {
    singleChoiceAnswers[questionId] = optionId;
  }

  void setSingleChoiceAnswer(int questionId, int optionId) =>
      setSingleChoice(questionId, optionId);

  void setMultipleChoiceAnswer(int questionId, List<int> selectedIds) {
    multipleChoiceAnswers[questionId] = selectedIds;
  }

  void toggleMultipleChoice(int questionId, int optionId) {
    if (!multipleChoiceAnswers.containsKey(questionId)) {
      multipleChoiceAnswers[questionId] = [];
    }
    if (multipleChoiceAnswers[questionId]!.contains(optionId)) {
      multipleChoiceAnswers[questionId]!.remove(optionId);
    } else {
      multipleChoiceAnswers[questionId]!.add(optionId);
    }
    multipleChoiceAnswers.refresh();
  }

  void setCvUrl(String url) {
    cvUrl.value = url;
  }

  bool isAnswerValid(RequirementQuestionEntity question) {
    if (question.isRequired != true) return true;

    switch (question.questionType) {
      case RequirementQuestionType.text:
        final answer = textAnswers[question.questionId];
        return answer != null && answer.trim().isNotEmpty;
      case RequirementQuestionType.singleChoice:
        return singleChoiceAnswers.containsKey(question.questionId);
      case RequirementQuestionType.multipleChoice:
        final selected = multipleChoiceAnswers[question.questionId];
        return selected != null && selected.isNotEmpty;
      case null:
        return true;
    }
  }

  bool get canSubmit {
    if (selectedRecruitment.value == null) return false;
    for (final q in questions) {
      if (q.isRequired == true && !isAnswerValid(q)) {
        return false;
      }
    }
    return true;
  }

  Future<void> submitApplication() async {
    if (!canSubmit) {
      AppSnackbarUtils.showError('Thông báo', 'Vui lòng trả lời đầy đủ các câu hỏi bắt buộc');
      return;
    }

    if (isSubmitting.value) return;
    isSubmitting.value = true;

    final answers = <AnswerItem>[];

    for (final q in questions) {
      final qId = q.questionId!;

      switch (q.questionType) {
        case RequirementQuestionType.text:
          answers.add(AnswerItem(
            questionId: qId,
            answerText: textAnswers[qId],
          ));
          break;
        case RequirementQuestionType.singleChoice:
          final selectedId = singleChoiceAnswers[qId];
          if (selectedId != null) {
            answers.add(AnswerItem(
              questionId: qId,
              selectedOptionIds: [selectedId],
            ));
          }
          break;
        case RequirementQuestionType.multipleChoice:
          final selectedIds = multipleChoiceAnswers[qId];
          if (selectedIds != null && selectedIds.isNotEmpty) {
            answers.add(AnswerItem(
              questionId: qId,
              selectedOptionIds: selectedIds,
            ));
          }
          break;
        case null:
          break;
      }
    }

    final params = ApplyCtvParams(
      eventId: selectedRecruitment.value!.eventId!,
      cvUrl: cvUrl.value.isEmpty ? null : cvUrl.value,
      answers: answers,
    );

    final result = await _createApplicationUsecase(params);

    result.fold(
      (failure) {
        _handleFailure(failure);
        isSubmitting.value = false;
      },
      (application) {
        hasApplied.value = true;
        final idx = recruitments.indexWhere(
            (r) => r.ctvRecruitmentId == selectedRecruitment.value!.ctvRecruitmentId);
        if (idx != -1) {
          recruitments[idx] = recruitments[idx].copyWith(userEventState: UserEventState.ctvApplied);
        }
        AppSnackbarUtils.showSuccess('Thành công', 'Gửi đơn ứng tuyển CTV thành công!');
        isSubmitting.value = false;
        clearSelection();
      },
    );
  }

  void resetAnswers() {
    textAnswers.clear();
    singleChoiceAnswers.clear();
    multipleChoiceAnswers.clear();
    cvUrl.value = '';
    hasApplied.value = false;
  }

  void _handleFailure(FailureEntity failure) {
    failure.when(
      serverFailure: (_, message) => AppSnackbarUtils.showError('Lỗi', message),
      dataParsingFailure: () => AppSnackbarUtils.showError('Lỗi', 'Không đọc được dữ liệu'),
      noConnectionFailure: () => AppSnackbarUtils.showError('Lỗi', 'Không có kết nối mạng'),
      systemFailure: (_, message) => AppSnackbarUtils.showError('Lỗi', message),
    );
  }
}