import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/event_management/presentation/page/event_detail_page.dart';
import 'package:events_app/feature/event_management/presentation/utils/event_action_utils.dart';
import 'package:events_app/feature/event_management/presentation/widget/event_or_ctv_card.dart';
import 'package:events_app/feature/recruitment/domain/entity/ctv_recruitment_entity.dart';
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
            child: isEvent ? _buildEventList(listEvent) : _buildCtvList(listCtv),
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

    final showLoader = hasMore || isLoadingMore;
    return GridView.builder(
      controller: scrollController,
      itemCount: listEvent.length + (showLoader ? 1 : 0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.7),
      itemBuilder: (context, index) {
        if (index == listEvent.length && showLoader) {
          if (hasMore && !isLoadingMore) {
            WidgetsBinding.instance.addPostFrameCallback((_) => onLoadMore());
          }

          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        if (index >= listEvent.length) {
          return const SizedBox.shrink();
        }

        final event = listEvent[index];
        return GestureDetector(
            onTap: () {
              if (onTap != null) {
                onTap!.call(event);
                return;
              }

              Get.to(() => EventDetailPage(eventId: event.eventId));
            },
            child: EventOrCtvCard(isEvent: true, event: event));
      },
    );
  }

  _buildCtvList(List<CtvRecruitmentEntity> listCtv) {
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

    final showLoader = hasMore || isLoadingMore;
    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: listCtv.length + (showLoader ? 1 : 0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.7),
      itemBuilder: (context, index) {
        if (index == listCtv.length && showLoader) {
          if (hasMore && !isLoadingMore) {
            WidgetsBinding.instance.addPostFrameCallback((_) => onLoadMore());
          }

          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        if (index >= listCtv.length) {
          return const SizedBox.shrink();
        }

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
    );
  }
}
