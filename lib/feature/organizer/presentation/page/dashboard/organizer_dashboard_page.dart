import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
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
import 'package:fl_chart/fl_chart.dart';
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
    if (!Get.isRegistered<OrganizerDashboardController>()) {
      final ctrl = OrganizerDashboardController();
      Get.put(ctrl);
    }
    if (!Get.isRegistered<OrganizerEventListController>()) {
      final ctrl = OrganizerEventListController();
      Get.put(ctrl);
    }
    _dashboardCtrl = Get.find<OrganizerDashboardController>();
    _eventCtrl = Get.find<OrganizerEventListController>();
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
        child: Obx(() {
          if (_dashboardCtrl.isLoading.value &&
              _dashboardCtrl.dashboard.value == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
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
          );
        }),
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
                  final avatarUrl =
                      auth.currentUser.value?.userProfile?.avatarUrl ??
                          auth.currentUser.value?.organizationProfile?.logoUrl;
                  return CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white24,
                    backgroundImage:
                        avatarUrl != null ? NetworkImage(avatarUrl) : null,
                    child: avatarUrl == null
                        ? const Icon(Icons.business,
                            color: Colors.white, size: 22)
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
                            auth.currentUser.value?.userProfile?.fullName ??
                                auth.currentUser.value?.organizationProfile
                                    ?.organizationName ??
                                'Tổ chức';
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
              ],
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                if (_eventCtrl.events.isNotEmpty &&
                    _eventCtrl.events.first.eventId != null) {
                  Get.to(() => OrganizerEventStatisticsPage(
                        eventId: _eventCtrl.events.first.eventId!,
                      ));
                }
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.analytics_outlined,
                        color: Colors.white, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Tổng quan tháng này',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios,
                        color: Colors.white70, size: 14),
                  ],
                ),
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
        final curEvents = dash?.currentPeriodEvents ?? 0;
        final curRegs = dash?.currentPeriodRegistrations ?? 0;
        final curViews = dash?.currentPeriodViews ?? 0;
        final curRate = dash?.currentPeriodAttendanceRate ?? 0.0;

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
                    subValue: curEvents > 0
                        ? '$curEvents sự kiện mới (30 ngày)'
                        : null,
                    tooltipMessage:
                        'Tăng ${_formatGrowth(dash?.totalEventsGrowth) ?? '0%'} so với 30 ngày trước.\nTháng này: $curEvents sự kiện.',
                    onTap: () => Get.to(() => const OrganizerEventListPage()),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OrganizerStatCard(
                    title: 'Lượt đăng ký',
                    value: _formatCompact(totalReg),
                    icon: Icons.people_outline,
                    iconColor: const Color(0xFF8B5CF6),
                    trend: _formatGrowth(dash?.totalRegistrationsGrowth),
                    subValue: curRegs > 0
                        ? '${_formatCompact(curRegs)} đăng ký (30 ngày)'
                        : null,
                    tooltipMessage:
                        'Tăng ${_formatGrowth(dash?.totalRegistrationsGrowth) ?? '0%'} so với 30 ngày trước.\nTháng này: ${_formatCompact(curRegs)} đăng ký.',
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
                    value: _formatCompact(views),
                    icon: Icons.visibility_outlined,
                    iconColor: const Color(0xFFF59E0B),
                    trend: _formatGrowth(dash?.totalViewsGrowth),
                    subValue: curViews > 0
                        ? '${_formatCompact(curViews)} lượt xem (30 ngày)'
                        : null,
                    tooltipMessage:
                        'Tăng ${_formatGrowth(dash?.totalViewsGrowth) ?? '0%'} so với 30 ngày trước.\nTháng này: ${_formatCompact(curViews)} lượt xem.',
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OrganizerStatCard(
                    title: 'Tỷ lệ tham dự',
                    value: '${(avgRate).toStringAsFixed(1)}%',
                    icon: Icons.qr_code_scanner,
                    iconColor: const Color(0xFF10B981),
                    trend: _formatGrowth(dash?.averageAttendanceRateGrowth),
                    subValue: curRate > 0
                        ? '${curRate.toStringAsFixed(1)}% (30 ngày)'
                        : null,
                    tooltipMessage:
                        '${_formatGrowth(dash?.averageAttendanceRateGrowth) ?? '0%'} so với 30 ngày trước.\nTháng này: ${curRate.toStringAsFixed(1)}% tham dự.',
                    onTap: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // _buildPeriodComparison(dash),
          ],
        );
      }),
    );
  }

  Widget _buildPeriodComparison(dash) {
    final curEvents = (dash?.currentPeriodEvents ?? 0).toDouble();
    final prevEvents = (dash?.previousPeriodEvents ?? 0).toDouble();
    final curRegs = (dash?.currentPeriodRegistrations ?? 0).toDouble();
    final prevRegs = (dash?.previousPeriodRegistrations ?? 0).toDouble();
    final curViews = (dash?.currentPeriodViews ?? 0).toDouble();
    final prevViews = (dash?.previousPeriodViews ?? 0).toDouble();
    final curRate = dash?.currentPeriodAttendanceRate ?? 0.0;
    final prevRate = dash?.previousPeriodAttendanceRate ?? 0.0;

    const currentColor = Color(0xFF06B6D4);
    const previousColor = Color(0xFFCBD5E1);
    const labelColor = Color(0xff64748B);
    const valueColor = Color(0xff273143);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.compare_arrows, size: 16, color: currentColor),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'So sánh 30 ngày gần nhất vs 30 ngày trước đó',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: valueColor,
                  ),
                ),
              ),
              _buildLegendItem('Kỳ này', currentColor),
              const SizedBox(width: 12),
              _buildLegendItem('Kỳ trước', previousColor),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _maxGroupY(curEvents, prevEvents, curRegs, prevRegs,
                        curViews, prevViews, curRate, prevRate) *
                    1.2,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => const Color(0xff1E293B),
                    tooltipRoundedRadius: 8,
                    tooltipPadding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final label = [
                        'Sự kiện',
                        'Đăng ký',
                        'Lượt xem',
                        'Tỷ lệ %'
                      ][groupIndex];
                      final val = rodIndex == 0
                          ? [curEvents, curRegs, curViews, curRate][groupIndex]
                          : [
                              prevEvents,
                              prevRegs,
                              prevViews,
                              prevRate
                            ][groupIndex];
                      final valStr = groupIndex == 3
                          ? '${val.toStringAsFixed(1)}%'
                          : _formatCompact(val.toInt());
                      return BarTooltipItem(
                        '$label: $valStr',
                        const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const labels = [
                          'Sự kiện',
                          'Đăng ký',
                          'Lượt xem',
                          'Tỷ lệ %'
                        ];
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            labels[value.toInt()],
                            style: const TextStyle(
                                fontSize: 10,
                                color: labelColor,
                                fontWeight: FontWeight.w500),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (value, meta) {
                        final val = value.toInt();
                        return Text(
                          _formatCompact(val),
                          style:
                              const TextStyle(fontSize: 9, color: labelColor),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _maxGroupY(curEvents, prevEvents, curRegs,
                          prevRegs, curViews, prevViews, curRate, prevRate) /
                      4,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.shade200,
                    strokeWidth: 1,
                    dashArray: [3, 3],
                  ),
                ),
                barGroups: [
                  _makeGroup(0, curEvents, prevEvents),
                  _makeGroup(1, curRegs, prevRegs),
                  _makeGroup(2, curViews, prevViews),
                  _makeGroup(3, curRate, prevRate),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _maxGroupY(double e1, double p1, double e2, double p2, double e3,
      double p3, double r1, double r2) {
    final maxVal =
        [e1, p1, e2, p2, e3, p3, r1, r2].reduce((a, b) => a > b ? a : b);
    return maxVal == 0 ? 100 : maxVal;
  }

  BarChartGroupData _makeGroup(int x, double current, double previous) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: current,
          color: const Color(0xFF06B6D4),
          width: 14,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
        BarChartRodData(
          toY: previous,
          color: const Color(0xFFCBD5E1),
          width: 14,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Color(0xff64748B)),
        ),
      ],
    );
  }

  String? _formatGrowth(double? growth) {
    if (growth == null) return null;
    final percent = growth / 100;
    final sign = percent >= 0 ? '+' : '';
    return '$sign${percent.toStringAsFixed(1)}%';
  }

  String _formatCompact(int value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return '$value';
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
                onTap: () => _showEventPickerForParticipants(context),
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

  void _showEventPickerForParticipants(BuildContext context) {
    final events = _eventCtrl.events;
    if (events.isEmpty) {
      AppSnackbarUtils.showInfo('Thông báo', 'Chưa có sự kiện nào');
      return;
    }
    if (events.length == 1) {
      _navigateToParticipants(events.first);
      return;
    }
    OrganizerEventPickerSheet.show(
      context: context,
      events: events,
      onSelected: _navigateToParticipants,
      title: 'Chọn sự kiện',
    );
  }

  void _navigateToParticipants(EventSummaryEntity e) {
    if (e.eventId != null) {
      Get.to(() => OrganizerParticipantListPage(
            eventId: e.eventId!,
            recruitmentType: e.recruitmentType,
            eventTitle: e.title,
          ));
    }
  }

  Widget _buildRecentEvents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OrganizerSectionHeader(
          title: 'Sự kiện gần đây',
          actionLabel: 'Xem tất cả',
          onActionTap: () => Get.find<OrganizerNavBarController>()
              .navigateTo(OrganizerNavOptions.events),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Obx(() {
            final events = _eventCtrl.events.take(3).toList();
            if (_eventCtrl.isLoading.value && events.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xff06B6D4)),
              );
            }
            if (events.isEmpty) {
              return const OrganizerEmptyState(
                message: 'Chưa có sự kiện nào',
                icon: Icons.event_busy,
                compact: true,
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
    final status = e.status ?? EventStatus.draft;
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
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade600),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.people_outline,
                          size: 12, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text(
                        '${e.totalParticipants ?? 0} / ${e.capacity ?? 0}',
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade600),
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

  OrganizerStatusBadge _getStatusBadge(EventStatus status) {
    switch (status) {
      case EventStatus.published:
        return OrganizerStatusBadge.published();
      case EventStatus.closed:
        return OrganizerStatusBadge.closed();
      case EventStatus.cancelled:
        return OrganizerStatusBadge.cancelled();
      case EventStatus.draft:
        return OrganizerStatusBadge.draft();
      case EventStatus.locked:
        return OrganizerStatusBadge.locked();
    }
  }
}
