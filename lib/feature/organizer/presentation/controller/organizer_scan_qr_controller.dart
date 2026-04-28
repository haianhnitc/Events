import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/common/utils/app_location_service.dart';
import 'package:events_app/common/utils/permission_helper.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/attendance/domain/entity/attendance_entity.dart';
import 'package:events_app/feature/attendance/domain/usecase/attendance_usecase.dart';
import 'package:events_app/feature/attendance/domain/usecase/scan_qr_params.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';
import 'package:events_app/feature/organizer/attendance/domain/usecase/organizer_attendance_usecase.dart';
import 'package:events_app/feature/organizer/attendance/domain/usecase/organizer_attendance_params.dart';
import 'package:permission_handler/permission_handler.dart';

enum OrganizerScanMode {
  checkIn,
  checkOut,
}

enum OrganizerCameraPermissionState {
  checking,
  granted,
  denied,
  permanentlyDenied,
}

class OrganizerScanResultEntity {
  final AttendanceScanResultEntity? scanResult;
  final ParticipantEntity? participant;
  final OrganizerScanMode? action;
  final String? message;

  OrganizerScanResultEntity({
    this.scanResult,
    this.participant,
    this.action,
    this.message,
  });
}

class OrganizerScanQrController extends GetxController with GetTickerProviderStateMixin {
  MobileScannerController? mobileScannerController;

  final Rx<OrganizerCameraPermissionState> permissionState =
      OrganizerCameraPermissionState.checking.obs;
  final RxBool isProcessing = false.obs;
  final Rx<OrganizerScanMode> scanMode = OrganizerScanMode.checkIn.obs;
  final RxString lastScan = ''.obs;
  final RxBool showResultOverlay = false.obs;
  final RxBool _showingResult = false.obs;
  final Rx<OrganizerScanResultEntity?> lastScanResult =
      Rx<OrganizerScanResultEntity?>(null);
  final RxString lastError = ''.obs;

  final Rx<int> currentEventId = Rx<int>(0);
  final RxInt checkedInCount = 0.obs;
  final RxInt totalParticipants = 0.obs;

  final RxSet<int> _scannedParticipantIds = <int>{}.obs;

  final PermissionHelper _permissionHelper = PermissionHelper();
  final AppLocationService _locationService = AppLocationService();
  final ScanQrUsecase _scanQrUsecase = networkGetIt<ScanQrUsecase>();
  final OrganizerManualCheckInUsecase _manualCheckInUsecase =
      networkGetIt<OrganizerManualCheckInUsecase>();
  final OrganizerManualCheckOutUsecase _manualCheckOutUsecase =
      networkGetIt<OrganizerManualCheckOutUsecase>();

  static OrganizerScanQrController? _instance;

  static OrganizerScanQrController get instance {
    _instance ??= OrganizerScanQrController();
    return _instance!;
  }

  static OrganizerScanQrController ensureInstance() {
    if (!Get.isRegistered<OrganizerScanQrController>()) {
      Get.put(OrganizerScanQrController());
    }
    return Get.find<OrganizerScanQrController>();
  }

  @override
  void onInit() {
    super.onInit();
    _checkCameraPermission();
  }

  @override
  void onClose() {
    mobileScannerController?.dispose();
    _instance = null;
    super.onClose();
  }

  Future<void> _checkCameraPermission() async {
    final result = await _permissionHelper.requestCameraPermission();

    if (!Get.isRegistered<OrganizerScanQrController>()) return;

    switch (result.status) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
      case PermissionStatus.provisional:
        permissionState.value = OrganizerCameraPermissionState.granted;
        mobileScannerController = MobileScannerController();
        break;
      case PermissionStatus.permanentlyDenied:
        permissionState.value = OrganizerCameraPermissionState.permanentlyDenied;
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      default:
        permissionState.value = OrganizerCameraPermissionState.denied;
        break;
    }
  }

  Future<bool> retryCameraPermission() async {
    permissionState.value = OrganizerCameraPermissionState.checking;
    await _checkCameraPermission();
    return permissionState.value == OrganizerCameraPermissionState.granted;
  }

  Future<void> openAppSettings() async {
    await _permissionHelper.openSettings();
  }

  void toggleMode() {
    scanMode.value = scanMode.value == OrganizerScanMode.checkIn
        ? OrganizerScanMode.checkOut
        : OrganizerScanMode.checkIn;
  }

  void setEventId(int eventId) {
    currentEventId.value = eventId;
  }

  void setTotalParticipants(int total) {
    totalParticipants.value = total;
  }

  Future<void> toggleTorch() async {
    try {
      await mobileScannerController?.toggleTorch();
    } catch (_) {}
  }

  void onBarcodeDetected(BarcodeCapture barcodeCapture) {
    if (isProcessing.value || _showingResult.value) return;

    final barcodes = barcodeCapture.barcodes;
    if (barcodes.isEmpty) return;

    final barcode = barcodes.first;
    final code = barcode.rawValue;
    if (code == null || code.isEmpty) return;

    _processCode(code);
  }

  Future<void> _processCode(String code) async {
    isProcessing.value = true;
    lastScan.value = code;
    mobileScannerController?.stop();

    final validationError = _validateQrFormat(code);
    if (validationError != null) {
      _showErrorSnackbar('Mã QR không hợp lệ', validationError);
      _resumeScanner();
      return;
    }

    if (_isQrExpired(code)) {
      _showErrorSnackbar('Mã QR hết hạn',
          'Mã QR đã hết hạn. Vui lòng tạo mã mới.');
      _resumeScanner();
      return;
    }

    final isAttendeeQr = _isAttendeeQrCode(code);
    final isEventQr = _isEventQrCode(code);

    if (scanMode.value == OrganizerScanMode.checkIn) {
      await _handleCheckIn(code);
    } else {
      await _handleCheckOut(code);
    }
  }

  bool _isAttendeeQrCode(String code) {
    return code.startsWith('PARTICIPANT:');
  }

  bool _isEventQrCode(String code) {
    return code.startsWith('EVENT_CHECKIN:') || code.startsWith('EVENT_CHECKOUT:');
  }

  String? _validateQrFormat(String code) {
    final validPrefixes = ['PARTICIPANT:'];
    final hasValidPrefix = validPrefixes.any((p) => code.startsWith(p));

    if (!hasValidPrefix) {
      return 'Mã QR không đúng định dạng. Vui lòng quét mã QR người tham gia.';
    }

    final parts = code.split(':');
    if (parts.length < 4) {
      return 'Mã QR không đúng định dạng. Cần đủ 4 phần: PARTICIPANT:id:timestamp:signature.';
    }

    return null;
  }

  bool _isQrExpired(String code) => false;

  Future<void> _handleCheckIn(String code) async {
    final eventParticipantId = _parseParticipantIdFromQr(code);
    if (eventParticipantId == null) {
      _showErrorSnackbar('Mã QR không hợp lệ', 'Không thể đọc ID từ mã QR.');
      _resumeScanner();
      return;
    }

    if (_scannedParticipantIds.contains(eventParticipantId)) {
      _showErrorSnackbar(
        'Đã quét rồi',
        'Mã này đã được quét trong phiên này. Vui lòng quét mã khác.',
      );
      _resumeScanner();
      return;
    }

    _scannedParticipantIds.add(eventParticipantId);
    final result = await _processAttendeeCheckIn(code, eventParticipantId);

    if (!Get.isRegistered<OrganizerScanQrController>()) return;

    if (result != null) {
      _onScanSuccess(result, OrganizerScanMode.checkIn);
    } else {
      final mappedMessage = _mapBeErrorMessage(lastError.value);
      _showErrorSnackbar(
        'Check-in thất bại',
        mappedMessage.isNotEmpty
            ? mappedMessage
            : 'Không thể check-in. Vui lòng thử lại.',
      );
      _resumeScanner();
    }
  }

  Future<void> _handleCheckOut(String code) async {
    final eventParticipantId = _parseParticipantIdFromQr(code);
    if (eventParticipantId == null) {
      _showErrorSnackbar('Mã QR không hợp lệ', 'Không thể đọc ID từ mã QR.');
      _resumeScanner();
      return;
    }

    if (_scannedParticipantIds.contains(eventParticipantId)) {
      _showErrorSnackbar(
        'Đã quét rồi',
        'Mã này đã được quét trong phiên này. Vui lòng quét mã khác.',
      );
      _resumeScanner();
      return;
    }

    _scannedParticipantIds.add(eventParticipantId);
    final result = await _processAttendeeCheckIn(code, eventParticipantId);

    if (!Get.isRegistered<OrganizerScanQrController>()) return;

    if (result != null) {
      _onScanSuccess(result, OrganizerScanMode.checkOut);
    } else {
      final mappedMessage = _mapBeErrorMessage(lastError.value);
      _showErrorSnackbar(
        'Check-out thất bại',
        mappedMessage.isNotEmpty
            ? mappedMessage
            : 'Không thể check-out. Vui lòng thử lại.',
      );
      _resumeScanner();
    }
  }

  int? _parseParticipantIdFromQr(String code) {
    final parts = code.split(':');
    if (parts.length >= 4) {
      return int.tryParse(parts[1]);
    }
    return null;
  }

  Future<OrganizerScanResultEntity?> _processAttendeeCheckIn(
      String code, int eventParticipantId) async {
    lastError.value = '';

    final locationResult = await _locationService.getCurrentLocation();
    final coords = locationResult.coords;

    final result = await _scanQrUsecase(ScanQrParams(
      eventParticipantId: eventParticipantId,
      qrContent: code,
      latitude: coords?.latitude,
      longitude: coords?.longitude,
    ));

    OrganizerScanResultEntity? scanResult;
    result.fold(
      (failure) {
        lastScanResult.value = null;
        lastError.value = _extractErrorMessage(failure);
      },
      (scanData) {
        lastScanResult.value = OrganizerScanResultEntity(
          scanResult: scanData,
          action: scanMode.value,
        );
        lastError.value = '';
        scanResult = lastScanResult.value;
      },
    );

    return scanResult;
  }

  Future<OrganizerScanResultEntity?> _processAttendeeCheckOut(
      int eventParticipantId) async {
    lastError.value = '';

    final result = await _manualCheckOutUsecase(
      OrganizerManualAttendanceParams(eventParticipantId: eventParticipantId),
    );

    OrganizerScanResultEntity? scanResult;
    result.fold(
      (failure) {
        lastScanResult.value = null;
        lastError.value = _extractErrorMessage(failure);
      },
      (log) {
        lastScanResult.value = OrganizerScanResultEntity(
          action: OrganizerScanMode.checkOut,
          message: 'Check-out thành công',
        );
        lastError.value = '';
        scanResult = lastScanResult.value;
      },
    );

    return scanResult;
  }

  void _onScanSuccess(OrganizerScanResultEntity result, OrganizerScanMode action) {
    _showingResult.value = true;
    showResultOverlay.value = true;
    lastScanResult.value = result;

    if (action == OrganizerScanMode.checkIn) {
      checkedInCount.value++;
    }

    final participantName = result.scanResult?.participantName ?? 'Người tham gia';
    final message = result.message ??
        (action == OrganizerScanMode.checkIn
            ? 'Check-in thành công'
            : 'Check-out thành công');

    _showSuccessSnackbar(
      action == OrganizerScanMode.checkIn ? 'Check-in thành công' : 'Check-out thành công',
      '$participantName - $message',
    );

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!Get.isRegistered<OrganizerScanQrController>()) return;
      _hideResultOverlay();
    });
  }

  void _hideResultOverlay() {
    _showingResult.value = false;
    showResultOverlay.value = false;
    lastScanResult.value = null;
    isProcessing.value = false;
    lastScan.value = '';
    mobileScannerController?.start();
  }

  void _resumeScanner() {
    if (!Get.isRegistered<OrganizerScanQrController>()) return;
    if (_showingResult.value || showResultOverlay.value) return;
    isProcessing.value = false;
    lastScan.value = '';
    mobileScannerController?.start();
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

    if (lower.contains('already checked in') ||
        lower.contains('already check-in')) {
      return 'Người này đã check-in rồi.';
    }
    if (lower.contains('already checked out') ||
        lower.contains('already check-out')) {
      return 'Người này đã check-out rồi.';
    }
    if (lower.contains('must check-in') || lower.contains('chưa check-in')) {
      return 'Người này chưa check-in. Cần check-in trước khi check-out.';
    }
    if (lower.contains('qr has expired') || lower.contains('hết hạn')) {
      return 'Mã QR đã hết hạn. Vui lòng tạo mã QR mới.';
    }
    if (lower.contains('invalid qr signature') ||
        lower.contains('invalid participant qr')) {
      return 'Mã QR không hợp lệ hoặc đã bị sửa. Vui lòng quét lại.';
    }
    if (lower.contains('participant not found') ||
        lower.contains('không tìm thấy')) {
      return 'Không tìm thấy người tham gia với mã QR này.';
    }
    if (lower.contains('permission') || lower.contains('quyền')) {
      return 'Bạn không có quyền thực hiện thao tác này.';
    }
    if (lower.contains('ctv') && lower.contains('only')) {
      return 'Sự kiện chỉ dành cho CTV. Không thể check-in người tham gia.';
    }
    if (lower.contains('attendee') && lower.contains('only')) {
      return 'Sự kiện chỉ dành cho người tham gia. Không thể check-in CTV.';
    }
    if (lower.contains('must submit feedback')) {
      return 'Người này cần hoàn thành đánh giá trước khi check-out.';
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
      duration: const Duration(seconds: 3),
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

  void resetStats() {
    checkedInCount.value = 0;
    totalParticipants.value = 0;
  }
}
