import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/common/utils/app_image_utils.dart';
import 'package:events_app/feature/recruitment/domain/entity/ctv_recruitment_entity.dart';
import 'package:events_app/feature/recruitment/domain/entity/requirement_question_entity.dart';
import 'package:events_app/feature/staff_application/presentation/controller/apply_ctv_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApplyCtvPage extends StatefulWidget {
  const ApplyCtvPage({super.key});

  @override
  State<ApplyCtvPage> createState() => _ApplyCtvPageState();
}

class _ApplyCtvPageState extends State<ApplyCtvPage> {
  final ApplyCtvController _controller = ApplyCtvController.ensureInstance();

  @override
  void initState() {
    super.initState();
    _controller.loadOpenRecruitments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6F9),
      appBar: AppBar(
        backgroundColor: const Color(0xffDB0025),
        elevation: 0,
        title: const Text(
          'Ứng tuyển Cộng tác viên',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => _controller.loadOpenRecruitments(),
          ),
        ],
      ),
      body: Obx(() {
        if (_controller.isLoading.value && _controller.recruitments.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xffDB0025)),
          );
        }
        final recruitments = _controller.recruitments;
        if (recruitments.isEmpty) {
          return _buildEmptyState();
        }
        return RefreshIndicator(
          onRefresh: () => _controller.loadOpenRecruitments(),
          color: const Color(0xffDB0025),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: recruitments.length,
            itemBuilder: (context, index) =>
                _buildRecruitmentCard(recruitments[index]),
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xffF0F0F0),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.work_outline,
                size: 40,
                color: Color(0xffB0B4C0),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Không có tin tuyển dụng',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Color(0xff273143),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Hiện tại không có vị trí CTV nào đang mở.\nHãy quay lại sau nhé!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff67688C),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecruitmentCard(CtvRecruitmentEntity recruitment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildRecruitmentHeader(recruitment),
          const Divider(height: 1, color: Color(0xffF0F0F0)),
          _buildRecruitmentBody(recruitment),
          _buildRecruitmentFooter(recruitment),
        ],
      ),
    );
  }

  Widget _buildRecruitmentHeader(CtvRecruitmentEntity recruitment) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: SizedBox(
            height: 140,
            width: double.infinity,
            child: AppImageUtils.buildNetworkImage(
              imageUrl: recruitment.banner,
              placeholder: AppImageUtils.buildImagePlaceholder(
                icon: Icons.work,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xffDB0025),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Tuyển CTV',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        if (recruitment.cashRewardAmount != null && recruitment.cashRewardAmount! > 0)
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xff00A63E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.monetization_on,
                    size: 14,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatPrice(recruitment.cashRewardAmount!),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.4),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecruitmentBody(CtvRecruitmentEntity recruitment) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recruitment.title ?? 'Vị trí CTV',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xff273143),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            recruitment.description ?? '',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xff67688C),
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildInfoChip(
                Icons.schedule,
                recruitment.startTime != null
                    ? AppDateUtils.formatDateOnly(recruitment.startTime)
                    : 'N/A',
              ),
              _buildInfoChip(
                Icons.badge,
                recruitment.roleName ?? 'CTV',
              ),
              if (recruitment.quantity != null)
                _buildInfoChip(
                  Icons.group,
                  '${recruitment.quantity} vị trí',
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xffDB0025).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: const Color(0xffDB0025),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xffDB0025),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecruitmentFooter(CtvRecruitmentEntity recruitment) {
    final state = recruitment.userEventState;
    final isRejected = state == UserEventState.ctvRejected;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: isRejected
          ? _buildReapplyButton(recruitment)
          : _buildApplyButton(recruitment),
    );
  }

  Widget _buildReapplyButton(CtvRecruitmentEntity recruitment) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _showApplicationSheet(recruitment),
        icon: const Icon(Icons.refresh, size: 18),
        label: const Text('Ứng tuyển lại'),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xffDB0025),
          side: const BorderSide(color: Color(0xffDB0025)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildAppliedButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xffDCFCE7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            size: 20,
            color: Color(0xff22C55E),
          ),
          SizedBox(width: 8),
          Text(
            'Đã ứng tuyển',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xff22C55E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplyButton(CtvRecruitmentEntity recruitment) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showApplicationSheet(recruitment),
        icon: const Icon(Icons.send, size: 18),
        label: const Text('Ứng tuyển ngay'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffDB0025),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  void _showApplicationSheet(CtvRecruitmentEntity recruitment) {
    _controller.selectRecruitment(recruitment);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ApplicationBottomSheet(
        recruitment: recruitment,
        controller: _controller,
      ),
    );
  }

  String _formatPrice(int price) {
    final str = price.toString();
    final result = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        result.write('.');
      }
      result.write(str[i]);
    }
    return result.toString();
  }
}

class _ApplicationBottomSheet extends StatefulWidget {
  const _ApplicationBottomSheet({
    required this.recruitment,
    required this.controller,
  });

  final CtvRecruitmentEntity recruitment;
  final ApplyCtvController controller;

  @override
  State<_ApplicationBottomSheet> createState() => _ApplicationBottomSheetState();
}

class _ApplicationBottomSheetState extends State<_ApplicationBottomSheet> {
  final TextEditingController _cvUrlController = TextEditingController();
  final Map<int, TextEditingController> _textControllers = {};
  final Map<int, int?> _singleChoiceSelections = {};
  final Map<int, Set<int>> _multipleChoiceSelections = {};
  final Map<int, int> _ratingSelections = {};

  @override
  void dispose() {
    _cvUrlController.dispose();
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(),
          _buildHeader(),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRecruitmentInfo(),
                  const SizedBox(height: 20),
                  _buildCvSection(),
                  const SizedBox(height: 20),
                  if (widget.controller.questions.isNotEmpty) ...[
                    _buildQuestionsSection(),
                    const SizedBox(height: 20),
                  ],
                ],
              ),
            ),
          ),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: const Color(0xffE5E7EB),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xffDB0025).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.work,
              color: Color(0xffDB0025),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Đơn ứng tuyển',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff273143),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Vui lòng điền đầy đủ thông tin',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xff67688C),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              widget.controller.clearSelection();
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close,
              color: Color(0xff67688C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecruitmentInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffDB0025).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xffDB0025).withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 56,
              height: 56,
              child: AppImageUtils.buildNetworkImage(
                imageUrl: widget.recruitment.banner,
                placeholder: AppImageUtils.buildImagePlaceholder(icon: Icons.work),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.recruitment.title ?? 'Vị trí CTV',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff273143),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.recruitment.roleName ?? 'CTV',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff67688C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCvSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.attach_file,
              size: 20,
              color: Color(0xffDB0025),
            ),
            SizedBox(width: 8),
            Text(
              'Link CV (không bắt buộc)',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xff273143),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _cvUrlController,
          decoration: InputDecoration(
            hintText: 'Nhập link CV của bạn...',
            hintStyle: const TextStyle(
              color: Color(0xffB0B4C0),
              fontSize: 14,
            ),
            filled: true,
            fillColor: const Color(0xffF8F9FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          onChanged: (value) {
            widget.controller.setCvUrl(value);
          },
        ),
      ],
    );
  }

  Widget _buildQuestionsSection() {
    final questions = widget.controller.questions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.quiz,
              size: 20,
              color: Color(0xffDB0025),
            ),
            SizedBox(width: 8),
            Text(
              'Câu hỏi ứng tuyển',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xff273143),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...questions.map((q) => _buildQuestionItem(q)),
      ],
    );
  }

  Widget _buildQuestionItem(RequirementQuestionEntity question) {
    final questionType = question.questionType;

    if (questionType == RequirementQuestionType.singleChoice) {
      return _buildSingleChoiceQuestion(question);
    } else if (questionType == RequirementQuestionType.multipleChoice) {
      return _buildMultipleChoiceQuestion(question);
    } else if (questionType == RequirementQuestionType.rating) {
      return _buildRatingQuestion(question);
    }

    _textControllers[question.questionId!] ??= TextEditingController();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xffE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionHeader(question),
          const SizedBox(height: 12),
          TextField(
            controller: _textControllers[question.questionId!],
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Nhập câu trả lời...',
              hintStyle: const TextStyle(
                color: Color(0xffB0B4C0),
                fontSize: 14,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xffE5E7EB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xffE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xffDB0025)),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
            onChanged: (value) {
              widget.controller.setTextAnswer(question.questionId!, value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionHeader(RequirementQuestionEntity question) {
    return Row(
      children: [
        Expanded(
          child: Text(
            question.questionText ?? '',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xff273143),
            ),
          ),
        ),
        if (question.isRequired == true)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xffEF4444).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'Bắt buộc',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Color(0xffEF4444),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSingleChoiceQuestion(RequirementQuestionEntity question) {
    final options = question.options ?? [];
    final selected = _singleChoiceSelections[question.questionId];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xffE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionHeader(question),
          const SizedBox(height: 12),
          ...options.map((option) {
            final isSelected = selected == option.optionId;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _singleChoiceSelections[question.questionId!] = option.optionId;
                });
                widget.controller.setSingleChoiceAnswer(
                  question.questionId!,
                  option.optionId!,
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xffDB0025).withValues(alpha: 0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xffDB0025)
                        : const Color(0xffE5E7EB),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? const Color(0xffDB0025)
                            : Colors.transparent,
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xffDB0025)
                              : const Color(0xffB0B4C0),
                          width: 1.5,
                        ),
                      ),
                      child: isSelected
                          ? const Center(
                              child: Icon(
                                Icons.check,
                                size: 12,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        option.optionValue ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: isSelected
                              ? const Color(0xffDB0025)
                              : const Color(0xff273143),
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMultipleChoiceQuestion(RequirementQuestionEntity question) {
    final options = question.options ?? [];
    final selected = _multipleChoiceSelections[question.questionId] ?? {};

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xffE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionHeader(question),
          const SizedBox(height: 12),
          ...options.map((option) {
            final isSelected = selected.contains(option.optionId);
            return GestureDetector(
              onTap: () {
                setState(() {
                  final current = _multipleChoiceSelections[question.questionId!] ?? {};
                  if (isSelected) {
                    current.remove(option.optionId);
                  } else {
                    current.add(option.optionId!);
                  }
                  _multipleChoiceSelections[question.questionId!] = current;
                });
                widget.controller.setMultipleChoiceAnswer(
                  question.questionId!,
                  selected.toList(),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xffDB0025).withValues(alpha: 0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xffDB0025)
                        : const Color(0xffE5E7EB),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: isSelected
                            ? const Color(0xffDB0025)
                            : Colors.transparent,
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xffDB0025)
                              : const Color(0xffB0B4C0),
                          width: 1.5,
                        ),
                      ),
                      child: isSelected
                          ? const Center(
                              child: Icon(
                                Icons.check,
                                size: 12,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        option.optionValue ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: isSelected
                              ? const Color(0xffDB0025)
                              : const Color(0xff273143),
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRatingQuestion(RequirementQuestionEntity question) {
    const maxRating = 5;
    final currentRating = _ratingSelections[question.questionId] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionHeader(question),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(maxRating, (index) {
              final rating = index + 1;
              final isSelected = rating <= currentRating;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _ratingSelections[question.questionId!] = rating;
                  });
                  widget.controller.ratingAnswers[question.questionId!] = rating;
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    isSelected ? Icons.star : Icons.star_border,
                    size: 40,
                    color: isSelected
                        ? const Color(0xffF59E0B)
                        : const Color(0xffD1D5DB),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              currentRating > 0 ? '$currentRating / $maxRating' : 'Nhấn để đánh giá',
              style: TextStyle(
                fontSize: 13,
                color: currentRating > 0
                    ? const Color(0xffF59E0B)
                    : const Color(0xffB0B4C0),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() {
      final canSubmit = widget.controller.canSubmit;
      final isSubmitting = widget.controller.isSubmitting.value;
      final hasApplied = widget.controller.hasApplied.value;

      if (hasApplied) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pop(context);
          widget.controller.clearSelection();
        });
      }

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: canSubmit && !isSubmitting
                ? () => widget.controller.submitApplication()
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: canSubmit
                  ? const Color(0xffDB0025)
                  : const Color(0xffB0B4C0),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: isSubmitting
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Gửi đơn ứng tuyển',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      );
    });
  }
}
