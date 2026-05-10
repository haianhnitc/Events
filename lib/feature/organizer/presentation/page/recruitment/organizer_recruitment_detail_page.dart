import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/common/utils/app_image_utils.dart';
import 'package:events_app/feature/common/utils/app_map_utils.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/feature/organizer/presentation/page/events/organizer_event_detail_page.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_recruitment_detail_controller.dart';
import 'package:events_app/feature/organizer/presentation/page/recruitment/organizer_recruitment_form_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrganizerRecruitmentDetailPage extends StatefulWidget {
  final int recruitmentId;

  const OrganizerRecruitmentDetailPage({
    super.key,
    required this.recruitmentId,
  });

  @override
  State<OrganizerRecruitmentDetailPage> createState() =>
      _OrganizerRecruitmentDetailPageState();
}

class _OrganizerRecruitmentDetailPageState
    extends State<OrganizerRecruitmentDetailPage> {
  late final OrganizerRecruitmentDetailController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = OrganizerRecruitmentDetailController.attach(widget.recruitmentId);
  }

  @override
  void dispose() {
    OrganizerRecruitmentDetailController.detach(widget.recruitmentId);
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
          'Chi tiết tuyển CTV',
          style: TextStyle(
            color: Color(0xff273143),
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          Obx(() => _ctrl.isLoading.value
              ? const SizedBox.shrink()
              : IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Color(0xff64748B)),
                  onPressed: () {
                    final reason = _ctrl.getEditBlockReason();
                    if (reason != null) {
                      AppSnackbarUtils.showError('Không thể chỉnh sửa', reason);
                      return;
                    }
                    Get.to(() => OrganizerRecruitmentFormPage(
                        recruitmentId: _ctrl.recruitment.value!.ctvRecruitmentId));
                  },
                )),
        ],
      ),
      body: Obx(() {
        if (_ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_ctrl.recruitment.value == null) {
          return const Center(child: Text('Không tìm thấy dữ liệu'));
        }
        return _buildContent(_ctrl.recruitment.value!);
      }),
    );
  }

  Widget _buildContent(recruitment) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBanner(recruitment),
          const SizedBox(height: 16),
          _buildStatusBadge(recruitment),
          const SizedBox(height: 16),
          _buildInfoCard(recruitment),
          const SizedBox(height: 16),
          if (_hasRewards(recruitment)) _buildRewardsSection(recruitment),
          const SizedBox(height: 16),
          if ((recruitment.description ?? '').isNotEmpty)
            _buildDescription(recruitment),
        ],
      ),
    );
  }

  Widget _buildBanner(recruitment) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 180,
        width: double.infinity,
        child: AppImageUtils.buildNetworkImage(
          imageUrl: recruitment.banner,
          placeholder: AppImageUtils.buildImagePlaceholder(),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(recruitment) {
    final isOpen = recruitment.isOpen ?? false;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isOpen
                ? const Color(0xFF10B981).withOpacity(0.1)
                : const Color(0xFFEF4444).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            isOpen ? 'Đang tuyển' : 'Đã đóng',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isOpen ? const Color(0xFF10B981) : const Color(0xFFEF4444),
            ),
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF06B6D4).withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.people_outline,
                  size: 14, color: Color(0xFF06B6D4)),
              const SizedBox(width: 4),
              Text(
                '${recruitment.recruitedCtvCount ?? 0} / ${recruitment.quantity ?? 0}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF06B6D4)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(recruitment) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Text(
            recruitment.title ?? 'N/A',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xff273143),
            ),
          ),
          const SizedBox(height: 12),
          _infoRow(Icons.calendar_today_outlined, 'Thời gian',
              AppDateUtils.formatDateTime(recruitment.startTime)),
          const SizedBox(height: 8),
          _infoRow(
              Icons.work_outline, 'Vị trí', recruitment.roleName ?? 'N/A'),
          const SizedBox(height: 8),
          _infoRow(
            Icons.location_on_outlined,
            'Địa điểm',
            recruitment.venue?.name ?? 'N/A',
            trailing: recruitment.venue?.latitude != null
                ? GestureDetector(
                    onTap: () => AppMapUtils.openVenueDirection(
                      Get.context!,
                      mapUrl: recruitment.venue?.mapUrl,
                      latitude: recruitment.venue?.latitude,
                      longitude: recruitment.venue?.longitude,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF06B6D4).withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.directions,
                          size: 16, color: Color(0xFF06B6D4)),
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 8),
          _infoRow(Icons.business, 'Ban tổ chức',
              recruitment.organizerName ?? 'N/A'),
          if (recruitment.eventId != null) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        OrganizerEventDetailPage(eventId: recruitment.eventId),
                  ),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF06B6D4).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: const Color(0xFF06B6D4).withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.event, size: 16, color: Color(0xFF06B6D4)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        recruitment.eventTitle ?? 'Xem sự kiện liên kết',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF06B6D4),
                        ),
                      ),
                    ),
                    const Icon(Icons.chevron_right,
                        size: 18, color: Color(0xFF06B6D4)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, {Widget? trailing}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF64748B)),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xff273143),
            ),
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  bool _hasRewards(recruitment) =>
      (recruitment.rewardCoin ?? 0) > 0 ||
      (recruitment.youthUnionPoint ?? 0) > 0 ||
      (recruitment.cashRewardAmount ?? 0) > 0 ||
      (recruitment.certificateName ?? '').trim().isNotEmpty;

  Widget _buildRewardsSection(recruitment) {
    final badges = <Widget>[];

    if ((recruitment.rewardCoin ?? 0) > 0) {
      badges.add(_rewardBadge(Icons.stars, const Color(0xFFF59E0B),
          '${recruitment.rewardCoin} Xu'));
    }
    if ((recruitment.youthUnionPoint ?? 0) > 0) {
      badges.add(_rewardBadge(Icons.badge, const Color(0xFF8B5CF6),
          '${recruitment.youthUnionPoint} Điểm Đoàn'));
    }
    if ((recruitment.cashRewardAmount ?? 0) > 0) {
      badges.add(_rewardBadge(Icons.attach_money, const Color(0xFF10B981),
          '${recruitment.cashRewardAmount} VNĐ'));
    }
    if ((recruitment.certificateName ?? '').trim().isNotEmpty) {
      badges.add(_rewardBadge(Icons.card_membership, const Color(0xFF06B6D4),
          recruitment.certificateName));
    }

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
                fontSize: 12, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(recruitment) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
          const Text(
            'Mô tả',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xff273143),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            recruitment.description ?? '',
            style: const TextStyle(
                fontSize: 13, color: Color(0xff64748B), height: 1.5),
          ),
        ],
      ),
    );
  }
}
