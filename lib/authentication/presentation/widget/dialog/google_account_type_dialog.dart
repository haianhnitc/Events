import 'package:events_app/authentication/presentation/widget/login/google_account_type_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool?> showGoogleAccountTypeDialog() async {
  return Get.dialog<bool>(
    AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Column(
        children: [
          Icon(
            Icons.account_circle_outlined,
            size: 48,
            color: Color(0xff06B6D4),
          ),
          SizedBox(height: 12),
          Text(
            'Chọn loại tài khoản',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xff273143),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Bạn muốn đăng nhập với tư cách nào?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xff64748B),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                GoogleAccountTypeButton(
                  icon: Icons.school_outlined,
                  title: 'Tôi là sinh viên',
                  subtitle: 'Tham gia sự kiện, đăng ký CTV',
                  onTap: () => Get.back(result: true),
                ),
                const SizedBox(height: 12),
                GoogleAccountTypeButton(
                  icon: Icons.business_outlined,
                  title: 'Tôi là tổ chức',
                  subtitle: 'Tạo và quản lý sự kiện',
                  onTap: () => Get.back(result: false),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: null),
          child: const Text(
            'Hủy',
            style: TextStyle(color: Color(0xff64748B)),
          ),
        ),
      ],
    ),
    barrierDismissible: true,
  );
}
