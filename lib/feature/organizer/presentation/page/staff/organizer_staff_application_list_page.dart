import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_staff_application_list_controller.dart';
import 'package:events_app/feature/organizer/presentation/page/staff/organizer_staff_application_detail_page.dart';
import 'package:events_app/feature/organizer/presentation/page/staff/organizer_staff_answer_summary_page.dart';
import 'package:events_app/feature/organizer/presentation/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrganizerStaffApplicationListPage extends StatefulWidget {
  final int? recruitmentId;

  const OrganizerStaffApplicationListPage({super.key, this.recruitmentId});

  @override
  State<OrganizerStaffApplicationListPage> createState() =>
      _OrganizerStaffApplicationListPageState();
}

class _OrganizerStaffApplicationListPageState
    extends State<OrganizerStaffApplicationListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  late OrganizerStaffApplicationListController _ctrl;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _ctrl = Get.put(OrganizerStaffApplicationListController());
    if (widget.recruitmentId != null) {
      _ctrl.setEventFilter(widget.recruitmentId);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff64748B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Đơn ứng tuyển CTV',
          style: TextStyle(
              color: Color(0xff273143),
              fontSize: 17,
              fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          if (widget.recruitmentId != null)
            IconButton(
              icon: const Icon(Icons.summarize_outlined,
                  color: Color(0xff64748B)),
              onPressed: () {
                Get.to(() => OrganizerStaffAnswerSummaryPage(
                    recruitmentId: widget.recruitmentId!));
              },
              tooltip: 'Tổng hợp câu trả lời',
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: const Color(0xFF06B6D4),
          unselectedLabelColor: Colors.grey.shade600,
          indicatorColor: const Color(0xFF06B6D4),
          labelStyle:
              const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          tabs: [
            Obx(() => Tab(text: 'Tất cả (${_ctrl.applications.length})')),
            Obx(() => Tab(text: 'Chờ duyệt (${_ctrl.pendingCount})')),
            Obx(() => Tab(text: 'Đã duyệt (${_ctrl.approvedCount})')),
            Obx(() => Tab(text: 'Từ chối (${_ctrl.rejectedCount})')),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: OrganizerSearchField(
              controller: _searchController,
              hintText: 'Tìm kiếm ứng viên...',
              onChanged: (v) {
                _ctrl.searchQuery.value = v;
                _ctrl.loadApplications(refresh: true);
              },
              onClear: () {
                _searchController.clear();
                _ctrl.searchQuery.value = '';
                _ctrl.loadApplications(refresh: true);
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildApplicationList(null),
                _buildApplicationList(StaffApplicationStatus.pending),
                _buildApplicationList(StaffApplicationStatus.approved),
                _buildApplicationList(StaffApplicationStatus.rejected),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationList(StaffApplicationStatus? status) {
    return Obx(() {
      if (_ctrl.isLoading.value && _ctrl.applications.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      var filtered = _ctrl.applications.toList();
      if (status != null) {
        filtered = filtered.where((a) => a.status == status).toList();
      }
      if (_searchController.text.isNotEmpty) {
        final q = _searchController.text.toLowerCase();
        filtered = filtered.where((a) {
          final name = a.applicant?.fullName?.toLowerCase() ?? '';
          final email = a.applicant?.email?.toLowerCase() ?? '';
          return name.contains(q) || email.contains(q);
        }).toList();
      }
      if (filtered.isEmpty) {
        return OrganizerEmptyState(
          message: 'Không có đơn ứng tuyển',
          icon: Icons.assignment_outlined,
        );
      }
      return RefreshIndicator(
        onRefresh: _ctrl.refreshApplications,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final app = filtered[index];
            return _buildApplicationCard(app);
          },
        ),
      );
    });
  }

  Widget _buildApplicationCard(app) {
    final badge = app.status == StaffApplicationStatus.pending
        ? OrganizerStatusBadge.pending()
        : app.status == StaffApplicationStatus.approved
            ? OrganizerStatusBadge.approved()
            : OrganizerStatusBadge.rejected();

    final event = app.eventTitle ?? 'N/A';
    final submittedAt = app.appliedTime != null
        ? AppDateUtils.formatDate(app.appliedTime!)
        : 'N/A';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 6)
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            if (app.applicationId != null) {
              Get.to(() => OrganizerStaffApplicationDetailPage(
                  applicationId: app.applicationId!));
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFFE0F2FE),
                  backgroundImage: app.applicant?.avatarUrl != null
                      ? NetworkImage(app.applicant!.avatarUrl!)
                      : null,
                  child: app.applicant?.avatarUrl == null
                      ? Text(
                          (app.applicant?.fullName ?? '?')[0],
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
                        app.applicant?.fullName ?? 'N/A',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff273143)),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(Icons.event,
                              size: 12, color: Colors.grey.shade600),
                          Flexible(
                            child: Text(event,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey.shade600),
                                overflow: TextOverflow.ellipsis),
                          ),
                          const SizedBox(width: 6),
                          Icon(Icons.schedule,
                              size: 12, color: Colors.grey.shade600),
                          Text(submittedAt,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade600)),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    badge,
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
