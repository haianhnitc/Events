import 'package:flutter/material.dart';

enum OrganizerStatBarVariant { inline, card, compact }

class OrganizerStatBar extends StatelessWidget {
  const OrganizerStatBar({
    super.key,
    required this.stats,
    this.variant = OrganizerStatBarVariant.inline,
    this.backgroundColor,
  });

  final List<OrganizerStatItem> stats;
  final OrganizerStatBarVariant variant;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case OrganizerStatBarVariant.inline:
        return _buildInline();
      case OrganizerStatBarVariant.card:
        return _buildCard();
      case OrganizerStatBarVariant.compact:
        return _buildCompact();
    }
  }

  Widget _buildInline() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 8),
        ],
      ),
      child: Row(
        children: stats.asMap().entries.map((entry) {
          final index = entry.key;
          final stat = entry.value;
          return Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  stat.value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: stat.color,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  stat.label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                if (index < stats.length - 1) ...[
                  const SizedBox(width: 8),
                  Container(width: 1, height: 16, color: Colors.grey.shade200),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F000000), offset: Offset(0, 4), blurRadius: 12),
        ],
      ),
      child: Row(
        children: stats.asMap().entries.map((entry) {
          final index = entry.key;
          final stat = entry.value;
          return Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: stat.color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(stat.icon, size: 20, color: stat.color),
                ),
                const SizedBox(height: 8),
                Text(
                  stat.value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: stat.color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  stat.label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Container(width: 1, height: 24, color: Colors.grey.shade200),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCompact() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: stats.asMap().entries.map((entry) {
          final index = entry.key;
          final stat = entry.value;
          return Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: stat.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(stat.icon ?? Icons.circle,
                          size: 12, color: stat.color),
                      const SizedBox(width: 4),
                      Text(
                        '${stat.value} ${stat.label}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: stat.color,
                        ),
                      ),
                    ],
                  ),
                ),
                if (index < stats.length - 1) const SizedBox(width: 8),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class OrganizerStatItem {
  final String value;
  final String label;
  final Color color;
  final IconData? icon;

  const OrganizerStatItem({
    required this.value,
    required this.label,
    required this.color,
    this.icon,
  });
}
