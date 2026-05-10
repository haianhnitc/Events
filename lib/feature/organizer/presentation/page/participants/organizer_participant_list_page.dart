import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_participant_list_controller.dart';
import 'package:events_app/feature/organizer/presentation/page/participants/organizer_participant_detail_page.dart';
import 'package:events_app/feature/organizer/presentation/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrganizerParticipantListPage extends StatefulWidget {
  final int eventId;
  final EventRecruitmentType? recruitmentType;
  final String? eventTitle;

  const OrganizerParticipantListPage({
    super.key,
    required this.eventId,
    this.recruitmentType,
    this.eventTitle,
  });

  @override
  State<OrganizerParticipantListPage> createState() =>
      _OrganizerParticipantListPageState();
}

class _OrganizerParticipantListPageState
    extends State<OrganizerParticipantListPage> {
  final _searchController = TextEditingController();

  late OrganizerParticipantListController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.put(OrganizerParticipantListController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ctrl.setEventFilter(widget.eventId);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: OrganizerAppBar(
        title: 'Người tham gia',
        subtitle: widget.eventTitle,
        actions: [
          IconButton(
            icon:
                const Icon(Icons.person_add_outlined, color: Color(0xff64748B)),
            tooltip: 'Thêm người tham gia',
            onPressed: () async {
              final recruitmentType = widget.recruitmentType;
              if (recruitmentType == null) {
                AppSnackbarUtils.showError(
                    'Lỗi', 'Không xác định được loại tuyển dụng của sự kiện');
                return;
              }
              final result = await showOrganizerInviteDialog(
                eventId: widget.eventId,
                recruitmentType: recruitmentType,
                eventTitle: widget.eventTitle ?? '',
              );
              if (result == true) {
                _ctrl.refreshParticipants();
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
              children: [
                OrganizerSearchField(
                  controller: _searchController,
                  hintText: 'Tìm kiếm theo tên, email, SĐT...',
                  onChanged: (v) => setState(() {}),
                  onClear: () => setState(() {}),
                ),
                const SizedBox(height: 12),
                Obx(() => _buildFilterChips()),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Obx(() => _buildStatsBar()),
          Expanded(child: _buildParticipantList()),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('Tất cả', _ctrl.filterType.value == null,
              () => _ctrl.setTypeFilter(null)),
          const SizedBox(width: 8),
          _buildFilterChip(
              'Người tham dự',
              _ctrl.filterType.value == 'ATTENDEE',
              () => _ctrl.setTypeFilter('ATTENDEE')),
          const SizedBox(width: 8),
          _buildFilterChip('CTV', _ctrl.filterType.value == 'CTV',
              () => _ctrl.setTypeFilter('CTV')),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF06B6D4) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xff64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsBar() {
    final total = _ctrl.participants.length;
    final checkedIn = _ctrl.checkedInCount;
    final absent = total - checkedIn;
    return OrganizerStatBar(
      variant: OrganizerStatBarVariant.card,
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
          value: '$absent',
          label: 'Vắng',
          color: const Color(0xFFEF4444),
          icon: Icons.warning_amber,
        ),
      ],
    );
  }

  Widget _buildParticipantList() {
    return Obx(() {
      if (_ctrl.isLoading.value && _ctrl.participants.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xff06B6D4)),
        );
      }
      return _buildParticipantListContent();
    });
  }

  Widget _buildParticipantListContent() {
    final participants = _ctrl.participants;
    if (participants.isEmpty) {
      return const OrganizerEmptyState(
        message: 'Chưa có người tham gia',
        description: 'Chưa có ai đăng ký sự kiện này',
        icon: Icons.people_outline,
      );
    }
    return RefreshIndicator(
      onRefresh: _ctrl.refreshParticipants,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: participants.length,
        itemBuilder: (context, index) {
          final p = participants[index];
          return _buildParticipantCard(p);
        },
      ),
    );
  }

  Widget _buildParticipantCard(p) {
    final statusColor = p.hasCheckedIn == true
        ? const Color(0xFF10B981)
        : const Color(0xFFF59E0B);
    final statusLabel =
        p.hasCheckedIn == true ? 'Đã check-in' : 'Chưa check-in';
    final isCtv = p.participantType == ParticipantType.ctv;

    return Dismissible(
      key: Key('participant_${p.eventParticipantId}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        return await showOrganizerDeleteDialog(
              context: context,
              title: 'Xóa người tham gia',
              message:
                  'Bạn có chắc muốn xóa ${p.user?.fullName ?? 'người này'} khỏi sự kiện? Hành động này không thể hoàn tác.',
              confirmLabel: 'Xóa',
            ) ??
            false;
      },
      onDismissed: (_) {
        if (p.eventParticipantId != null) {
          _ctrl.deleteParticipant(p.eventParticipantId!);
        }
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
                color: Color(0x14000000), offset: Offset(0, 2), blurRadius: 6)
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              if (p.eventParticipantId != null) {
                Get.to(() => OrganizerParticipantDetailPage(
                    participantId: p.eventParticipantId!));
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: const Color(0xFFE0F2FE),
                    backgroundImage: p.user?.avatarUrl != null
                        ? NetworkImage(p.user!.avatarUrl!)
                        : null,
                    child: p.user?.avatarUrl == null
                        ? Text(
                            (p.user?.fullName ?? '?')[0],
                            style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF06B6D4),
                                fontWeight: FontWeight.w600),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
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
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.calendar_today,
                                size: 12, color: Colors.grey.shade500),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                  p.user?.joinedAt != null
                                      ? AppDateUtils.formatDate(
                                          p.user!.joinedAt!)
                                      : '',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade600),
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isCtv
                              ? const Color(0xFF8B5CF6).withValues(alpha: 0.1)
                              : const Color(0xFF06B6D4).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
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
                      const SizedBox(height: 6),
                      Text(statusLabel,
                          style: TextStyle(
                              fontSize: 11,
                              color: statusColor,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
