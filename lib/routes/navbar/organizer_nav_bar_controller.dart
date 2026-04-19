import 'package:get/get.dart';

enum OrganizerNavOptions { dashboard, events, attendance, recruitment }

class OrganizerNavBarController extends GetxController {
  final selectedPage = Rx<OrganizerNavOptions>(OrganizerNavOptions.dashboard);

  void navigateTo(OrganizerNavOptions option) {
    selectedPage.value = option;
  }

  void reset() {
    selectedPage.value = OrganizerNavOptions.dashboard;
  }
}
