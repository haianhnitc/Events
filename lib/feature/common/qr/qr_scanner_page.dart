import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:events_app/feature/attendance/presentation/controller/scan_qr_controller.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class QrScannerPage extends StatelessWidget {
  const QrScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ScanQrController.ensureInstance();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Quét QR',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Obx(() {
            if (controller.permissionState.value != CameraPermissionState.granted) {
              return const SizedBox.shrink();
            }
            return IconButton(
              icon: const Icon(Icons.flash_on, color: Colors.white),
              tooltip: 'Bật/Tắt đèn',
              onPressed: controller.toggleTorch,
            );
          }),
        ],
      ),
      body: Obx(_buildBody),
    );
  }

  Widget _buildBody() {
    final controller = ScanQrController.to;
    final state = controller.permissionState.value;

    switch (state) {
      case CameraPermissionState.checking:
        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF06B6D4),
          ),
        );

      case CameraPermissionState.denied:
      case CameraPermissionState.permanentlyDenied:
        return _buildPermissionDenied(controller, state);

      case CameraPermissionState.granted:
        return _buildScanner(controller);
    }
  }

  Widget _buildScanner(ScanQrController controller) {
    return Stack(
      children: [
        MobileScanner(
          controller: controller.mobileScannerController!,
          onDetect: controller.onBarcodeDetected,
        ),
        Center(
          child: SizedBox(
            width: 280,
            height: 280,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white70, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                AnimatedBuilder(
                  animation: controller.lineAnimation,
                  builder: (context, child) {
                    final top = controller.lineAnimation.value * 280;
                    return Positioned(
                      top: top,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.greenAccent.withOpacity(0.0),
                              Colors.greenAccent.withOpacity(0.95),
                              Colors.greenAccent.withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Obx(() {
                final lastScan = controller.lastScan.value;
                return Text(
                  lastScan.isEmpty
                      ? 'Hướng camera vào mã QR để quét'
                      : 'Kết quả: $lastScan',
                  style: const TextStyle(color: Colors.white),
                );
              }),
            ),
          ),
        ),
        Obx(() {
          if (!controller.showSuccessOverlay.value) {
            return const SizedBox.shrink();
          }
          return _buildSuccessOverlay(controller);
        }),
      ],
    );
  }

  Widget _buildSuccessOverlay(ScanQrController controller) {
    final isCheckIn = controller.lastAction.value == AttendanceAction.checkIn;
    final actionLabel = isCheckIn ? 'Check-in thành công!' : 'Check-out thành công!';

    return Positioned.fill(
      child: Container(
        color: Colors.black45,
        child: Center(
          child: Container(
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
                    color: isCheckIn
                        ? const Color(0xFFDCFCE7)
                        : const Color(0xFFFEF3C7),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCheckIn ? Icons.check_circle : Icons.logout,
                    color: isCheckIn ? const Color(0xff22C55E) : const Color(0xffF59E0B),
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  actionLabel,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff273143),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionDenied(ScanQrController controller, CameraPermissionState state) {
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
              state == CameraPermissionState.permanentlyDenied
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
                onPressed: controller.openAppSettings,
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
            const SizedBox(height: 12),
            if (state != CameraPermissionState.permanentlyDenied)
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: controller.retryCameraPermission,
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
        ),
      ),
    );
  }
}
