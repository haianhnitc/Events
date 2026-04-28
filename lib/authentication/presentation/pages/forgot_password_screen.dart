import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = AuthController.ensureInstance();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffEAFBFF), Color(0xffFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        ),
                        const Expanded(
                          child: Text(
                            'Khôi phục mật khẩu',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xff273143),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.fromLTRB(18, 20, 18, 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color:
                                const Color(0xff06B6D4).withValues(alpha: 0.12),
                            blurRadius: 30,
                            offset: const Offset(0, 12),
                          )
                        ],
                      ),
                      child: Form(
                        key: authController.forgotPasswordFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Nhập email để nhận liên kết đặt lại mật khẩu',
                              style: TextStyle(
                                color: Color(0xff67688C),
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller:
                                  authController.forgotPasswordEmailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: authController.validateEmail,
                            ),
                            const SizedBox(height: 18),
                            Obx(() {
                              return SizedBox(
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: authController.isLoadingEmail.value
                                      ? null
                                      : authController.submitForgotPassword,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff06B6D4),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: authController.isLoadingEmail.value
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          'Gửi email',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                ),
                              );
                            }),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Đã nhớ mật khẩu?',
                                  style: TextStyle(
                                    color: Color(0xff67688C),
                                    fontSize: 13,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: const Text(
                                    ' Đăng nhập',
                                    style: TextStyle(
                                      color: Color(0xff06B6D4),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
