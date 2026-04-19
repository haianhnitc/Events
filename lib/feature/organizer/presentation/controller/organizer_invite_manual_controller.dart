import 'package:get/get.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/organizer/participant/domain/usecase/organizer_participant_usecase.dart';
import 'package:events_app/feature/organizer/participant/domain/usecase/organizer_participant_params.dart';

class OrganizerInviteManualController extends GetxController {
  CreateOrganizerParticipantUsecase get _createParticipantUsecase =>
      networkGetIt<CreateOrganizerParticipantUsecase>();

  final RxBool isSubmitting = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> inviteParticipant({
    required int eventId,
    int? userId,
    String? email,
    required ParticipantType participantType,
  }) async {
    if (isSubmitting.value) return;
    if (userId == null && (email == null || email.isEmpty)) {
      errorMessage.value = 'Cần cung cấp userId hoặc email';
      AppSnackbarUtils.showError('Lỗi', 'Cần cung cấp userId hoặc email');
      return;
    }

    isSubmitting.value = true;
    errorMessage.value = '';

    final result =
        await _createParticipantUsecase(CreateOrganizerParticipantParams(
      eventId: eventId,
      userId: userId,
      email: email,
      participantType: participantType,
    ));

    result.fold(
      (failure) {
        _handleFailure(failure);
        isSubmitting.value = false;
      },
      (participant) {
        AppSnackbarUtils.showSuccess(
            'Thành công', 'Thêm người tham gia thành công');
        Get.back(result: participant);
        isSubmitting.value = false;
      },
    );
  }

  void _handleFailure(FailureEntity failure) {
    failure.when(
      serverFailure: (_, message) {
        errorMessage.value = message ?? 'Mời người tham gia thất bại';
        AppSnackbarUtils.showError(
            'Lỗi', message ?? 'Mời người tham gia thất bại');
      },
      dataParsingFailure: () {
        errorMessage.value = 'Dữ liệu không hợp lệ';
        AppSnackbarUtils.showError('Lỗi', 'Dữ liệu không hợp lệ');
      },
      noConnectionFailure: () {
        errorMessage.value = 'Không có kết nối mạng';
        AppSnackbarUtils.showError('Lỗi', 'Không có kết nối mạng');
      },
      systemFailure: (_, message) {
        errorMessage.value = message ?? 'Lỗi hệ thống';
        AppSnackbarUtils.showError('Lỗi', message ?? 'Lỗi hệ thống');
      },
    );
  }
}
