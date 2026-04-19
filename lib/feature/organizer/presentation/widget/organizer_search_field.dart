import 'package:flutter/material.dart';

class OrganizerSearchField extends StatelessWidget {
  const OrganizerSearchField({
    super.key,
    required this.controller,
    this.hintText,
    this.onChanged,
    this.onClear,
    this.prefixIcon,
  });

  final TextEditingController controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText ?? 'Tìm kiếm...',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          prefixIcon: Icon(
            prefixIcon ?? Icons.search,
            size: 20,
            color: Colors.grey.shade400,
          ),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              return value.text.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        controller.clear();
                        onClear?.call();
                      },
                      child: const Icon(Icons.close, size: 18, color: Colors.grey),
                    )
                  : const SizedBox.shrink();
            },
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    );
  }
}