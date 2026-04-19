import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:events_app/feature/attendance/domain/entity/attendance_entity.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_event_qr_controller.dart';

class OrganizerEventQrFullscreenPage extends StatefulWidget {
  final int eventId;
  final String eventName;
  final String? eventDate;
  final String? eventVenue;

  const OrganizerEventQrFullscreenPage({
    super.key,
    required this.eventId,
    required this.eventName,
    this.eventDate,
    this.eventVenue,
  });

  @override
  State<OrganizerEventQrFullscreenPage> createState() =>
      _OrganizerEventQrFullscreenPageState();
}

class _OrganizerEventQrFullscreenPageState
    extends State<OrganizerEventQrFullscreenPage>
    with SingleTickerProviderStateMixin {
  late final OrganizerEventQrController _ctrl;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.put(OrganizerEventQrController());
    _ctrl.loadEventQr(widget.eventId);

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.07).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    Get.delete<OrganizerEventQrController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  ),
                ),
              ),
              _buildContent(),
              _buildCloseButton(),
              _buildDownloadButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'QUÉT ĐỂ CHECK-IN',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF06B6D4),
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.eventName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 32),
            _buildQrBox(),
            const SizedBox(height: 24),
            _buildCountdown(),
            const SizedBox(height: 24),
            _buildInstructions(),
            const SizedBox(height: 20),
            if (widget.eventDate != null || widget.eventVenue != null)
              _buildEventInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildQrBox() {
    return Obx(() {
      if (_ctrl.isLoading.value) {
        return AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) => Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF06B6D4).withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const SizedBox(
                width: 220,
                height: 220,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF06B6D4),
                    strokeWidth: 3,
                  ),
                ),
              ),
            ),
          ),
        );
      }

      if (_ctrl.errorMessage.value.isNotEmpty) {
        return _buildQrPlaceholder(
          icon: Icons.error_outline,
          iconColor: const Color(0xFFEF4444),
          title: 'Không tải được QR',
          subtitle: 'Nhấn để thử lại',
          onTap: () => _ctrl.loadEventQr(widget.eventId),
        );
      }

      final qr = _ctrl.eventQr.value;
      if (qr == null || qr.qrContent == null) {
        return _buildQrPlaceholder(
          icon: Icons.qr_code_2,
          iconColor: Colors.grey.shade400,
          title: 'Chưa có mã QR',
          subtitle: 'QR sẽ xuất hiện khi sự kiện bắt đầu',
          onTap: null,
        );
      }

      return AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) => Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF06B6D4).withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(
                  base64Decode(qr.qrContent!),
                  width: 220,
                  height: 220,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Center(
                    child: Icon(
                      Icons.qr_code_2,
                      size: 120,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildQrPlaceholder({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    final box = AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) => Transform.scale(
        scale: _pulseAnimation.value,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF06B6D4).withOpacity(0.2),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 120, color: iconColor),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: box);
    }
    return box;
  }

  Widget _buildCountdown() {
    return Obx(() {
      final remaining = _ctrl.remaining;
      final isExpired = _ctrl.isExpired;

      if (_ctrl.eventQr.value == null) {
        return const SizedBox.shrink();
      }

      if (isExpired) {
        return GestureDetector(
          onTap: () => _ctrl.loadEventQr(widget.eventId),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withOpacity(0.15),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color(0xFFEF4444).withOpacity(0.3),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.refresh, size: 16, color: Color(0xFFEF4444)),
                SizedBox(width: 8),
                Text(
                  'QR hết hạn — Nhấn để làm mới',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      final minutes = remaining!.inMinutes;
      final seconds = remaining.inSeconds % 60;
      final progress = _getCountdownProgress(remaining);

      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.timer_outlined,
                  size: 16, color: Color(0xFF06B6D4)),
              const SizedBox(width: 6),
              Text(
                'Hết hạn sau  ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF06B6D4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 4,
                backgroundColor: Colors.white.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress > 0.3
                      ? const Color(0xFF06B6D4)
                      : const Color(0xFFF59E0B),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  double _getCountdownProgress(Duration remaining) {
    const totalMinutes = 60;
    final totalSeconds = totalMinutes * 60;
    final remainingSeconds = remaining.inSeconds;
    return (remainingSeconds / totalSeconds).clamp(0.0, 1.0);
  }

  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          _buildInstructionRow(
              Icons.phone_android, 'Mở ứng dụng Sự kiện'),
          const SizedBox(height: 8),
          _buildInstructionRow(Icons.qr_code_scanner, 'Quét mã QR này'),
          const SizedBox(height: 8),
          _buildInstructionRow(Icons.check_circle_outline, 'Check-in tự động'),
        ],
      ),
    );
  }

  Widget _buildInstructionRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF06B6D4)),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.75),
          ),
        ),
      ],
    );
  }

  Widget _buildEventInfo() {
    return Text(
      [
        if (widget.eventDate != null) widget.eventDate,
        if (widget.eventVenue != null) widget.eventVenue,
      ].join('  •  '),
      style: TextStyle(
        fontSize: 11,
        color: Colors.white.withOpacity(0.4),
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildCloseButton() {
    return Positioned(
      top: 16,
      right: 16,
      child: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.close, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  Widget _buildDownloadButton() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tính năng đang phát triển'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.15)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.download,
                    color: Colors.white.withOpacity(0.85), size: 18),
                const SizedBox(width: 8),
                Text(
                  'Tải xuống mã QR',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
