import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_attendance_list_controller.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_event_list_controller.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_event_statistics_controller.dart';
import 'package:events_app/feature/organizer/presentation/widget/widgets.dart';
import 'package:events_app/routes/organizer_app_layout_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrganizerAttendanceOverviewPage extends StatefulWidget {
  final int? eventId;

  const OrganizerAttendanceOverviewPage({super.key, this.eventId});

  @override
  State<OrganizerAttendanceOverviewPage> createState() =>
      _OrganizerAttendanceOverviewPageState();
}

class _OrganizerAttendanceOverviewPageState
    extends State<OrganizerAttendanceOverviewPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late OrganizerEventListController _eventCtrl;
  late OrganizerEventStatisticsController _statsCtrl;
  late OrganizerAttendanceListController _attendanceCtrl;

  EventSummaryEntity? _selectedEvent;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _eventCtrl = Get.find<OrganizerEventListController>();
    _statsCtrl = Get.put(OrganizerEventStatisticsController());
    _attendanceCtrl = Get.put(OrganizerAttendanceListController());

    if (widget.eventId != null) {
      final layoutCtrl = Get.find<OrganizerAppLayoutController>();
      layoutCtrl.setEventContext(widget.eventId!);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final found = _eventCtrl.events.firstWhereOrNull(
            (e) => e.eventId == widget.eventId);
        if (found != null && mounted) {
          setState(() => _selectedEvent = found);
          _onEventSelected(found);
        }
      });
    } else if (_eventCtrl.events.isNotEmpty) {
      _selectedEvent = _eventCtrl.events.first;
      _onEventSelected(_selectedEvent!);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    final layoutCtrl = Get.find<OrganizerAppLayoutController>();
    layoutCtrl.clearEventContext();
    super.dispose();
  }

  void _onEventSelected(EventSummaryEntity event) {
    if (event.eventId == null) return;
    _statsCtrl.setEventId(event.eventId!);
    _attendanceCtrl.setEventFilter(event.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff64748B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Tổng quan điểm danh',
            style: TextStyle(
                color: Color(0xff273143),
                fontSize: 17,
                fontWeight: FontWeight.w700)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xff64748B)),
            onPressed: () {
              _statsCtrl.refresh();
              _attendanceCtrl.refreshLogs();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Sự kiện',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff475569))),
                const SizedBox(height: 6),
                Obx(() {
                  final events = _eventCtrl.events;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<EventSummaryEntity>(
                        value: _selectedEvent,
                        hint: Text('Chọn sự kiện',
                            style: TextStyle(
                                color: Colors.grey.shade400, fontSize: 14)),
                        isExpanded: true,
                        items: events
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.title ?? 'N/A',
                                      overflow: TextOverflow.ellipsis),
                                ))
                            .toList(),
                        onChanged: (e) {
                          setState(() => _selectedEvent = e);
                          if (e != null) _onEventSelected(e);
                        },
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF06B6D4),
            unselectedLabelColor: Colors.grey.shade600,
            indicatorColor: const Color(0xFF06B6D4),
            labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            tabs: const [
              Tab(text: 'Tổng quan'),
              Tab(text: 'Theo dõi real-time'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSummaryTab(),
                _buildTrackerTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOverviewCard(),
          const SizedBox(height: 16),
          _buildCheckInRateChart(),
          const SizedBox(height: 16),
          _buildTimeDistributionCard(),
          const SizedBox(height: 16),
          _buildAttendanceByCategory(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildOverviewCard() {
    return Obx(() {
      final stats = _statsCtrl.statistics.value;
      final total = stats?.totalRegistered ?? 0;
      final checkedIn = stats?.totalCheckedIn ?? 0;
      final checkedOut = stats?.totalCheckedOut ?? 0;
      final noShow = total - checkedIn;
      final rate = total > 0 ? checkedIn / total : 0.0;

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF06B6D4).withOpacity(0.3),
              offset: const Offset(0, 8),
              blurRadius: 16,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.event_available,
                      color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedEvent?.title ?? 'Chưa chọn sự kiện',
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildOverviewItem('$total', 'Tổng vé', Icons.confirmation_number),
                _buildOverviewItem('$checkedIn', 'Check-in', Icons.check_circle),
                _buildOverviewItem('$checkedOut', 'Check-out', Icons.logout),
                _buildOverviewItem(
                    '${(rate * 100).toStringAsFixed(0)}%',
                    'Tỷ lệ',
                    Icons.percent),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildOverviewItem(String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white.withOpacity(0.8), size: 18),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white)),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                    fontSize: 10, color: Colors.white.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckInRateChart() {
    return Obx(() {
      final stats = _statsCtrl.statistics.value;
      final total = stats?.totalRegistered ?? 0;
      final checkedIn = stats?.totalCheckedIn ?? 0;
      final checkedOut = stats?.totalCheckedOut ?? 0;
      final noShow = total - checkedIn;
      final rate = total > 0 ? checkedIn / total : 0.0;
      final checkoutRate = checkedIn > 0 ? checkedOut / checkedIn : 0.0;
      final noShowRate = total > 0 ? noShow / total : 0.0;

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 8)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tỷ lệ check-in',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff273143))),
            const SizedBox(height: 16),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Stack(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator(
                          value: rate,
                          strokeWidth: 10,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF10B981)),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${(rate * 100).toStringAsFixed(0)}%',
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF10B981))),
                            Text('thành công',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    children: [
                      _buildRateRow(
                          'Đã check-in', '$checkedIn', const Color(0xFF10B981), rate),
                      const SizedBox(height: 10),
                      _buildRateRow(
                          'Đã check-out', '$checkedOut', const Color(0xFFF59E0B), checkoutRate),
                      const SizedBox(height: 10),
                      _buildRateRow(
                          'Vắng mặt', '$noShow', const Color(0xFFEF4444), noShowRate),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildRateRow(String label, String value, Color color, double progress) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
        ),
        Text(value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildTimeDistributionCard() {
    return Obx(() {
      final timeline = _statsCtrl.analytics.value?.checkInTimeline ?? [];

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 8)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text('Phân bố check-in theo giờ',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff273143))),
                Spacer(),
                Icon(Icons.access_time, size: 18, color: Color(0xFF06B6D4)),
              ],
            ),
            const SizedBox(height: 16),
            if (timeline.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Chưa có dữ liệu',
                      style: TextStyle(color: Color(0xff94A3B8), fontSize: 13)),
                ),
              )
            else
              SizedBox(
                height: 120,
                child: Row(
                  children: timeline.map((item) {
                    final maxCount = timeline
                        .map((e) => e.count ?? 0)
                        .fold<int>(0, (max, c) => c > max ? c : max);
                    final fraction = maxCount > 0
                        ? ((item.count ?? 0) / maxCount).clamp(0.05, 1.0)
                        : 0.05;
                    return _buildTimelineBar(
                      item.time ?? '',
                      fraction,
                      item.count ?? 0,
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildTimelineBar(String time, double fraction, int count) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Tooltip(
                message: '$count người',
                child: Container(
                  height: 80 * fraction,
                  width: 24,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF06B6D4),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(time, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget _buildAttendanceByCategory() {
    return Obx(() {
      final gender = _statsCtrl.analytics.value?.genderDistribution;
      final major = _statsCtrl.analytics.value?.majorDistribution;
      final hasData = gender != null ||
          (major != null && major.isNotEmpty);

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 8)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Phân bố người tham gia',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff273143))),
            const SizedBox(height: 16),
            if (!hasData)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Chưa có dữ liệu phân bố',
                      style: TextStyle(color: Color(0xff94A3B8), fontSize: 13)),
                ),
              )
            else ...[
              if (gender != null) ...[
                _buildCategoryRow('Nam', gender.malePercentage?.toInt() ?? 0,
                    const Color(0xFF3B82F6)),
                const SizedBox(height: 8),
                _buildCategoryRow('Nữ', gender.femalePercentage?.toInt() ?? 0,
                    const Color(0xFFEC4899)),
                if (major != null && major.isNotEmpty) const SizedBox(height: 12),
              ],
              if (major != null && major.isNotEmpty) ...[
                const Divider(height: 16),
                const Text('Ngành học',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff475569))),
                const SizedBox(height: 8),
                ...major.take(5).map((m) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildCategoryRow(
                        m.name ?? 'N/A',
                        (m.percentage ?? 0).toInt(),
                        const Color(0xFF06B6D4)),
                  );
                }),
              ],
            ],
          ],
        ),
      );
    });
  }

  Widget _buildCategoryRow(String label, int percent, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
        ),
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (percent / 100).clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 36,
          child: Text('$percent%',
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff273143))),
        ),
      ],
    );
  }

  Widget _buildTrackerTab() {
    return Obx(() {
      if (_attendanceCtrl.isLoading.value && _attendanceCtrl.attendanceLogs.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      return RefreshIndicator(
        onRefresh: _attendanceCtrl.refreshLogs,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRealTimeStats(),
              const SizedBox(height: 16),
              _buildCheckInChart(),
              const SizedBox(height: 16),
              _buildTodayLog(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildRealTimeStats() {
    final stats = _statsCtrl.statistics.value;
    final total = stats?.totalRegistered ?? 0;
    final checkedIn = stats?.totalCheckedIn ?? 0;
    final noShow = total - checkedIn;
    final rate = total > 0 ? ((checkedIn / total) * 100).toStringAsFixed(0) : '0';
    final lastUpdate = stats?.lastUpdateTime;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 8)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text('Cập nhật real-time',
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF10B981),
                      fontWeight: FontWeight.w600)),
              const Spacer(),
              if (lastUpdate != null)
                Text(AppDateUtils.formatDate(lastUpdate),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500))
              else
                Text(AppDateUtils.formatDate(DateTime.now()),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatBox('$checkedIn', 'Đã check-in', const Color(0xFF10B981)),
              _buildStatBox('$noShow', 'Vắng mặt', const Color(0xFFEF4444)),
              _buildStatBox('$rate%', 'Tỷ lệ', const Color(0xFF06B4D4)),
              _buildStatBox('$total', 'Tổng', Colors.grey.shade700),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String value, String label, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckInChart() {
    final timeline = _statsCtrl.analytics.value?.checkInTimeline ?? [];
    final lastUpdate = _statsCtrl.analytics.value?.lastUpdateTime;

    if (timeline.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 8)
          ],
        ),
        child: const Column(
          children: [
            Icon(Icons.timeline, size: 40, color: Color(0xff94A3B8)),
            SizedBox(height: 8),
            Text('Chưa có dữ liệu check-in',
                style: TextStyle(fontSize: 13, color: Color(0xff94A3B8))),
          ],
        ),
      );
    }

    final maxCount = timeline
        .map((e) => e.count ?? 0)
        .fold<int>(0, (max, c) => c > max ? c : max);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 8)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Timeline check-in hôm nay',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff273143))),
              const Spacer(),
              if (lastUpdate != null)
                Text('Cập nhật: ${AppDateUtils.formatDate(lastUpdate)}',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: Row(
              children: timeline.map((item) {
                final fraction = maxCount > 0
                    ? ((item.count ?? 0) / maxCount).clamp(0.05, 1.0)
                    : 0.05;
                return _buildTimeBar(item.time ?? '', fraction, item.count ?? 0);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBar(String time, double fraction, int count) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Tooltip(
                message: '$count người',
                child: Container(
                  width: 24,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 120 * fraction,
                  decoration: BoxDecoration(
                    color: const Color(0xFF06B6D4),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(time,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget _buildTodayLog() {
    final logs = _attendanceCtrl.attendanceLogs
        .where((l) => l.createdTime != null)
        .toList()
      ..sort((a, b) => b.createdTime!.compareTo(a.createdTime!));

    if (logs.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 8)
          ],
        ),
        child: const Center(
          child: Text('Chưa có nhật ký điểm danh',
              style: TextStyle(color: Color(0xff94A3B8))),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 8)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Nhật ký điểm danh hôm nay',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff273143))),
          const SizedBox(height: 12),
          ...logs.take(20).map((log) => _buildLogItem(log)),
        ],
      ),
    );
  }

  Widget _buildLogItem(log) {
    final isCheckIn = log.type?.name == 'checkIn';
    final participant = log.eventParticipant;
    final user = participant?.user;
    final name = user?.fullName ?? 'N/A';
    final timeStr = log.createdTime != null
        ? '${log.createdTime!.hour.toString().padLeft(2, '0')}:${log.createdTime!.minute.toString().padLeft(2, '0')}'
        : '-';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isCheckIn
                  ? const Color(0xFF10B981).withOpacity(0.1)
                  : const Color(0xFFEF4444).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCheckIn ? Icons.login : Icons.logout,
              size: 14,
              color: isCheckIn
                  ? const Color(0xFF10B981)
                  : const Color(0xFFEF4444),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff273143))),
                Text(isCheckIn ? 'Check-in' : 'Check-out',
                    style:
                        TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Text(timeStr,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff273143))),
        ],
      ),
    );
  }
}
