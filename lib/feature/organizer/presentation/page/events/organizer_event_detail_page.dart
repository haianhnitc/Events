import 'package:events_app/feature/common/domain/entity/category_entity.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/feature/event_management/domain/entity/event_entity.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_event_detail_controller.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_event_statistics_controller.dart';
import 'package:events_app/feature/organizer/presentation/page/attendance/organizer_event_qr_fullscreen_page.dart';
import 'package:events_app/feature/organizer/presentation/page/events/organizer_create_event_page.dart';
import 'package:events_app/feature/organizer/presentation/page/events/organizer_event_statistics_page.dart';
import 'package:events_app/feature/organizer/presentation/page/participants/organizer_participant_list_page.dart';
import 'package:events_app/feature/organizer/presentation/page/feedback/organizer_feedback_list_page.dart';
import 'package:events_app/feature/organizer/presentation/widget/widgets.dart';
import 'package:events_app/routes/organizer_app_layout_controller.dart';
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

  @override
  void initState() {
    super.initState();
    _detailCtrl = Get.put(OrganizerEventDetailController());
    _statsCtrl = Get.put(OrganizerEventStatisticsController());

    _detailCtrl.setEventId(widget.eventId);
    _statsCtrl.setEventId(widget.eventId);

    _detailCtrl.loadEvent(widget.eventId);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final layoutCtrl = Get.find<OrganizerAppLayoutController>();
      layoutCtrl.setEventContext(widget.eventId);
    });
  }

  @override
  void dispose() {
    Get.delete<OrganizerEventDetailController>();
    Get.delete<OrganizerEventStatisticsController>();

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
              final ev = _detailCtrl.event.value;
              if (ev == null) return;
              if (ev.status != EventStatus.draft) {
                AppSnackbarUtils.showError(
                  'Không thể chỉnh sửa',
                  'Sự kiện đã xuất bản, không thể chỉnh sửa.',
                );
                return;
              }
              Get.to(() => OrganizerCreateEventPage(
                    eventId: ev.eventId,
                    event: ev,
                  ));
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
                      _buildRewardsSection(event),
                      const SizedBox(height: 20),
                      _buildDescription(event.description),
                      const SizedBox(height: 20),
                      _buildStatsButton(),
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
                style: const TextStyle(fontSize: 48, color: Color(0xFF06B6D4)),
              ),
            )
          : null,
    );
  }

  Widget _buildStatusRow(EventEntity event) {
    final status = event.status;
    String statusText = 'N/A';
    Widget statusBadge = OrganizerStatusBadge.pending();

    if (status == EventStatus.published) {
      statusText = 'Đã xuất bản';
      statusBadge = OrganizerStatusBadge.published();
    } else if (status == EventStatus.draft) {
      statusText = 'Bản nháp';
      statusBadge = OrganizerStatusBadge.pending();
    } else if (status == EventStatus.cancelled) {
      statusText = 'Đã hủy';
      statusBadge = OrganizerStatusBadge.rejected();
    } else if (status == EventStatus.closed) {
      statusText = 'Đã đóng';
      statusBadge = OrganizerStatusBadge.closed();
    } else if (status == EventStatus.locked) {
      statusText = 'Bị khóa';
      statusBadge = OrganizerStatusBadge.locked();
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
                  const Icon(Icons.visibility_outlined,
                      size: 14, color: Color(0xFF06B6D4)),
                  const SizedBox(width: 4),
                  Text(statusText,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF06B6D4))),
                ],
              ),
            ),
          ],
        ),
        if (event.venue?.capacity != null &&
            event.totalParticipants != null) ...[
          const SizedBox(height: 8),
          _buildCapacityWarning(
              event.venue!.capacity!, event.totalParticipants!),
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
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: color),
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

  Widget _buildMetaRow(EventEntity event) {
    final venue = event.venue;
    final venueName = venue?.name ?? 'N/A';
    final address = venue?.address ?? 'N/A';

    String timeRange = 'N/A';
    if (event.startTime != null && event.endTime != null) {
      timeRange =
          '${AppDateUtils.formatDateTime(event.startTime!)} - ${AppDateUtils.formatDateTime(event.endTime!)}';
    } else if (event.startTime != null) {
      timeRange = AppDateUtils.formatDateTime(event.startTime!);
    }

    final categories = event.categories;
    final categoryNames = categories
        ?.map((CategoryEntity c) => c.name ?? '')
        .where((String s) => s.isNotEmpty)
        .join(', ');

    final participantCount = event.totalParticipants ?? 0;
    final venueCapacity = venue?.capacity;

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _buildMetaItem(Icons.calendar_today_outlined, timeRange),
        _buildMetaItem(Icons.location_on_outlined, '$venueName, $address'),
        if (categoryNames != null && categoryNames.isNotEmpty)
          _buildMetaItem(Icons.category_outlined, categoryNames),
        if (venueCapacity != null && venueCapacity > 0)
          _buildMetaItem(
              Icons.people_outline, '$participantCount / $venueCapacity người')
        else
          _buildMetaItem(Icons.people_outline, '$participantCount người'),
        if (event.price != null)
          _buildMetaItem(
            Icons.attach_money,
            event.price == 0 ? 'Miễn phí' : '${event.price}đ',
          ),
        if (event.createdTime != null)
          _buildMetaItem(Icons.access_time,
              'Tạo ${AppDateUtils.formatDate(event.createdTime!)}'),
      ],
    );
  }

  Widget _buildMetaItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Flexible(
          child: Text(text,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              overflow: TextOverflow.ellipsis,
              maxLines: 1),
        ),
      ],
    );
  }

  Widget _buildRewardsSection(EventEntity event) {
    final badges = <Widget>[];

    if ((event.rewardCoin ?? 0) > 0) {
      badges.add(_rewardBadge(
          Icons.stars, const Color(0xFFF59E0B), '${event.rewardCoin} Xu'));
    }
    if ((event.youthUnionPoint ?? 0) > 0) {
      badges.add(_rewardBadge(Icons.badge, const Color(0xFF8B5CF6),
          '${event.youthUnionPoint} Điểm Đoàn'));
    }
    if ((event.certificateName ?? '').trim().isNotEmpty) {
      badges.add(_rewardBadge(Icons.card_membership, const Color(0xFF06B6D4),
          event.certificateName!));
    }

    if (badges.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: badges,
    );
  }

  Widget _rewardBadge(IconData icon, Color color, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(String? description) {
    if (description == null || description.isEmpty) {
      return const SizedBox.shrink();
    }
    return Text(
      description,
      style:
          const TextStyle(fontSize: 14, color: Color(0xff475569), height: 1.5),
    );
  }

  Widget _buildStatsButton() {
    return GestureDetector(
      onTap: () {
        Get.to(() => OrganizerEventStatisticsPage(eventId: widget.eventId));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF06B6D4).withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF06B6D4).withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF06B6D4).withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.bar_chart_rounded,
                  size: 20, color: Color(0xFF06B6D4)),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Xem thống kê sự kiện',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF06B6D4),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Đăng ký, Check-in, Tỷ lệ vắng mặt...',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF06B6D4)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(EventEntity event) {
    final isDraft = event.status == EventStatus.draft;
    final isPublished = event.status == EventStatus.published;
    final isLocked = event.status == EventStatus.locked;
    final isClosed = event.status == EventStatus.closed;
    final isCancelled = event.status == EventStatus.cancelled;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isLocked)
          _buildStatusWarningBanner(
            icon: Icons.lock_outline,
            message: 'Sự kiện bị khóa. Chỉ quản trị viên mới có thể mở khóa.',
            color: const Color(0xFFEF4444),
          ),
        if (isClosed)
          _buildStatusWarningBanner(
            icon: Icons.event_busy,
            message: 'Sự kiện đã đóng. Không thể nhận đăng ký mới.',
            color: const Color(0xFFF59E0B),
          ),
        if (isCancelled)
          _buildStatusWarningBanner(
            icon: Icons.cancel_outlined,
            message: 'Sự kiện đã bị hủy.',
            color: const Color(0xFF6B7280),
          ),
        if (isLocked || isClosed || isCancelled) const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionBtn(
                icon: Icons.login,
                label: 'QR Check-in',
                color: const Color(0xFF10B981),
                onTap: () {
                  Get.to(() => OrganizerEventQrFullscreenPage(
                        eventId: widget.eventId,
                        eventName: _detailCtrl.event.value?.title ?? '',
                        eventDate: _detailCtrl.event.value?.startTime != null
                            ? AppDateUtils.formatDate(
                                _detailCtrl.event.value!.startTime!)
                            : null,
                        eventVenue: _detailCtrl.event.value?.venue?.name,
                        action: 'CHECKIN',
                      ));
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildActionBtn(
                icon: Icons.logout,
                label: 'QR Check-out',
                color: const Color(0xFFF59E0B),
                onTap: () {
                  Get.to(() => OrganizerEventQrFullscreenPage(
                        eventId: widget.eventId,
                        eventName: _detailCtrl.event.value?.title ?? '',
                        eventDate: _detailCtrl.event.value?.startTime != null
                            ? AppDateUtils.formatDate(
                                _detailCtrl.event.value!.startTime!)
                            : null,
                        eventVenue: _detailCtrl.event.value?.venue?.name,
                        action: 'CHECKOUT',
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
                icon: Icons.people_outline,
                label: 'Người tham gia',
                color: const Color(0xFF06B6D4),
                onTap: () {
                  Get.to(() => OrganizerParticipantListPage(
                        eventId: widget.eventId,
                        recruitmentType:
                            _detailCtrl.event.value?.recruitmentType,
                        eventTitle: _detailCtrl.event.value?.title,
                      ));
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildActionBtn(
                icon: Icons.feedback_outlined,
                label: 'Xem feedback',
                color: const Color(0xFF06B6D4),
                onTap: () {
                  Get.to(() => OrganizerFeedbackListPage(
                        eventId: widget.eventId,
                        eventTitle: _detailCtrl.event.value?.title,
                      ));
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (isDraft)
          Obx(() => _buildActionBtn(
                icon: Icons.publish,
                label: _detailCtrl.isActionLoading.value
                    ? 'Đang xuất bản...'
                    : 'Xuất bản sự kiện',
                color: const Color(0xFF06B6D4),
                onTap: _detailCtrl.isActionLoading.value
                    ? () {}
                    : () => _handlePublish(),
              )),
        if (isPublished) ...[
          const SizedBox(height: 10),
          Obx(() => _buildActionBtn(
                icon: Icons.lock_outline,
                label: _detailCtrl.isActionLoading.value
                    ? 'Đang đóng...'
                    : 'Đóng sự kiện',
                color: const Color(0xFFF59E0B),
                onTap: _detailCtrl.isActionLoading.value
                    ? () {}
                    : () => _handleClose(),
              )),
        ],
        if (isDraft || isPublished) const SizedBox(height: 10),
        Obx(() => _buildActionBtn(
              icon: Icons.cancel_outlined,
              label: _detailCtrl.isCancelling.value
                  ? 'Đang hủy...'
                  : 'Hủy sự kiện',
              color: const Color(0xFFEF4444),
              onTap: _detailCtrl.isCancelling.value
                  ? () {}
                  : () => _handleCancel(),
            )),
      ],
    );
  }

  Widget _buildStatusWarningBanner({
    required IconData icon,
    required String message,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
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

    String message =
        'Hành động này sẽ hủy sự kiện và không thể hoàn tác. Bạn có chắc muốn hủy?';
    if (hasParticipants) {
      message =
          'Sự kiện đã có người đăng ký. Hủy sự kiện sẽ ảnh hưởng đến người tham gia. Bạn có chắc muốn hủy?';
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
