import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_event_list_controller.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_recruitment_list_controller.dart';
import 'package:events_app/feature/organizer/presentation/page/recruitment/organizer_recruitment_form_page.dart';
import 'package:events_app/feature/organizer/presentation/page/staff/organizer_staff_application_list_page.dart';
import 'package:events_app/feature/organizer/presentation/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrganizerRecruitmentListPage extends StatefulWidget {
  const OrganizerRecruitmentListPage({super.key});

  @override
  State<OrganizerRecruitmentListPage> createState() =>
      _OrganizerRecruitmentListPageState();
}

class _OrganizerRecruitmentListPageState
    extends State<OrganizerRecruitmentListPage> {
  final _searchController = TextEditingController();
  late OrganizerEventListController _eventCtrl;
  EventSummaryEntity? _selectedEvent;

  late OrganizerRecruitmentListController _ctrl;

  @override
  void initState() {
    super.initState();
    _eventCtrl = Get.find<OrganizerEventListController>();
    _ctrl = Get.put(OrganizerRecruitmentListController());
    _ctrl.loadRecruitments();
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Tuyển CTV',
          style: TextStyle(
              color: Color(0xff273143),
              fontSize: 17,
              fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
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
                        hint: Text('Tất cả sự kiện',
                            style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
                        isExpanded: true,
                        items: [
                          const DropdownMenuItem<EventSummaryEntity>(
                            value: null,
                            child: Text('Tất cả sự kiện'),
                          ),
                          ...events.map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.title ?? 'N/A',
                                    overflow: TextOverflow.ellipsis),
                              )),
                        ],
                        onChanged: (e) {
                          setState(() => _selectedEvent = e);
                          _ctrl.setEventFilter(e?.eventId);
                        },
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 12),
                OrganizerSearchField(
                  controller: _searchController,
                  hintText: 'Tìm kiếm bài tuyển dụng...',
                  onChanged: (v) {
                    _ctrl.searchQuery.value = v;
                    _ctrl.loadRecruitments(refresh: true);
                  },
                  onClear: () {
                    _searchController.clear();
                    _ctrl.searchQuery.value = '';
                    _ctrl.loadRecruitments(refresh: true);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (_ctrl.isLoading.value && _ctrl.recruitments.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              final items = _ctrl.recruitments;
              if (items.isEmpty) {
                return OrganizerEmptyState(
                  message: 'Chưa có bài tuyển dụng',
                  description: 'Tạo bài tuyển CTV để thu hút ứng viên',
                  icon: Icons.work_outline,
                  actionLabel: 'Tạo bài tuyển',
                  onAction: () => Get.to(() => const OrganizerRecruitmentFormPage()),
                );
              }
              return RefreshIndicator(
                onRefresh: _ctrl.refreshRecruitments,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _buildCard(item);
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const OrganizerRecruitmentFormPage()),
        backgroundColor: const Color(0xFF06B6D4),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCard(item) {
    final badge = item.isOpen == true
        ? OrganizerStatusBadge.open()
        : OrganizerStatusBadge.closed();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 8)
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            if (item.ctvRecruitmentId != null) {
              Get.to(() => OrganizerStaffApplicationListPage(
                  recruitmentId: item.ctvRecruitmentId));
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.work_outline,
                          size: 20, color: Color(0xFFF59E0B)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title ?? 'N/A',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff273143)),
                            maxLines: 2,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.event,
                                  size: 12, color: Colors.grey.shade600),
                              const SizedBox(width: 4),
                              Text(
                                item.eventTitle ?? 'N/A',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    badge,
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildMetaItem(
                        Icons.group_outlined, '${item.appliedCount ?? 0} ứng tuyển'),
                    const SizedBox(width: 16),
                    _buildMetaItem(
                        Icons.person_outline, '${item.quantity ?? 0} cần tuyển'),
                    const Spacer(),
                    if (item.startTime != null)
                      _buildMetaItem(Icons.schedule,
                          'Hạn: ${AppDateUtils.formatDate(item.startTime!)}'),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                        child: _buildActionBtn('Xem đơn', Icons.list_alt_outlined, () {
                      if (item.ctvRecruitmentId != null) {
                        Get.to(() => OrganizerStaffApplicationListPage(
                            recruitmentId: item.ctvRecruitmentId));
                      }
                    })),
                    const SizedBox(width: 8),
                    Expanded(
                        child: _buildActionBtn('Sửa', Icons.edit_outlined, () {
                      if (item.ctvRecruitmentId != null) {
                        Get.to(() => OrganizerRecruitmentFormPage(
                            recruitmentId: item.ctvRecruitmentId));
                      }
                    })),
                    const SizedBox(width: 8),
                    Expanded(
                      child:                     item.isOpen == true
                          ? _buildActionBtn(
                              'Đóng tuyển', Icons.stop_circle_outlined,
                              () => _showCloseRecruitmentDialog(item, item.ctvRecruitmentId!))
                          : _buildActionBtn('Mở lại', Icons.play_arrow, () {
                          if (item.ctvRecruitmentId != null) {
                            _ctrl.reopenRecruitment(item.ctvRecruitmentId!);
                          }
                        }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCloseRecruitmentDialog(item, int recruitmentId) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Xác nhận đóng tuyển'),
        content: Text(
          'Bạn có chắc muốn đóng tuyển CTV cho sự kiện "${item.eventTitle}" không? Sau khi đóng, người đăng ký sẽ không thể nộp đơn ứng tuyển CTV.',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
            child: const Text('Đóng tuyển', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      _ctrl.closeRecruitment(recruitmentId);
    }
  }

  Widget _buildMetaItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
      ],
    );
  }

  Widget _buildActionBtn(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: const Color(0xff64748B)),
            const SizedBox(width: 4),
            Text(label,
                style:
                    const TextStyle(fontSize: 12, color: Color(0xff64748B))),
          ],
        ),
      ),
    );
  }
}
