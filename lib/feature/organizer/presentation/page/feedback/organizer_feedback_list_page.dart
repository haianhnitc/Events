import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/feedback/domain/entity/feedback_entity.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_feedback_list_controller.dart';
import 'package:events_app/feature/organizer/presentation/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrganizerFeedbackListPage extends StatefulWidget {
  final int eventId;
  final String? eventTitle;

  const OrganizerFeedbackListPage({
    super.key,
    required this.eventId,
    this.eventTitle,
  });

  @override
  State<OrganizerFeedbackListPage> createState() =>
      _OrganizerFeedbackListPageState();
}

class _OrganizerFeedbackListPageState extends State<OrganizerFeedbackListPage> {
  late OrganizerFeedbackListController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.put(OrganizerFeedbackListController());
    _ctrl.setEventFilter(widget.eventId);
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
        title: Text(
          widget.eventTitle ?? 'Phản hồi',
          style: const TextStyle(
              color: Color(0xff273143),
              fontSize: 17,
              fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Obx(() => _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_ctrl.isLoading.value && _ctrl.feedbacks.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _ctrl.refresh,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildSummaryCard(),
          ),
          SliverToBoxAdapter(
            child: _buildQuestionsOverview(),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  const Text(
                    'Danh sách phản hồi',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff273143),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_ctrl.totalFeedbacks}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFF59E0B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_ctrl.feedbacks.isEmpty)
            SliverFillRemaining(
              child: OrganizerEmptyState(
                message: 'Chưa có phản hồi',
                description: 'Người tham gia chưa gửi đánh giá nào',
                icon: Icons.feedback_outlined,
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= _ctrl.feedbacks.length) return null;
                  final fb = _ctrl.feedbacks[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildFeedbackCard(fb),
                  );
                },
                childCount: _ctrl.feedbacks.length,
              ),
            ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final avg = _ctrl.averageRating;
    final total = _ctrl.totalFeedbacks;
    final questions = _ctrl.questions;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF59E0B).withOpacity(0.3),
            offset: const Offset(0, 8),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.star_rate, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.eventTitle ?? 'Phản hồi sự kiện',
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildSummaryItem(
                avg != null ? avg.toStringAsFixed(1) : 'N/A',
                'Điểm TB',
                Icons.star,
              ),
              _buildSummaryItem('$total', 'Phản hồi', Icons.chat_bubble),
              _buildSummaryItem(
                '${questions.length}',
                'Câu hỏi',
                Icons.help_outline,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white.withOpacity(0.8), size: 18),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white)),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                    fontSize: 10, color: Colors.white.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionsOverview() {
    final questions = _ctrl.questions;
    if (questions.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
              Icon(Icons.quiz_outlined, size: 18, color: Color(0xFFF59E0B)),
              SizedBox(width: 8),
              Text(
                'Câu hỏi đã thiết lập',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff273143),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...questions.asMap().entries.map((entry) {
            final index = entry.key;
            final q = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildQuestionItem(index + 1, q),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildQuestionItem(int index, FeedbackQuestionEntity q) {
    final typeLabel = _getQuestionTypeLabel(q.questionType);
    final dist = _ctrl.answerDistribution;
    final qDist = q.feedbackQuestionId != null
        ? dist[q.feedbackQuestionId] ?? {}
        : <String, int>{};

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: Color(0xFFF59E0B),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  q.questionContent ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff273143),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  typeLabel,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFFF59E0B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (q.questionType == FeedbackQuestionType.rating &&
              qDist.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildRatingDistribution(qDist),
          ],
          if (q.questionType == FeedbackQuestionType.singleChoice &&
              qDist.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildChoiceDistribution(qDist),
          ],
        ],
      ),
    );
  }

  Widget _buildRatingDistribution(Map<String, int> dist) {
    final maxVal = dist.values.fold<int>(0, (max, v) => v > max ? v : max);
    final entries = dist.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));

    return Column(
      children: entries.map((e) {
        final fraction = maxVal > 0 ? e.value / maxVal : 0.0;
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              SizedBox(
                width: 20,
                child: Text(
                  e.key,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFF59E0B)),
                ),
              ),
              const Icon(Icons.star, size: 10, color: Color(0xFFF59E0B)),
              const SizedBox(width: 6),
              Expanded(
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: fraction.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              SizedBox(
                width: 24,
                child: Text(
                  '${e.value}',
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff64748B)),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChoiceDistribution(Map<String, int> dist) {
    final maxVal = dist.values.fold<int>(0, (max, v) => v > max ? v : max);
    final entries = dist.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: entries.take(5).map((e) {
        final fraction = maxVal > 0 ? e.value / maxVal : 0.0;
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  e.key,
                  style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xff475569)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: fraction.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              SizedBox(
                width: 24,
                child: Text(
                  '${e.value}',
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff64748B)),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFeedbackCard(FeedbackEntity fb) {
    final participant = fb.eventParticipant;
    final user = participant?.user;
    final name = user?.fullName ?? 'N/A';
    final email = user?.email ?? '';
    final answers = fb.feedbackAnswers ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F000000), offset: Offset(0, 1), blurRadius: 4)
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: const Color(0xFFE0F2FE),
          child: Text(
            name[0],
            style: const TextStyle(fontSize: 14, color: Color(0xFF06B6D4)),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xff273143)),
        ),
        subtitle: Text(
          email,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
        trailing: fb.createdTime != null
            ? Text(
                AppDateUtils.formatDate(fb.createdTime!),
                style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
              )
            : null,
        children: [
          if (answers.isNotEmpty) ...[
            const Divider(height: 16),
            ...answers.map((a) => _buildAnswerItem(a)),
          ],
          if (fb.comment != null && fb.comment!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withOpacity(0.06),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: const Color(0xFFF59E0B).withOpacity(0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.format_quote,
                      size: 14, color: Color(0xFFF59E0B)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      fb.comment!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xff475569),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAnswerItem(FeedbackAnswerEntity a) {
    final questionText = a.questionText ?? 'Câu hỏi';
    final answerValue = a.answerValue ?? '-';

    if (a.questionType == FeedbackQuestionType.rating) {
      final rating = int.tryParse(answerValue) ?? 0;
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.help_outline,
                size: 14, color: Color(0xff94A3B8)),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    questionText,
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: List.generate(5, (i) {
                      return Icon(
                        i < rating ? Icons.star : Icons.star_border,
                        size: 14,
                        color: const Color(0xFFF59E0B),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.help_outline,
              size: 14, color: Color(0xff94A3B8)),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  questionText,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 2),
                Text(
                  answerValue,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff273143),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getQuestionTypeLabel(FeedbackQuestionType? type) {
    switch (type) {
      case FeedbackQuestionType.text:
        return 'Text';
      case FeedbackQuestionType.rating:
        return 'Rating';
      case FeedbackQuestionType.singleChoice:
        return '1 chọn';
      case FeedbackQuestionType.multipleChoice:
        return 'Nhiều chọn';
      default:
        return 'N/A';
    }
  }
}
