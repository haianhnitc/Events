import 'package:events_app/common/path/asset_path.dart';
import 'package:events_app/feature/common/notifications_page.dart';
import 'package:events_app/feature/common/notifications_controller.dart';
import 'package:events_app/feature/common/qr/qr_scanner_page.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/routes/app_layout_controller.dart';
import 'package:events_app/routes/navbar/bottom_nav_bar.dart';
import 'package:events_app/routes/navbar/bottom_nav_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AppLayout extends StatelessWidget {
  AppLayout({super.key});

  final navBarcontroller = Get.put(BottomNavBarController(), permanent: true);
  final appLayoutController = Get.put(AppLayoutController(), permanent: true);
  final NotificationsController _notifCtrl =
      Get.put(NotificationsController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 61,
          backgroundColor: Colors.white,
          title: Image.asset(
            AssetPath.linkLogo,
            height: 40,
            fit: BoxFit.contain,
          ),
          actions: [
            Obx(() {
              final count = _notifCtrl.unreadCount;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () async {
                    await Get.to(() => NotificationsPage());
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              AssetPath.notification,
                              height: 18,
                              width: 18,
                            ),
                          ).marginOnly(right: 0),
                          if (count > 0)
                            Positioned(
                              right: -10,
                              top: -4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 3, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 4,
                                        offset: Offset(0, 1)),
                                  ],
                                ),
                                constraints: const BoxConstraints(
                                    minWidth: 10, maxWidth: 20, minHeight: 18),
                                child: Center(
                                  child: Text(
                                    count > 9 ? '9+' : '$count',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          navBarcontroller.selectedPage.value =
                              NavBarOptions.myAccount;
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            AssetPath.profile,
                            height: 18,
                            width: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(width: 8),
            const Divider(
              color: Color(0xff6B7280),
              height: 2,
            )
          ],
        ),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: Obx(
          () => IndexedStack(
            index: appLayoutController.currentIndex,
            children: appLayoutController.pages,
          ),
        ),
        bottomNavigationBar: BottomNavBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          padding: const EdgeInsets.only(top: 10),
          width: 67,
          height: 67,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: FloatingActionButton(
            heroTag: 'main_qr_fab',
            onPressed: () async {
              final result = await Get.to(() => const QrScannerPage());
              if (result == true) {
                AppSnackbarUtils.showSuccess(
                  'Hoàn tất',
                  'Thao tác đã được ghi nhận thành công.',
                );
              }
            },
            elevation: 0,
            backgroundColor: Colors.transparent,
            shape: const CircleBorder(),
            child: Container(
              width: 67,
              height: 67,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF06B6D4),
                    Color(0xFF00B8DB),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(
                Icons.qr_code_scanner_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
