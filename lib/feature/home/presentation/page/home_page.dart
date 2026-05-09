import 'package:events_app/feature/home/presentation/controller/home_controller.dart';
import 'package:events_app/feature/home/presentation/widget/footer_home_page.dart';
import 'package:events_app/feature/home/presentation/widget/header_home_page.dart';
import 'package:events_app/feature/home/presentation/widget/item_featured_event.dart';
import 'package:events_app/feature/home/presentation/widget/ranking_card.dart';
import 'package:events_app/feature/user_management/presentation/page/rank_list_page.dart';
import 'package:events_app/routes/navbar/bottom_nav_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

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
                      _buildTwoItemSubHeader(),
                      const SizedBox(height: 24),
                      Obx(() {
                        controller.userRank?.value;
                        return RankingCard(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const RankListPage()),
                            );
                          },
                          userRank: controller.userRank,
                        );
                      }),
                      const SizedBox(height: 24),
                      _buildFeaturedEventHeader(),
                      const SizedBox(height: 16),
                    ],
                  ).marginSymmetric(horizontal: 16, vertical: 24),
                ],
              ),
            ),
            Obx(() {
              if (controller.isLoading.value) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                );
              }
              final events = controller.featuredEvents;
              if (events.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      'Chưa có sự kiện nổi bật',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        height: 24 / 17,
                      ),
                    ),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverGrid.builder(
                  itemCount: events.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 162 / 210,
                  ),
                  itemBuilder: (context, index) {
                    return ItemFeaturedEvent(
                      eventFeatured: events[index],
                    );
                  },
                ),
              );
            }),
            const SliverToBoxAdapter(child: FooterHomePage()),
          ],
        ),
      ),
    );
  }

  Widget _buildTwoItemSubHeader() {
    final controller = Get.find<BottomNavBarController>();
    return Row(
      children: [
        _buildEventActionCard(true, controller),
        const SizedBox(width: 12),
        _buildEventActionCard(false, controller),
      ],
    );
  }

  Widget _buildEventActionCard(
          bool isEvent, BottomNavBarController controller) =>
      Expanded(
        child: GestureDetector(
          onTap: () {
            controller.selectedPage.value =
                isEvent ? NavBarOptions.events : NavBarOptions.ctv;
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

  Widget _buildFeaturedEventHeader() {
    final controller = Get.find<BottomNavBarController>();
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
            controller.selectedPage.value = NavBarOptions.events;
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
