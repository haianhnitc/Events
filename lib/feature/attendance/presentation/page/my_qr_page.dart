import 'dart:convert';

import 'package:events_app/feature/attendance/domain/entity/attendance_entity.dart';
import 'package:events_app/feature/attendance/presentation/controller/my_qr_controller.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyQrPage extends StatelessWidget {
  const MyQrPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6F9),
      appBar: AppBar(
        backgroundColor: const Color(0xff06B6D4),
        elevation: 0,
        title: const Text(
          'QR Của Tôi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () => MyQrController.ensureInstance().refreshQr(),
          ),
        ],
      ),
      body: Obx(() {
        final controller = MyQrController.ensureInstance();

        if (controller.isLoading.value && controller.participants.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xff06B6D4),
            ),
          );
        }

        final participants = controller.participants;

        if (participants.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () => controller.refreshQr(),
          color: const Color(0xff06B6D4),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: participants.length,
            itemBuilder: (context, index) {
              final participant = participants[index];
              return _buildQrCard(context, participant, controller);
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xffF0F0F0),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.qr_code,
              size: 40,
              color: Color(0xffB0B4C0),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Chưa có sự kiện nào',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xff67688C),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Đăng ký tham gia sự kiện để nhận QR',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xffB0B4C0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrCard(
    BuildContext context,
    ParticipantEntity participant,
    MyQrController controller,
  ) {
    final qr = controller.getQrFor(participant.eventParticipantId!);
    final needsStaffQr = controller.needsStaffQr(participant);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEventHeader(participant),
          const Divider(height: 1, color: Color(0xffF0F0F0)),
          _buildParticipantInfo(participant),
          if (qr != null && participant.participantType != ParticipantType.ctv)
            _buildQrSection(context, qr, participant, controller)
          else if (needsStaffQr)
            _buildStaffQrPlaceholder()
          else
            _buildNoQrPlaceholder(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildEventHeader(ParticipantEntity participant) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: participant.participantType == ParticipantType.ctv
                  ? const Color(0xffDB0025).withValues(alpha: 0.1)
                  : const Color(0xff06B6D4).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              participant.participantType == ParticipantType.ctv ? 'CTV' : 'Người tham dự',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: participant.participantType == ParticipantType.ctv
                    ? const Color(0xffDB0025)
                    : const Color(0xff06B6D4),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: const Text(
              '',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xff273143),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _buildStatusChip(participant),
        ],
      ),
    );
  }

  Widget _buildStatusChip(ParticipantEntity participant) {
    Color statusColor;
    String statusText;

    if (participant.checkOutTime != null) {
      statusColor = const Color(0xffB0B4C0);
      statusText = 'Đã kết thúc';
    } else if (participant.hasCheckedIn == true) {
      statusColor = const Color(0xff00A63E);
      statusText = 'Đã check-in';
    } else {
      statusColor = const Color(0xffF59E0B);
      statusText = 'Chưa check-in';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: statusColor,
        ),
      ),
    );
  }

  Widget _buildParticipantInfo(ParticipantEntity participant) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xffF0F0F0),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.person,
              color: Color(0xffB0B4C0),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  participant.user?.fullName ?? 'Không rõ',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff273143),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Mã tham dự: ${participant.eventParticipantId}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff67688C),
                  ),
                ),
              ],
            ),
          ),
          if (participant.checkInTime != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Check-in lúc',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xffB0B4C0),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  AppDateUtils.formatDateTime(participant.checkInTime),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff273143),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildQrSection(
    BuildContext context,
    AttendanceQrEntity qr,
    ParticipantEntity participant,
    MyQrController controller,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xffE5E7EB),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          if (qr.qrContent != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Image.memory(
                base64Decode(qr.qrContent!),
                width: 180,
                height: 180,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 180,
                    height: 180,
                    color: const Color(0xffF0F0F0),
                    child: const Icon(
                      Icons.qr_code,
                      size: 80,
                      color: Color(0xffB0B4C0),
                    ),
                  );
                },
              ),
            )
          else
            Container(
              width: 180,
              height: 180,
              color: const Color(0xffF0F0F0),
              child: const Icon(
                Icons.qr_code,
                size: 80,
                color: Color(0xffB0B4C0),
              ),
            ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.qr_code,
                size: 16,
                color: Color(0xff06B6D4),
              ),
              const SizedBox(width: 6),
              Text(
                qr.scanMethod == ScanMethod.staffQr
                    ? 'QR Nhân viên'
                    : 'QR Sự kiện',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff67688C),
                ),
              ),
            ],
          ),
          if (qr.expiryTime != null) ...[
            const SizedBox(height: 8),
            _buildExpiryTimer(qr.expiryTime!, participant.eventParticipantId!),
          ],
        ],
      ),
    );
  }

  Widget _buildExpiryTimer(DateTime expiryTime, int eventParticipantId) {
    return Obx(() {
      final controller = MyQrController.ensureInstance();
      final qr = controller.getQrFor(eventParticipantId);
      final remaining = qr?.expiryTime?.difference(DateTime.now());

      if (remaining == null || remaining.isNegative) {
        return const Text(
          'QR đã hết hạn',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xffDB0025),
            fontWeight: FontWeight.w500,
          ),
        );
      }

      final minutes = remaining.inMinutes;
      final seconds = remaining.inSeconds % 60;

      return Text(
        'Hết hạn sau: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xffF59E0B),
          fontWeight: FontWeight.w500,
        ),
      );
    });
  }

  Widget _buildStaffQrPlaceholder() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xffF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xffE5E7EB),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xffDB0025).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.badge,
              size: 40,
              color: Color(0xffDB0025),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'QR Cộng tác viên',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xff273143),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'QR sẽ hiển thị khi được duyệt',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xff67688C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoQrPlaceholder() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xffF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xffE5E7EB),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xffB0B4C0).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.qr_code_2,
              size: 40,
              color: Color(0xffB0B4C0),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Chưa có QR',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xff273143),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'QR sẽ được tạo khi sự kiện bắt đầu',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xff67688C),
            ),
          ),
        ],
      ),
    );
  }
}
