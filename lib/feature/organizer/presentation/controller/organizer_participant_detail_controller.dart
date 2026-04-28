import 'package:get/get.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/feedback/domain/entity/feedback_entity.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';
import 'package:events_app/feature/organizer/participant/domain/usecase/organizer_participant_usecase.dart';
import 'package:events_app/feature/organizer/feedback/domain/usecase/organizer_feedback_usecase.dart';
import 'package:events_app/feature/organizer/feedback/domain/usecase/organizer_feedback_params.dart';

class OrganizerParticipantDetailController extends GetxController {
  GetOrganizerParticipantByIdUsecase get _getParticipantByIdUsecase =>
      networkGetIt<GetOrganizerParticipantByIdUsecase>();
  GetOrganizerFeedbacksUsecase get _getFeedbacksUsecase =>
      networkGetIt<GetOrganizerFeedbacksUsecase>();

  final Rx<ParticipantEntity?> participant = Rx<ParticipantEntity?>(null);
  final RxList<FeedbackEntity> feedbacks = <FeedbackEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingFeedbacks = false.obs;

  Future<void> loadParticipant(int participantId) async {
    isLoading.value = true;
    final result = await _getParticipantByIdUsecase(participantId);
    result.fold(
      (failure) {
        _handleFailure(failure);
        isLoading.value = false;
      },
      (data) async {
        participant.value = data;
        isLoading.value = false;
        _loadFeedbacks();
      },
    );
  }

  Future<void> _loadFeedbacks() async {
    final p = participant.value;
    if (p == null || p.eventId == null || p.eventParticipantId == null) return;
    isLoadingFeedbacks.value = true;
    final result = await _getFeedbacksUsecase(
      GetOrganizerFeedbacksParams(
        eventId: p.eventId,
        participantId: p.eventParticipantId,
      ),
    );
    result.fold(
      (failure) {
        isLoadingFeedbacks.value = false;
      },
      (data) {
        feedbacks.assignAll(data);
        isLoadingFeedbacks.value = false;
      },
    );
  }

  void _handleFailure(FailureEntity failure) {
    failure.when(
      serverFailure: (_, message) => AppSnackbarUtils.showError('Lỗi', message ?? 'Lấy chi tiết thất bại'),
      dataParsingFailure: () => AppSnackbarUtils.showError('Lỗi', 'Không đọc được dữ liệu'),
      noConnectionFailure: () => AppSnackbarUtils.showError('Lỗi', 'Không có kết nối mạng'),
      systemFailure: (_, message) => AppSnackbarUtils.showError('Lỗi', message ?? 'Lỗi hệ thống'),
    );
  }
}
