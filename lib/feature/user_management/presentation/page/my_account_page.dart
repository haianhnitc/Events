import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/feature/user_management/presentation/page/edit_profile_page.dart';
import 'package:events_app/feature/user_management/presentation/widget/my_portfolio_card.dart';
import 'package:events_app/feature/user_management/presentation/widget/my_profile_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyAccountPage extends StatelessWidget {
  const MyAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6F9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 309,
              child: Stack(
                children: [
                  Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                        colors: [
                          const Color(0xff06B6D4).withValues(alpha: 0.8),
                          const Color(0xff06B6D4)
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, top: 16),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Hồ sơ',
                              style: TextStyle(
                                fontSize: 16,
                                height: 24 / 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditProfilePage(),
                              ),
                            ),
                            icon: const Icon(Icons.edit_rounded,
                                color: Colors.white, size: 22),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 92,
                    left: 0,
                    right: 0,
                    child: MyProfileCard(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const MyPortfolioCard(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() {
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
                      authController.isLoading.value
                          ? 'Đang đăng xuất...'
                          : 'Đăng xuất',
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
              }),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
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
