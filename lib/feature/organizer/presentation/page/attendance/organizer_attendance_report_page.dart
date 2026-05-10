import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_attendance_list_controller.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_event_list_controller.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_event_statistics_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrganizerAttendanceReportPage extends StatefulWidget {
  final int? eventId;

  const OrganizerAttendanceReportPage({super.key, this.eventId});

  @override
  State<OrganizerAttendanceReportPage> createState() =>
      _OrganizerAttendanceReportPageState();
}

class _OrganizerAttendanceReportPageState
    extends State<OrganizerAttendanceReportPage> {
  late OrganizerEventListController _eventCtrl;
  late OrganizerEventStatisticsController _statsCtrl;
  late OrganizerAttendanceListController _attendanceCtrl;

  EventSummaryEntity? _selectedEvent;
  DateTimeRange? _selectedDateRange;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _eventCtrl = Get.put(OrganizerEventListController());
    _statsCtrl = Get.put(OrganizerEventStatisticsController());
    _attendanceCtrl = Get.put(OrganizerAttendanceListController());

    if (widget.eventId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final found = _eventCtrl.events
            .firstWhereOrNull((e) => e.eventId == widget.eventId);
        if (found != null && mounted) {
          setState(() => _selectedEvent = found);
          _onEventSelected(found);
        }
      });
    }
  }

  void _onEventSelected(EventSummaryEntity event) {
    if (event.eventId == null) return;
    _statsCtrl.setEventId(event.eventId!);
    _attendanceCtrl.setEventFilter(event.eventId);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  List<dynamic> _getFilteredLogs() {
    var logs = _attendanceCtrl.attendanceLogs.toList();

    if (_selectedDateRange != null) {
      logs = logs.where((l) {
        final created = l.createdTime;
        if (created == null) return false;
        return created.isAfter(
                _selectedDateRange!.start.subtract(const Duration(days: 1))) &&
            created
                .isBefore(_selectedDateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }

    if (_selectedFilter == 'checkin') {
      logs = logs.where((l) => l.type == AttendanceLogType.checkIn).toList();
    } else if (_selectedFilter == 'checkout') {
      logs = logs.where((l) => l.type == AttendanceLogType.checkOut).toList();
    }

    return logs;
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
        title: const Text('Báo cáo điểm danh',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEventSelector(),
            const SizedBox(height: 12),
            _buildDateRangePicker(),
            const SizedBox(height: 16),
            _buildQuickFilters(),
            const SizedBox(height: 16),
            _buildDailySummary(),
            const SizedBox(height: 16),
            _buildCheckInTrends(),
            const SizedBox(height: 16),
            _buildDetailedTable(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('Tất cả', _selectedFilter == 'all', () {
            setState(() => _selectedFilter = 'all');
          }),
          const SizedBox(width: 8),
          _buildFilterChip('Check-in', _selectedFilter == 'checkin', () {
            setState(() => _selectedFilter = 'checkin');
          }),
          const SizedBox(width: 8),
          _buildFilterChip('Check-out', _selectedFilter == 'checkout', () {
            setState(() => _selectedFilter = 'checkout');
          }),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF06B6D4) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? const Color(0xFF06B6D4) : Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: selected ? Colors.white : const Color(0xff64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildEventSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Sự kiện',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xff475569))),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<EventSummaryEntity>(
              value: _selectedEvent,
              hint: Text('Chọn sự kiện',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
              isExpanded: true,
              items: _eventCtrl.events.map((e) {
                return DropdownMenuItem<EventSummaryEntity>(
                  value: e,
                  child: Text(e.title ?? 'N/A',
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: (v) {
                if (v != null) {
                  setState(() => _selectedEvent = v);
                  _onEventSelected(v);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateRangePicker() {
    return GestureDetector(
      onTap: () async {
        final range = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2025),
          lastDate: DateTime.now(),
          initialDateRange: _selectedDateRange,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Color(0xFF06B6D4),
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: Color(0xff273143),
                ),
              ),
              child: child!,
            );
          },
        );
        if (range != null) {
          setState(() => _selectedDateRange = range);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today,
                size: 18, color: Color(0xff64748B)),
            const SizedBox(width: 10),
            Text(
              _selectedDateRange != null
                  ? '${_formatDate(_selectedDateRange!.start)} - ${_formatDate(_selectedDateRange!.end)}'
                  : 'Chọn khoảng thời gian',
              style: TextStyle(
                fontSize: 14,
                color: _selectedDateRange != null
                    ? const Color(0xff273143)
                    : Colors.grey.shade400,
              ),
            ),
            const Spacer(),
            Icon(Icons.arrow_drop_down, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildDailySummary() {
    return Obx(() {
      final stats = _statsCtrl.statistics.value;
      final total = stats?.totalRegistered ?? 0;
      final checkedIn = stats?.totalCheckedIn ?? 0;
      final noShow = total - checkedIn;
      final rate = total > 0 ? checkedIn / total : 0.0;

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
            Row(
              children: [
                const Text('Tổng kết sự kiện',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff273143))),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _selectedEvent?.startTime != null
                        ? _formatDate(_selectedEvent!.startTime!)
                        : 'Chưa chọn sự kiện',
                    style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF10B981),
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildSummaryItem('Tổng đăng ký', '$total', Icons.group_add,
                    const Color(0xFF06B6D4)),
                _buildSummaryItem('Đã check-in', '$checkedIn',
                    Icons.check_circle, const Color(0xFF10B981)),
                _buildSummaryItem('Vắng mặt', '$noShow', Icons.cancel,
                    const Color(0xFFEF4444)),
                _buildSummaryItem(
                    'Tỷ lệ',
                    '${(rate * 100).toStringAsFixed(0)}%',
                    Icons.percent,
                    const Color(0xFFF59E0B)),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSummaryItem(
      String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckInTrends() {
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
            const Text('Xu hướng check-in',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff273143))),
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
          Text(time,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget _buildDetailedTable() {
    return Obx(() {
      final filteredLogs = _getFilteredLogs();
      if (_attendanceCtrl.isLoading.value && filteredLogs.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xff06B6D4)),
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
            Row(
              children: [
                const Text('Danh sách điểm danh',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff273143))),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF06B6D4).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${filteredLogs.length} bản ghi',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF06B6D4),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (filteredLogs.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Không có bản ghi nào',
                      style: TextStyle(color: Color(0xff94A3B8), fontSize: 13)),
                ),
              )
            else
              Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        SizedBox(
                            width: 32,
                            child: Text('STT',
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff64748B)))),
                        Expanded(
                            child: Text('Người tham gia',
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff64748B)))),
                        SizedBox(
                            width: 70,
                            child: Text('Thời gian',
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff64748B)))),
                        SizedBox(
                            width: 70,
                            child: Text('Loại',
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff64748B)))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...filteredLogs.asMap().entries.map<Widget>((entry) {
                    final idx = entry.key;
                    final log = entry.value;
                    return _buildReportLogRow(idx + 1, log);
                  }),
                ],
              ),
          ],
        ),
      );
    });
  }

  Widget _buildReportLogRow(int index, dynamic log) {
    final typeName = log.type?.displayName ?? '';
    final typeColor = typeName == 'checkIn'
        ? const Color(0xFF10B981)
        : const Color(0xFFF59E0B);
    final typeLabel = typeName == 'checkIn' ? 'Check-in' : 'Check-out';
    final userName = log.eventParticipant?.user?.fullName ?? 'N/A';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: [
          SizedBox(
              width: 32,
              child: Text(
                '$index',
                style: const TextStyle(fontSize: 12, color: Color(0xff94A3B8)),
              )),
          Expanded(
            child: Text(
              userName,
              style: const TextStyle(fontSize: 12, color: Color(0xff273143)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 70,
            child: Text(
              log.createdTime != null
                  ? AppDateUtils.formatDateTime(log.createdTime!)
                  : 'N/A',
              style: const TextStyle(fontSize: 11, color: Color(0xff64748B)),
            ),
          ),
          SizedBox(
            width: 70,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(typeLabel,
                  style: TextStyle(
                      fontSize: 10,
                      color: typeColor,
                      fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
