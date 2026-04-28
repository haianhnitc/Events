import 'dart:async';

import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/attendance/domain/entity/attendance_entity.dart';
import 'package:events_app/feature/attendance/domain/usecase/attendance_usecase.dart';
import 'package:events_app/feature/attendance/domain/usecase/scan_qr_params.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';
import 'package:events_app/feature/participant/domain/usecase/participant_usecase.dart';
import 'package:get/get.dart';

class MyQrController extends GetxController {
  final GetParticipantQrUsecase _getParticipantQrUsecase =
      networkGetIt<GetParticipantQrUsecase>();
  final GetEventQrUsecase _getEventQrUsecase =
      networkGetIt<GetEventQrUsecase>();
  final GetMyParticipantsUsecase _getParticipantsUsecase =
      networkGetIt<GetMyParticipantsUsecase>();

  final RxList<ParticipantEntity> _participants = <ParticipantEntity>[].obs;
  final RxMap<int, AttendanceQrEntity> _qrMap = <int, AttendanceQrEntity>{}.obs;
  final RxMap<int, Timer?> _expiryTimers = <int, Timer?>{}.obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;

  static MyQrController get to => Get.find<MyQrController>();

  static MyQrController ensureInstance() {
    if (!Get.isRegistered<MyQrController>()) {
      Get.put(MyQrController());
    }
    return Get.find<MyQrController>();
  }

  @override
  void onInit() {
    super.onInit();
    loadParticipants();
  }

  @override
  void onClose() {
    for (final timer in _expiryTimers.values) {
      timer?.cancel();
    }
    super.onClose();
  }

  List<ParticipantEntity> get participants => _participants;

  AttendanceQrEntity? getQrFor(int eventParticipantId) =>
      _qrMap[eventParticipantId];

  bool canShowQr(ParticipantEntity participant) {
    if (participant.isCheckOut == true) return false;
    if (participant.hasCheckedIn == true) return false;
    if (participant.participantType == ParticipantType.ctv) return false;
    final qr = _qrMap[participant.eventParticipantId];
    if (qr == null) return false;
    return qr.scanMethod == ScanMethod.eventQr;
  }

  bool needsStaffQr(ParticipantEntity participant) {
    if (participant.participantType == ParticipantType.ctv) return true;
    if (participant.participantType == ParticipantType.attendee &&
        participant.ticketId != null) {
      final qr = _qrMap[participant.eventParticipantId];
      return qr?.scanMethod == ScanMethod.staffQr;
    }
    return false;
  }

  Future<void> loadParticipants() async {
    if (isLoading.value) return;
    isLoading.value = true;

    final currentUserId = _getCurrentUserId();
    if (currentUserId == null) {
      isLoading.value = false;
      return;
    }

    final result = await _getParticipantsUsecase(
      GetMyParticipantsParams(userId: currentUserId, page: 0, size: 50),
    );

    result.fold(
      (failure) {
        _handleFailure(failure);
        isLoading.value = false;
      },
      (data) {
        _participants.assignAll(data);
        isLoading.value = false;
        _loadQrsForParticipants(data);
      },
    );
  }

  Future<void> refreshQr() async {
    if (isRefreshing.value) return;
    isRefreshing.value = true;

    for (final p in _participants) {
      if (p.eventParticipantId != null && p.isCheckOut != true) {
        await _loadQrForParticipant(p);
      }
    }

    isRefreshing.value = false;
  }

  Future<void> _loadQrsForParticipants(List<ParticipantEntity> participants) async {
    for (final p in participants) {
      if (p.eventParticipantId != null && p.isCheckOut != true) {
        await _loadQrForParticipant(p);
      }
    }
  }

  Future<void> loadQrFor(ParticipantEntity participant) async {
    if (participant.eventParticipantId == null || participant.isCheckOut == true) return;
    await _loadQrForParticipant(participant);
  }

  Future<void> _loadQrForParticipant(ParticipantEntity participant) async {
    final epId = participant.eventParticipantId!;
    final participantType = participant.participantType;
    final ticketId = participant.ticketId;

    AttendanceQrEntity? qr;

    final resolvedEventId = participant.event?.eventId ?? participant.eventId;
    if (resolvedEventId == null) return;

    if (participantType == ParticipantType.attendee && ticketId != null) {
      final result = await _getParticipantQrUsecase(
        GetParticipantQrParams(eventParticipantId: epId),
      );
      result.fold((_) {}, (qrData) => qr = qrData);
    } else if (participantType == ParticipantType.ctv ||
        (participantType == ParticipantType.attendee && ticketId == null)) {
      final result = await _getEventQrUsecase(
        GetEventQrParams(eventId: resolvedEventId, action: 'CHECKIN'),
      );
      result.fold((_) {}, (qrData) => qr = qrData);
    }

    if (qr != null) {
      _qrMap[epId] = qr!;
      _startExpiryTimer(epId, qr!);
    }
  }

  void _startExpiryTimer(int eventParticipantId, AttendanceQrEntity qr) {
    _expiryTimers[eventParticipantId]?.cancel();

    if (qr.expiryTime == null) return;

    final now = DateTime.now();
    final remaining = qr.expiryTime!.difference(now);

    if (remaining.isNegative) {
      _refreshSingleQr(eventParticipantId);
      return;
    }

    _expiryTimers[eventParticipantId] = Timer(remaining, () {
      _refreshSingleQr(eventParticipantId);
    });
  }

  Future<void> _refreshSingleQr(int eventParticipantId) async {
    final participant = _participants.firstWhereOrNull(
      (p) => p.eventParticipantId == eventParticipantId,
    );
    if (participant == null) return;

    await _loadQrForParticipant(participant);
  }

  void removeQr(int eventParticipantId) {
    _qrMap.remove(eventParticipantId);
    _expiryTimers[eventParticipantId]?.cancel();
    _expiryTimers.remove(eventParticipantId);
  }

  void markFeedbackSubmitted(int eventParticipantId) {
    final index = _participants.indexWhere(
      (p) => p.eventParticipantId == eventParticipantId,
    );
    if (index == -1) return;
    _participants[index] = _participants[index].copyWith(
      hasFeedback: true,
      feedbackSubmittedTime: DateTime.now(),
    );
  }

  int? getCurrentUserId() => _getCurrentUserId();

  int? _getCurrentUserId() {
    final user = AuthController.to.currentUser.value;
    return user?.userId;
  }

  void _handleFailure(FailureEntity failure) {
    failure.when(
      serverFailure: (_, message) => AppSnackbarUtils.showError('Lỗi', _mapBeErrorMessage(message)),
      dataParsingFailure: () =>
          AppSnackbarUtils.showError('Lỗi', 'Không đọc được dữ liệu'),
      noConnectionFailure: () =>
          AppSnackbarUtils.showError('Lỗi', 'Không có kết nối mạng'),
      systemFailure: (_, message) => AppSnackbarUtils.showError('Lỗi', message ?? 'Lỗi hệ thống'),
    );
  }

  String _mapBeErrorMessage(String? rawMessage) {
    if (rawMessage == null || rawMessage.isEmpty) return 'Đã xảy ra lỗi';

    final lower = rawMessage.toLowerCase();

    if (lower.contains('not found') ||
        lower.contains('không tồn tại')) {
      return 'Không tìm thấy thông tin đăng ký của bạn.';
    }
    if (lower.contains('permission') ||
        lower.contains('quyền')) {
      return 'Bạn không có quyền lấy mã QR này.';
    }
    if (lower.contains('must check-in') ||
        lower.contains('chưa check-in')) {
      return 'Bạn cần check-in trước khi lấy mã QR check-out.';
    }
    if (lower.contains('already checked in') ||
        lower.contains('đã check-in rồi')) {
      return 'Bạn đã check-in rồi. Không thể lấy mã QR sự kiện.';
    }
    if (lower.contains('qr has expired') ||
        lower.contains('hết hạn')) {
      return 'Mã QR đã hết hạn. Vui lòng làm mới.';
    }
    if (lower.contains('invalid qr')) {
      return 'Mã QR không hợp lệ.';
    }
    if (lower.contains('free attendee check-in') ||
        lower.contains('do not require participant qr') ||
        lower.contains('use event qr')) {
      return 'Vé miễn phí không cần QR cá nhân. Hãy dùng QR sự kiện do ban tổ chức cung cấp.';
    }

    return rawMessage;
  }
}
