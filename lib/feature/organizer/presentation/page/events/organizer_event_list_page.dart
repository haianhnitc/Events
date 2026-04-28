import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_event_list_controller.dart';
import 'package:events_app/feature/organizer/presentation/page/events/organizer_create_event_page.dart';
import 'package:events_app/feature/organizer/presentation/page/events/organizer_event_detail_page.dart';
import 'package:events_app/feature/organizer/presentation/page/events/organizer_event_statistics_page.dart';
import 'package:events_app/feature/organizer/presentation/widget/widgets.dart';
import 'package:events_app/routes/organizer_app_layout_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrganizerEventListPage extends StatefulWidget {
  const OrganizerEventListPage({super.key});

  @override
  State<OrganizerEventListPage> createState() => _OrganizerEventListPageState();
}

class _OrganizerEventListPageState extends State<OrganizerEventListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  OrganizerEventListController get _ctrl =>
      Get.find<OrganizerEventListController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    final status = _tabIndexToStatus(_tabController.index);
    _ctrl.setFilter(status);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _searchController.dispose();
    final layoutCtrl = Get.find<OrganizerAppLayoutController>();
    layoutCtrl.clearEventContext();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Quản lý sự kiện',
          style: TextStyle(
            color: Color(0xff273143),
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: const Color(0xff06B6D4),
          unselectedLabelColor: Colors.grey.shade600,
          indicatorColor: const Color(0xff06B6D4),
          dividerColor: Colors.grey.shade200,
          labelStyle:
              const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Tất cả'),
            Tab(text: 'Nháp'),
            Tab(text: 'Đã đăng'),
            Tab(text: 'Đã đóng'),
            Tab(text: 'Đã hủy'),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: OrganizerSearchField(
              controller: _searchController,
              hintText: 'Tìm kiếm sự kiện...',
              onChanged: (v) => _ctrl.setSearch(v),
              onClear: () {
                _searchController.clear();
                _ctrl.setSearch('');
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              if (_ctrl.isLoading.value && _ctrl.events.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              final events = _ctrl.filteredEvents;
              if (events.isEmpty) {
                return OrganizerEmptyState(
                  message: 'Không có sự kiện nào',
                  description: 'Tạo sự kiện mới để bắt đầu',
                  icon: Icons.event_outlined,
                  actionLabel: 'Tạo sự kiện',
                  onAction: () =>
                      Get.to(() => const OrganizerCreateEventPage()),
                );
              }
              return RefreshIndicator(
                onRefresh: _ctrl.refreshEvents,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: events.length + (_ctrl.isLoading.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (_ctrl.isLoading.value && index == 0) {
                      return const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: LinearProgressIndicator(),
                      );
                    }
                    final event = events[index - (_ctrl.isLoading.value ? 1 : 0)];
                    return _buildEventCard(event);
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'organizer_event_list_fab',
        onPressed: () => Get.to(() => const OrganizerCreateEventPage()),
        backgroundColor: const Color(0xFF06B6D4),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEventCard(EventSummaryEntity event) {
    final badge = _getStatusBadge(event.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 8),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            if (event.eventId != null) {
              Get.to(() => OrganizerEventDetailPage(eventId: event.eventId!));
            }
          },
          child: Column(
            children: [
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(14)),
                  image: event.banner != null
                      ? DecorationImage(
                          image: NetworkImage(event.banner!), fit: BoxFit.cover)
                      : null,
                ),
                child: event.banner == null
                    ? const Center(
                        child: Icon(Icons.event,
                            size: 40, color: Color(0xFF06B6D4)),
                      )
                    : null,
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            event.title ?? 'Không có tiêu đề',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff273143),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        badge,
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 13, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                            event.startTime != null
                                ? AppDateUtils.formatDate(event.startTime!)
                                : 'N/A',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade600)),
                        const SizedBox(width: 16),
                        Icon(Icons.people_outline,
                            size: 13, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          '${event.totalParticipants ?? 0} / ${event.capacity ?? 0}',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildActionBtn(
                          icon: Icons.visibility_outlined,
                          label: 'Xem',
                          onTap: () {
                            if (event.eventId != null) {
                              Get.to(() => OrganizerEventDetailPage(
                                  eventId: event.eventId!));
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildActionBtn(
                          icon: Icons.edit_outlined,
                          label: 'Sửa',
                          enabled: event.status != EventStatus.published,
                          onTap: () {
                            if (event.eventId != null) {
                              Get.to(() => OrganizerCreateEventPage(
                                  eventId: event.eventId));
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildActionBtn(
                          icon: Icons.bar_chart_rounded,
                          label: 'Thống kê',
                          onTap: () {
                            if (event.eventId != null) {
                              Get.to(() => OrganizerEventStatisticsPage(
                                  eventId: event.eventId!));
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionBtn({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: enabled ? Colors.grey.shade50 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: enabled ? const Color(0xff64748B) : Colors.grey.shade400),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(fontSize: 12, color: enabled ? const Color(0xff64748B) : Colors.grey.shade400),
              ),
            ],
          ),
        ),
      ),
    );
  }

  OrganizerStatusBadge _getStatusBadge(status) {
    if (status == null) return OrganizerStatusBadge.draft();
    switch (status) {
      case EventStatus.published:
        return OrganizerStatusBadge.published();
      case EventStatus.draft:
        return OrganizerStatusBadge.draft();
      case EventStatus.closed:
        return OrganizerStatusBadge.closed();
      case EventStatus.cancelled:
        return OrganizerStatusBadge.cancelled();
    }
    return OrganizerStatusBadge.draft();
  }

  EventStatus? _tabIndexToStatus(int index) {
    switch (index) {
      case 1:
        return EventStatus.draft;
      case 2:
        return EventStatus.published;
      case 3:
        return EventStatus.closed;
      case 4:
        return EventStatus.cancelled;
      default:
        return null;
    }
  }

}
