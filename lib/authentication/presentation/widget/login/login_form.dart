import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/authentication/presentation/pages/forgot_password_screen.dart';
import 'package:events_app/common/path/asset_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LoginForm extends StatelessWidget {
  final bool isStudent;

  const LoginForm({super.key, required this.isStudent});

  @override
  Widget build(BuildContext context) {
    final authController = AuthController.to;

    return Obx(
      () => Form(
        key: authController.loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildEmailField(authController),
            const SizedBox(height: 16),
            _buildPasswordField(authController),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Get.to(() => const ForgotPasswordScreen()),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                ),
                child: const Text(
                  'Quên mật khẩu?',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xff64748B),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildSubmitButton(authController),
            const SizedBox(height: 16),
            _buildDivider(),
            const SizedBox(height: 16),
            _buildGoogleButton(authController),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField(AuthController authController) {
    return TextFormField(
      controller: authController.loginEmailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Nhập email',
        prefixIcon: const Icon(Icons.mail_outline, size: 20, color: Color(0xff94A3B8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: authController.validateEmail,
    );
  }

  Widget _buildPasswordField(AuthController authController) {
    return TextFormField(
      controller: authController.loginPasswordController,
      obscureText: authController.loginObscurePassword.value,
      textInputAction: TextInputAction.done,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: 'Mật khẩu',
        hintText: 'Nhập mật khẩu',
        prefixIcon: const Icon(Icons.lock_outline, size: 20, color: Color(0xff94A3B8)),
        suffixIcon: IconButton(
          onPressed: authController.toggleLoginPasswordVisibility,
          icon: Icon(
            authController.loginObscurePassword.value
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            size: 20,
            color: const Color(0xff94A3B8),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: authController.validateLoginPassword,
    );
  }

  Widget _buildSubmitButton(AuthController authController) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: authController.isLoading.value
            ? null
            : authController.submitLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff06B6D4),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child: authController.isLoading.value
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Đăng nhập',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 18),
                ],
              ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'hoặc đăng nhập với',
            style: TextStyle(color: Color(0xff94A3B8), fontSize: 13),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300)),
      ],
    );
  }

  Widget _buildGoogleButton(AuthController authController) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: authController.signInWithGoogle,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(AssetPath.googleIcon, height: 20),
            const SizedBox(width: 10),
            const Text(
              'Google',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
