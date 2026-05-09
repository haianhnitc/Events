import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_staff_application_detail_controller.dart';
import 'package:events_app/feature/organizer/presentation/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrganizerStaffApplicationDetailPage extends StatefulWidget {
  final int applicationId;

  const OrganizerStaffApplicationDetailPage(
      {super.key, required this.applicationId});

  @override
  State<OrganizerStaffApplicationDetailPage> createState() =>
      _OrganizerStaffApplicationDetailPageState();
}

class _OrganizerStaffApplicationDetailPageState
    extends State<OrganizerStaffApplicationDetailPage> {
  late OrganizerStaffApplicationDetailController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.put(OrganizerStaffApplicationDetailController());
    _ctrl.loadApplication(widget.applicationId);
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
        title: const Text('Chi tiết đơn ứng tuyển',
            style: TextStyle(
                color: Color(0xff273143),
                fontSize: 17,
                fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (_ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final app = _ctrl.application.value;
        if (app == null) {
          return const Center(child: Text('Không tìm thấy đơn ứng tuyển'));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileCard(app),
              const SizedBox(height: 16),
              _buildAnswersSection(app),
              const SizedBox(height: 20),
              if (app.status == StaffApplicationStatus.pending)
                _buildActionButtons(),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileCard(app) {
    final applicant = app.applicant;
    final badge = app.status == StaffApplicationStatus.pending
        ? OrganizerStatusBadge.pending()
        : app.status == StaffApplicationStatus.approved
            ? OrganizerStatusBadge.approved()
            : OrganizerStatusBadge.rejected();

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
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: const Color(0xFFE0F2FE),
            backgroundImage: applicant?.avatarUrl != null
                ? NetworkImage(applicant!.avatarUrl!)
                : null,
            child: applicant?.avatarUrl == null
                ? Text(
                    (applicant?.fullName ?? '?')[0],
                    style: const TextStyle(
                        fontSize: 22,
                        color: Color(0xFF06B6D4),
                        fontWeight: FontWeight.w700),
                  )
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  applicant?.fullName ?? 'N/A',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff273143)),
                ),
                const SizedBox(height: 4),
                Text(
                  applicant?.email ?? '',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.event, size: 13, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      app.eventTitle ?? 'N/A',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    badge,
                    const SizedBox(width: 8),
                    if (app.appliedTime != null)
                      Text(
                        'Nộp: ${AppDateUtils.formatDate(app.appliedTime!)}',
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade500),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswersSection(app) {
    final answers = app.applicationAnswers ?? [];

    if (answers.isEmpty) {
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
        child: const Center(
          child: Text('Chưa có câu trả lời',
              style: TextStyle(color: Color(0xff94A3B8))),
        ),
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
          const Row(
            children: [
              Icon(Icons.quiz_outlined, size: 18, color: Color(0xFF8B5CF6)),
              SizedBox(width: 8),
              Text('Câu trả lời ứng tuyển',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff273143))),
            ],
          ),
          const SizedBox(height: 16),
          ...answers.asMap().entries.map((entry) {
            final index = entry.key;
            final answer = entry.value;
            return Column(
              children: [
                if (index > 0) const Divider(height: 20),
                _buildAnswerItem(
                  '${index + 1}',
                  answer.questionText ?? 'Câu hỏi',
                  answer.answerValue ?? '',
                  answer.questionType,
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAnswerItem(
      String num, String question, String answer, RequirementQuestionType? type) {
    IconData typeIcon;
    Color typeColor;

    switch (type) {
      case RequirementQuestionType.singleChoice:
        typeIcon = Icons.radio_button_checked;
        typeColor = const Color(0xFF8B5CF6);
        break;
      case RequirementQuestionType.multipleChoice:
        typeIcon = Icons.check_box;
        typeColor = const Color(0xFFF59E0B);
        break;
      default:
        typeIcon = Icons.short_text;
        typeColor = const Color(0xFF06B6D4);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFF06B6D4).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(num,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF06B6D4))),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(question,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff273143))),
            ),
            Icon(typeIcon, size: 16, color: typeColor),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.only(left: 32),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              const Icon(Icons.format_quote,
                  size: 14, color: Color(0xff94A3B8)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(answer,
                    style: const TextStyle(
                        fontSize: 13, color: Color(0xff475569))),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _ctrl.isActionLoading.value
                    ? null
                    : () => _ctrl.showApproveDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                icon: _ctrl.isActionLoading.value
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.check_circle_outline,
                        color: Colors.white, size: 18),
                label: Text(
                  _ctrl.isActionLoading.value ? 'Đang xử lý...' : 'Duyệt đơn',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
            )),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _ctrl.showRejectDialog(),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFEF4444),
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: Color(0xFFEF4444)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            icon: const Icon(Icons.cancel_outlined, size: 18),
            label: const Text('Từ chối đơn',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }
}
