import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/home/presentation/widget/footer_home_page.dart';
import 'package:events_app/feature/home/presentation/widget/header_home_page.dart';
import 'package:events_app/feature/home/presentation/widget/item_featured_event.dart';
import 'package:events_app/feature/home/presentation/widget/ranking_card.dart';
import 'package:events_app/routes/navbar/bottom_nav_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key, required this.featuredEvents});

  final List<EventSummaryEntity> featuredEvents;
  final bottomNavBarController = Get.find<BottomNavBarController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: SafeArea(
        child: CustomScrollView(
          key: const PageStorageKey<String>('home_page_scroll'),
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  Container(
                    height: 240,
                    decoration: const BoxDecoration(
                        color: Color(0xff00B8DB),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24))),
                  ),
                  Column(
                    children: [
                      const HeaderHomePage(),
                      const SizedBox(height: 24),
                      _buildTwoItemSubHEader(),
                      const SizedBox(height: 24),
                      const RankingCard(),
                      const SizedBox(height: 24),
                      _buildFeaturedEventHeader(true),
                      const SizedBox(height: 16),
                    ],
                  ).marginSymmetric(horizontal: 16, vertical: 24),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverGrid.builder(
                itemCount: featuredEvents.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 162 / 210,
                ),
                itemBuilder: (context, index) {
                  return ItemFeaturedEvent(
                    eventFeatured: featuredEvents[index],
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(child: FooterHomePage()),
          ],
        ),
      ),
    );
  }

  _buildTwoItemSubHEader() => Row(
        children: [
          _buildEventActionCard(true),
          const SizedBox(width: 12),
          _buildEventActionCard(false),
        ],
      );

  _buildEventActionCard(bool isEvent) => Expanded(
        child: GestureDetector(
          onTap: () {
            isEvent
                ? bottomNavBarController.selectedPage.value =
                    NavBarOptions.events
                : bottomNavBarController.selectedPage.value = NavBarOptions.ctv;
          },
          child: Container(
              padding: const EdgeInsets.only(top: 16),
              height: 116,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white.withValues(alpha: 0.1),
                        spreadRadius: -1,
                        blurRadius: 6,
                        offset: const Offset(0, 4))
                  ],
                  gradient: isEvent
                      ? LinearGradient(colors: [
                          const Color(0xff06B6D4).withValues(alpha: 0.1),
                          const Color(0xff00B8DB).withValues(alpha: 0.1)
                        ])
                      : LinearGradient(colors: [
                          const Color(0xffDB0025).withValues(alpha: 0.1),
                          const Color(0xffFF6900).withValues(alpha: 0.1)
                        ]),
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                        color: isEvent
                            ? const Color(0xff06B6D4).withValues(alpha: 0.2)
                            : const Color(0xffDB0025).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(57384700)),
                    child: Center(
                      child: isEvent
                          ? const Icon(
                              Icons.calendar_today,
                              size: 24,
                              color: Color(0xff06B6D4),
                            )
                          : const Icon(
                              Icons.people_alt_outlined,
                              size: 28,
                              color: Color(0xffDB0025),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isEvent ? 'Khám phá sự kiện' : 'Việc làm CTV',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        height: 20 / 14,
                        fontWeight: FontWeight.w600),
                  )
                ],
              )),
        ),
      );

  Widget _buildFeaturedEventHeader(bool isEvent) {
    return Row(
      children: [
        const Text(
          'Sự kiện nổi bật',
          style: TextStyle(
              fontSize: 18,
              height: 28 / 18,
              fontWeight: FontWeight.w700,
              color: Colors.black),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            bottomNavBarController.selectedPage.value = NavBarOptions.events;
          },
          child: const Row(
            children: [
              Text(
                'Tất cả',
                style: TextStyle(
                  fontSize: 14,
                  height: 20 / 14,
                  color: Color(0xff06B6D4),
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                width: 4,
              ),
              Icon(
                Icons.chevron_right_outlined,
                color: Color(0xff06B6D4),
                size: 15,
              )
            ],
          ),
        )
      ],
    );
  }
}
