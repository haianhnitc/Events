import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/common/path/asset_path.dart';
import 'package:events_app/feature/common/notifications_page.dart';
import 'package:events_app/feature/common/notifications_controller.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/feature/organizer/presentation/page/attendance/organizer_qr_scanner_page.dart';
import 'package:events_app/feature/organizer/presentation/page/attendance/organizer_barcode_scanner_page.dart';
import 'package:events_app/feature/organizer/presentation/page/organizer_profile_page.dart';
import 'package:events_app/routes/navbar/organizer_nav_bar.dart';
import 'package:events_app/routes/navbar/organizer_nav_bar_controller.dart';
import 'package:events_app/routes/organizer_app_layout_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class OrganizerAppLayout extends StatelessWidget {
  const OrganizerAppLayout({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OrganizerNavBarController(), permanent: true);
    Get.put(OrganizerAppLayoutController(), permanent: true);

    final layoutController = Get.find<OrganizerAppLayoutController>();
    final navController = Get.find<OrganizerNavBarController>();
    final notifCtrl = Get.put(NotificationsController(), permanent: true);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
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
            final count = notifCtrl.unreadCount;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await Get.to(() => const NotificationsPage());
                    },
                    child: Stack(
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
                        ),
                        if (count > 0)
                          Positioned(
                            right: -8,
                            top: -4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 3, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 10,
                                maxWidth: 20,
                                minHeight: 18,
                              ),
                              child: Center(
                                child: Text(
                                  count > 9 ? '9+' : '$count',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const OrganizerProfilePage());
                    },
                    child: Obx(() {
                      final auth = Get.find<AuthController>();
                      final avatarUrl = auth
                              .currentUser.value?.userProfile?.avatarUrl ??
                          auth.currentUser.value?.organizationProfile?.logoUrl;
                      return Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                          image: avatarUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(avatarUrl),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: avatarUrl == null
                            ? Icon(Icons.person,
                                size: 18, color: Colors.grey.shade600)
                            : null,
                      );
                    }),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(width: 8),
          Container(
            width: 1,
            height: 24,
            color: const Color(0xffE5E7EB),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(
        () => IndexedStack(
          index: layoutController.currentIndex,
          children: layoutController.pages,
        ),
      ),
      bottomNavigationBar: const OrganizerNavBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: 62,
        height: 62,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF06B6D4).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          heroTag: 'organizer_main_fab',
          onPressed: () async {
            final choice = await showModalBottomSheet<String>(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (ctx) => Container(
                padding: const EdgeInsets.only(bottom: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(top: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF06B6D4).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.qr_code_scanner,
                            color: Color(0xFF06B6D4)),
                      ),
                      title: const Text(
                        'Quét QR Code',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: const Text('Quét mã QR của người tham gia'),
                      onTap: () => Navigator.pop(ctx, 'qr'),
                    ),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:
                            const Icon(Icons.qr_code, color: Color(0xFFF59E0B)),
                      ),
                      title: const Text(
                        'Quét Barcode',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: const Text('Quét mã vạch trên vé'),
                      onTap: () => Navigator.pop(ctx, 'barcode'),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );

            if (choice == 'qr') {
              final eventId = layoutController.currentEventId.value;
              if (eventId == null) {
                await Get.to(() => const OrganizerQrScannerPage());
              } else {
                final result = await Get.to(
                    () => OrganizerQrScannerPage(eventId: eventId));
                if (result == true) {
                  AppSnackbarUtils.showSuccess(
                      'Thành công', 'Check-in đã được ghi nhận');
                }
              }
            } else if (choice == 'barcode') {
              final eventId = layoutController.currentEventId.value;
              if (eventId == null) {
                await Get.to(() => const OrganizerBarcodeScannerPage());
              } else {
                await Get.to(
                    () => OrganizerBarcodeScannerPage(eventId: eventId));
              }
            }
          },
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape: const CircleBorder(),
          child: Container(
            width: 62,
            height: 62,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF06B6D4), Color(0xFF00B8DB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(
              Icons.qr_code_scanner_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}
