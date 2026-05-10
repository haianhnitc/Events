import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:flutter/material.dart';
import 'package:events_app/feature/organizer/recruitment/domain/usecase/organizer_recruitment_params.dart';

String _getReqTypeLabel(RequirementQuestionType? type) {
  switch (type) {
    case RequirementQuestionType.text:
      return 'TEXT';
    case RequirementQuestionType.singleChoice:
      return '1 CHỌN';
    case RequirementQuestionType.multipleChoice:
      return 'NHIỀU CHỌN';
    case RequirementQuestionType.rating:
      return 'ĐÁNH GIÁ';
    default:
      return 'TEXT';
  }
}

class RequirementQuestionCard extends StatelessWidget {
  final RequirementQuestionCreateParams question;
  final VoidCallback onRemove;
  final VoidCallback onEdit;

  const RequirementQuestionCard({
    super.key,
    required this.question,
    required this.onRemove,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF06B6D4).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _getReqTypeLabel(question.questionType),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF06B6D4),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (question.isRequired == true) ...[
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Bắt buộc',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              GestureDetector(
                onTap: onRemove,
                child: const Icon(Icons.delete_outline,
                    size: 16, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            question.questionText ?? '',
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xff273143),
              fontWeight: FontWeight.w500,
            ),
          ),
          if (question.options != null && question.options!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: question.options!
                  .map((o) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          o.optionValue ?? '',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xff64748B),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class RequirementQuestionSheet {
  static void show(
    BuildContext context, {
    RequirementQuestionCreateParams? existing,
    required void Function(RequirementQuestionCreateParams) onSave,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _RequirementQuestionSheetBody(
        existing: existing,
        onSave: onSave,
      ),
    );
  }
}

class _ReqTypeChip extends StatelessWidget {
  final RequirementQuestionType selected;
  final RequirementQuestionType type;
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ReqTypeChip({
    required this.selected,
    required this.type,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == type;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color:
                isSelected ? color.withOpacity(0.1) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? color : const Color(0xFFE2E8F0),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon,
                  size: 20,
                  color: isSelected ? color : const Color(0xFF94A3B8)),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? color : const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequirementQuestionSheetBody extends StatefulWidget {
  final RequirementQuestionCreateParams? existing;
  final void Function(RequirementQuestionCreateParams) onSave;

  const _RequirementQuestionSheetBody({
    this.existing,
    required this.onSave,
  });

  @override
  State<_RequirementQuestionSheetBody> createState() =>
      _RequirementQuestionSheetBodyState();
}

class _RequirementQuestionSheetBodyState
    extends State<_RequirementQuestionSheetBody> {
  late TextEditingController _contentCtrl;
  late RequirementQuestionType _selectedType;
  late bool _isRequired;
  late List<TextEditingController> _optionCtrls;

  @override
  void initState() {
    super.initState();
    _contentCtrl =
        TextEditingController(text: widget.existing?.questionText ?? '');
    _selectedType =
        widget.existing?.questionType ?? RequirementQuestionType.text;
    _isRequired = widget.existing?.isRequired ?? false;
    _optionCtrls = [];
    if (widget.existing?.options != null) {
      for (final o in widget.existing!.options!) {
        _optionCtrls.add(TextEditingController(text: o.optionValue ?? ''));
      }
    }
    if (_optionCtrls.isEmpty) {
      _optionCtrls = [TextEditingController(), TextEditingController()];
    }
  }

  @override
  void dispose() {
    _contentCtrl.dispose();
    for (final c in _optionCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  void _addOption() {
    setState(() => _optionCtrls.add(TextEditingController()));
  }

  void _removeOption(int i) {
    setState(() {
      _optionCtrls[i].dispose();
      _optionCtrls.removeAt(i);
    });
  }

  void _save() {
    if (_contentCtrl.text.trim().isEmpty) return;
    final needsOptions =
        _selectedType == RequirementQuestionType.singleChoice ||
            _selectedType == RequirementQuestionType.multipleChoice;
    final options = needsOptions
        ? _optionCtrls
            .where((c) => c.text.trim().isNotEmpty)
            .map((c) => QuestionOptionCreateParams(optionValue: c.text.trim()))
            .toList()
        : null;

    widget.onSave(RequirementQuestionCreateParams(
      questionText: _contentCtrl.text.trim(),
      questionType: _selectedType,
      isRequired: _isRequired,
      options: options,
    ));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final isEditing = widget.existing != null;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 8, 20, bottomPadding + 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF06B6D4).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.quiz_outlined,
                        color: Color(0xFF06B6D4), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isEditing ? 'Sửa câu hỏi' : 'Thêm câu hỏi',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff1E293B),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.close,
                          size: 18, color: Color(0xFF64748B)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _contentCtrl,
                decoration: InputDecoration(
                  labelText: 'Nội dung câu hỏi',
                  hintText: 'VD: Bạn có kinh nghiệm tham gia sự kiện?',
                  labelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff475569),
                  ),
                  hintStyle:
                      TextStyle(fontSize: 13, color: Colors.grey.shade400),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF06B6D4), width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.all(14),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              const Text(
                'Loại câu hỏi',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Color(0xff475569),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _ReqTypeChip(
                    selected: _selectedType,
                    type: RequirementQuestionType.text,
                    label: 'Text',
                    icon: Icons.text_fields_rounded,
                    color: const Color(0xFF64748B),
                    onTap: () => setState(
                        () => _selectedType = RequirementQuestionType.text),
                  ),
                  const SizedBox(width: 8),
                  _ReqTypeChip(
                    selected: _selectedType,
                    type: RequirementQuestionType.rating,
                    label: 'Rating',
                    icon: Icons.star_rounded,
                    color: const Color(0xFFF59E0B),
                    onTap: () => setState(
                        () => _selectedType = RequirementQuestionType.rating),
                  ),
                  const SizedBox(width: 8),
                  _ReqTypeChip(
                    selected: _selectedType,
                    type: RequirementQuestionType.singleChoice,
                    label: '1 chọn',
                    icon: Icons.radio_button_checked_rounded,
                    color: const Color(0xFF10B981),
                    onTap: () => setState(() =>
                        _selectedType = RequirementQuestionType.singleChoice),
                  ),
                  const SizedBox(width: 8),
                  _ReqTypeChip(
                    selected: _selectedType,
                    type: RequirementQuestionType.multipleChoice,
                    label: 'Nhiều',
                    icon: Icons.check_box_rounded,
                    color: const Color(0xFF8B5CF6),
                    onTap: () => setState(() =>
                        _selectedType = RequirementQuestionType.multipleChoice),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_selectedType != RequirementQuestionType.text &&
                  _selectedType != RequirementQuestionType.rating) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Tùy chọn',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Color(0xff475569),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${_optionCtrls.length}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: _addOption,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF06B6D4).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, size: 14, color: Color(0xFF06B6D4)),
                            SizedBox(width: 2),
                            Text(
                              'Thêm',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF06B6D4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...List.generate(_optionCtrls.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Center(
                            child: Text(
                              '${i + 1}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _optionCtrls[i],
                            decoration: InputDecoration(
                              hintText: 'Tùy chọn ${i + 1}',
                              hintStyle: TextStyle(
                                  fontSize: 13, color: Colors.grey.shade400),
                              filled: true,
                              fillColor: const Color(0xFFF8FAFC),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Color(0xFF06B6D4), width: 1.5),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                            ),
                          ),
                        ),
                        if (_optionCtrls.length > 2) ...[
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () => _removeOption(i),
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(Icons.close,
                                  size: 16, color: Colors.red.shade400),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 8),
              ],
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Bắt buộc trả lời',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff1E293B),
                              ),
                            ),
                            Text(
                              'Người ứng tuyển phải trả lời câu hỏi này',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Switch(
                      value: _isRequired,
                      onChanged: (v) => setState(() => _isRequired = v),
                      activeThumbColor: const Color(0xFF06B6D4),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Hủy',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF06B6D4),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        isEditing ? 'Lưu câu hỏi' : 'Thêm câu hỏi',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
