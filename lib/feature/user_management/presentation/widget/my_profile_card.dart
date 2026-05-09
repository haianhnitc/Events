import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/user_management/domain/entity/user_entity.dart';
import 'package:events_app/feature/user_management/domain/entity/rank_entity.dart';
import 'package:events_app/feature/user_management/domain/entity/user_package_entity.dart';
import 'package:events_app/feature/user_management/presentation/controller/my_profile_controller.dart';
import 'package:events_app/feature/user_management/presentation/page/package_list_page.dart';
import 'package:events_app/feature/user_management/presentation/page/rank_list_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyProfileCard extends StatelessWidget {
  final VoidCallback? onEditTap;

  const MyProfileCard({super.key, this.onEditTap});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<MyProfileController>();

    return Obx(() {
      final user = AuthController.to.currentUser.value;
      final rank = profileController.userRank.value;
      final packages = profileController.userPackages;
      final activePackage = packages
          .where((p) => p.status == UserPackageStatus.active)
          .firstOrNull;

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x19000000),
              offset: Offset(0, 4),
              blurRadius: 16,
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAvatar(user),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildUserInfo(user),
                      ),
                      _buildEditButton(),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 1,
                    color: const Color(0xff273143).withValues(alpha: 0.08),
                  ),
                  const SizedBox(height: 20),
                  _buildStatsRowSection(user, rank, activePackage),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAvatar(UserEntity? user) {
    final avatarUrl = user?.userProfile?.avatarUrl;
    return Container(
      height: 64,
      width: 64,
      margin: const EdgeInsets.only(top: 0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xff06B6D4).withValues(alpha: 0.1),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 6,
            spreadRadius: -1,
            color: const Color(0xff000000).withValues(alpha: 0.08),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: avatarUrl != null && avatarUrl.isNotEmpty
          ? Image.network(
              avatarUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildAvatarPlaceholder(user),
            )
          : _buildAvatarPlaceholder(user),
    );
  }

  Widget _buildAvatarPlaceholder(UserEntity? user) {
    final name = user?.userProfile?.fullName ?? user?.email ?? '?';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Center(
      child: Text(
        initial,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Color(0xff06B6D4),
        ),
      ),
    );
  }

  Widget _buildUserInfo(UserEntity? user) {
    final fullName = user?.userProfile?.fullName ?? 'Chưa cập nhật';
    final studentCode = user?.userProfile?.studentCode;
    final university = user?.userProfile?.university;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          fullName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff273143),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (studentCode != null && studentCode.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            studentCode,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xff67688C),
            ),
          ),
        ],
        if (university != null && university.isNotEmpty) ...[
          const SizedBox(height: 9),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                width: 1.71,
                color: const Color(0xff273143).withValues(alpha: 0.1),
              ),
            ),
            child: Text(
              university,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xff273143),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEditButton() {
    return GestureDetector(
      onTap: onEditTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: const Icon(
          Icons.edit_outlined,
          size: 18,
          color: Color(0xff64748B),
        ),
      ),
    );
  }

  Widget _buildStatsRowSection(
      UserEntity? user, RankEntity? rank, UserPackageEntity? activePackage) {
    return Builder(
      builder: (ctx) {
        return Column(
          children: [
            _buildStatsRow(user, rank, activePackage),
            const SizedBox(height: 16),
            _buildNavigationRow(ctx),
          ],
        );
      },
    );
  }

  Widget _buildStatsRow(
      UserEntity? user, RankEntity? rank, UserPackageEntity? activePackage) {
    final levelName = rank?.levelName;
    final ranking = rank?.ranking;
    final coin = user?.currentCoin ?? 0;

    return Row(
      children: [
        Expanded(
          child: _buildDetailComponent(
            value: levelName ?? 'Chưa có',
            label: 'Cấp bậc',
            color: _getLevelColor(rank?.level ?? 0),
          ),
        ),
        Container(
          width: 1,
          height: 40,
          color: const Color(0xff273143).withValues(alpha: 0.08),
        ),
        Expanded(
          child: _buildDetailComponent(
            value: ranking != null ? '#$ranking' : '—',
            label: 'Xếp hạng',
            color: const Color(0xff155DFC),
          ),
        ),
        Container(
          width: 1,
          height: 40,
          color: const Color(0xff273143).withValues(alpha: 0.08),
        ),
        Expanded(
          child: _buildDetailComponent(
            value: '$coin',
            label: 'Xu',
            color: const Color(0xffDB0025),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationRow(BuildContext ctx) {
    return Row(
      children: [
        Expanded(
          child: _buildNavButton(
            icon: Icons.leaderboard_rounded,
            label: 'Bảng xếp hạng',
            color: const Color(0xff155DFC),
            onTap: () => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const RankListPage()),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildNavButton(
            icon: Icons.card_membership_rounded,
            label: 'Gói dịch vụ',
            color: const Color(0xff7B2FBE),
            onTap: () => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const PackageListPage()),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.15),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Color _getLevelColor(int level) {
    switch (level) {
      case 5:
        return const Color(0xff7B2FBE);
      case 4:
        return const Color(0xffFF6B35);
      case 3:
        return const Color(0xff06B6D4);
      case 2:
        return const Color(0xff00A63E);
      default:
        return const Color(0xff94A3B8);
    }
  }

  Widget _buildDetailComponent({
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: color,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xff67688C),
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
