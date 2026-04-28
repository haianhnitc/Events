import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_staff_application_list_controller.dart';
import 'package:events_app/feature/staff_application/domain/entity/staff_application_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrganizerStaffAnswerSummaryPage extends StatefulWidget {
  final int recruitmentId;

  const OrganizerStaffAnswerSummaryPage(
      {super.key, required this.recruitmentId});

  @override
  State<OrganizerStaffAnswerSummaryPage> createState() =>
      _OrganizerStaffAnswerSummaryPageState();
}

class _OrganizerStaffAnswerSummaryPageState
    extends State<OrganizerStaffAnswerSummaryPage> {
  late OrganizerStaffApplicationListController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.put(OrganizerStaffApplicationListController());
    _ctrl.setEventFilter(widget.recruitmentId);
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
        title: const Text('Tổng hợp câu trả lời',
            style: TextStyle(
                color: Color(0xff273143),
                fontSize: 17,
                fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (_ctrl.isLoading.value && _ctrl.applications.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final approved = _ctrl.applications
            .where((a) => a.status == StaffApplicationStatus.approved)
            .length;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryHeader(approved),
              const SizedBox(height: 16),
              ..._buildQuestionSummaries(),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSummaryHeader(int approvedCount) {
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF06B6D4).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                const Icon(Icons.summarize, size: 24, color: Color(0xFF06B6D4)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Text(
                      'Bai tuyen CTV',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff273143)),
                    )),
                const SizedBox(height: 4),
                Obx(() => Text(
                      '${_ctrl.applications.length} don ung tuyen',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    )),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$approvedCount da duyet',
              style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF10B981),
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildQuestionSummaries() {
    final apps = _ctrl.applications
        .where((a) =>
            a.applicationAnswers != null && a.applicationAnswers!.isNotEmpty)
        .toList();

    if (apps.isEmpty) {
      return [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Center(
            child: Text('Chua co cau tra loi nao',
                style: TextStyle(color: Color(0xff94A3B8))),
          ),
        ),
      ];
    }

    final allAnswers = apps.expand((a) => a.applicationAnswers!).toList();
    final questionMap = <int?, List<ApplicationAnswerEntity>>{};
    for (final answer in allAnswers) {
      questionMap.putIfAbsent(answer.questionId, () => []).add(answer);
    }

    return questionMap.entries.map((entry) {
      final answers = entry.value;
      final firstAnswer = answers.first;
      final questionType = firstAnswer.questionType;

      if (questionType == RequirementQuestionType.singleChoice ||
          questionType == RequirementQuestionType.multipleChoice) {
        return _buildChoiceSummary(
            firstAnswer.questionText ?? 'Cau hoi', answers);
      } else {
        return _buildTextSummary(
            firstAnswer.questionText ?? 'Cau hoi', answers, apps);
      }
    }).toList();
  }

  Widget _buildTextSummary(
      String question,
      List<ApplicationAnswerEntity> answers,
      List<StaffApplicationEntity> apps) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          Row(
            children: [
              const Icon(Icons.help_outline,
                  size: 18, color: Color(0xFF06B6D4)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(question,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff273143))),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF06B6D4).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('TEXT',
                    style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF06B6D4),
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...answers.take(10).map((answer) {
            final app = apps.firstWhere(
              (a) => a.applicationAnswers?.contains(answer) == true,
              orElse: () => apps.first,
            );
            return _buildAnswerRow(
                app.applicant?.fullName ?? 'N/A', answer.answerValue ?? '');
          }),
        ],
      ),
    );
  }

  Widget _buildChoiceSummary(
      String question, List<ApplicationAnswerEntity> answers) {
    final total = answers.length;
    final choiceCount = <String, int>{};
    for (final answer in answers) {
      final value = answer.answerValue ?? 'Khác';
      choiceCount[value] = (choiceCount[value] ?? 0) + 1;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          Row(
            children: [
              const Icon(Icons.pie_chart_outline,
                  size: 18, color: Color(0xFF8B5CF6)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(question,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff273143))),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...choiceCount.entries.map((e) {
            final percent =
                total > 0 ? (e.value / total * 100).toStringAsFixed(0) : '0';
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(e.key,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700)),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 100,
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: total > 0 ? e.value / total : 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B5CF6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 40,
                    child: Text('$percent%',
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff273143))),
                  ),
                  SizedBox(
                    width: 30,
                    child: Text('(${e.value})',
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade500)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAnswerRow(String name, String answer) {
    if (answer.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: const Color(0xFFE0F2FE),
              child: Text(name[0],
                  style:
                      const TextStyle(fontSize: 10, color: Color(0xFF06B6D4))),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                  Text(answer,
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
