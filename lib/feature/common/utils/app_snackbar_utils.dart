import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbarUtils {
  const AppSnackbarUtils._();

  static void showSuccess(
    String title,
    String message, {
    String? icon,
  }) {
    _show(
      title: title,
      message: message,
      accentColor: const Color(0xff00A63E),
      icon: icon ?? '✓',
    );
  }

  static void showError(
    String title,
    String message, {
    String? icon,
  }) {
    _show(
      title: title,
      message: message,
      accentColor: const Color(0xffDB0025),
      icon: icon ?? '!',
    );
  }

  static void showInfo(
    String title,
    String message, {
    String? icon,
  }) {
    _show(
      title: title,
      message: message,
      accentColor: const Color(0xff06B6D4),
      icon: icon ?? 'i',
    );
  }

  static void _show({
    required String title,
    required String message,
    required Color accentColor,
    required String icon,
  }) {
    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.TOP,
      snackStyle: SnackStyle.FLOATING,
      backgroundColor: Colors.white,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      borderRadius: 18,
      borderColor: accentColor.withOpacity(0.25),
      borderWidth: 1.2,
      boxShadows: [
        BoxShadow(
          color: accentColor.withOpacity(0.14),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
      titleText: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                icon,
                style: TextStyle(
                  color: accentColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xff273143),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      messageText: Padding(
        padding: const EdgeInsets.only(left: 38, top: 4),
        child: Text(
          message,
          style: const TextStyle(
            color: Color(0xff67688C),
            fontSize: 13,
            height: 1.35,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      icon: const SizedBox.shrink(),
    );
  }
}
