import 'package:flutter/material.dart';

class OrganizerStatCard extends StatelessWidget {
  const OrganizerStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    this.trend,
    this.subValue,
    this.tooltipMessage,
    this.onTap,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final String? trend;
  final String? subValue;
  final String? tooltipMessage;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            offset: Offset(0, 2),
            blurRadius: 8),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, size: 18, color: iconColor),
                    ),
                    const Spacer(),
                    if (trend != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _trendColor(trend!).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          trend!,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: _trendColor(trend!),
                          ),
                        ),
                      ),
                    if (tooltipMessage != null) ...[
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => _showTooltip(context),
                        child: Icon(Icons.info_outline,
                            size: 14, color: Colors.grey.shade400),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: iconColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (subValue != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subValue!,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _trendColor(String trend) {
    if (trend.startsWith('+')) return const Color(0xFF10B981);
    if (trend.startsWith('-')) return const Color(0xFFEF4444);
    return Colors.grey;
  }

  void _showTooltip(BuildContext context) {
    if (tooltipMessage == null) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        content: Text(tooltipMessage!,
            style: const TextStyle(fontSize: 13, color: Color(0xff64748B))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
}
