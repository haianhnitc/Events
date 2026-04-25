import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/common/utils/app_distance_utils.dart';
import 'package:events_app/common/utils/app_location_service.dart';
import 'package:events_app/common/utils/permission_helper.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/attendance/domain/entity/attendance_entity.dart';
import 'package:events_app/feature/attendance/domain/usecase/attendance_usecase.dart';
import 'package:events_app/feature/attendance/domain/usecase/scan_qr_params.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/event_management/domain/entity/event_entity.dart';
import 'package:events_app/feature/event_management/domain/usecase/get_event_by_id_usecase.dart';
import 'package:events_app/feature/feedback/domain/usecase/feedback_usecase.dart';
import 'package:events_app/feature/feedback/domain/usecase/feedback_usecase_params.dart';
import 'package:events_app/feature/feedback/presentation/page/feedback_page.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';
import 'package:events_app/feature/participant/domain/usecase/participant_usecase.dart';
import 'package:permission_handler/permission_handler.dart';

enum CameraPermissionState {
  checking,
  granted,
  denied,
  permanentlyDenied,
}

enum QrScanMode {
  auto,
  checkInOnly,
  checkOutOnly,
}

class ScanQrController extends GetxController with GetTickerProviderStateMixin {
  late final AnimationController lineAnimationController;
  late final Animation<double> lineAnimation;
  MobileScannerController? mobileScannerController;

  final Rx<CameraPermissionState> permissionState =
      CameraPermissionState.checking.obs;
  final RxBool isProcessing = false.obs;
  final RxString lastScan = ''.obs;
  final RxBool showSuccessOverlay = false.obs;
  final Rx<AttendanceAction?> lastAction = Rx<AttendanceAction?>(null);
  final Rx<AttendanceScanResultEntity?> lastScanResult =
      Rx<AttendanceScanResultEntity?>(null);
  final RxString lastError = ''.obs;

  final RxBool isPendingFeedbackCheckOut = false.obs;
  final Rx<int?> pendingEventParticipantId = Rx<int?>(null);
  final Rx<int?> pendingEventId = Rx<int?>(null);
  final RxString pendingQrContent = ''.obs;
  final Rx<double?> pendingLatitude = Rx<double?>(null);
  final Rx<double?> pendingLongitude = Rx<double?>(null);

  final PermissionHelper _permissionHelper = PermissionHelper();
  final AppLocationService _locationService = AppLocationService();
  final SelfCheckInUsecase _selfCheckinUsecase =
      networkGetIt<SelfCheckInUsecase>();
  final GetMyParticipantsUsecase _getParticipantsUsecase =
      networkGetIt<GetMyParticipantsUsecase>();
  final GetFeedbackQuestionsUsecase _getFeedbackQuestionsUsecase =
      networkGetIt<GetFeedbackQuestionsUsecase>();
  final GetEventByIdUsecase _getEventByIdUsecase =
      networkGetIt<GetEventByIdUsecase>();

  static ScanQrController get to => Get.find<ScanQrController>();

  static ScanQrController ensureInstance() {
    if (!Get.isRegistered<ScanQrController>()) {
      Get.put(ScanQrController());
    }
    return Get.find<ScanQrController>();
  }

  @override
  void onInit() {
    super.onInit();
    lineAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    lineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: lineAnimationController, curve: Curves.linear),
    );
    _checkCameraPermission();
  }

  @override
  void onClose() {
    mobileScannerController?.dispose();
    lineAnimationController.dispose();
    super.onClose();
  }

  Future<void> _checkCameraPermission() async {
    final result = await _permissionHelper.requestCameraPermission();

    if (!Get.isRegistered<ScanQrController>()) return;

    switch (result.status) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
      case PermissionStatus.provisional:
        permissionState.value = CameraPermissionState.granted;
        mobileScannerController = MobileScannerController();
        break;
      case PermissionStatus.permanentlyDenied:
        permissionState.value = CameraPermissionState.permanentlyDenied;
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      default:
        permissionState.value = CameraPermissionState.denied;
        break;
    }
  }

  Future<bool> retryCameraPermission() async {
    permissionState.value = CameraPermissionState.checking;
    await _checkCameraPermission();
    return permissionState.value == CameraPermissionState.granted;
  }

  Future<void> openAppSettings() async {
    await _permissionHelper.openSettings();
  }

  void onBarcodeDetected(BarcodeCapture barcodeCapture) {
    if (isProcessing.value || showSuccessOverlay.value) return;

    final barcodes = barcodeCapture.barcodes;
    if (barcodes.isEmpty) return;

    final barcode = barcodes.first;
    final code = barcode.rawValue;
    if (code == null || code.isEmpty) return;

    _processCode(code);
  }

  Future<void> toggleTorch() async {
    try {
      await mobileScannerController?.toggleTorch();
    } catch (_) {}
  }

  Future<void> _processCode(String code) async {
    isProcessing.value = true;
    lastScan.value = code;
    mobileScannerController?.stop();

    final currentUser = _getCurrentUser();

    if (currentUser == null) {
      _showErrorSnackbar('Lỗi',
          'Không tìm thấy thông tin người dùng. Vui lòng đăng nhập lại.');
      _resumeScanner();
      return;
    }

    final userId = currentUser.userId;
    if (userId == null) {
      _showErrorSnackbar('Lỗi', 'Không tìm thấy ID người dùng.');
      _resumeScanner();
      return;
    }

    final qrParseError = _validateQrFormat(code);
    if (qrParseError != null) {
      _showErrorSnackbar('Mã QR không hợp lệ', qrParseError);
      _resumeScanner();
      return;
    }

    final eventIdFromQr = _parseEventIdFromQr(code);
    if (eventIdFromQr == null) {
      _showErrorSnackbar('Mã QR không hợp lệ', 'Mã QR không đúng định dạng sự kiện.');
      _resumeScanner();
      return;
    }

    if (_isQrExpired(code)) {
      _showErrorSnackbar('Mã QR hết hạn',
          'Mã QR đã hết hạn (1 tiếng). Vui lòng tạo mã mới.');
      _resumeScanner();
      return;
    }

    final participant = await _findParticipantByQrAndUserId(code, userId);

    if (participant == null) {
      _showErrorSnackbar('Không tìm thấy',
          'Bạn chưa đăng ký tham gia sự kiện này hoặc mã QR không hợp lệ.');
      _resumeScanner();
      return;
    }

    if (participant.eventId != eventIdFromQr) {
      _showErrorSnackbar(
          'Sai sự kiện', 'Mã QR không thuộc sự kiện bạn đã đăng ký.');
      _resumeScanner();
      return;
    }

    final event = await _getEventById(participant.eventId!);
    final coords = await _getCurrentLocation();
    final action = _determineAction(participant);

    if (action == AttendanceAction.checkIn) {
      final error = _validateCheckIn(
        participant: participant,
        event: event,
        currentLocation: coords,
        eventIdFromQr: eventIdFromQr,
      );
      if (error != null) {
        _showErrorSnackbar('Không thể check-in', error);
        _resumeScanner();
        return;
      }
    } else {
      final shouldCancel = await _validateCheckOut(
        participant: participant,
        event: event,
        currentLocation: coords,
        code: code,
      );
      if (shouldCancel) return;
    }

    final result = await _processQrContent(
      code,
      eventParticipantId: participant.eventParticipantId,
      action: action,
      latitude: coords?.latitude,
      longitude: coords?.longitude,
    );

    if (!Get.isRegistered<ScanQrController>()) return;

    if (result != null) {
      _onScanSuccess(participant, action, result, event);
    } else {
      final mappedMessage = _mapBeErrorMessage(lastError.value);
      _showErrorSnackbar(
        'Thất bại',
        mappedMessage.isNotEmpty
            ? mappedMessage
            : 'Xử lý QR thất bại. Vui lòng thử lại.',
      );
      _resumeScanner();
    }
  }

  String? _validateQrFormat(String code) {
    if (!code.startsWith('EVENT:')) {
      return 'Bạn cần quét mã QR của sự kiện (EVENT), không phải mã QR cá nhân.';
    }
    final parts = code.split(':');
    if (parts.length != 4) {
      return 'Mã QR không đúng định dạng. Vui lòng quét lại.';
    }
    return null;
  }

  int? _parseEventIdFromQr(String code) {
    final parts = code.split(':');
    if (parts.length != 4) return null;
    return int.tryParse(parts[1]);
  }

  bool _isQrExpired(String code) {
    final parts = code.split(':');
    if (parts.length != 4) return true;
    final timestamp = int.tryParse(parts[2]);
    if (timestamp == null) return true;
    final qrTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateTime.now().difference(qrTime).inHours >= 1;
  }

  String? _validateCheckIn({
    required ParticipantEntity participant,
    required EventEntity? event,
    required LocationCoords? currentLocation,
    required int eventIdFromQr,
  }) {
    if (participant.hasCheckedIn == true) {
      return 'Bạn đã check-in sự kiện này rồi.';
    }

    if (participant.status != ParticipantStatus.registered) {
      if (participant.status == ParticipantStatus.attended) {
        return 'Bạn đã tham dự sự kiện này.';
      }
      if (participant.status == ParticipantStatus.noShow) {
        return 'Bạn đã vắng mặt (no-show) sự kiện này.';
      }
      return 'Bạn đã hủy đăng ký sự kiện này.';
    }

    if (participant.participantType == ParticipantType.ctv) {
      return 'CTV cần để nhân viên quét mã QR của bạn. Bạn không thể tự check-in.';
    }

    if (participant.participantType == ParticipantType.attendee &&
        participant.ticketId != null) {
      return 'Sự kiện này yêu cầu nhân viên quét mã vé. Bạn không thể tự check-in bằng mã QR sự kiện.';
    }

    if (currentLocation == null) {
      return 'Cần cập nhật vị trí để check-in. Vui lòng bật định vị và thử lại.';
    }

    final venueLat = event?.venue?.latitude;
    final venueLng = event?.venue?.longitude;
    if (venueLat == null || venueLng == null) {
      return null;
    }

    final withinRadius = isWithinRadius(
      userLat: currentLocation.latitude,
      userLng: currentLocation.longitude,
      targetLat: venueLat,
      targetLng: venueLng,
      radiusMeters: 1000,
    );
    if (!withinRadius) {
      final distance = calculateDistance(
        lat1: currentLocation.latitude,
        lng1: currentLocation.longitude,
        lat2: venueLat,
        lng2: venueLng,
      );
      final distanceText = distance >= 1000
          ? '${(distance / 1000).toStringAsFixed(1)} km'
          : '${distance.round()} m';
      return 'Bạn đang cách địa điểm sự kiện $distanceText. Cần cách địa điểm dưới 1 km để check-in.';
    }

    return null;
  }

 
  Future<bool> _validateCheckOut({
    required ParticipantEntity participant,
    required EventEntity? event,
    required LocationCoords? currentLocation,
    required String code,
  }) async {
    if (participant.hasCheckedIn != true) {
      _showErrorSnackbar('Không thể check-out',
          'Bạn chưa check-in sự kiện. Vui lòng check-in trước.');
      _resumeScanner();
      return true;
    }

    if (participant.isCheckOut == true) {
      _showErrorSnackbar('Không thể check-out',
          'Bạn đã check-out sự kiện này rồi.');
      _resumeScanner();
      return true;
    }

    if (currentLocation == null) {
      _showErrorSnackbar('Không thể check-out',
          'Cần cập nhật vị trí để check-out. Vui lòng bật định vị và thử lại.');
      _resumeScanner();
      return true;
    }

    final venueLat = event?.venue?.latitude;
    final venueLng = event?.venue?.longitude;
    if (venueLat != null && venueLng != null) {
      final withinRadius = isWithinRadius(
        userLat: currentLocation.latitude,
        userLng: currentLocation.longitude,
        targetLat: venueLat,
        targetLng: venueLng,
        radiusMeters: 1000,
      );
      if (!withinRadius) {
        final distance = calculateDistance(
          lat1: currentLocation.latitude,
          lng1: currentLocation.longitude,
          lat2: venueLat,
          lng2: venueLng,
        );
        final distanceText = distance >= 1000
            ? '${(distance / 1000).toStringAsFixed(1)} km'
            : '${distance.round()} m';
        _showErrorSnackbar('Ngoài phạm vi',
            'Bạn đang cách địa điểm sự kiện $distanceText. Cần cách địa điểm dưới 1 km để check-out.');
        _resumeScanner();
        return true;
      }
    }

    final hasQuestions =
        await _eventHasFeedbackQuestions(participant.eventId!);

    if (hasQuestions) {
      if (participant.hasFeedback != true) {
        await _showFeedbackRequiredDialog(
          participant: participant,
          event: event,
          currentLocation: currentLocation,
          code: code,
        );
        return true;
      }
    }

    return false;
  }


  Future<EventEntity?> _getEventById(int eventId) async {
    final result = await _getEventByIdUsecase(eventId);
    return result.fold((_) => null, (event) => event);
  }

  Future<bool> _eventHasFeedbackQuestions(int eventId) async {
    final result = await _getFeedbackQuestionsUsecase(
      GetFeedbackQuestionsParams(eventId: eventId),
    );
    return result.fold(
      (_) => false,
      (questions) => questions.isNotEmpty,
    );
  }

  Future<void> _showFeedbackRequiredDialog({
    required ParticipantEntity participant,
    required EventEntity? event,
    required LocationCoords? currentLocation,
    required String code,
  }) async {
    isPendingFeedbackCheckOut.value = true;
    pendingEventParticipantId.value = participant.eventParticipantId;
    pendingEventId.value = participant.eventId;
    pendingQrContent.value = code;
    pendingLatitude.value = currentLocation?.latitude;
    pendingLongitude.value = currentLocation?.longitude;

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xff06B6D4).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.rate_review,
                color: Color(0xff06B6D4),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Yêu cầu đánh giá',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff273143),
                ),
              ),
            ),
          ],
        ),
        content: const Text(
          'Bạn cần hoàn thành đánh giá sự kiện trước khi check-out. Vui lòng làm feedback trước nhé!',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xff67688C),
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text(
              'Để sau',
              style: TextStyle(color: Color(0xff67688C)),
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff06B6D4),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: const Text('Làm feedback ngay'),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    if (confirmed != true) {
      _clearPendingState();
      _resumeScanner();
      return;
    }

    await Get.to(
      () => FeedbackPage(
        eventId: pendingEventId.value!,
        onSubmitted: _onFeedbackSubmittedForCheckOut,
        checkOutContext: CheckOutContext(
          eventParticipantId: pendingEventParticipantId.value!,
          qrContent: pendingQrContent.value,
          latitude: pendingLatitude.value,
          longitude: pendingLongitude.value,
          venueLat: event?.venue?.latitude,
          venueLng: event?.venue?.longitude,
        ),
      ),
    );
  }

  void _clearPendingState() {
    isPendingFeedbackCheckOut.value = false;
    pendingEventParticipantId.value = null;
    pendingEventId.value = null;
    pendingQrContent.value = '';
    pendingLatitude.value = null;
    pendingLongitude.value = null;
  }

  void _onFeedbackSubmittedForCheckOut() {
    _clearPendingState();
    Get.back(result: true);
  }

  Future<LocationCoords?> _getCurrentLocation() async {
    final result = await _locationService.getCurrentLocation();
    return result.coords;
  }

  AttendanceAction _determineAction(ParticipantEntity participant) {
    if (participant.hasCheckedIn == true && participant.isCheckOut != true) {
      return AttendanceAction.checkOut;
    }
    return AttendanceAction.checkIn;
  }

  Future<ParticipantEntity?> _findParticipantByQrAndUserId(
    String qrContent,
    int userId,
  ) async {
    final result = await _getParticipantsUsecase(
      GetMyParticipantsParams(userId: userId, page: 0, size: 50),
    );

    return result.fold(
      (_) => null,
      (participants) {
        final qrEventId = _parseEventIdFromQr(qrContent);

        for (final p in participants) {
          if (p.isCheckOut == true) continue;
          if (p.status == ParticipantStatus.noShow) continue;

          final pEventId = p.eventId;
          if (pEventId == null) continue;
          if (qrEventId != null && pEventId != qrEventId) continue;

          return p;
        }
        return null;
      },
    );
  }

  Future<AttendanceScanResultEntity?> _processQrContent(
    String qrContent, {
    int? eventParticipantId,
    double? latitude,
    double? longitude,
    AttendanceAction action = AttendanceAction.checkIn,
  }) async {
    if (isProcessing.value) return null;

    lastError.value = '';

    final result = await _selfCheckinUsecase(ScanQrParams(
      eventParticipantId: eventParticipantId,
      qrContent: qrContent,
      action: action,
      latitude: latitude,
      longitude: longitude,
    ));

    AttendanceScanResultEntity? scanResult;
    result.fold(
      (failure) {
        lastScanResult.value = null;
        lastError.value = _extractErrorMessage(failure);
      },
      (scanData) {
        lastScanResult.value = scanData;
        lastError.value = '';
        scanResult = scanData;
      },
    );

    return scanResult;
  }

  void _onScanSuccess(
    ParticipantEntity participant,
    AttendanceAction action,
    AttendanceScanResultEntity result,
    EventEntity? event,
  ) {
    final eventTitle = event?.title ?? 'sự kiện';
    final actionLabel =
        action == AttendanceAction.checkIn ? 'Check-in' : 'Check-out';
    final message =
        result.message ?? '$actionLabel thành công sự kiện "$eventTitle"';

    showSuccessOverlay.value = true;
    lastAction.value = action;

    _showSuccessSnackbar(actionLabel, message);

    Future.delayed(const Duration(milliseconds: 2000), () {
      if (!Get.isRegistered<ScanQrController>()) return;
      Get.back(result: true);
    });
  }

  void _resumeScanner() {
    if (!Get.isRegistered<ScanQrController>()) return;
    isProcessing.value = false;
    lastScan.value = '';
    mobileScannerController?.start();
  }

  void clearLastScan() {
    lastScanResult.value = null;
    lastError.value = '';
    lastScan.value = '';
  }

  dynamic _getCurrentUser() {
    try {
      final authController = Get.find<dynamic>(tag: 'AuthController');
      return authController.currentUser.value;
    } catch (_) {
      return null;
    }
  }

  String _extractErrorMessage(FailureEntity failure) {
    String message = 'Đã xảy ra lỗi';
    failure.when(
      serverFailure: (_, msg) => message = msg ?? 'Đã xảy ra lỗi từ máy chủ',
      dataParsingFailure: () => message = 'Không đọc được dữ liệu phản hồi',
      noConnectionFailure: () => message = 'Không có kết nối mạng. Vui lòng kiểm tra internet.',
      systemFailure: (_, msg) => message = msg ?? 'Lỗi hệ thống',
    );
    return message;
  }

  String _mapBeErrorMessage(String rawMessage) {
    if (rawMessage.isEmpty) return '';

    final lower = rawMessage.toLowerCase();

    if (lower.contains('participant already checked in') ||
        lower.contains('already checked-in') ||
        lower.contains('already check-in')) {
      return 'Bạn đã check-in sự kiện này rồi.';
    }
    if (lower.contains('participant already checked out') ||
        lower.contains('already checked-out') ||
        lower.contains('already check-out')) {
      return 'Bạn đã check-out sự kiện này rồi.';
    }
    if (lower.contains('must check-in') ||
        lower.contains('chưa check-in')) {
      return 'Bạn cần check-in trước khi check-out.';
    }
    if (lower.contains('qr has expired') ||
        lower.contains('hết hạn')) {
      return 'Mã QR đã hết hạn. Vui lòng tạo mã QR mới.';
    }
    if (lower.contains('invalid qr signature') ||
        lower.contains('invalid event qr') ||
        lower.contains('invalid participant qr')) {
      return 'Mã QR không hợp lệ hoặc đã bị sửa. Vui lòng quét lại.';
    }
    if (lower.contains('participant qr does not match')) {
      return 'Mã QR không khớp với tài khoản của bạn.';
    }
    if (lower.contains('event qr does not belong')) {
      // New BE format: "EVENT QR does not belong to this event. QR event: 123, your registration event: 456"
      if (lower.contains('qr event:') || lower.contains('your registration event:')) {
        return 'Mã QR không thuộc sự kiện bạn đã đăng ký. Vui lòng quét đúng mã QR của sự kiện.';
      }
      return 'Mã QR không thuộc sự kiện bạn đã đăng ký.';
    }
    if (lower.contains('latitude') && lower.contains('required') ||
        lower.contains('cần truy cập vị trí')) {
      return 'Cần cập nhật vị trí để thực hiện thao tác. Vui lòng bật định vị.';
    }
    if (lower.contains('within 1km') ||
        lower.contains('bạn đang ở xa') ||
        lower.contains('cách địa điểm')) {
      return 'Bạn đang ở ngoài phạm vi cho phép (cách quá 1km). Di chuyển gần địa điểm sự kiện và thử lại.';
    }
    if (lower.contains('event venue location') && lower.contains('not configured')) {
      return 'Sự kiện chưa cấu hình địa điểm. Liên hệ người tổ chức.';
    }
    if (lower.contains('only registered participants') ||
        lower.contains('trạng thái') ||
        lower.contains('không hợp lệ')) {
      return 'Trạng thái đăng ký không hợp lệ. Bạn không thể check-in/check-out.';
    }
    if (lower.contains('checkout log already exists')) {
      return 'Bạn đã check-out sự kiện này rồi.';
    }
    if (lower.contains('must submit feedback') ||
        lower.contains('phải làm feedback')) {
      return 'Bạn cần hoàn thành đánh giá sự kiện trước khi check-out.';
    }
    if (lower.contains('ctv check-in') ||
        lower.contains('CTV phải') ||
        lower.contains('CTV must')) {
      return 'CTV cần để nhân viên quét mã QR. Bạn không thể tự check-in.';
    }
    if (lower.contains('paid attendee') ||
        lower.contains('trả phí') ||
        lower.contains('vé chưa được phát')) {
      return 'Sự kiện yêu cầu nhân viên quét vé. Bạn không thể tự check-in.';
    }
    if (lower.contains('ticket is not issued')) {
      return 'Vé của bạn chưa được phát. Liên hệ nhân viên để nhận vé.';
    }
    if (lower.contains('invalid action')) {
      return 'Thao tác không hợp lệ.';
    }
    if (lower.contains('event participant id is required')) {
      return 'Không tìm thấy thông tin người tham gia.';
    }
    if (lower.contains('free attendee') ||
        lower.contains('miễn phí')) {
      return 'Sự kiện miễn phí không cần quét mã vé. Hãy quét mã QR sự kiện.';
    }

    return rawMessage;
  }

  void _showSuccessSnackbar(String title, String message) {
    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.TOP,
      snackStyle: SnackStyle.FLOATING,
      backgroundColor: Colors.white,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      borderRadius: 18,
      borderColor: const Color(0xff22C55E).withValues(alpha: 0.25),
      borderWidth: 1.2,
      boxShadows: const [
        BoxShadow(
          color: Color(0x1422C55E),
          blurRadius: 24,
          offset: Offset(0, 8),
        ),
      ],
      titleText: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0x1A22C55E),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '✓',
                style: TextStyle(
                  color: Color(0xff22C55E),
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xff273143),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      messageText: Padding(
        padding: const EdgeInsets.only(left: 38, top: 4),
        child: Text(
          message,
          style: const TextStyle(
            color: Color(0xff67688C),
            fontSize: 13,
            height: 1.35,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      icon: const SizedBox.shrink(),
    );
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.TOP,
      snackStyle: SnackStyle.FLOATING,
      backgroundColor: Colors.white,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      borderRadius: 18,
      borderColor: const Color(0xffEF4444).withValues(alpha: 0.25),
      borderWidth: 1.2,
      boxShadows: const [
        BoxShadow(
          color: Color(0x14EF4444),
          blurRadius: 24,
          offset: Offset(0, 8),
        ),
      ],
      titleText: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0x1AEF4444),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '✗',
                style: TextStyle(
                  color: Color(0xffEF4444),
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xff273143),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      messageText: Padding(
        padding: const EdgeInsets.only(left: 38, top: 4),
        child: Text(
          message,
          style: const TextStyle(
            color: Color(0xff67688C),
            fontSize: 13,
            height: 1.35,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      icon: const SizedBox.shrink(),
    );
  }
}
