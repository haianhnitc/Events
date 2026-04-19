import 'package:flutter/material.dart';

class OrganizerSectionHeader extends StatelessWidget {
  const OrganizerSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
    this.padding,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xff273143),
            ),
          ),
          const Spacer(),
          if (actionLabel != null)
            GestureDetector(
              onTap: onActionTap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    actionLabel!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xff06B6D4),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: Color(0xff06B6D4),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}