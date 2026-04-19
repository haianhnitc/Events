import 'package:get/get.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/attendance/domain/entity/event_attendance_log_entity.dart';
import 'package:events_app/feature/organizer/attendance/domain/usecase/organizer_attendance_usecase.dart';
import 'package:events_app/feature/organizer/attendance/domain/usecase/organizer_attendance_params.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';
import 'package:events_app/feature/participant/domain/usecase/participant_usecase.dart';

class OrganizerManualCheckinController extends GetxController {
  OrganizerManualCheckInUsecase get _manualCheckInUsecase =>
      networkGetIt<OrganizerManualCheckInUsecase>();
  OrganizerManualCheckOutUsecase get _manualCheckOutUsecase =>
      networkGetIt<OrganizerManualCheckOutUsecase>();
  GetParticipantByIdUsecase get _getParticipantByIdUsecase =>
      networkGetIt<GetParticipantByIdUsecase>();

  final RxBool isSubmitting = false.obs;
  final Rx<EventAttendanceLogEntity?> lastResult = Rx<EventAttendanceLogEntity?>(null);
  final RxString errorMessage = ''.obs;

  Future<bool> manualCheckIn(int eventParticipantId) async {
    if (isSubmitting.value) return false;
    isSubmitting.value = true;
    errorMessage.value = '';

    final validationError = await _preValidateManualCheckIn(eventParticipantId);
    if (validationError != null) {
      errorMessage.value = validationError;
      AppSnackbarUtils.showError('Không thể check-in', validationError);
      isSubmitting.value = false;
      return false;
    }

    final result = await _manualCheckInUsecase(
      OrganizerManualAttendanceParams(eventParticipantId: eventParticipantId),
    );

    bool success = false;
    result.fold(
      (failure) {
        _handleFailure(failure);
        isSubmitting.value = false;
      },
      (log) {
        AppSnackbarUtils.showSuccess('Thành công', 'Check-in thủ công thành công');
        lastResult.value = log;
        isSubmitting.value = false;
        success = true;
      },
    );

    return success;
  }

  Future<bool> manualCheckOut(int eventParticipantId) async {
    if (isSubmitting.value) return false;
    isSubmitting.value = true;
    errorMessage.value = '';

    final validationError = await _preValidateManualCheckOut(eventParticipantId);
    if (validationError != null) {
      errorMessage.value = validationError;
      AppSnackbarUtils.showError('Không thể check-out', validationError);
      isSubmitting.value = false;
      return false;
    }

    final result = await _manualCheckOutUsecase(
      OrganizerManualAttendanceParams(eventParticipantId: eventParticipantId),
    );

    bool success = false;
    result.fold(
      (failure) {
        _handleFailure(failure);
        isSubmitting.value = false;
      },
      (log) {
        AppSnackbarUtils.showSuccess('Thành công', 'Check-out thủ công thành công');
        lastResult.value = log;
        isSubmitting.value = false;
        success = true;
      },
    );

    return success;
  }

  Future<String?> _preValidateManualCheckIn(int eventParticipantId) async {
    final participant = await _fetchParticipant(eventParticipantId);
    if (participant == null) {
      return 'Không tìm thấy người tham gia này.';
    }

    if (participant.status != ParticipantStatus.registered) {
      if (participant.status == ParticipantStatus.attended) {
        return 'Người này đã tham dự sự kiện.';
      }
      if (participant.status == ParticipantStatus.noShow) {
        return 'Người này đã vắng mặt (no-show).';
      }
      return 'Người này đã hủy đăng ký sự kiện.';
    }

    if (participant.hasCheckedIn == true) {
      return 'Người này đã check-in rồi.';
    }

    if (participant.isCheckOut == true) {
      return 'Người này đã check-out rồi.';
    }

    return null;
  }

  Future<String?> _preValidateManualCheckOut(int eventParticipantId) async {
    final participant = await _fetchParticipant(eventParticipantId);
    if (participant == null) {
      return 'Không tìm thấy người tham gia này.';
    }

    if (participant.hasCheckedIn != true) {
      return 'Người này chưa check-in. Vui lòng check-in trước.';
    }

    if (participant.isCheckOut == true) {
      return 'Người này đã check-out rồi.';
    }

    return null;
  }

  Future<ParticipantEntity?> _fetchParticipant(int eventParticipantId) async {
    final result = await _getParticipantByIdUsecase(eventParticipantId);
    return result.fold((_) => null, (p) => p);
  }

  void clearResult() {
    lastResult.value = null;
    errorMessage.value = '';
  }

  void _handleFailure(FailureEntity failure) {
    String displayMessage = 'Thao tác thất bại';
    failure.when(
      serverFailure: (_, message) {
        displayMessage = _mapBeErrorMessage(message);
        errorMessage.value = displayMessage;
        AppSnackbarUtils.showError('Lỗi', displayMessage);
      },
      dataParsingFailure: () {
        displayMessage = 'Dữ liệu không hợp lệ';
        errorMessage.value = displayMessage;
        AppSnackbarUtils.showError('Lỗi', displayMessage);
      },
      noConnectionFailure: () {
        displayMessage = 'Không có kết nối mạng';
        errorMessage.value = displayMessage;
        AppSnackbarUtils.showError('Lỗi', displayMessage);
      },
      systemFailure: (_, message) {
        displayMessage = message ?? 'Lỗi hệ thống';
        errorMessage.value = displayMessage;
        AppSnackbarUtils.showError('Lỗi', message ?? 'Lỗi hệ thống');
      },
    );
  }

  String _mapBeErrorMessage(String? rawMessage) {
    if (rawMessage == null || rawMessage.isEmpty) return 'Thao tác thất bại';

    final lower = rawMessage.toLowerCase();

    if (lower.contains('not found') ||
        lower.contains('không tồn tại')) {
      return 'Không tìm thấy người tham gia.';
    }
    if (lower.contains('permission') ||
        lower.contains('quyền')) {
      return 'Bạn không có quyền thực hiện thao tác này.';
    }
    if (lower.contains('already checked in') ||
        lower.contains('đã check-in')) {
      return 'Người này đã check-in rồi.';
    }
    if (lower.contains('already checked out') ||
        lower.contains('đã check-out')) {
      return 'Người này đã check-out rồi.';
    }
    if (lower.contains('must check-in') ||
        lower.contains('chưa check-in')) {
      return 'Người này chưa check-in. Cần check-in trước.';
    }
    if (lower.contains('ctv only') ||
        lower.contains('attendee only')) {
      return 'Loại người tham gia không phù hợp với hình thức đăng ký của sự kiện này.';
    }
    if (lower.contains('ctv') && lower.contains('requires qr')) {
      return 'CTV cần quét mã QR để check-in, không thể check-in thủ công.';
    }
    if (lower.contains('paid') || lower.contains('ticket')) {
      return 'Người này có vé có phí, cần quét mã vé để check-in.';
    }
    if (lower.contains('must submit feedback')) {
      return 'Người này cần hoàn thành đánh giá trước khi check-out.';
    }

    return rawMessage;
  }
}
