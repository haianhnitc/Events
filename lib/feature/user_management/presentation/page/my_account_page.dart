import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/feature/user_management/presentation/page/edit_profile_page.dart';
import 'package:events_app/feature/user_management/presentation/widget/my_portfolio_card.dart';
import 'package:events_app/feature/user_management/presentation/widget/my_profile_card.dart';
import 'package:events_app/feature/user_management/presentation/controller/my_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  late final MyProfileController _profileController;

  @override
  void initState() {
    super.initState();
    _profileController = Get.put(MyProfileController());
    _profileController.loadUser();
    _profileController.loadRankAndPackages();
  }

  @override
  void dispose() {
    Get.delete<MyProfileController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6F9),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: const Color(0xff06B6D4),
            child: const SafeArea(
              bottom: false,
              child: Padding(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Hồ sơ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  MyProfileCard(
                    onEditTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfilePage(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const MyPortfolioCard(),
                  const SizedBox(height: 16),
                  const _LogoutButton(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final authController = AuthController.to;
      return SizedBox(
        width: double.infinity,
        height: 46,
        child: OutlinedButton.icon(
          onPressed: authController.isLoading.value
              ? null
              : () => _confirmLogout(context, authController),
          icon: authController.isLoading.value
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.logout_rounded),
          label: Text(
            authController.isLoading.value ? 'Đang đăng xuất...' : 'Đăng xuất',
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xffDB0025),
            side: BorderSide(
              width: 1,
              color: const Color(0xffDB0025).withValues(alpha: 0.35),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    });
  }

  void _confirmLogout(BuildContext context, AuthController authController) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Xác nhận đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              authController.logout();
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
