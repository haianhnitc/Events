import 'package:flutter/material.dart';

class OrganizerStatCard extends StatelessWidget {
  const OrganizerStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor,
    this.onTap,
    this.trend,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;
  final String? trend;

  Color _trendColor(String trend) {
    if (trend.startsWith('-')) return const Color(0xFFEF4444);
    return const Color(0xFF10B981);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              offset: Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (iconColor ?? const Color(0xff06B6D4)).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: iconColor ?? const Color(0xff06B6D4),
                  ),
                ),
                const Spacer(),
                if (trend != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _trendColor(trend!).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      trend!,
                      style: TextStyle(
                        fontSize: 11,
                        color: _trendColor(trend!),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xff273143),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}