import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/common/path/asset_path.dart';
import 'package:events_app/feature/user_management/presentation/page/edit_profile_page.dart';
import 'package:events_app/feature/user_management/presentation/widget/my_portfolio_card.dart';
import 'package:events_app/feature/user_management/presentation/widget/my_profile_card.dart';
import 'package:events_app/feature/user_management/presentation/controller/my_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff273143)),
          onPressed: () => Navigator.pop(context),
        ),
        leadingWidth: 56,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AssetPath.logoText,
              height: 28,
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfilePage(),
                ),
              ),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xffF1F5F9),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xffE2E8F0)),
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: Color(0xff64748B),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (_profileController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff06B6D4)),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const MyProfileCard(
                onEditTap: null,
              ),
              const SizedBox(height: 16),
              const MyPortfolioCard(),
              const SizedBox(height: 16),
              const _MenuSection(),
              const SizedBox(height: 16),
              const _LogoutButton(),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
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
          label: 'Sự kiện đã tham gia',
          onTap: () => Get.toNamed('/my-registration'),
        ),
        const SizedBox(height: 8),
        _MenuItem(
          icon: Icons.confirmation_number_outlined,
          label: 'Vé & QR của tôi',
          onTap: () => Get.toNamed('/my-ticket'),
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
