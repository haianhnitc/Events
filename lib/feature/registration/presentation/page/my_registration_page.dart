import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/feature/attendance/presentation/controller/my_qr_controller.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/common/utils/app_image_utils.dart';
import 'package:events_app/feature/event_management/presentation/page/ctv_detail_page.dart';
import 'package:events_app/feature/event_management/presentation/page/event_detail_page.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';
import 'package:events_app/feature/registration/presentation/controller/registration_controller.dart';

class MyRegistrationPage extends StatefulWidget {
  const MyRegistrationPage({super.key});

  @override
  State<MyRegistrationPage> createState() => _MyRegistrationPageState();
}

class _MyRegistrationPageState extends State<MyRegistrationPage> {
  final RegistrationController _controller =
      RegistrationController.ensureInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xff06B6D4),
        elevation: 0,
        title: const Text(
          'Sự Kiện Đã Tham Gia',
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
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => _controller.loadMyRegistrations(refresh: true),
          ),
        ],
      ),
      body: Obx(() {
        if (_controller.isLoading.value && _controller.registrations.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xff06B6D4)),
          );
        }
        if (_controller.registrations.isEmpty) {
          return _buildEmptyState();
        }
        final sorted = List<ParticipantEntity>.from(_controller.registrations);
        sorted.sort((a, b) {
          final aEnded = a.status == ParticipantStatus.attended ||
              a.status == ParticipantStatus.noShow ||
              a.isCheckOut == true;
          final bEnded = b.status == ParticipantStatus.attended ||
              b.status == ParticipantStatus.noShow ||
              b.isCheckOut == true;
          if (aEnded != bEnded) return aEnded ? 1 : -1;
          final aTime = a.event?.startTime ?? DateTime(1900);
          final bTime = b.event?.startTime ?? DateTime(1900);
          return bTime.compareTo(aTime);
        });
        return RefreshIndicator(
          onRefresh: () => _controller.loadMyRegistrations(refresh: true),
          color: const Color(0xff06B6D4),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sorted.length,
            itemBuilder: (context, index) {
              final p = sorted[index];
              return GestureDetector(
                onTap: () => _navigateToDetail(p),
                child: _buildCard(p),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.event_available,
                size: 40,
                color: Color(0xffB0B4C0),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Chưa có đăng ký nào',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff273143),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Đăng ký tham gia sự kiện để xem tại đây',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff67688C),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(ParticipantEntity p) {
    final isCtv = p.participantType == ParticipantType.ctv;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: _buildBanner(p),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _buildTypeChip(p),
                              const SizedBox(width: 6),
                              _buildStatusChip(p.status),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            p.event?.title ?? p.eventTitle ?? 'Sự kiện',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff273143),
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          if (p.event?.startTime != null) ...[
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 12,
                                  color: Color(0xff94A3B8),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    AppDateUtils.formatDate(
                                        p.event!.startTime!),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xff94A3B8),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                if (isCtv) ...[
                  const SizedBox(height: 12),
                  _buildRewardsRow(p),
                ],
                const SizedBox(height: 14),
                _buildActionRow(p),
              ],
            ),
          ),
          if (_canCancel(p))
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFF1F5F9),
                    width: 1,
                  ),
                ),
              ),
              child: TextButton(
                onPressed: () => _showCancelDialog(p),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(16)),
                  ),
                ),
                child: const Text(
                  'Hủy đăng ký',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xffEF4444),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBanner(ParticipantEntity p) {
    final banner = p.event?.banner;
    return banner != null
        ? AppImageUtils.buildNetworkImage(
            imageUrl: banner,
            placeholder: AppImageUtils.buildImagePlaceholder(icon: Icons.event),
            fit: BoxFit.cover,
          )
        : AppImageUtils.buildImagePlaceholder(icon: Icons.event);
  }

  Widget _buildTypeChip(ParticipantEntity p) {
    final isCtv = p.participantType == ParticipantType.ctv;
    final hasTicket = p.ticketId != null;
    final color = isCtv ? const Color(0xffDB0025) : const Color(0xff06B6D4);
    final label = isCtv ? 'CTV' : (hasTicket ? 'Người tham dự' : 'Miễn phí');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildStatusChip(ParticipantStatus? status) {
    Color color;
    String label;
    if (status == ParticipantStatus.attended) {
      color = const Color(0xff22C55E);
      label = 'Đã tham dự';
    } else if (status == ParticipantStatus.noShow) {
      color = const Color(0xffEF4444);
      label = 'Không tham dự';
    } else {
      color = const Color(0xffF59E0B);
      label = 'Đã đăng ký';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _buildRewardsRow(ParticipantEntity p) {
    final coinReward = p.event?.youthUnionPoint;
    final certName = p.event?.certificateName;
    final price = p.event?.price;
    final isFree = price == null || price == 0;

    final items = <Widget>[];

    if (coinReward != null && coinReward > 0) {
      items.add(_rewardTag(
        Icons.monetization_on_outlined,
        '+$coinReward đoàn',
        const Color(0xffF59E0B),
      ));
    }
    if (certName != null && certName.isNotEmpty) {
      items.add(_rewardTag(
        Icons.verified_outlined,
        certName,
        const Color(0xff22C55E),
      ));
    }
    if (!isFree) {
      items.add(_rewardTag(
        Icons.payments_outlined,
        '${NumberFormat('#,###').format(price)}đ',
        const Color(0xff06B6D4),
      ));
    }
    if ((coinReward == null || coinReward == 0) &&
        (certName == null || certName.isEmpty) &&
        isFree) {
      items.add(_rewardTag(
        Icons.workspace_premium_outlined,
        'Miễn phí',
        const Color(0xff94A3B8),
      ));
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items,
    );
  }

  Widget _rewardTag(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(ParticipantEntity p) {
    final isAttended = p.status == ParticipantStatus.attended;
    final hasFeedback = p.hasFeedback == true;
    final bool showFeedback = isAttended && !hasFeedback;
    final bool showFeedbackDone = isAttended && hasFeedback;

    if (!showFeedback && !showFeedbackDone) {
      return const SizedBox.shrink();
    }

    if (showFeedbackDone) {
      return Row(
        children: [
          Expanded(
            child: _ActionBtn(
              icon: Icons.check_circle_outline,
              label: 'Đã đánh giá',
              color: const Color(0xff22C55E),
              filled: false,
              onTap: null,
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: _ActionBtn(
            icon: Icons.rate_review_outlined,
            label: 'Đánh giá',
            color: const Color(0xff06B6D4),
            filled: true,
            onTap: () => _navigateToFeedback(p.eventId!),
          ),
        ),
      ],
    );
  }

  void _navigateToDetail(ParticipantEntity p) {
    if (p.participantType == ParticipantType.ctv) {
      Get.to(
        () => CtvDetailPage(ctvRecruitmentId: p.recruitmentId),
      );
    } else {
      Get.to(
        () => EventDetailPage(eventId: p.eventId),
      );
    }
  }

  void _navigateToFeedback(int eventId) {
    Get.toNamed('/feedback', arguments: {'eventId': eventId});
  }

  bool _canCancel(ParticipantEntity p) {
    if (p.participantType != ParticipantType.attendee) return false;
    if (p.hasCheckedIn == true) return false;
    if (p.status == ParticipantStatus.attended ||
        p.status == ParticipantStatus.noShow) return false;
    final myId = AuthController.to.currentUser.value?.userId;
    final isOwner = p.user?.userId == myId;
    final role = AuthController.to.currentUser.value?.role;
    final isAdmin = role == UserRole.admin || role == UserRole.organization;
    if (!isOwner && !isAdmin) return false;
    final startTime = p.event?.startTime;
    if (startTime == null) return false;
    if (DateTime.now().isAfter(startTime.subtract(
      const Duration(hours: 24),
    ))) return false;
    return true;
  }

  void _showCancelDialog(ParticipantEntity p) {
    final title = p.event?.title ?? p.eventTitle ?? 'sự kiện này';
    final hasTicket = p.ticketId != null;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xffFEE2E2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xffEF4444),
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Hủy đăng ký',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff1A1D1F),
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bạn có chắc muốn hủy đăng ký "$title"?',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xff4B5563),
              ),
            ),
            if (hasTicket) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xffFEF3C7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Color(0xffF59E0B),
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Bạn sẽ được hoàn coin đã dùng mua vé.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xff92400E),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              backgroundColor: const Color(0xffF3F4F6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Giữ đăng ký',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xff4B5563),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              if (p.eventParticipantId != null) {
                _controller.cancelRegistration(p.eventParticipantId!);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffEF4444),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Hủy đăng ký',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    this.filled = true,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool filled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (!filled) {
      return Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 16, color: color),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: onTap != null ? color : color.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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

class _QrBtn extends StatefulWidget {
  const _QrBtn({required this.p});
  final ParticipantEntity p;

  @override
  State<_QrBtn> createState() => _QrBtnState();
}

class _QrBtnState extends State<_QrBtn> {
  bool _loading = false;
  bool _qrReady = false;

  @override
  Widget build(BuildContext context) {
    if (_qrReady) {
      return _buildQrReadyBtn();
    }
    if (_loading) {
      return Container(
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xff06B6D4).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xff06B6D4),
            ),
          ),
        ),
      );
    }
    return _buildFetchBtn();
  }

  Widget _buildQrReadyBtn() {
    final isCtv = widget.p.participantType == ParticipantType.ctv;
    return _ActionBtn(
      icon: Icons.qr_code_2,
      label: isCtv ? 'Xem QR CTV' : 'Xem QR vé',
      color: const Color(0xff22C55E),
      filled: true,
      onTap: () => _showQrSheet(context),
    );
  }

  Widget _buildFetchBtn() {
    final isCtv = widget.p.participantType == ParticipantType.ctv;
    return _ActionBtn(
      icon: Icons.qr_code,
      label: isCtv ? 'Lấy QR CTV' : 'Lấy QR vé',
      color: const Color(0xff06B6D4),
      filled: true,
      onTap: () async {
        setState(() => _loading = true);
        await MyQrController.ensureInstance().loadQrFor(widget.p);
        if (mounted) {
          setState(() {
            _loading = false;
            _qrReady = true;
          });
        }
      },
    );
  }

  void _showQrSheet(BuildContext ctx) {
    final participantId = widget.p.eventParticipantId;
    if (participantId == null) return;

    final qrController = MyQrController.ensureInstance();
    final qr = qrController.getQrFor(participantId);
    final eventTitle =
        widget.p.event?.title ?? widget.p.eventTitle ?? 'QR Sự kiện';

    Get.bottomSheet(
      Container(
        width: double.infinity,
        height: MediaQuery.of(ctx).size.height * 0.85,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xffE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              eventTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff273143),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xff06B6D4).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Mã QR Check-in',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff06B6D4),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Obx(() {
                final qrNow = qrController.getQrFor(participantId);
                if (qrNow == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.qr_code_2,
                          size: 48,
                          color: Color(0xffB0B4C0),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Chưa có mã QR',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff273143),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'QR sẽ có khi sự kiện bắt đầu',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff67688C),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: qrController.isLoading.value
                              ? null
                              : () => qrController.loadQrFor(widget.p),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff06B6D4),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Lấy QR'),
                        ),
                      ],
                    ),
                  );
                }
                return Column(
                  children: [
                    if (qrNow.expiryTime != null) ...[
                      Text(
                        'Hết hạn: ${_formatExpiry(qrNow.expiryTime!)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xffF59E0B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: qrNow.qrContent != null &&
                                  qrNow.qrContent!.isNotEmpty
                              ? Image.memory(
                                  base64Decode(qrNow.qrContent!),
                                  width: 260,
                                  height: 260,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.qr_code,
                                    size: 140,
                                    color: Color(0xffB0B4C0),
                                  ),
                                )
                              : const Icon(
                                  Icons.qr_code,
                                  size: 140,
                                  color: Color(0xffB0B4C0),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Quét mã QR để check-in',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff67688C),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  String _formatExpiry(DateTime expiry) {
    final diff = expiry.difference(DateTime.now());
    if (diff.isNegative) return 'Đã hết hạn';
    return '${diff.inMinutes}p ${diff.inSeconds % 60}giây';
  }
}
