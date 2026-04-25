import 'dart:async';

import 'package:events_app/feature/event_management/presentation/controller/event_controller.dart';
import 'package:events_app/feature/event_management/presentation/page/ctv_detail_page.dart';
import 'package:events_app/feature/event_management/presentation/page/event_detail_page.dart';
import 'package:events_app/feature/common/presentation/controller/filter_selection_controller.dart';
import 'package:events_app/feature/common/presentation/controller/category_controller.dart';
import 'package:events_app/feature/common/presentation/widget/event_filter_bottom_sheet.dart';
import 'package:events_app/feature/event_management/presentation/widget/event_or_ctv_list.dart';
import 'package:events_app/feature/event_management/presentation/widget/header_event_or_ctv_page.dart';
import 'package:events_app/feature/recruitment/presentation/controller/ctv_controller.dart';
import 'package:events_app/feature/recruitment/domain/entity/ctv_recruitment_entity.dart';
import 'package:events_app/feature/recruitment/presentation/widget/ctv_apply_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventOrCtvPage extends StatefulWidget {
  const EventOrCtvPage({super.key, required this.isEvent});

  final bool isEvent;

  @override
  State<EventOrCtvPage> createState() => _EventOrCtvPageState();
}

class _EventOrCtvPageState extends State<EventOrCtvPage> {
  EventController get eventController => Get.find<EventController>();
  CtvController get ctvController => Get.find<CtvController>();
  CategoryController get categoryController => Get.find<CategoryController>();
  TextEditingController? _searchController;
  late final ScrollController _scrollController;
  Timer? _searchDebounceTimer;

  TextEditingController get _effectiveSearchController =>
      _searchController ??= TextEditingController(
        text: widget.isEvent
            ? eventController.keyword.value
            : ctvController.keyword.value,
      );

  @override
  void initState() {
    super.initState();
    Get.lazyPut(() => CategoryController());
    Get.lazyPut(() => EventController());
    Get.lazyPut(() => CtvController());
    categoryController.loadCategories();
    _scrollController = ScrollController()..addListener(_handleScroll);
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _searchController?.dispose();
    super.dispose();
  }

  void _handleSearchChanged(String keyword) {
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;

      if (widget.isEvent) {
        eventController.setSearchKeyword(keyword);
        return;
      }

      ctvController.setSearchKeyword(keyword);
    });
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.extentAfter > 240) return;

    if (widget.isEvent) {
      eventController.loadMore();
      return;
    }

    ctvController.loadMore();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return widget.isEvent
            ? eventController.handleBackPressed()
            : ctvController.handleBackPressed();
      },
      child: Obx(() => _buildContent(context)),
    );
  }

  Widget _buildContent(BuildContext context) {
    final selectedEvent = eventController.selectedEvent.value;
    final selectedCtvRecruitment = ctvController.selectedRecruitment.value;

    if (widget.isEvent && selectedEvent != null) {
      return EventDetailPage(
        key: ValueKey('event_detail_${selectedEvent.eventId}'),
        eventId: selectedEvent.eventId,
      );
    }

    if (!widget.isEvent && selectedCtvRecruitment != null) {
      return CtvDetailPage(
        key: ValueKey(
          'ctv_detail_${selectedCtvRecruitment.ctvRecruitmentId}',
        ),
        ctvRecruitmentId: selectedCtvRecruitment.ctvRecruitmentId,
      );
    }

    return _buildListContent(context);
  }

  Widget _buildListContent(BuildContext context) {
    final hasActiveFilter = widget.isEvent
        ? _hasActiveFilters(eventController.selectedFilters)
        : _hasActiveFilters(ctvController.selectedFilters);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: SafeArea(
        child: Column(
          children: [
            HeaderEventOrCtvPage(
              isEvent: widget.isEvent,
              onFilterTap: () => _showFilterBottomSheet(context),
              hasActiveFilter: hasActiveFilter,
              onSearchChanged: _handleSearchChanged,
              searchController: _effectiveSearchController,
            ),
            Expanded(
              child: Obx(
                () {
                  final eventItems = eventController.events.toList();
                  final ctvItems = ctvController.recruitments.toList();
                  final isLoadingMore = widget.isEvent
                      ? eventController.isLoadingMore.value
                      : ctvController.isLoadingMore.value;
                  final hasMore = widget.isEvent
                      ? eventController.hasMore.value
                      : ctvController.hasMore.value;

                  return EventOrCtvList(
                    isEvent: widget.isEvent,
                    listEvent: eventItems,
                    listCtv: ctvItems,
                    scrollController: _scrollController,
                    hasMore: hasMore,
                    isLoadingMore: isLoadingMore,
                    onLoadMore: widget.isEvent
                        ? eventController.loadMore
                        : ctvController.loadMore,
                    onTap: widget.isEvent
                        ? eventController.openEventDetail
                        : ctvController.openCtvDetail,
                    onPrimaryActionTap:
                        widget.isEvent ? null : _openCtvApplyBottomSheet,
                    resolveActionState: widget.isEvent
                        ? null
                        : ctvController.getApplyActionState,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCtvApplyBottomSheet(CtvRecruitmentEntity recruitment) {
    if (!mounted) return;

    final recruitmentId = recruitment.ctvRecruitmentId;
    if (recruitmentId == null) {
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CtvApplyBottomSheet(
        ctvRecruitmentId: recruitmentId,
        eventId: recruitment.eventId,
        position: recruitment.roleName,
        onSubmitted: () {
          ctvController.refreshApplyState(recruitmentId);
        },
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    final FilterSelectionController filterController =
        widget.isEvent ? eventController : ctvController;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EventFilterBottomSheet(
        controller: filterController,
        categories: categoryController.categories.toList(),
        isEvent: widget.isEvent,
      ),
    );
  }

  bool _hasActiveFilters(Map<int, List<String>> filters) {
    return filters.values.any(
      (values) => values.any((value) => value.trim().isNotEmpty),
    );
  }
}
