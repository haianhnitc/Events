import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/feedback/domain/entity/feedback_entity.dart';
import 'package:events_app/feature/organizer/feedback/domain/usecase/organizer_feedback_usecase.dart';
import 'package:events_app/feature/organizer/feedback/domain/usecase/organizer_feedback_params.dart';
import 'package:get/get.dart';

class OrganizerFeedbackController extends GetxController {
  final DeleteFeedbackQuestionsUsecase _deleteFeedbackQuestionsUsecase =
      networkGetIt<DeleteFeedbackQuestionsUsecase>();

  final RxSet<int> selectedQuestionIds = <int>{}.obs;
  final RxBool isDeleting = false.obs;

  bool get hasSelection => selectedQuestionIds.isNotEmpty;
  int get selectedCount => selectedQuestionIds.length;

  void toggleSelection(int questionId) {
    if (selectedQuestionIds.contains(questionId)) {
      selectedQuestionIds.remove(questionId);
    } else {
      selectedQuestionIds.add(questionId);
    }
  }

  void selectAll(List<FeedbackQuestionEntity> questions) {
    selectedQuestionIds.addAll(questions.map((q) => q.feedbackQuestionId!));
  }

  void clearSelection() {
    selectedQuestionIds.clear();
  }

  Future<bool> deleteSelectedQuestions() async {
    if (!hasSelection) return false;

    isDeleting.value = true;

    final params = DeleteFeedbackQuestionsParams(
      questionIds: selectedQuestionIds.toList(),
    );

    final result = await _deleteFeedbackQuestionsUsecase(params);

    return result.fold(
      (failure) {
        _handleFailure(failure);
        isDeleting.value = false;
        return false;
      },
      (_) {
        isDeleting.value = false;
        return true;
      },
    );
  }

  void _handleFailure(FailureEntity failure) {
    AuthController.handleFailure(failure);
  }
}
