import 'package:events_app/common/path/asset_path.dart';
import 'package:events_app/routes/navbar/organizer_nav_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class OrganizerNavBar extends StatelessWidget {
  const OrganizerNavBar({super.key});

  static final controller = Get.find<OrganizerNavBarController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(height: 1, color: Color(0xffF0F2F5)),
              Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      option: OrganizerNavOptions.dashboard,
                      label: 'Trang chủ',
                      imagePath: AssetPath.home,
                    ),
                    _buildNavItem(
                      option: OrganizerNavOptions.events,
                      label: 'Sự kiện',
                      imagePath: AssetPath.events,
                    ),
                    const SizedBox(width: 56),
                    _buildNavItem(
                      option: OrganizerNavOptions.attendance,
                      label: 'Điểm danh',
                      imagePath: AssetPath.scheduleIcon,
                    ),
                    _buildNavItem(
                      option: OrganizerNavOptions.recruitment,
                      label: 'Tuyển CTV',
                      imagePath: AssetPath.ctv,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required OrganizerNavOptions option,
    required String label,
    required String imagePath,
  }) {
    final isSelected = controller.selectedPage.value == option;
    return GestureDetector(
      onTap: () => controller.navigateTo(option),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              imagePath,
              height: 22,
              width: 22,
              color: isSelected ? const Color(0xff06B6D4) : const Color(0xff9CA3AF),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 11,
                color: isSelected ? const Color(0xff06B6D4) : const Color(0xff9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
