import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/event_management/presentation/controller/event_controller.dart';
import 'package:events_app/feature/event_management/presentation/page/event_detail_page.dart';
import 'package:events_app/feature/event_management/presentation/utils/event_action_utils.dart';
import 'package:events_app/feature/event_management/presentation/widget/event_or_ctv_card.dart';
import 'package:events_app/feature/recruitment/domain/entity/ctv_recruitment_entity.dart';
import 'package:events_app/feature/recruitment/presentation/controller/ctv_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventOrCtvList extends StatelessWidget {
  const EventOrCtvList(
      {super.key,
      required this.isEvent,
      required this.listEvent,
      required this.listCtv,
      required this.scrollController,
      required this.hasMore,
      required this.isLoadingMore,
      required this.onLoadMore,
      this.isInitialLoading = false,
      this.isLoading = false,
      this.onTap,
      this.onPrimaryActionTap,
      this.resolveActionState});

  final bool isEvent;
  final List<EventSummaryEntity> listEvent;
  final List<CtvRecruitmentEntity> listCtv;
  final ScrollController scrollController;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;
  final bool isInitialLoading;
  final bool isLoading;
  final Function? onTap;
  final Function(CtvRecruitmentEntity recruitment)? onPrimaryActionTap;
  final ActionButtonState Function(CtvRecruitmentEntity recruitment)?
      resolveActionState;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isEvent
              ? Text(
                  "${listEvent.length} sự kiện",
                  style: const TextStyle(
                      fontSize: 14,
                      height: 20 / 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff273143)),
                )
              : Text(
                  "${listCtv.length} công việc",
                  style: const TextStyle(
                      fontSize: 14,
                      height: 20 / 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff273143)),
                ),
          const SizedBox(height: 16),
          Expanded(
            child: isInitialLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xff06B6D4)),
                  )
                : isEvent
                    ? _buildEventList(listEvent)
                    : _buildCtvList(listCtv),
          ),
        ],
      ),
    );
  }

  _buildEventList(List<EventSummaryEntity> listEvent) {
    if (listEvent.isEmpty) {
      return const Center(
        child: Text(
          'Không tìm thấy sự kiện nào',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xff67688C),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        final ctrl = EventController();
        if (Get.isRegistered<EventController>()) {
          ctrl.loadEvents(refresh: true);
        }
        await Future.delayed(const Duration(milliseconds: 500));
      },
      notificationPredicate: (notification) => notification.depth == 1,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification &&
              notification.metrics.extentAfter < 80 &&
              !isLoadingMore &&
              hasMore) {
            onLoadMore();
          }
          return false;
        },
        child: GridView.builder(
          controller: scrollController,
          itemCount: listEvent.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.65),
          itemBuilder: (context, index) {
            final event = listEvent[index];
            return GestureDetector(
              onTap: () {
                if (onTap != null) {
                  onTap!.call(event);
                  return;
                }
                Get.to(() => EventDetailPage(eventId: event.eventId));
              },
              child: EventOrCtvCard(isEvent: true, event: event),
            );
          },
        ),
      ),
    );
  }

  _buildCtvList(List<CtvRecruitmentEntity> listCtv) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xff06B6D4)),
      );
    }
    if (listCtv.isEmpty) {
      return const Center(
        child: Text(
          'Không tìm thấy công việc nào',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xff67688C),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        final ctrl = CtvController();
        if (Get.isRegistered<CtvController>()) {
          ctrl.loadRecruitments(refresh: true);
        }
        await Future.delayed(const Duration(milliseconds: 500));
      },
      notificationPredicate: (notification) => notification.depth == 1,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification &&
              notification.metrics.extentAfter < 80 &&
              !isLoadingMore &&
              hasMore) {
            onLoadMore();
          }
          return false;
        },
        child: GridView.builder(
          controller: scrollController,
          padding: const EdgeInsets.only(bottom: 24),
          itemCount: listCtv.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.65),
          itemBuilder: (context, index) {
            final ctv = listCtv[index];
            return GestureDetector(
              onTap: () {
                if (onTap != null) {
                  onTap!.call(ctv);
                }
              },
              child: EventOrCtvCard(
                isEvent: false,
                ctv: ctv,
                actionStateOverride: resolveActionState?.call(ctv),
                onApplyTap: () => onPrimaryActionTap?.call(ctv),
              ),
            );
          },
        ),
      ),
    );
  }
}
