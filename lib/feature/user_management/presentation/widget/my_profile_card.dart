import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/common/path/asset_path.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/user_management/domain/entity/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class MyProfileCard extends StatelessWidget {
  const MyProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      child: Obx(
        () {
          final user = AuthController.to.currentUser.value;
          return Container(
            height: 217,
            width: double.infinity,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(2, 10),
                blurRadius: 16,
                spreadRadius: 0,
              )
            ]),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildAvatar(user),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildUserInfo(user),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        Divider(
                          height: 1,
                          color: const Color(0xff273143).withOpacity(0.1),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildDetailComponent(
                              value:
                                  '${user?.userProfile?.remainingFreePortfolios ?? 0}',
                              label: 'Hồ sơ miễn phí',
                              color: const Color(0xff06B6D4),
                            ),
                            const Spacer(),
                            _buildDetailComponent(
                              value: '${user?.currentCoin ?? 0}',
                              label: 'Xu',
                              color: const Color(0xffDB0025),
                            ),
                            const Spacer(),
                            _buildDetailComponent(
                              value: _formatRole(user),
                              label: 'Vai trò',
                              color: const Color(0xff00A63E),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 34,
                  right: 34,
                  child: SvgPicture.asset(
                    AssetPath.editIcon,
                    height: 16,
                    width: 16,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatar(UserEntity? user) {
    final avatarUrl = user?.userProfile?.avatarUrl;
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xff06B6D4).withOpacity(0.1),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 6,
            spreadRadius: -1,
            color: const Color(0xff000000).withOpacity(0.1),
          )
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
          fontSize: 28,
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
    final roleLabel = _formatRole(user);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          fullName,
          style: const TextStyle(
            fontSize: 16,
            height: 24 / 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff273143),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (studentCode != null && studentCode.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            studentCode,
            style: const TextStyle(
              fontSize: 14,
              height: 20 / 14,
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
                color: const Color(0xff273143).withOpacity(0.1),
              ),
            ),
            child: Text(
              university,
              style: const TextStyle(
                fontSize: 12,
                height: 16 / 12,
                fontWeight: FontWeight.w500,
                color: Color(0xff273143),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xff06B6D4).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            roleLabel,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xff06B6D4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailComponent({
    required String value,
    required String label,
    required Color color,
  }) {
    return SizedBox(
      height: 52,
      width: 74,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              height: 32 / 24,
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
              height: 16 / 12,
              fontWeight: FontWeight.w400,
              color: Color(0xff67688C),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

  String _formatRole(UserEntity? user) {
    switch (user?.role) {
      case UserRole.organization:
        return 'Tổ chức';
      case UserRole.admin:
        return 'Quản trị';
      case UserRole.user:
      default:
        return 'Người dùng';
    }
  }
}
