import 'package:flutter/material.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class OrganizerStatusBadge extends StatelessWidget {
  const OrganizerStatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.textColor,
    this.icon,
  });

  final String label;
  final Color color;
  final Color? textColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: textColor ?? color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  factory OrganizerStatusBadge.draft() => const OrganizerStatusBadge(
        label: 'Nháp',
        color: Color(0xff94A3B8),
      );

  factory OrganizerStatusBadge.published() => const OrganizerStatusBadge(
        label: 'Đã đăng',
        color: Color(0xFF10B981),
        icon: Icons.check_circle_outline,
      );

  factory OrganizerStatusBadge.closed() => const OrganizerStatusBadge(
        label: 'Đã đóng',
        color: Color(0xff64748B),
        icon: Icons.lock_outline,
      );

  factory OrganizerStatusBadge.cancelled() => const OrganizerStatusBadge(
        label: 'Đã hủy',
        color: Color(0xffEF4444),
      );

  factory OrganizerStatusBadge.locked() => const OrganizerStatusBadge(
        label: 'Đã khóa',
        color: Color(0xff7C3AED),
        icon: Icons.lock,
      );

  factory OrganizerStatusBadge.pending() => const OrganizerStatusBadge(
        label: 'Chờ duyệt',
        color: Color(0xffF59E0B),
        icon: Icons.schedule,
      );

  factory OrganizerStatusBadge.approved() => const OrganizerStatusBadge(
        label: 'Đã duyệt',
        color: Color(0xFF10B981),
        icon: Icons.check_circle,
      );

  factory OrganizerStatusBadge.rejected() => const OrganizerStatusBadge(
        label: 'Từ chối',
        color: Color(0xffEF4444),
        icon: Icons.cancel,
      );

  factory OrganizerStatusBadge.open() => const OrganizerStatusBadge(
        label: 'Mở tuyển',
        color: Color(0xFF10B981),
        icon: Icons.play_arrow,
      );

  factory OrganizerStatusBadge.fromStatus(EventStatus status) {
    switch (status) {
      case EventStatus.published:
        return OrganizerStatusBadge.published();
      case EventStatus.draft:
        return OrganizerStatusBadge.draft();
      case EventStatus.closed:
        return OrganizerStatusBadge.closed();
      case EventStatus.cancelled:
        return OrganizerStatusBadge.cancelled();
      case EventStatus.locked:
        return OrganizerStatusBadge.locked();
    }
  }
}
