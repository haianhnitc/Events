import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/common/utils/app_image_utils.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/event_management/presentation/controller/event_controller.dart';
import 'package:events_app/routes/navbar/bottom_nav_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemFeaturedEvent extends StatelessWidget {
  ItemFeaturedEvent({super.key, required this.eventFeatured});

  static const int _bannerLogicalWidth = 162;
  static const int _bannerLogicalHeight = 91;

  final EventSummaryEntity eventFeatured;

  final eventController = Get.isRegistered<EventController>()
      ? Get.find<EventController>()
      : Get.put(EventController());
  final bottomNavBarController = Get.find<BottomNavBarController>();

  void _openEventDetailInEventTab() {
    if (eventFeatured.eventId == null) return;

    eventController.openEventDetail(eventFeatured);
    bottomNavBarController.selectedPage.value = NavBarOptions.events;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openEventDetailInEventTab,
      child: Container(
        height: 210,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              offset: Offset(0, 4),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: SizedBox(
                    height: 91,
                    width: double.infinity,
                    child: _buildBanner(),
                  ),
                ),
                const SizedBox(height: 36),
                Text(
                  eventFeatured.title ?? '',
                  style: const TextStyle(
                      fontSize: 14,
                      height: 17.5 / 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ).marginSymmetric(horizontal: 12),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_month,
                        size: 12, color: Color(0xff67688C)),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      AppDateUtils.formatDateOnly(eventFeatured.startTime),
                      style: const TextStyle(
                        fontSize: 11,
                        height: 16.5 / 11,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff67688C),
                      ),
                    )
                  ],
                ).marginSymmetric(horizontal: 12)
              ],
            ),
            Positioned(
              top: 6,
              left: 8,
              right: 8,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    height: 23,
                    decoration: BoxDecoration(
                      color: const Color(0xff00A63E),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 4),
                          spreadRadius: -1,
                          blurRadius: 6,
                          color: Colors.white.withOpacity(0.1),
                        )
                      ],
                    ),
                    child: Center(
                      child: Text(
                        eventFeatured.price == null
                            ? 'Miễn phí'
                            : '${eventFeatured.price} VNĐ',
                        style: const TextStyle(
                          fontSize: 10,
                          height: 15 / 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    height: 23,
                    decoration: BoxDecoration(
                      color: const Color(0xff06B6D4),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 4),
                          spreadRadius: -1,
                          blurRadius: 6,
                          color: Colors.white.withOpacity(0.1),
                        )
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Chứng nhận',
                        style: TextStyle(
                          fontSize: 10,
                          height: 15 / 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return AppImageUtils.buildNetworkImage(
      imageUrl: eventFeatured.banner,
      placeholder: AppImageUtils.buildImagePlaceholder(),
      fit: BoxFit.cover,
      memCacheWidth: _bannerLogicalWidth * 2,
      memCacheHeight: _bannerLogicalHeight * 2,
      maxWidthDiskCache: _bannerLogicalWidth * 2,
      maxHeightDiskCache: _bannerLogicalHeight * 2,
    );
  }
}
