import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
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
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF5BC0FF), Color(0xFF4A90E2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Center(
                    child: Text(
                      'Tài khoản',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (_profileController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xff06B6D4)),
                    ),
                  );
                }

                return const SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      MyProfileCard(
                        onEditTap: null,
                      ),
                      SizedBox(height: 16),
                      MyPortfolioCard(),
                      SizedBox(height: 16),
                      _MenuSection(),
                      SizedBox(height: 16),
                      _LogoutButton(),
                      SizedBox(height: 24),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  const _MenuSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MenuItem(
          icon: Icons.event_available_rounded,
          label: 'Sự kiện của tôi',
          onTap: () => Get.toNamed('/my-events'),
        ),
        const SizedBox(height: 8),
        _MenuItem(
          icon: Icons.account_balance_wallet_outlined,
          label: 'Lịch sử giao dịch',
          onTap: () => Get.toNamed('/transaction-history'),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xff06B6D4), size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff1A1D1F),
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xff9CA3AF),
                size: 22,
              ),
            ],
          ),
        ),
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
          onPressed: authController.isLoadingEmail.value
              ? null
              : () => _confirmLogout(context, authController),
          icon: authController.isLoadingEmail.value
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.logout_rounded),
          label: Text(
            authController.isLoadingEmail.value
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
