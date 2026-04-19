import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_scan_qr_controller.dart';

class OrganizerQrScannerPage extends StatefulWidget {
  final int? eventId;
  final int? totalParticipants;

  const OrganizerQrScannerPage({
    super.key,
    this.eventId,
    this.totalParticipants,
  });

  @override
  State<OrganizerQrScannerPage> createState() => _OrganizerQrScannerPageState();
}

class _OrganizerQrScannerPageState extends State<OrganizerQrScannerPage> {
  late final OrganizerScanQrController _controller;

  @override
  void initState() {
    super.initState();
    _controller = OrganizerScanQrController.ensureInstance();
    if (widget.eventId != null) {
      _controller.setEventId(widget.eventId!);
      _controller.setTotalParticipants(widget.totalParticipants ?? 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Máy quét QR',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          Obx(() {
            if (_controller.permissionState.value !=
                OrganizerCameraPermissionState.granted) {
              return const SizedBox.shrink();
            }
            return IconButton(
              icon: const Icon(Icons.flash_on, color: Colors.white),
              onPressed: _controller.toggleTorch,
            );
          }),
        ],
      ),
      body: Obx(_buildBody),
    );
  }

  Widget _buildBody() {
    final state = _controller.permissionState.value;

    switch (state) {
      case OrganizerCameraPermissionState.checking:
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF06B6D4)),
        );

      case OrganizerCameraPermissionState.denied:
      case OrganizerCameraPermissionState.permanentlyDenied:
        return _buildPermissionDenied(state);

      case OrganizerCameraPermissionState.granted:
        return _buildScanner();
    }
  }

  Widget _buildScanner() {
    return Stack(
      children: [
        MobileScanner(
          controller: _controller.mobileScannerController!,
          onDetect: _controller.onBarcodeDetected,
        ),
        Center(
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              border: Border.all(
                color: _controller.scanMode.value == OrganizerScanMode.checkIn
                    ? const Color(0xFF06B6D4)
                    : const Color(0xFFF59E0B),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -1,
                  left: -1,
                  child: _buildCorner(true, true),
                ),
                Positioned(
                  top: -1,
                  right: -1,
                  child: _buildCorner(true, false),
                ),
                Positioned(
                  bottom: -1,
                  left: -1,
                  child: _buildCorner(false, true),
                ),
                Positioned(
                  bottom: -1,
                  right: -1,
                  child: _buildCorner(false, false),
                ),
                if (_controller.isProcessing.value)
                  const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 16,
          left: 0,
          right: 0,
          child: _buildModeToggle(),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _buildBottomPanel(),
        ),
        Obx(() {
          if (!_controller.showResultOverlay.value) {
            return const SizedBox.shrink();
          }
          return _buildResultOverlay();
        }),
      ],
    );
  }

  Widget _buildModeToggle() {
    return Center(
      child: Obx(() {
        final isCheckIn = _controller.scanMode.value == OrganizerScanMode.checkIn;
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  if (_controller.scanMode.value != OrganizerScanMode.checkIn) {
                    _controller.toggleMode();
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isCheckIn ? const Color(0xFF06B6D4) : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    'CHECK-IN',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isCheckIn ? Colors.white : Colors.white54,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (_controller.scanMode.value != OrganizerScanMode.checkOut) {
                    _controller.toggleMode();
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: !isCheckIn ? const Color(0xFFF59E0B) : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    'CHECK-OUT',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: !isCheckIn ? Colors.white : Colors.white54,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBottomPanel() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0),
            Colors.black.withOpacity(0.9),
          ],
        ),
      ),
      child: Obx(() {
        final result = _controller.lastScanResult.value;
        final isCheckIn =
            _controller.scanMode.value == OrganizerScanMode.checkIn;
        final modeColor = isCheckIn
            ? const Color(0xFF06B6D4)
            : const Color(0xFFF59E0B);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (result != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFF10B981).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFF10B981),
                      child: Icon(
                        isCheckIn ? Icons.check : Icons.logout,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            result.scanResult?.participantName ?? 'Người tham gia',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            result.scanResult?.participantType?.name.toUpperCase() ??
                                'ATTENDEE',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'THÀNH CÔNG',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatChip(
                  '${_controller.checkedInCount.value}',
                  'Đã check-in',
                  modeColor,
                ),
                _buildStatChip(
                  '${_controller.totalParticipants.value}',
                  'Tổng cộng',
                  Colors.white70,
                ),
                Obx(() {
                  final absent = _controller.totalParticipants.value -
                      _controller.checkedInCount.value;
                  return _buildStatChip(
                    '$absent',
                    'Vắng mặt',
                    const Color(0xFFEF4444),
                  );
                }),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _buildResultOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black45,
        child: Center(
          child: Obx(() {
            final result = _controller.lastScanResult.value;
            final isCheckIn =
                _controller.scanMode.value == OrganizerScanMode.checkIn;
            final modeColor = isCheckIn
                ? const Color(0xFF06B6D4)
                : const Color(0xFFF59E0B);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 30,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: modeColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isCheckIn ? Icons.check_circle : Icons.logout,
                      color: modeColor,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    isCheckIn
                        ? 'Check-in thành công!'
                        : 'Check-out thành công!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff273143),
                    ),
                  ),
                  if (result?.scanResult?.participantName != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      result!.scanResult!.participantName!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff67688C),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildStatChip(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildCorner(bool top, bool left) {
    final isCheckIn =
        _controller.scanMode.value == OrganizerScanMode.checkIn;
    final color = isCheckIn
        ? const Color(0xFF06B6D4)
        : const Color(0xFFF59E0B);

    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        border: Border(
          top: top
              ? BorderSide(color: color, width: 4)
              : BorderSide.none,
          bottom: !top
              ? BorderSide(color: color, width: 4)
              : BorderSide.none,
          left: left
              ? BorderSide(color: color, width: 4)
              : BorderSide.none,
          right: !left
              ? BorderSide(color: color, width: 4)
              : BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPermissionDenied(OrganizerCameraPermissionState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xffFEE2E2),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.no_photography_outlined,
                size: 40,
                color: Color(0xffEF4444),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Chưa có quyền camera',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xff273143),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              state == OrganizerCameraPermissionState.permanentlyDenied
                  ? 'Quyền camera đã bị từ chối vĩnh viễn. '
                      'Vui lòng vào Cài đặt để bật quyền truy cập camera.'
                  : 'Ứng dụng cần quyền truy cập camera để quét mã QR. '
                      'Vui lòng cấp quyền trong Cài đặt.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xff67688C),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _controller.openAppSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff06B6D4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Mở Cài đặt',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            if (state != OrganizerCameraPermissionState.permanentlyDenied) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _controller.retryCameraPermission,
                  child: const Text(
                    'Thử lại',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff06B6D4),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
