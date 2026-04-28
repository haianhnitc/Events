import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/attendance/domain/entity/event_attendance_log_entity.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_attendance_list_controller.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_event_list_controller.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_participant_list_controller.dart';
import 'package:events_app/feature/organizer/presentation/page/attendance/organizer_attendance_report_page.dart';
import 'package:events_app/feature/organizer/presentation/page/attendance/organizer_attendance_setup_page.dart';
import 'package:events_app/feature/organizer/presentation/page/participants/organizer_participant_detail_page.dart';
import 'package:events_app/feature/organizer/presentation/widget/widgets.dart';
import 'package:events_app/routes/organizer_app_layout_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class OrganizerAttendanceListPage extends StatefulWidget {
  final int? eventId;

  const OrganizerAttendanceListPage({super.key, this.eventId});

  @override
  State<OrganizerAttendanceListPage> createState() =>
      _OrganizerAttendanceListPageState();
}

class _OrganizerAttendanceListPageState
    extends State<OrganizerAttendanceListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  late OrganizerAttendanceListController _attendanceCtrl;
  late OrganizerEventListController _eventCtrl;
  late OrganizerParticipantListController _participantCtrl;

  EventSummaryEntity? _selectedEvent;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _eventCtrl = Get.find<OrganizerEventListController>();
    _attendanceCtrl = Get.put(OrganizerAttendanceListController());
    _participantCtrl = Get.put(OrganizerParticipantListController());

    if (widget.eventId != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _attendanceCtrl.setEventFilter(widget.eventId!);
        _participantCtrl.setEventFilter(widget.eventId!);
        final layoutCtrl = Get.find<OrganizerAppLayoutController>();
        layoutCtrl.setEventContext(widget.eventId!);
      });
    } else if (_eventCtrl.events.isNotEmpty) {
      _selectedEvent = _eventCtrl.events.first;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _attendanceCtrl.setEventFilter(_selectedEvent!.eventId);
        _participantCtrl.setEventFilter(_selectedEvent!.eventId);
      });
    }
  }

  @override
  void dispose() {
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
      appBar: OrganizerAppBar(
        title: 'Danh sách điểm danh',
        actions: [
          IconButton(
            icon:
                const Icon(Icons.analytics_outlined, color: Color(0xff64748B)),
            tooltip: 'Báo cáo điểm danh',
            onPressed: () {
              if (_selectedEvent != null) {
                Get.to(() => OrganizerAttendanceReportPage(
                    eventId: _selectedEvent!.eventId));
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xff64748B)),
            tooltip: 'Thiết lập điểm danh',
            onPressed: () {
              if (_selectedEvent != null) {
                Get.to(() => OrganizerAttendanceSetupPage(
                    eventId: _selectedEvent!.eventId!));
              }
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
                const Text(
                  'Sự kiện',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff475569)),
                ),
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
                          _attendanceCtrl.setEventFilter(e?.eventId);
                          _participantCtrl.setEventFilter(e?.eventId);
                        },
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 12),
                OrganizerSearchField(
                  controller: _searchController,
                  hintText: 'Tìm theo tên, email, mã vé...',
                  onChanged: (v) => setState(() {}),
                  onClear: () => setState(() {}),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Obx(() => _buildSummaryBar()),
          TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF06B6D4),
            unselectedLabelColor: Colors.grey.shade600,
            indicatorColor: const Color(0xFF06B6D4),
            labelStyle:
                const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontSize: 13),
            onTap: (_) => setState(() {}),
            tabs: const [
              Tab(text: 'Tất cả'),
              Tab(text: 'Đã check-in'),
              Tab(text: 'Chưa check-in'),
              Tab(text: 'Đã check-out'),
            ],
          ),
          Expanded(
            child: Obx(() {
              if (_attendanceCtrl.isLoading.value &&
                  _attendanceCtrl.attendanceLogs.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return TabBarView(
                controller: _tabController,
                children: [
                  _buildLogList(null),
                  _buildLogList(true),
                  _buildParticipantListUnchecked(),
                  _buildLogList('checkout'),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBar() {
    final total = _participantCtrl.participants.length;
    final checkedIn = _attendanceCtrl.totalCheckIns;
    final checkedOut = _attendanceCtrl.totalCheckOuts;
    return OrganizerStatBar(
      variant: OrganizerStatBarVariant.compact,
      stats: [
        OrganizerStatItem(
          value: '$total',
          label: 'Đăng ký',
          color: const Color(0xFF06B6D4),
          icon: Icons.people_outline,
        ),
        OrganizerStatItem(
          value: '$checkedIn',
          label: 'Check-in',
          color: const Color(0xFF10B981),
          icon: Icons.login,
        ),
        OrganizerStatItem(
          value: '$checkedOut',
          label: 'Check-out',
          color: const Color(0xFFF59E0B),
          icon: Icons.logout,
        ),
      ],
    );
  }

  Widget _buildLogList(Object? filter) {
    if (_attendanceCtrl.isLoading.value &&
        _attendanceCtrl.attendanceLogs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    final allLogs = _attendanceCtrl.attendanceLogs;
    List<EventAttendanceLogEntity> filtered;
    if (filter == null) {
      filtered = allLogs;
    } else if (filter == 'checkout') {
      filtered =
          allLogs.where((l) => l.type == AttendanceLogType.checkOut).toList();
    } else {
      final isCheckedIn = filter as bool;
      filtered = allLogs.where((l) {
        final isLogCheckIn = l.type == AttendanceLogType.checkIn;
        return isCheckedIn ? isLogCheckIn : !isLogCheckIn;
      }).toList();
    }

    if (filtered.isEmpty) {
      return OrganizerEmptyState(
        message: 'Không có dữ liệu',
        description: 'Chưa có nhật ký điểm danh',
        icon: Icons.assignment_outlined,
      );
    }
    return RefreshIndicator(
      onRefresh: _attendanceCtrl.refreshLogs,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final log = filtered[index];
          return _buildLogCard(log);
        },
      ),
    );
  }

  Widget _buildParticipantListUnchecked() {
    if (_participantCtrl.isLoading.value &&
        _participantCtrl.participants.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    final participants = _participantCtrl.participants;
    final checkedInIds = _attendanceCtrl.attendanceLogs
        .where((l) => l.type == AttendanceLogType.checkIn)
        .map((l) => l.eventParticipant?.eventParticipantId)
        .toSet();

    final unchecked = participants
        .where((p) => !checkedInIds.contains(p.eventParticipantId))
        .toList();

    if (unchecked.isEmpty) {
      return OrganizerEmptyState(
        message: 'Tất cả đã check-in',
        description: 'Mọi người đều đã điểm danh',
        icon: Icons.check_circle_outline,
      );
    }
    return RefreshIndicator(
      onRefresh: () async {
        await _attendanceCtrl.refreshLogs();
        await _participantCtrl.refreshParticipants();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: unchecked.length,
        itemBuilder: (context, index) {
          final p = unchecked[index];
          return _buildUncheckedParticipantCard(p);
        },
      ),
    );
  }

  Widget _buildUncheckedParticipantCard(p) {
    final isCtv = p.participantType == ParticipantType.ctv;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Color(0x14000000), offset: Offset(0, 1), blurRadius: 4)
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: p.eventParticipantId != null
              ? () => Get.to(() => OrganizerParticipantDetailPage(
                  participantId: p.eventParticipantId!))
              : null,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFFFEF3C7),
                  child: Text(
                    (p.user?.fullName ?? '?')[0],
                    style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFFF59E0B),
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.user?.fullName ?? 'N/A',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff273143)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        p.user?.email ?? '',
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isCtv
                              ? const Color(0xFF8B5CF6).withValues(alpha: 0.1)
                              : const Color(0xFF06B6D4).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isCtv ? 'CTV' : 'Người tham dự',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isCtv
                                ? const Color(0xFF8B5CF6)
                                : const Color(0xFF06B6D4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.warning_amber,
                          size: 14, color: Color(0xFFF59E0B)),
                      SizedBox(width: 4),
                      Text('Vắng',
                          style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFFF59E0B),
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogCard(log) {
    final isCheckIn = log.type == AttendanceLogType.checkIn;
    final isCheckOut = log.type == AttendanceLogType.checkOut;
    final scanMethodName = _getScanMethodLabel(log.scanMethod ?? '');
    final scannedByName = log.scannedByUser?.fullName;
    final participant = log.eventParticipant;
    final user = participant?.user;
    final userName =
        user?.fullName ?? participant?.applicationId?.toString() ?? 'N/A';
    final email = user?.email ?? '';
    final ticketCode = participant?.participantQrContent ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Color(0x14000000), offset: Offset(0, 1), blurRadius: 4)
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: participant?.eventParticipantId != null
              ? () => Get.to(() => OrganizerParticipantDetailPage(
                  participantId: participant!.eventParticipantId!))
              : null,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: const Color(0xFFE0F2FE),
                      child: Text(
                        (userName == 'N/A' ? '?' : userName[0]),
                        style: const TextStyle(
                            fontSize: 16, color: Color(0xFF06B6D4)),
                      ),
                    ),
                    if (isCheckIn)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check,
                              size: 10, color: Colors.white),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff273143)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$email  ${ticketCode.isNotEmpty ? '  •  $ticketCode' : ''}',
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _buildScanMethodBadge(scanMethodName, log.scanMethod),
                          if (scannedByName != null) ...[
                            const SizedBox(width: 4),
                            Text(
                              'bởi $scannedByName',
                              style: TextStyle(
                                  fontSize: 10, color: Colors.grey.shade500),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                if (isCheckIn)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle,
                            size: 14, color: Color(0xFF10B981)),
                        SizedBox(width: 4),
                        Text('Check-in',
                            style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF10B981),
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  )
                else if (isCheckOut)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.logout, size: 14, color: Color(0xFFF59E0B)),
                        SizedBox(width: 4),
                        Text('Check-out',
                            style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFFF59E0B),
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  )
                else
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.warning_amber,
                            size: 14, color: Color(0xFFEF4444)),
                        SizedBox(width: 4),
                        Text('Vắng',
                            style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFFEF4444),
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScanMethodBadge(String scanMethodName, dynamic scanMethodRaw) {
    final method = _parseScanMethod(scanMethodRaw);
    if (method == null) return const SizedBox.shrink();

    final label = method.displayName;

    final color = switch (method) {
      ScanMethod.eventQr => const Color(0xFF10B981),
      ScanMethod.staffQr => const Color(0xFF06B6D4),
      ScanMethod.manual => const Color(0xFFF59E0B),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_scanMethodIcon(method), size: 10, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
                fontSize: 10, color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  String _getScanMethodLabel(String raw) {
    switch (raw.toUpperCase()) {
      case 'EVENT_QR':
        return 'QR sự kiện';
      case 'STAFF_QR':
        return 'QR cộng tác viên';
      case 'MANUAL':
        return 'Thủ công';
      default:
        return raw;
    }
  }

  ScanMethod? _parseScanMethod(dynamic raw) {
    if (raw is ScanMethod) return raw;
    if (raw is String) {
      return ScanMethodApiValue.fromApiValue(raw);
    }
    return null;
  }

  IconData _scanMethodIcon(ScanMethod method) {
    return switch (method) {
      ScanMethod.eventQr => Icons.qr_code_2,
      ScanMethod.staffQr => Icons.qr_code_scanner,
      ScanMethod.manual => Icons.edit,
    };
  }
}
