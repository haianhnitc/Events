import 'package:get/get.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/feedback/domain/entity/feedback_entity.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/organizer/feedback/domain/usecase/organizer_feedback_usecase.dart';
import 'package:events_app/feature/organizer/feedback/domain/usecase/organizer_feedback_params.dart';

class OrganizerFeedbackListController extends GetxController {
  GetOrganizerFeedbacksUsecase get _getFeedbacksUsecase =>
      networkGetIt<GetOrganizerFeedbacksUsecase>();
  GetOrganizerFeedbackQuestionsUsecase get _getQuestionsUsecase =>
      networkGetIt<GetOrganizerFeedbackQuestionsUsecase>();

  final RxList<FeedbackEntity> feedbacks = <FeedbackEntity>[].obs;
  final RxList<FeedbackQuestionEntity> questions = <FeedbackQuestionEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final RxInt currentPage = 0.obs;
  final Rx<int?> filterEventId = Rx<int?>(null);

  Future<void> loadFeedbacks({bool refresh = false}) async {
    final eventId = filterEventId.value;
    if (eventId == null) return;

    if (refresh) {
      currentPage.value = 0;
      hasMore.value = true;
      feedbacks.clear();
      questions.clear();
    }
    if (!hasMore.value && !refresh) return;

    isLoading.value = true;
    final result = await _getFeedbacksUsecase(GetOrganizerFeedbacksParams(
      eventId: eventId,
      page: currentPage.value,
      size: 20,
    ));

    result.fold(
      (failure) {
        _handleFailure(failure);
        isLoading.value = false;
      },
      (data) {
        if (refresh) {
          feedbacks.assignAll(data);
        } else {
          feedbacks.addAll(data);
        }
        hasMore.value = data.length >= 20;
        currentPage.value++;
        isLoading.value = false;
        _loadQuestions();
      },
    );
  }

  Future<void> _loadQuestions() async {
    final eventId = filterEventId.value;
    if (eventId == null) return;

    final result = await _getQuestionsUsecase(eventId);
    result.fold(
      (_) {},
      (data) => questions.assignAll(data),
    );
  }

  Future<void> refresh() async {
    await loadFeedbacks(refresh: true);
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoadingMore.value) return;
    isLoadingMore.value = true;
    await loadFeedbacks();
    isLoadingMore.value = false;
  }

  void setEventFilter(int? eventId) {
    filterEventId.value = eventId;
    loadFeedbacks(refresh: true);
  }

  int get totalFeedbacks => feedbacks.length;

  double? get averageRating {
    final ratings = <double>[];
    for (final fb in feedbacks) {
      final answers = fb.feedbackAnswers ?? [];
      for (final a in answers) {
        if (a.questionType == FeedbackQuestionType.rating &&
            a.answerValue != null) {
          final parsed = double.tryParse(a.answerValue!);
          if (parsed != null) ratings.add(parsed);
        }
      }
    }
    if (ratings.isEmpty) return null;
    return ratings.reduce((a, b) => a + b) / ratings.length;
  }

  Map<int, Map<String, int>> get answerDistribution {
    final dist = <int, Map<String, int>>{};
    for (final q in questions) {
      if (q.feedbackQuestionId == null) continue;
      dist[q.feedbackQuestionId!] = {};
    }
    for (final fb in feedbacks) {
      final answers = fb.feedbackAnswers ?? [];
      for (final a in answers) {
        if (a.questionId == null || a.answerValue == null) continue;
        final q = questions.firstWhereOrNull(
            (q) => q.feedbackQuestionId == a.questionId);
        if (q == null) continue;
        if (q.questionType == FeedbackQuestionType.rating ||
            q.questionType == FeedbackQuestionType.singleChoice ||
            q.questionType == FeedbackQuestionType.multipleChoice) {
          dist[a.questionId!] ??= {};
          dist[a.questionId!]![a.answerValue!] =
              (dist[a.questionId!]![a.answerValue!] ?? 0) + 1;
        }
      }
    }
    return dist;
  }

  void _handleFailure(FailureEntity failure) {
    AuthController.handleFailure(failure);
  }
}
