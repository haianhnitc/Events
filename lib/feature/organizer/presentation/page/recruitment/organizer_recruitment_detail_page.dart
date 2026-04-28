import 'package:events_app/common/path/asset_path.dart';
import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/common/utils/app_image_utils.dart';
import 'package:events_app/feature/common/utils/app_map_utils.dart';
import 'package:events_app/feature/event_management/presentation/page/event_detail_page.dart';
import 'package:events_app/feature/recruitment/domain/entity/ctv_recruitment_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class OrganizerRecruitmentDetailPage extends StatelessWidget {
  final CtvRecruitmentEntity recruitment;

  const OrganizerRecruitmentDetailPage({super.key, required this.recruitment});

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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBanner(),
            const SizedBox(height: 16),
            _buildStatusBadge(),
            const SizedBox(height: 16),
            _buildInfoCard(context),
            const SizedBox(height: 16),
            if (_hasRewards) _buildRewardsSection(),
            const SizedBox(height: 16),
            if ((recruitment.description ?? '').isNotEmpty) _buildDescription(),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
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

  Widget _buildStatusBadge() {
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

  Widget _buildInfoCard(BuildContext context) {
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
          _infoRow(Icons.work_outline, 'Vị trí', recruitment.roleName ?? 'N/A'),
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
                        EventDetailPage(eventId: recruitment.eventId),
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

  Widget _infoRow(IconData icon, String label, String value,
      {Widget? trailing}) {
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

  bool get _hasRewards =>
      (recruitment.rewardCoin ?? 0) > 0 ||
      (recruitment.youthUnionPoint ?? 0) > 0 ||
      (recruitment.cashRewardAmount ?? 0) > 0 ||
      (recruitment.certificateName ?? '').trim().isNotEmpty;

  Widget _buildRewardsSection() {
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
          recruitment.certificateName!));
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

  Widget _buildDescription() {
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
