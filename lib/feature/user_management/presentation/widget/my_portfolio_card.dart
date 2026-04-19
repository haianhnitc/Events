import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/common/path/asset_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MyPortfolioCard extends StatelessWidget {
  const MyPortfolioCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff06B6D4), Color(0xff155DFC)],
        ),
      ),
      child: Obx(() {
        final user = AuthController.to.currentUser.value;
        final freePortfolios =
            user?.userProfile?.remainingFreePortfolios ?? 0;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(AssetPath.folderIcon, height: 20, width: 20),
                const SizedBox(width: 8),
                const Text(
                  'Hồ sơ của tôi',
                  style: TextStyle(
                    fontSize: 16,
                    height: 24 / 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    border: Border.all(
                      width: 1.71,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$freePortfolios hồ sơ',
                    style: const TextStyle(
                      fontSize: 12,
                      height: 16 / 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Quản lý và chia sẻ hồ sơ hoạt động chuyên nghiệp',
              style: TextStyle(
                fontSize: 14,
                height: 20 / 14,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.9),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildButton(context, 'Xem hồ sơ', Icons.folder_open_rounded, () {
                  Get.dialog(
                    AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      title: const Text('Hồ sơ hoạt động'),
                      content: const Text(
                        'Tính năng đang được phát triển.\nVui lòng liên hệ BE để cung cấp API.',
                        textAlign: TextAlign.center,
                      ),
                      actions: [
                        TextButton(onPressed: () => Get.back(), child: const Text('Đóng')),
                      ],
                    ),
                  );
                }),
                const SizedBox(width: 8),
                _buildButton(context, 'Tạo mới', Icons.add_rounded, () {
                  Get.dialog(
                    AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      title: const Text('Tạo hồ sơ'),
                      content: const Text(
                        'Tính năng đang được phát triển.\nVui lòng liên hệ BE để cung cấp API.',
                        textAlign: TextAlign.center,
                      ),
                      actions: [
                        TextButton(onPressed: () => Get.back(), child: const Text('Đóng')),
                      ],
                    ),
                  );
                }),
              ],
            )
          ],
        );
      }),
    );
  }

  Widget _buildButton(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Flexible(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: const Color(0xff06B6D4),
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  height: 20 / 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff06B6D4),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
