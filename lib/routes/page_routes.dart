import 'package:events_app/data_mock/ctv_recruitment_summary_mock.dart';
import 'package:events_app/data_mock/event_summary_mock.dart';
import 'package:events_app/feature/event_management/presentation/page/event_or_ctv_page.dart';
import 'package:events_app/feature/home/presentation/page/home_page.dart';
import 'package:events_app/feature/news/presentation/page/news_page.dart';
import 'package:events_app/feature/user_management/presentation/page/my_account_page.dart';
import 'package:events_app/routes/navbar/bottom_nav_bar_controller.dart';
import 'package:flutter/material.dart';

final listEvent = eventSummaryMock;
final listCtv = ctvRecruitmentSummaryMock;

Map<NavBarOptions, Widget> routes = {
  NavBarOptions.home: HomePage(featuredEvents: listEvent),
  NavBarOptions.events: const EventOrCtvPage(isEvent: true),
  NavBarOptions.ctv: const EventOrCtvPage(isEvent: false),
  NavBarOptions.news: const NewsPage(),
  NavBarOptions.myAccount: const MyAccountPage(),
};

void resetRoutes() {
  routes = {
    NavBarOptions.home: HomePage(featuredEvents: listEvent),
    NavBarOptions.events: const EventOrCtvPage(isEvent: true),
    NavBarOptions.ctv: const EventOrCtvPage(isEvent: false),
    NavBarOptions.news: const NewsPage(),
    NavBarOptions.myAccount: const MyAccountPage(),
  };
}
