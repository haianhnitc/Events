import 'package:events_app/routes/navbar/bottom_nav_bar_controller.dart';
import 'package:events_app/routes/page_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppLayoutController extends GetxController {
  final BottomNavBarController navBarController =
      Get.find<BottomNavBarController>();

  int get currentIndex =>
      NavBarOptions.values.indexOf(navBarController.selectedPage.value);

  List<Widget> get pages => NavBarOptions.values
      .map((option) => routes[option] ?? const SizedBox.shrink())
      .toList();
}
