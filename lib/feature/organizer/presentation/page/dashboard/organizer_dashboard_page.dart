import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_dashboard_controller.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_event_list_controller.dart';
import 'package:events_app/routes/navbar/organizer_nav_bar_controller.dart';
import 'package:events_app/feature/organizer/presentation/page/events/organizer_create_event_page.dart';
import 'package:events_app/feature/organizer/presentation/page/events/organizer_event_detail_page.dart';
import 'package:events_app/feature/organizer/presentation/page/events/organizer_event_list_page.dart';
import 'package:events_app/feature/organizer/presentation/page/events/organizer_event_statistics_page.dart';
import 'package:events_app/feature/organizer/presentation/page/participants/organizer_participant_list_page.dart';
import 'package:events_app/feature/organizer/presentation/page/recruitment/organizer_recruitment_list_page.dart';
import 'package:events_app/feature/organizer/presentation/widget/widgets.dart';
import 'package:events_app/routes/organizer_app_layout_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrganizerDashboardPage extends StatefulWidget {
  const OrganizerDashboardPage({super.key});

  @override
  State<OrganizerDashboardPage> createState() => _OrganizerDashboardPageState();
}

class _OrganizerDashboardPageState extends State<OrganizerDashboardPage> {
  late OrganizerDashboardController _dashboardCtrl;
  late OrganizerEventListController _eventCtrl;

  @override
  void initState() {
    super.initState();
    _dashboardCtrl = Get.put(OrganizerDashboardController());
    _eventCtrl = Get.put(OrganizerEventListController());
  }

  @override
  void dispose() {
    final layoutCtrl = Get.find<OrganizerAppLayoutController>();
    layoutCtrl.clearEventContext();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _dashboardCtrl.refreshDashboard();
            await _eventCtrl.refreshEvents();
          },
          child: CustomScrollView(
            slivers: [
              _buildHeader(),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    _buildStatGrid(),
                    const SizedBox(height: 20),
                    _buildQuickActions(),
                    const SizedBox(height: 20),
                    _buildRecentEvents(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFF06B6D4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Obx(() {
                  final auth = Get.find<AuthController>();
                  final avatarUrl = auth.currentUser.value?.userProfile?.avatarUrl ??
                      auth.currentUser.value?.organizationProfile?.logoUrl;
                  return CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white24,
                    backgroundImage:
                        avatarUrl != null ? NetworkImage(avatarUrl) : null,
                    child: avatarUrl == null
                        ? const Icon(Icons.business, color: Colors.white, size: 22)
                        : null,
                  );
                }),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        final auth = Get.find<AuthController>();
                        final name =
                            auth.currentUser.value?.userProfile?.fullName ?? auth.currentUser.value?.organizationProfile?.organizationName ?? 'Tổ chức';
                        return Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      }),
                      const Text(
                        'Trang tổ chức',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _dashboardCtrl.refreshDashboard();
                    _eventCtrl.refreshEvents();
                  },
                  icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.analytics_outlined, color: Colors.white, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Tổng quan tháng này',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(() {
        final dash = _dashboardCtrl.dashboard.value;
        final totalEvents = dash?.totalEvents ?? 0;
        final totalReg = dash?.totalRegistrations ?? 0;
        final avgRate = dash?.averageAttendanceRate ?? 0.0;
        final views = dash?.totalViews ?? 0;

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: OrganizerStatCard(
                    title: 'Tổng sự kiện',
                    value: '$totalEvents',
                    icon: Icons.event_outlined,
                    iconColor: const Color(0xFF06B6D4),
                    trend: _formatGrowth(dash?.totalEventsGrowth),
                    onTap: () => Get.to(() => const OrganizerEventListPage()),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OrganizerStatCard(
                    title: 'Lượt đăng ký',
                    value: '$totalReg',
                    icon: Icons.people_outline,
                    iconColor: const Color(0xFF8B5CF6),
                    trend: _formatGrowth(dash?.totalRegistrationsGrowth),
                    onTap: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OrganizerStatCard(
                    title: 'Lượt xem',
                    value: '$views',
                    icon: Icons.visibility_outlined,
                    iconColor: const Color(0xFFF59E0B),
                    trend: _formatGrowth(dash?.totalViewsGrowth),
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OrganizerStatCard(
                    title: 'Tỷ lệ tham dự',
                    value: '${(avgRate * 100).toStringAsFixed(0)}%',
                    icon: Icons.qr_code_scanner,
                    iconColor: const Color(0xFF10B981),
                    trend: _formatGrowth(dash?.averageAttendanceRateGrowth),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  String? _formatGrowth(double? growth) {
    if (growth == null) return null;
    final sign = growth >= 0 ? '+' : '';
    return '$sign${growth.toStringAsFixed(0)}%';
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OrganizerSectionHeader(title: 'Thao tác nhanh'),
        SizedBox(
          height: 90,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildQuickActionItem(
                icon: Icons.add_circle_outline,
                label: 'Tạo sự kiện',
                color: const Color(0xFF06B6D4),
                onTap: () => Get.to(() => const OrganizerCreateEventPage()),
              ),
              _buildQuickActionItem(
                icon: Icons.qr_code_scanner,
                label: 'Điểm danh',
                color: const Color(0xFF8B5CF6),
                onTap: () {
                  final navCtrl = Get.find<OrganizerNavBarController>();
                  navCtrl.navigateTo(OrganizerNavOptions.attendance);
                },
              ),
              _buildQuickActionItem(
                icon: Icons.people_outline,
                label: 'Người tham gia',
                color: const Color(0xFF10B981),
                onTap: () {
                  final events = _eventCtrl.events;
                  if (events.isEmpty) {
                    AppSnackbarUtils.showInfo('Thông báo', 'Chưa có sự kiện nào');
                    return;
                  }
                  Get.to(() => OrganizerParticipantListPage(
                    eventId: events.first.eventId!,
                    recruitmentType: events.first.recruitmentType,
                    eventTitle: events.first.title,
                  ));
                },
              ),
              _buildQuickActionItem(
                icon: Icons.article_outlined,
                label: 'Tuyển CTV',
                color: const Color(0xFFF59E0B),
                onTap: () => Get.to(() => const OrganizerRecruitmentListPage()),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Color(0xff64748B)),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentEvents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OrganizerSectionHeader(
          title: 'Sự kiện gần đây',
          actionLabel: 'Xem tất cả',
          onActionTap: () => Get.to(() => const OrganizerEventListPage()),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Obx(() {
            final events = _eventCtrl.events.take(3).toList();
            if (_eventCtrl.isLoading.value && events.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (events.isEmpty) {
              return OrganizerEmptyState(
                message: 'Chưa có sự kiện nào',
                icon: Icons.event_busy,
              );
            }
            return Column(
              children: events.asMap().entries.map((entry) {
                final index = entry.key;
                final e = entry.value;
                return Column(
                  children: [
                    _buildRecentEventItem(e),
                    if (index < events.length - 1) const Divider(height: 1),
                  ],
                );
              }).toList(),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildRecentEventItem(e) {
    final status = e.status?.name ?? 'DRAFT';
    final statusBadge = _getStatusBadge(status);

    return InkWell(
      onTap: () {
        if (e.eventId != null) {
          Get.to(() => OrganizerEventDetailPage(eventId: e.eventId!));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2FE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: e.banner != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(e.banner!, fit: BoxFit.cover),
                    )
                  : const Icon(Icons.event, color: Color(0xFF06B6D4)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.title ?? 'N/A',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff273143),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 12, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text(
                        e.startTime != null
                            ? AppDateUtils.formatDate(e.startTime!)
                            : 'N/A',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.people_outline,
                          size: 12, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text(
                        '${e.totalParticipants ?? 0} / ${e.capacity ?? 0}',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            statusBadge,
          ],
        ),
      ),
    );
  }

  OrganizerStatusBadge _getStatusBadge(String status) {
    switch (status) {
      case 'PUBLISHED':
        return OrganizerStatusBadge.published();
      case 'CLOSED':
        return OrganizerStatusBadge.closed();
      case 'CANCELLED':
        return OrganizerStatusBadge.cancelled();
      default:
        return OrganizerStatusBadge.draft();
    }
  }
}
