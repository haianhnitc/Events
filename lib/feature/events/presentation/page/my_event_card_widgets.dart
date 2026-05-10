import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';
import 'package:events_app/feature/registration/presentation/controller/registration_controller.dart';

class RoleBadge extends StatelessWidget {
  const RoleBadge({super.key, required this.isCtv});
  final bool isCtv;

  @override
  Widget build(BuildContext context) {
    final color = isCtv ? const Color(0xffDB0025) : const Color(0xff06B6D4);
    final label = isCtv ? 'CTV' : 'Người tham dự';
    return _typeChip(label, color);
  }
}

class PriceBadge extends StatelessWidget {
  const PriceBadge({super.key, required this.isPaid});
  final bool isPaid;

  @override
  Widget build(BuildContext context) {
    if (!isPaid) return const SizedBox.shrink();
    return _typeChip('Có phí', const Color(0xffF59E0B));
  }
}

Widget _typeChip(String label, Color color) {
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

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.participant,
    this.showQrButton = false,
    this.onTap,
  });
  final ParticipantEntity participant;
  final bool showQrButton;
  final VoidCallback? onTap;

  bool get _canCancel {
    if (participant.participantType != ParticipantType.attendee) return false;
    if (participant.hasCheckedIn == true) return false;
    if (participant.status == ParticipantStatus.attended ||
        participant.status == ParticipantStatus.noShow) {
      return false;
    }
    final myId = AuthController.to.currentUser.value?.userId;
    final isOwner = participant.user?.userId == myId;
    final role = AuthController.to.currentUser.value?.role;
    final isAdmin = role == UserRole.admin || role == UserRole.organization;
    if (!isOwner && !isAdmin) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardHeader(),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              _buildRewardsRow(),
              if (showQrButton) ...[
                const SizedBox(height: 14),
                _QrActionRow(participant: participant),
              ] else ...[
                const SizedBox(height: 14),
                _FeedbackActionRow(participant: participant),
              ],
              if (_canCancel) ...[
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                _CancelRow(
                  participant: participant,
                  onCancel: () => _showCancelDialog(context, participant),
                ),
              ],
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardHeader() {
    final isCtv = participant.participantType == ParticipantType.ctv;
    final hasTicket = participant.ticketId != null;
    final isPaid =
        participant.participantType == ParticipantType.attendee && hasTicket;

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              RoleBadge(isCtv: isCtv),
              const SizedBox(width: 6),
              PriceBadge(isPaid: isPaid),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            participant.eventTitle ?? 'Sự kiện',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xff273143),
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (participant.registeredTime != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 12,
                  color: Color(0xff94A3B8),
                ),
                const SizedBox(width: 4),
                Text(
                  _formatDate(participant.registeredTime!),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff94A3B8),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRewardsRow() {
    if (participant.participantType != ParticipantType.ctv) {
      final hasTicket = participant.ticketId != null;
      if (hasTicket) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(left: 14, right: 14, top: 10),
        child: _rewardTag(
          Icons.workspace_premium_outlined,
          'Miễn phí',
          const Color(0xff94A3B8),
        ),
      );
    }

    final price = participant.ticketId != null ? 0 : null;
    final items = <Widget>[];

    if (price != null && price > 0) {
      items.add(_rewardTag(
        Icons.payments_outlined,
        '${NumberFormat('#,###').format(price)}đ',
        const Color(0xff06B6D4),
      ));
    }

    final certName = participant.eventId != null ? '' : null;
    if (certName != null && certName.isEmpty) {
      items.add(_rewardTag(
        Icons.verified_outlined,
        'Chứng nhận CTV',
        const Color(0xff22C55E),
      ));
    }

    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 10),
      child: Wrap(spacing: 8, runSpacing: 8, children: items),
    );
  }

  Widget _rewardTag(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
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

  void _showCancelDialog(BuildContext context, ParticipantEntity p) {
    final title = p.eventTitle ?? 'sự kiện này';
    final hasTicket = p.ticketId != null;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                    Icon(Icons.info_outline,
                        color: Color(0xffF59E0B), size: 20),
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
                  borderRadius: BorderRadius.circular(8)),
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
                RegistrationController.ensureInstance()
                    .cancelRegistration(p.eventParticipantId!);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffEF4444),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: const Text(
              'Hủy đăng ký',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} • ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _QrActionRow extends StatelessWidget {
  const _QrActionRow({required this.participant});
  final ParticipantEntity participant;

  @override
  Widget build(BuildContext context) {
    final isCtv = participant.participantType == ParticipantType.ctv;
    final hasTicket = participant.ticketId != null;
    final isFree = !isCtv && !hasTicket;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: _QrButton(
        label: 'Lấy QR để check-in',
        icon: Icons.qr_code,
        color: const Color(0xff06B6D4),
        onTap: () => _showQrSheet(context, isFree),
      ),
    );
  }

  void _showQrSheet(BuildContext ctx, bool isFree) {
    final participantId = participant.eventParticipantId;
    if (participantId == null) return;

    if (isFree) {
      AppSnackbarUtils.showInfo(
        'Sự kiện miễn phí',
        'Hãy quét mã QR của sự kiện để check-in',
      );
      return;
    }

    final qrContent = participant.participantQrContent;
    final eventTitle = participant.eventTitle ?? 'QR Sự kiện';
    final screenH = MediaQuery.of(ctx).size.height;

    Get.bottomSheet(
      Container(
        width: double.infinity,
        height: screenH * 0.85,
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
              child: qrContent != null && qrContent.isNotEmpty
                  ? Column(
                      children: [
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
                              child: QrImageView(
                                data: qrContent,
                                version: QrVersions.auto,
                                size: 260,
                                backgroundColor: Colors.white,
                                errorCorrectionLevel: QrErrorCorrectLevel.M,
                                errorStateBuilder: (ctx, err) => const Icon(
                                  Icons.qr_code,
                                  size: 140,
                                  color: Color(0xffB0B4C0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Người tổ chức sự kiện quét mã này để checkin cho bạn',
                          style:
                              TextStyle(fontSize: 12, color: Color(0xff67688C)),
                        ),
                      ],
                    )
                  : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.qr_code_2,
                              size: 48, color: Color(0xffB0B4C0)),
                          SizedBox(height: 12),
                          Text(
                            'Chưa có mã QR',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff273143),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'QR sẽ có khi sự kiện bắt đầu',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xff67688C)),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}

class _FeedbackActionRow extends StatelessWidget {
  const _FeedbackActionRow({required this.participant});
  final ParticipantEntity participant;

  @override
  Widget build(BuildContext context) {
    final isAttended = participant.status == ParticipantStatus.attended;
    final hasFeedback = participant.hasFeedback == true;

    if (isAttended && !hasFeedback) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: _QrButton(
          label: 'Đánh giá',
          icon: Icons.rate_review_outlined,
          color: const Color(0xff06B6D4),
          onTap: () => Get.toNamed('/feedback',
              arguments: {'eventId': participant.eventId}),
        ),
      );
    }

    if (isAttended && hasFeedback) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 14),
        child: _QrButton(
          label: 'Đã đánh giá',
          icon: Icons.check_circle_outline,
          color: Color(0xff22C55E),
          filled: false,
          onTap: null,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class _QrButton extends StatelessWidget {
  const _QrButton({
    required this.label,
    required this.icon,
    required this.color,
    this.filled = true,
    this.onTap,
  });
  final String label;
  final IconData icon;
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
          border: Border.all(color: color.withValues(alpha: 0.3)),
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

class _CancelRow extends StatelessWidget {
  const _CancelRow({required this.participant, required this.onCancel});
  final ParticipantEntity participant;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onCancel,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          foregroundColor: const Color(0xffEF4444),
        ),
        child: const Text(
          'Hủy đăng ký',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
