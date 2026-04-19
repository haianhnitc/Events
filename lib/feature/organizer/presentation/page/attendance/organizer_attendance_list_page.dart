import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_attendance_list_controller.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_event_list_controller.dart';
import 'package:events_app/feature/organizer/presentation/page/attendance/organizer_attendance_report_page.dart';
import 'package:events_app/feature/organizer/presentation/page/attendance/organizer_attendance_setup_page.dart';
import 'package:events_app/feature/organizer/presentation/page/participants/organizer_participant_detail_page.dart';
import 'package:events_app/feature/organizer/presentation/widget/widgets.dart';
import 'package:events_app/routes/organizer_app_layout_controller.dart';
import 'package:flutter/material.dart';
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

  EventSummaryEntity? _selectedEvent;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _eventCtrl = Get.find<OrganizerEventListController>();
    _attendanceCtrl = Get.put(OrganizerAttendanceListController());

    if (widget.eventId != null) {
      _attendanceCtrl.setEventFilter(widget.eventId!);
      final layoutCtrl = Get.find<OrganizerAppLayoutController>();
      layoutCtrl.setEventContext(widget.eventId!);
    } else if (_eventCtrl.events.isNotEmpty) {
      _selectedEvent = _eventCtrl.events.first;
      _attendanceCtrl.setEventFilter(_selectedEvent!.eventId);
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Danh sách điểm danh',
          style: TextStyle(
              color: Color(0xff273143),
              fontSize: 17,
              fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined,
                color: Color(0xff64748B)),
            tooltip: 'Báo cáo điểm danh',
            onPressed: () {
              if (_selectedEvent != null) {
                Get.to(() =>
                    OrganizerAttendanceReportPage(eventId: _selectedEvent!.eventId));
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined,
                color: Color(0xff64748B)),
            tooltip: 'Thiết lập điểm danh',
            onPressed: () {
              if (_selectedEvent != null) {
                Get.to(() =>
                    OrganizerAttendanceSetupPage(eventId: _selectedEvent!.eventId!));
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
                            style:
                                TextStyle(color: Colors.grey.shade400, fontSize: 14)),
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
          Obx(() => _buildSummaryBar()),
          TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF06B6D4),
            unselectedLabelColor: Colors.grey.shade600,
            indicatorColor: const Color(0xFF06B6D4),
            labelStyle:
                const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontSize: 13),
            tabs: const [
              Tab(text: 'Tất cả'),
              Tab(text: 'Đã check-in'),
              Tab(text: 'Chưa check-in'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildParticipantList(null),
                _buildParticipantList(true),
                _buildParticipantList(false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBar() {
    final total = _attendanceCtrl.attendanceLogs.length;
    final checkedIn = _attendanceCtrl.totalCheckIns;
    final absent = total - checkedIn;
    final rate = total > 0 ? ((checkedIn / total) * 100).toStringAsFixed(0) : '0';
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF06B6D4).withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF06B6D4).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.people_outline, size: 16, color: Color(0xFF06B6D4)),
          const SizedBox(width: 8),
          Text('Tỷ lệ check-in: ',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
          Text('$rate%',
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF10B981))),
          const Spacer(),
          Text('$absent vắng mặt',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildParticipantList(bool? isCheckedIn) {
    if (_attendanceCtrl.isLoading.value && _attendanceCtrl.attendanceLogs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    final allLogs = _attendanceCtrl.attendanceLogs;
    final filtered = isCheckedIn == null
        ? allLogs
        : allLogs.where((l) {
            final logTypeName = l.type?.name ?? '';
            if (isCheckedIn) {
              return logTypeName == 'checkIn';
            } else {
              return logTypeName != 'checkIn';
            }
          }).toList();

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
          return _buildLogCard(log, isCheckedIn);
        },
      ),
    );
  }

  Widget _buildLogCard(log, bool? isCheckedIn) {
    final hasCheckIn = log.type?.name == 'checkIn';
    final scanMethodName = log.scanMethod?.name ?? '';
    final scannedByName = log.scannedByUser?.fullName;
    final participant = log.eventParticipant;
    final user = participant?.user;
    final userName = user?.fullName ?? participant?.applicationId?.toString() ?? 'N/A';
    final email = user?.email ?? '';
    final ticketCode = participant?.participantQrContent ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Color(0x0F000000), offset: Offset(0, 1), blurRadius: 4)
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
                    if (hasCheckIn)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                          child:
                              const Icon(Icons.check, size: 10, color: Colors.white),
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
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
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
                                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                if (hasCheckIn)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.1),
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
                else
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withOpacity(0.1),
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

  Widget _buildScanMethodBadge(String scanMethodName, ScanMethod? scanMethod) {
    if (scanMethod == null) return const SizedBox.shrink();

    final label = switch (scanMethod.name) {
      'eventQr' => 'QR sự kiện',
      'staffQr' => 'Quét mã',
      'manual' => 'Thủ công',
      _ => scanMethodName,
    };

    final color = switch (scanMethod.name) {
      'eventQr' => const Color(0xFF10B981),
      'staffQr' => const Color(0xFF06B6D4),
      'manual' => const Color(0xFFF59E0B),
      _ => Colors.grey,
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
          Icon(_scanMethodIcon(scanMethod.name), size: 10, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  IconData _scanMethodIcon(String methodName) {
    return switch (methodName) {
      'eventQr' => Icons.qr_code_2,
      'staffQr' => Icons.qr_code_scanner,
      'manual' => Icons.edit,
      _ => Icons.help_outline,
    };
  }
}
