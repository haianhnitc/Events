import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_event_list_controller.dart';
import 'package:events_app/feature/organizer/presentation/page/events/organizer_create_event_page.dart';
import 'package:events_app/feature/organizer/presentation/page/events/organizer_event_detail_page.dart';
import 'package:events_app/feature/organizer/presentation/page/events/organizer_event_list_page.dart';
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
        actions: [
          IconButton(
            onPressed: () => _showSortOptions(),
            icon: const Icon(Icons.filter_list, color: Color(0xff64748B)),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: const Color(0xff06B6D4),
          unselectedLabelColor: Colors.grey.shade600,
          indicatorColor: const Color(0xff06B6D4),
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
                  onAction: () => Get.to(() => const OrganizerCreateEventPage()),
                );
              }
              return RefreshIndicator(
                onRefresh: _ctrl.refreshEvents,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return _buildEventCard(event);
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
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
                          image: NetworkImage(event.banner!),
                          fit: BoxFit.cover)
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
                          onTap: () {
                            if (event.eventId != null) {
                              Get.to(() => OrganizerCreateEventPage(eventId: event.eventId));
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildActionBtn(
                          icon: Icons.bar_chart_rounded,
                          label: 'Thống kê',
                          onTap: () {
                            if (event.eventId != null) {
                              Get.to(() => OrganizerEventStatisticsPage(eventId: event.eventId!));
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
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: const Color(0xff64748B)),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Color(0xff64748B)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortTile(String label, String sortKey, IconData icon, VoidCallback onTap) {
    final isSelected = _ctrl.sortBy.value == sortKey;
    return ListTile(
      leading: Icon(icon, color: isSelected ? const Color(0xFF06B6D4) : const Color(0xff64748B)),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? const Color(0xFF06B6D4) : const Color(0xff273143),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check, size: 18, color: Color(0xFF06B6D4))
          : null,
      onTap: () {
        onTap();
        Get.back();
      },
    );
  }

  OrganizerStatusBadge _getStatusBadge(status) {
    if (status == null) return OrganizerStatusBadge.draft();
    switch (status.name) {
      case 'published':
        return OrganizerStatusBadge.published();
      case 'draft':
        return OrganizerStatusBadge.draft();
      case 'closed':
        return OrganizerStatusBadge.closed();
      case 'cancelled':
        return OrganizerStatusBadge.cancelled();
      default:
        return OrganizerStatusBadge.draft();
    }
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

  void _showSortOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sắp xếp theo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xff273143),
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => _buildSortTile(
              'Thời gian bắt đầu',
              'startTime',
              Icons.calendar_today_outlined,
              () => _ctrl.setSort('startTime', 'DESC'),
            )),
            Obx(() => _buildSortTile(
              'Thời gian tạo',
              'createdTime',
              Icons.access_time,
              () => _ctrl.setSort('createdTime', 'DESC'),
            )),
            Obx(() => _buildSortTile(
              'Số người tham gia',
              'totalParticipants',
              Icons.people_outline,
              () => _ctrl.setSort('totalParticipants', 'DESC'),
            )),
            Obx(() => _buildSortTile(
              'Tên sự kiện',
              'title',
              Icons.title,
              () => _ctrl.setSort('title', 'ASC'),
            )),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
