import 'dart:async';

import 'package:get/get.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/attendance/domain/entity/attendance_entity.dart';
import 'package:events_app/feature/organizer/attendance/domain/usecase/organizer_attendance_usecase.dart';

class OrganizerEventQrController extends GetxController {
  GetOrganizerParticipantQrUsecase get _getParticipantQrUsecase =>
      networkGetIt<GetOrganizerParticipantQrUsecase>();
  GetOrganizerEventQrUsecase get _getEventQrUsecase =>
      networkGetIt<GetOrganizerEventQrUsecase>();

  final Rx<AttendanceQrEntity?> eventQr = Rx<AttendanceQrEntity?>(null);
  final Rx<AttendanceQrEntity?> participantQr = Rx<AttendanceQrEntity?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  Timer? _expiryTimer;

  @override
  void onClose() {
    _expiryTimer?.cancel();
    super.onClose();
  }

  Future<void> loadParticipantQr(int eventParticipantId) async {
    if (isLoading.value) return;
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _getParticipantQrUsecase(eventParticipantId);
    result.fold(
      (failure) {
        _handleFailure(failure);
        isLoading.value = false;
      },
      (qr) {
        participantQr.value = qr;
        isLoading.value = false;
      },
    );
  }

  Future<void> loadEventQr(int eventId) async {
    if (isLoading.value) return;
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _getEventQrUsecase(eventId);
    result.fold(
      (failure) {
        _handleFailure(failure);
        isLoading.value = false;
      },
      (qr) {
        eventQr.value = qr;
        isLoading.value = false;
        _scheduleExpiryRefresh(eventId, qr);
      },
    );
  }

  void _scheduleExpiryRefresh(int eventId, AttendanceQrEntity qr) {
    _expiryTimer?.cancel();
    if (qr.expiryTime == null) return;

    final remaining = qr.expiryTime!.difference(DateTime.now());
    if (remaining.isNegative || remaining.inSeconds < 1) {
      loadEventQr(eventId);
      return;
    }

    _expiryTimer = Timer(remaining, () {
      loadEventQr(eventId);
    });
  }

  void clear() {
    eventQr.value = null;
    participantQr.value = null;
    errorMessage.value = '';
    _expiryTimer?.cancel();
  }

  Duration? get remaining {
    final qr = eventQr.value;
    if (qr?.expiryTime == null) return null;
    final diff = qr!.expiryTime!.difference(DateTime.now());
    return diff.isNegative ? Duration.zero : diff;
  }

  bool get isExpired => remaining == null || remaining!.inSeconds <= 0;

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
        AppSnackbarUtils.showError('Lỗi', displayMessage);
      },
    );
  }

  String _mapBeErrorMessage(String? rawMessage) {
    if (rawMessage == null || rawMessage.isEmpty) return 'Thao tác thất bại';

    final lower = rawMessage.toLowerCase();

    if (lower.contains('not found') ||
        lower.contains('không tồn tại')) {
      return 'Không tìm thấy người tham gia này.';
    }
    if (lower.contains('permission') ||
        lower.contains('quyền')) {
      return 'Bạn không có quyền lấy QR của người này.';
    }
    if (lower.contains('already checked in')) {
      return 'Người này đã check-in. Cần check-in trước khi lấy QR check-out.';
    }
    if (lower.contains('must check-in')) {
      return 'Người này cần check-in trước khi lấy QR check-out.';
    }
    if (lower.contains('event not started') ||
        lower.contains('sự kiện chưa bắt đầu')) {
      return 'Sự kiện chưa bắt đầu. Không thể lấy mã QR.';
    }

    return rawMessage;
  }
}
