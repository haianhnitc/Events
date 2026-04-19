import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_event_detail_controller.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_event_statistics_controller.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_participant_list_controller.dart';
import 'package:events_app/routes/organizer_app_layout_controller.dart';
import 'package:events_app/feature/organizer/presentation/page/attendance/organizer_attendance_list_page.dart';
import 'package:events_app/feature/organizer/presentation/page/attendance/organizer_attendance_overview_page.dart';
import 'package:events_app/feature/organizer/presentation/page/attendance/organizer_attendance_setup_page.dart';
import 'package:events_app/feature/organizer/presentation/page/participants/organizer_participant_list_page.dart';
import 'package:events_app/feature/organizer/presentation/page/events/organizer_create_event_page.dart';
import 'package:events_app/feature/organizer/presentation/page/ticket/organizer_ticket_list_page.dart';
import 'package:events_app/feature/organizer/presentation/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrganizerEventDetailPage extends StatefulWidget {
  final int eventId;

  const OrganizerEventDetailPage({super.key, required this.eventId});

  @override
  State<OrganizerEventDetailPage> createState() =>
      _OrganizerEventDetailPageState();
}

class _OrganizerEventDetailPageState extends State<OrganizerEventDetailPage> {
  late OrganizerEventDetailController _detailCtrl;
  late OrganizerEventStatisticsController _statsCtrl;
  late OrganizerParticipantListController _participantCtrl;

  @override
  void initState() {
    super.initState();
    _detailCtrl = Get.put(OrganizerEventDetailController());
    _statsCtrl = Get.put(OrganizerEventStatisticsController());
    _participantCtrl = Get.put(OrganizerParticipantListController());

    _detailCtrl.setEventId(widget.eventId);
    _statsCtrl.setEventId(widget.eventId);
    _participantCtrl.setEventFilter(widget.eventId);

    _detailCtrl.loadEvent(widget.eventId);

    final layoutCtrl = Get.find<OrganizerAppLayoutController>();
    layoutCtrl.setEventContext(widget.eventId);
  }

  @override
  void dispose() {
    Get.delete<OrganizerEventDetailController>();
    Get.delete<OrganizerEventStatisticsController>();
    Get.delete<OrganizerParticipantListController>();

    // Clear event context khi rời khỏi event
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff64748B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Chi tiết sự kiện',
          style: TextStyle(
            color: Color(0xff273143),
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Color(0xff64748B)),
            onPressed: () {
              final event = _detailCtrl.event.value;
              if (event != null) {
                Get.to(() => OrganizerCreateEventPage(
                  eventId: event.eventId,
                  event: event,
                ));
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (_detailCtrl.isLoading.value && _detailCtrl.event.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final event = _detailCtrl.event.value;
        if (event == null) {
          return const Center(
            child: Text('Không tìm thấy sự kiện',
                style: TextStyle(color: Color(0xff94A3B8))),
          );
        }

        final stats = _statsCtrl.statistics.value;

        return RefreshIndicator(
          onRefresh: () async {
            await _detailCtrl.refreshEvent();
            await _statsCtrl.refresh();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBanner(event.banner, event.title ?? 'N/A'),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatusRow(event),
                      const SizedBox(height: 12),
                      _buildTitle(event.title ?? 'N/A'),
                      const SizedBox(height: 10),
                      _buildMetaRow(event),
                      const SizedBox(height: 16),
                      _buildDescription(event.description),
                      const SizedBox(height: 20),
                      _buildStatsGrid(stats),
                      const SizedBox(height: 20),
                      _buildParticipantSection(),
                      const SizedBox(height: 20),
                      _buildActionButtons(event),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBanner(String? banner, String title) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2FE),
        image: banner != null
            ? DecorationImage(
                image: NetworkImage(banner),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: banner == null
          ? Center(
              child: Text(
                title[0],
                style: const TextStyle(
                    fontSize: 48, color: Color(0xFF06B6D4)),
              ),
            )
          : null,
    );
  }

  Widget _buildStatusRow(event) {
    final status = event.status;
    String statusText = 'N/A';
    Widget statusBadge = OrganizerStatusBadge.pending();

    if (status?.name == 'PUBLISHED') {
      statusText = 'Đã xuất bản';
      statusBadge = OrganizerStatusBadge.published();
    } else if (status?.name == 'DRAFT') {
      statusText = 'Bản nháp';
      statusBadge = OrganizerStatusBadge.pending();
    } else if (status?.name == 'CANCELLED') {
      statusText = 'Đã hủy';
      statusBadge = OrganizerStatusBadge.rejected();
    } else if (status?.name == 'CLOSED') {
      statusText = 'Đã đóng';
      statusBadge = OrganizerStatusBadge.closed();
    }

    return Column(
      children: [
        Row(
          children: [
            statusBadge,
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF06B6D4).withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.visibility_outlined, size: 14, color: Color(0xFF06B6D4)),
                  const SizedBox(width: 4),
                  Text(statusText,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF06B6D4))),
                ],
              ),
            ),
          ],
        ),
        if (event.capacity != null && event.totalParticipants != null) ...[
          const SizedBox(height: 8),
          _buildCapacityWarning(event.capacity!, event.totalParticipants!),
        ],
      ],
    );
  }

  Widget _buildCapacityWarning(int capacity, int participants) {
    final percentage = participants / capacity;
    final isNearFull = percentage >= 0.8;
    final isFull = percentage >= 1.0;
    final color = isFull
        ? const Color(0xFFEF4444)
        : isNearFull
            ? const Color(0xFFF59E0B)
            : const Color(0xFF10B981);
    final label = isFull
        ? 'Đã đầy'
        : isNearFull
            ? 'Gần đầy'
            : '$participants/$capacity';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isFull ? Icons.warning_amber : Icons.people_outline,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: Color(0xff273143),
      ),
    );
  }

  Widget _buildMetaRow(event) {
    final venue = event.venue;
    final venueName = venue?.name ?? 'N/A';
    final address = venue?.address ?? 'N/A';

    String timeRange = 'N/A';
    if (event.startTime != null && event.endTime != null) {
      timeRange = '${AppDateUtils.formatDate(event.startTime!)} - ${AppDateUtils.formatDate(event.endTime!)}';
    }

    final categories = event.categories;
    final categoryNames = categories
        ?.map((c) => c.name ?? '')
        .where((s) => s.isNotEmpty)
        .join(', ');

    final participantCount = event.totalParticipants ?? 0;
    final capacity = event.capacity ?? 0;

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _buildMetaItem(Icons.calendar_today_outlined, timeRange),
        _buildMetaItem(Icons.location_on_outlined, '$venueName, $address'),
        if (categoryNames != null && categoryNames.isNotEmpty)
          _buildMetaItem(Icons.category_outlined, categoryNames),
        if (capacity > 0)
          _buildMetaItem(Icons.people_outline, '$participantCount / $capacity người'),
      ],
    );
  }

  Widget _buildMetaItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(text,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            overflow: TextOverflow.ellipsis),
      ],
    );
  }

  Widget _buildDescription(String? description) {
    if (description == null || description.isEmpty) {
      return const SizedBox.shrink();
    }
    return Text(
      description,
      style: const TextStyle(fontSize: 14, color: Color(0xff475569), height: 1.5),
    );
  }

  Widget _buildStatsGrid(stats) {
    final registered = stats?.totalRegistered ?? 0;
    final checkedIn = stats?.totalCheckedIn ?? 0;
    final noShow = stats != null && stats.totalRegistered != null
        ? (stats.totalRegistered! - stats.totalCheckedIn!).clamp(0, 9999)
        : (registered - checkedIn).clamp(0, 9999);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OrganizerSectionHeader(title: 'Thống kê'),
        const SizedBox(height: 8),
        if (_statsCtrl.isLoadingStats.value)
          const Center(
              child: Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ))
        else
          Row(
            children: [
              _buildStatItem('$registered', 'Đăng ký', const Color(0xFF06B6D4)),
              _buildStatItem('$checkedIn', 'Check-in', const Color(0xFF10B981)),
              _buildStatItem('$noShow', 'Vắng mặt', const Color(0xFFEF4444)),
            ],
          ),
      ],
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w800, color: color),
            ),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12, color: color.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OrganizerSectionHeader(
          title: 'Người tham gia gần đây',
          actionLabel: 'Xem tất cả',
          onActionTap: () {
            Get.to(() => OrganizerParticipantListPage(
              eventId: widget.eventId,
              recruitmentType: _detailCtrl.event.value?.recruitmentType,
              eventTitle: _detailCtrl.event.value?.title,
            ));
          },
        ),
        const SizedBox(height: 8),
        Obx(() {
          if (_participantCtrl.isLoading.value && _participantCtrl.participants.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final recent = _participantCtrl.participants.take(3).toList();
          if (recent.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.people_outline, size: 32, color: Colors.grey.shade400),
                    const SizedBox(height: 8),
                    Text('Chưa có người tham gia', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                  ],
                ),
              ),
            );
          }
          return Column(
            children: recent.map((p) => _buildRecentParticipantItem(p)).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildRecentParticipantItem(p) {
    final isCtv = p.participantType?.name == 'ctv';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Color(0x0F000000), offset: Offset(0, 1), blurRadius: 4),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFFE0F2FE),
            child: Text(
              (p.user?.fullName ?? '?')[0],
              style: const TextStyle(fontSize: 13, color: Color(0xFF06B6D4), fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.user?.fullName ?? 'N/A',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xff273143)),
                ),
                Text(
                  p.user?.email ?? '',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isCtv ? const Color(0xFF8B5CF6).withOpacity(0.1) : const Color(0xFF06B6D4).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              isCtv ? 'CTV' : 'Tham dự',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isCtv ? const Color(0xFF8B5CF6) : const Color(0xFF06B6D4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(event) {
    final isDraft = event.status?.name == 'DRAFT';
    final isPublished = event.status?.name == 'PUBLISHED';

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionBtn(
                icon: Icons.qr_code_scanner,
                label: 'Điểm danh',
                color: const Color(0xFF06B6D4),
                onTap: () {
                  Get.to(() => OrganizerAttendanceSetupPage(eventId: widget.eventId));
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildActionBtn(
                icon: Icons.people_outline,
                label: 'Người tham gia',
                color: const Color(0xFF8B5CF6),
                onTap: () {
                  Get.to(() => OrganizerParticipantListPage(
                    eventId: widget.eventId,
                    recruitmentType: _detailCtrl.event.value?.recruitmentType,
                    eventTitle: _detailCtrl.event.value?.title,
                  ));
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildActionBtn(
                icon: Icons.bar_chart_rounded,
                label: 'Lịch sử điểm danh',
                color: const Color(0xFF10B981),
                onTap: () {
                  Get.to(() => OrganizerAttendanceListPage(eventId: widget.eventId));
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildActionBtn(
                icon: Icons.confirmation_number_outlined,
                label: 'Quản lý vé',
                color: const Color(0xFFF59E0B),
                onTap: () {
                  Get.to(() => OrganizerTicketListPage(eventId: widget.eventId));
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildActionBtn(
                icon: Icons.analytics_outlined,
                label: 'Tổng quan điểm danh',
                color: const Color(0xFF06B6D4),
                onTap: () {
                  Get.to(() => OrganizerAttendanceOverviewPage(eventId: widget.eventId));
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildActionBtn(
                icon: Icons.share_outlined,
                label: 'Chia sẻ',
                color: const Color(0xFF8B5CF6),
                onTap: () {
                  AppSnackbarUtils.showInfo('Chia sẻ', 'Tính năng đang phát triển');
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (isDraft)
          Obx(() => _buildActionBtn(
                icon: Icons.publish,
                label: _detailCtrl.isActionLoading.value ? 'Đang xuất bản...' : 'Xuất bản sự kiện',
                color: const Color(0xFF06B6D4),
                onTap: _detailCtrl.isActionLoading.value ? () {} : () => _handlePublish(),
              )),
        if (isPublished) ...[
          Obx(() => _buildActionBtn(
                icon: Icons.lock_outline,
                label: _detailCtrl.isActionLoading.value ? 'Đang đóng...' : 'Đóng sự kiện',
                color: const Color(0xFFF59E0B),
                onTap: _detailCtrl.isActionLoading.value ? () {} : () => _handleClose(),
              )),
          const SizedBox(height: 10),
        ],
        if (isDraft || isPublished)
          Obx(() => _buildActionBtn(
                icon: Icons.cancel_outlined,
                label: _detailCtrl.isActionLoading.value ? 'Đang hủy...' : 'Hủy sự kiện',
                color: const Color(0xFFEF4444),
                onTap: _detailCtrl.isActionLoading.value ? () {} : () => _handleCancel(),
              )),
      ],
    );
  }

  Widget _buildActionBtn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }

  void _handlePublish() async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Xuất bản sự kiện'),
        content: const Text(
            'Sau khi xuất bản, sự kiện sẽ hiển thị công khai và người dùng có thể đăng ký. Bạn có chắc muốn xuất bản?'),
        actions: [
          TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Hủy')),
          ElevatedButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Xuất bản')),
        ],
      ),
    );
    if (confirm == true) {
      await _detailCtrl.publishEvent();
    }
  }

  void _handleClose() async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Đóng sự kiện'),
        content: const Text(
            'Sau khi đóng, sự kiện sẽ không còn nhận đăng ký mới. Bạn có chắc muốn đóng sự kiện này?'),
        actions: [
          TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Hủy')),
          ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
              ),
              child: const Text('Đóng sự kiện')),
        ],
      ),
    );
    if (confirm == true) {
      await _detailCtrl.closeEvent();
    }
  }

  void _handleCancel() async {
    final event = _detailCtrl.event.value;
    final hasParticipants = (event?.totalParticipants ?? 0) > 0;

    String message = 'Hành động này sẽ hủy sự kiện và không thể hoàn tác. Bạn có chắc muốn hủy?';
    if (hasParticipants) {
      message = 'Sự kiện đã có người đăng ký. Hủy sự kiện sẽ ảnh hưởng đến người tham gia. Bạn có chắc muốn hủy?';
    }

    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Hủy sự kiện'),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Không')),
          ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
              ),
              child: const Text('Hủy sự kiện')),
        ],
      ),
    );
    if (confirm == true) {
      await _detailCtrl.deleteEvent();
    }
  }
}
