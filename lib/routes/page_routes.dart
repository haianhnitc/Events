import 'package:events_app/feature/events/presentation/page/event_page.dart';
import 'package:events_app/feature/home/presentation/page/home_page.dart';
import 'package:events_app/feature/news/presentation/page/news_page.dart';
import 'package:events_app/routes/navbar/bottom_nav_bar_controller.dart';
import 'package:flutter/material.dart';

Map<NavBarOptions, Widget> routes = {
  NavBarOptions.home: HomePage(),
  NavBarOptions.events: EventPage(),
  NavBarOptions.news: NewsPage(),
  NavBarOptions.search: Container(),
  // NavBarOptions.contact: Container(),
};

void resetRoutes() {
  routes = {
    NavBarOptions.home: HomePage(),
    NavBarOptions.events: EventPage(),
    NavBarOptions.news: NewsPage(),
    NavBarOptions.search: Container(),
    // NavBarOptions.contact: Container(),
  };
}
