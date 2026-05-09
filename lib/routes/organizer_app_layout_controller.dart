import 'package:events_app/feature/organizer/presentation/controller/organizer_attendance_list_controller.dart';
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
  OrganizerNavBarController? _navController;

  OrganizerNavBarController get navController {
    if (_navController == null) {
      if (Get.isRegistered<OrganizerNavBarController>()) {
        _navController = Get.find<OrganizerNavBarController>();
      }
    }
    return _navController!;
  }

  final Rx<int?> currentEventId = Rx<int?>(null);

  int get currentIndex {
    final nav = _navController ?? navController;
    return OrganizerNavOptions.values.indexOf(nav.selectedPage.value);
  }

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

  void setEventContext(int eventId) {
    currentEventId.value = eventId;
  }

  void clearEventContext() {
    currentEventId.value = null;
  }
}
