import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/recruitment/domain/entity/question_option_entity.dart';
import 'package:events_app/feature/recruitment/domain/entity/requirement_question_entity.dart';
import 'package:events_app/feature/recruitment/presentation/controller/ctv_apply_sheet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CtvApplyBottomSheet extends StatefulWidget {
  const CtvApplyBottomSheet({
    super.key,
    required this.ctvRecruitmentId,
    this.eventId,
    this.position,
    this.onSubmitted,
  });

  final int ctvRecruitmentId;
  final int? eventId;
  final String? position;
  final VoidCallback? onSubmitted;

  @override
  State<CtvApplyBottomSheet> createState() => _CtvApplyBottomSheetState();
}

class _CtvApplyBottomSheetState extends State<CtvApplyBottomSheet> {
  late final CtvApplySheetController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CtvApplySheetController.attach(
      ctvRecruitmentId: widget.ctvRecruitmentId,
      eventId: widget.eventId,
    );
  }

  @override
  void dispose() {
    CtvApplySheetController.detach(
      ctvRecruitmentId: widget.ctvRecruitmentId,
      eventId: widget.eventId,
    );
    super.dispose();
  }

  Future<void> _submit() async {
    if (_controller.isSubmitting.value) return;

    final isSuccess = await _controller.submit();
    if (!isSuccess || !mounted) return;
    Navigator.of(context).pop();
    widget.onSubmitted?.call();
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.86;

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(maxHeight: maxHeight),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 38,
              height: 3,
              decoration: BoxDecoration(
                color: const Color(0xffD1D5DB),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text(
                    'Đơn ứng tuyển CTV',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff111827),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    splashRadius: 18,
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: Color(0xff6B7280),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.position == null || widget.position!.trim().isEmpty
                      ? 'Vui lòng trả lời các câu hỏi bên dưới.'
                      : 'Vị trí: ${widget.position}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff6B7280),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const Divider(height: 1, color: Color(0xffE5E7EB)),
            Expanded(
              child: Obx(() {
                if (_controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (_controller.questions.isEmpty) {
                  return const Center(
                    child: Text('Đợt tuyển dụng này chưa có câu hỏi.'),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  itemCount: _controller.questions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final question = _controller.questions[index];
                    return _buildQuestionCard(question, index + 1);
                  },
                );
              }),
            ),
            const Divider(height: 1, color: Color(0xffE5E7EB)),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: _controller.isSubmitting.value ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xffDB0025),
                      disabledBackgroundColor: const Color(0xff9CA3AF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _controller.isSubmitting.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Gửi đơn ứng tuyển',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(RequirementQuestionEntity question, int number) {
    final questionId = question.questionId;
    if (questionId == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffE5E7EB)),
        color: const Color(0xffF9FAFB),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xffE5E7EB)),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Câu $number',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xff6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (question.isRequired == true)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xffFEE2E2),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'Bắt buộc',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xff991B1B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            question.questionText ?? 'Câu hỏi',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xff111827),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
          if (question.questionType == RequirementQuestionType.text)
            TextField(
              controller: _controller.textControllerFor(questionId),
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Nhập câu trả lời của bạn',
                filled: true,
                fillColor: Colors.white,
                hintStyle: const TextStyle(color: Color(0xff6B7280)),
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
                isDense: true,
              ),
            ),
          if (question.questionType == RequirementQuestionType.singleChoice)
            ..._buildSingleChoiceOptions(
              questionId: questionId,
              options: question.options,
            ),
          if (question.questionType == RequirementQuestionType.rating)
            _buildRatingInput(questionId),
          if (question.questionType == RequirementQuestionType.multipleChoice)
            ..._buildMultiChoiceOptions(
              questionId: questionId,
              options: question.options,
            ),
        ],
      ),
    );
  }

  List<Widget> _buildSingleChoiceOptions({
    required int questionId,
    required List<QuestionOptionEntity>? options,
  }) {
    final items = <Widget>[];

    for (final option in options ?? const <QuestionOptionEntity>[]) {
      final optionId = option.optionId;
      if (optionId == null) continue;
      items.add(
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xffE5E7EB)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: RadioListTile<int>(
            dense: true,
            activeColor: const Color(0xffDB0025),
            contentPadding: const EdgeInsets.only(left: 4, right: 8),
            value: optionId,
            groupValue: _controller.singleChoiceValueFor(questionId),
            onChanged: (value) {
              if (value == null) return;
              _controller.updateSingleChoice(
                questionId: questionId,
                optionId: value,
              );
            },
            title: Text(
              option.optionValue ?? '',
              style: const TextStyle(
                color: Color(0xff111827),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      );
    }

    if (items.isEmpty) {
      items.add(
        const Text(
          'Không có lựa chọn cho câu hỏi này.',
          style: TextStyle(fontSize: 13, color: Color(0xff6B7280)),
        ),
      );
    }

    return items;
  }

  List<Widget> _buildMultiChoiceOptions({
    required int questionId,
    required List<QuestionOptionEntity>? options,
  }) {
    final items = <Widget>[];

    for (final option in options ?? const <QuestionOptionEntity>[]) {
      final optionId = option.optionId;
      if (optionId == null) continue;

      final selected = _controller.isMultiChoiceSelected(questionId, optionId);
      items.add(
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xffE5E7EB)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: CheckboxListTile(
            dense: true,
            activeColor: const Color(0xffDB0025),
            contentPadding: const EdgeInsets.only(left: 4, right: 8),
            value: selected,
            onChanged: (checked) {
              _controller.updateMultiChoice(
                questionId: questionId,
                optionId: optionId,
                checked: checked == true,
              );
            },
            title: Text(
              option.optionValue ?? '',
              style: const TextStyle(
                color: Color(0xff111827),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      );
    }

    if (items.isEmpty) {
      items.add(
        const Text(
          'Không có lựa chọn cho câu hỏi này.',
          style: TextStyle(fontSize: 13, color: Color(0xff6B7280)),
        ),
      );
    }

    return items;
  }

  Widget _buildRatingInput(int questionId) {
    const maxRating = 5;
    final currentRating = _controller.ratingValueFor(questionId);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(maxRating, (index) {
            final rating = index + 1;
            final isSelected = rating <= currentRating;

            return GestureDetector(
              onTap: () {
                _controller.updateRating(
                  questionId: questionId,
                  value: rating,
                );
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
        Text(
          currentRating > 0 ? '$currentRating / $maxRating' : 'Nhấn để đánh giá',
          style: TextStyle(
            fontSize: 13,
            color: currentRating > 0
                ? const Color(0xffF59E0B)
                : const Color(0xffB0B4C0),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
