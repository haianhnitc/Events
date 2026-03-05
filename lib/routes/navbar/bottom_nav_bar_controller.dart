import 'package:get/get.dart';

class BottomNavBarController extends GetxController {
  final selectedPage = Rx<NavBarOptions>(NavBarOptions.home);

  void resetLogin() {
    selectedPage.value = NavBarOptions.home;
  }
}

enum NavBarOptions { home, events, news, search }
