import 'package:flutter/material.dart';

class OrganizerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const OrganizerAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions = const [],
    this.bottom,
    this.elevation = 0,
    this.backgroundColor,
    this.titleColor,
    this.onBack,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget> actions;
  final PreferredSizeWidget? bottom;
  final double elevation;
  final Color? backgroundColor;
  final Color? titleColor;
  final VoidCallback? onBack;

  @override
  Size get preferredSize =>
      Size.fromHeight(bottom != null ? 108 : kToolbarHeight + elevation);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.white,
      elevation: elevation,
      leading: leading ??
          (Navigator.canPop(context)
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xff64748B)),
                  onPressed: onBack ?? () => Navigator.pop(context),
                )
              : null),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: titleColor ?? const Color(0xff273143),
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 1),
            Text(
              subtitle!,
              style: const TextStyle(
                color: Color(0xff94A3B8),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ],
      ),
      centerTitle: true,
      actions: actions,
      bottom: bottom,
    );
  }
}
