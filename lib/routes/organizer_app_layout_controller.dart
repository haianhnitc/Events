import 'package:events_app/feature/organizer/presentation/controller/organizer_attendance_list_controller.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_dashboard_controller.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_event_list_controller.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_recruitment_list_controller.dart';
import 'package:events_app/feature/organizer/presentation/page/attendance/organizer_attendance_list_page.dart';
import 'package:events_app/feature/organizer/presentation/page/dashboard/organizer_dashboard_page.dart';
import 'package:events_app/feature/organizer/presentation/page/events/organizer_event_list_page.dart';
import 'package:events_app/feature/organizer/presentation/page/recruitment/organizer_recruitment_list_page.dart';
import 'package:events_app/routes/navbar/organizer_nav_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrganizerAppLayoutController extends GetxController {
  final OrganizerNavBarController navController = Get.find<OrganizerNavBarController>();

  final Rx<int?> currentEventId = Rx<int?>(null);

  int get currentIndex =>
      OrganizerNavOptions.values.indexOf(navController.selectedPage.value);

  List<Widget> get pages => [
        const OrganizerDashboardPage(),
        const OrganizerEventListPage(),
        const OrganizerAttendanceListPage(),
        const OrganizerRecruitmentListPage(),
      ];

  @override
  void onInit() {
    super.onInit();
    _initControllers();
  }

  void _initControllers() {
    if (!Get.isRegistered<OrganizerDashboardController>()) {
      Get.put(OrganizerDashboardController(), permanent: true);
    }
    if (!Get.isRegistered<OrganizerEventListController>()) {
      Get.put(OrganizerEventListController(), permanent: true);
    }
    if (!Get.isRegistered<OrganizerAttendanceListController>()) {
      Get.put(OrganizerAttendanceListController(), permanent: true);
    }
    if (!Get.isRegistered<OrganizerRecruitmentListController>()) {
      Get.put(OrganizerRecruitmentListController(), permanent: true);
    }
  }

  /// Gọi khi vào page có event context (event detail, attendance setup, ...)
  void setEventContext(int eventId) {
    currentEventId.value = eventId;
  }

  /// Gọi khi rời page event context (back/dispose)
  void clearEventContext() {
    currentEventId.value = null;
  }
}
