import 'package:events_app/common/path/asset_path.dart';
import 'package:events_app/routes/navbar/bottom_nav_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({super.key});
  final controller = Get.find<BottomNavBarController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomAppBar(
        // shape: const CircularNotchedRectangle(),
        // notchMargin: 6,
        height: 56 + 7,
        padding: const EdgeInsets.only(top: 0, bottom: 7),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Divider(
              height: 2,
              color: Color(0xffF6F7F9),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(width: 20),

                controller.selectedPage.value == NavBarOptions.home
                    ? _buildSelectedItem(
                        name: 'Trang chủ',
                        imagePath: AssetPath.home,
                      )
                    : _buildItem(
                        page: NavBarOptions.home,
                        name: 'Trang chủ',
                        imagePath: AssetPath.home),
                const SizedBox(width: 20),
                controller.selectedPage.value == NavBarOptions.events
                    ? _buildSelectedItem(
                        name: 'Sự kiện', imagePath: AssetPath.events)
                    : _buildItem(
                        page: NavBarOptions.events,
                        name: 'Sự kiện',
                        imagePath: AssetPath.events),
                const Spacer(),
                controller.selectedPage.value == NavBarOptions.news
                    ? _buildSelectedItem(
                        name: 'Tin tức', imagePath: AssetPath.news)
                    : _buildItem(
                        page: NavBarOptions.news,
                        name: 'Tin tức',
                        imagePath: AssetPath.news),
                const SizedBox(width: 25),

                controller.selectedPage.value == NavBarOptions.search
                    ? _buildSelectedItem(
                        name: 'Tra cứu', imagePath: AssetPath.search)
                    : _buildItem(
                        page: NavBarOptions.search,
                        name: 'Tra cứu',
                        imagePath: AssetPath.search),
                const SizedBox(width: 25),

                // controller.selectedPage.value == NavBarOptions.contact
                //     ? _buildSelectedItem(
                //         name: 'Liên hệ', imagePath: AssetPath.contact)
                //     : _buildItem(
                //         page: NavBarOptions.contact,
                //         name: 'Liên hệ',
                //         imagePath: AssetPath.contact),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem({
    required NavBarOptions page,
    required String imagePath,
    required String name,
  }) {
    return GestureDetector(
      onTap: () {
        controller.selectedPage.value = page;
      },
      child: Column(
        children: [
          SizedBox(
            child: SvgPicture.asset(
              imagePath,
              height: 20,
              width: 20,
            ),
          ).paddingSymmetric(vertical: 4),
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 11,
              color: Color(0xff6B7280),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSelectedItem({
    required String imagePath,
    required String name,
  }) {
    return Column(
      children: [
        SizedBox(
          child: SvgPicture.asset(
            imagePath,
            height: 20,
            width: 20,
            color: const Color(0xff5FA9F0),
          ).paddingSymmetric(vertical: 4),
        ),
        Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 11,
            color: Color(0xff5FA9F0),
          ),
        )
      ],
    );
  }
}
