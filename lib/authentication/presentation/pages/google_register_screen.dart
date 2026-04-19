import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/authentication/presentation/widget/register/register_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoogleRegisterScreen extends StatelessWidget {
  final bool isStudent;

  const GoogleRegisterScreen({super.key, required this.isStudent});

  @override
  Widget build(BuildContext context) {
    final authController = AuthController.to;
    final googleResult = authController.googleAuthResult.value;

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xff273143)),
        ),
        title: Column(
          children: [
            Text(
              isStudent ? 'Đăng ký sinh viên' : 'Đăng ký tổ chức',
              style: const TextStyle(
                color: Color(0xff273143),
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle,
                    color: Color(0xff10B981), size: 14),
                const SizedBox(width: 4),
                Text(
                  'Đã đăng nhập Google',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildGoogleInfoCard(googleResult),
              const SizedBox(height: 20),
              _buildFormCard(authController, isStudent),
              const SizedBox(height: 20),
              _buildLoginPrompt(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleInfoCard(GoogleAuthSession googleResult) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xff10B981).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xfff0fdf4),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.check_circle,
              color: Color(0xff10B981),
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  googleResult.email.isNotEmpty
                      ? googleResult.email
                      : 'Đã xác thực Google',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff273143),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Tài khoản Google đã được xác thực',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(AuthController authController, bool isStudent) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: RegisterForm(isStudent: isStudent, isGoogleRegister: true),
    );
  }

  Widget _buildLoginPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Đã có tài khoản? ',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.back();
            Get.back();
          },
          child: const Text(
            'Đăng nhập',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xff06B6D4),
            ),
          ),
        ),
      ],
    );
  }
}
