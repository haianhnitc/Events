import 'package:events_app/app_layout.dart';
import 'package:events_app/authentication/presentation/pages/register_screen.dart';
import 'package:events_app/common/presentation/widget/custom_text_field.dart';
import 'package:events_app/common/path/asset_path.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/authentication/presentation/pages/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              _buildHeader(),
              const SizedBox(height: 32),
              _buildFormCard(),
              const SizedBox(height: 20),
              _buildRegisterPrompt(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xff06B6D4),
            borderRadius: BorderRadius.circular(16),
          ),
          child: SvgPicture.asset(
            AssetPath.logo,
            width: 32,
            height: 32,
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Chào mừng bạn!',
          style: TextStyle(
            color: Color(0xff273143),
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Đăng nhập để tham gia sự kiện thú vị',
          style: TextStyle(
            color: Color(0xff94A3B8),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const _LoginForm(),
    );
  }

  Widget _buildRegisterPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Chưa có tài khoản? ',
          style: TextStyle(color: Color(0xff64748B), fontSize: 14),
        ),
        GestureDetector(
          onTap: () => Get.to(() => const RegisterScreen()),
          child: const Text(
            'Đăng ký',
            style: TextStyle(
              color: Color(0xff06B6D4),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AuthController.to.loginFormState = _formKey.currentState;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authController = AuthController.to;

    return Form(
      key: _formKey,
      child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: authController.loginEmailController,
                labelText: 'Email',
                hintText: 'Nhập email của bạn',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.mail_outline, size: 20, color: Color(0xff94A3B8)),
                validator: authController.validateEmail,
              ),
              const SizedBox(height: 16),
              Obx(
                () => CustomTextField(
                  controller: authController.loginPasswordController,
                  labelText: 'Mật khẩu',
                  hintText: 'Nhập mật khẩu',
                  obscureText: authController.loginObscurePassword.value,
                  textInputAction: TextInputAction.done,
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
                  validator: authController.validateLoginPassword,
                ),
              ),
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
        );
  }

  Widget _buildSubmitButton(AuthController authController) {
    return SizedBox(
      height: 48,
      child: Obx(() => ElevatedButton(
        onPressed: authController.isLoadingEmail.value
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
        child: authController.isLoadingEmail.value
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
      )),
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
    return Obx(() => SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: authController.isLoadingEmail.value
            ? null
            : () async {
                final result = await authController.signInWithGoogle();
                if (result == AuthSignInResult.success) {
                  Get.offAll(() => AppLayout());
                }
              },
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          disabledBackgroundColor: Colors.grey.shade100,
          disabledForegroundColor: Colors.grey.shade400,
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (authController.isLoadingGoogle.value)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else ...[
              SvgPicture.asset(AssetPath.googleIcon, height: 20),
              const SizedBox(width: 10),
              const Text(
                'Google',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ],
        ),
      ),
    ));
  }
}
