import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrganizerPendingApprovalScreen extends StatelessWidget {
  const OrganizerPendingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.hourglass_top_rounded,
                  size: 72,
                  color: Color(0xff06B6D4),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tài khoản đang chờ duyệt',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff273143),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Hồ sơ tổ chức của bạn đã được gửi thành công. Vui lòng chờ quản trị viên xét duyệt trước khi sử dụng các tính năng dành cho organizer.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff67688C),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _handleLogout(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff06B6D4),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Đăng xuất',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogout() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Xác nhận đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              AuthController.to.logout();
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xffDB0025),
            ),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }
}
