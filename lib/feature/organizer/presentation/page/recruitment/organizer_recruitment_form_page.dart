import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/common/presentation/widget/avatar_upload_widget.dart';
import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/organizer/recruitment/domain/usecase/organizer_recruitment_params.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_event_list_controller.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_recruitment_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrganizerRecruitmentFormPage extends StatefulWidget {
  final int? eventId;
  final int? recruitmentId;

  const OrganizerRecruitmentFormPage({super.key, this.eventId, this.recruitmentId});

  @override
  State<OrganizerRecruitmentFormPage> createState() =>
      _OrganizerRecruitmentFormPageState();
}

class _OrganizerRecruitmentFormPageState
    extends State<OrganizerRecruitmentFormPage> {
  late OrganizerRecruitmentFormController _formCtrl;
  late OrganizerEventListController _eventCtrl;

  EventSummaryEntity? _selectedEvent;

  @override
  void initState() {
    super.initState();
    _formCtrl = Get.put(OrganizerRecruitmentFormController());
    _eventCtrl = Get.put(OrganizerEventListController());
    _formCtrl.initForCreate();
    _eventCtrl.loadEvents(reset: true);

    if (widget.recruitmentId != null) {
      _formCtrl.loadRecruitment(widget.recruitmentId!);
    } else if (widget.eventId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final event = _eventCtrl.events.firstWhereOrNull(
            (e) => e.eventId == widget.eventId);
        if (event != null) {
          setState(() => _selectedEvent = event);
        }
      });
    }

    ever(_formCtrl.editingRecruitment, (r) {
      if (r != null && r.eventId != null) {
        final event = _eventCtrl.events.firstWhereOrNull(
            (e) => e.eventId == r.eventId);
        if (event != null) {
          setState(() => _selectedEvent = event);
        } else {
          setState(() => _selectedEvent = EventSummaryEntity(
            eventId: r.eventId,
            title: r.eventTitle,
          ));
        }
      }
    });
  }

  @override
  void dispose() {
    Get.delete<OrganizerRecruitmentFormController>();
    Get.delete<OrganizerEventListController>();
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
        title: Obx(() => Text(
              _formCtrl.isEditMode ? 'Chỉnh sửa tuyển CTV' : 'Tạo bài tuyển CTV',
              style: const TextStyle(
                  color: Color(0xff273143),
                  fontSize: 17,
                  fontWeight: FontWeight.w700))),
        centerTitle: true,
      ),
      body: Obx(() {
        if (_formCtrl.isLoading.value && !_formCtrl.isEditMode) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEventSection(),
              const SizedBox(height: 16),
              _buildBannerSection(),
              const SizedBox(height: 16),
              _buildBasicSection(),
              const SizedBox(height: 16),
              _buildTimeSection(),
              const SizedBox(height: 16),
              _buildRewardSection(),
              const SizedBox(height: 16),
              _buildCategorySection(),
              const SizedBox(height: 16),
              _buildQuestionSection(),
              const SizedBox(height: 20),
              _buildPublishButton(),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildEventSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sự kiện liên kết',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff273143))),
          const SizedBox(height: 12),
          Obx(() {
            final events = _eventCtrl.events;
            if (_eventCtrl.isLoading.value && events.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
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
                  hint: Text('Chọn sự kiện',
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
                  isExpanded: true,
                  items: events
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.title ?? 'N/A',
                                overflow: TextOverflow.ellipsis),
                          ))
                      .toList(),
                  onChanged: (e) => setState(() => _selectedEvent = e),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBannerSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Hình ảnh bài tuyển dụng',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff273143))),
          const SizedBox(height: 12),
          Obx(() => BannerUploadWidget(
                previewUrl: _formCtrl.bannerPreviewUrl.value,
                fileType: FileType.recruitmentBanner,
                height: 140,
                onSuccess: (fileId, url) => _formCtrl.onBannerUploaded(fileId, url),
                onRemove: () {
                  _formCtrl.bannerFileId.value = null;
                  _formCtrl.bannerPreviewUrl.value = null;
                },
              )),
        ],
      ),
    );
  }

  Widget _buildBasicSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Thông tin cơ bản',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff273143))),
          const SizedBox(height: 14),
          _buildTextField(
            controller: _formCtrl.titleController,
            label: 'Tiêu đề bài tuyển',
            hint: 'VD: Tuyển CTV cho Tech Summit',
            validator: _formCtrl.validateTitle,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _formCtrl.descriptionController,
            label: 'Mô tả công việc',
            hint: 'Mô tả chi tiết về công việc...',
            maxLines: 4,
            validator: _formCtrl.validateDescription,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _formCtrl.roleNameController,
            label: 'Tên vị trí (tùy chọn)',
            hint: 'VD: Điều phối viên, MC',
            validator: _formCtrl.validateRoleName,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _formCtrl.quantityController,
            label: 'Số lượng cần tuyển',
            hint: 'VD: 10',
            keyboardType: TextInputType.number,
            validator: _formCtrl.validateQuantity,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Thời gian',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff273143))),
          const SizedBox(height: 14),
          _buildDatePicker(
            label: 'Mở đăng ký từ',
            value: _formCtrl.registerOpenTime.value,
            onChanged: _formCtrl.setRegisterOpenTime,
          ),
          const SizedBox(height: 12),
          _buildDatePicker(
            label: 'Thời gian bắt đầu chạy thử',
            value: _formCtrl.startTime.value,
            onChanged: _formCtrl.setStartTime,
            validator: _formCtrl.validateStartTime,
          ),
        ],
      ),
    );
  }

  Widget _buildRewardSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Phần thưởng khi hoàn thành',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff273143))),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _formCtrl.rewardCoinController,
                  label: 'Coin thưởng',
                  hint: '0',
                  keyboardType: TextInputType.number,
                  validator: _formCtrl.validateRewardCoin,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: _formCtrl.youthUnionPointController,
                  label: 'Điểm đoàn',
                  hint: '0',
                  keyboardType: TextInputType.number,
                  validator: _formCtrl.validateYouthUnionPoint,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _formCtrl.cashRewardController,
            label: 'Tiền mặt thưởng (VNĐ)',
            hint: '0',
            keyboardType: TextInputType.number,
            validator: _formCtrl.validateCashRewardAmount,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _formCtrl.certificateNameController,
            label: 'Tên chứng chỉ (tùy chọn)',
            hint: 'VD: Certificate of Volunteer Service',
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Danh mục bổ sung',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff273143))),
          const SizedBox(height: 8),
          Text(
            'Chọn danh mục để bài tuyển dụng dễ tìm thấy hơn (sẽ gắn vào sự kiện)',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          _buildCategoryGroup('Lĩnh vực', [9, 10, 11, 12, 13, 14, 15, 16], [
            'Công nghệ', 'Văn hóa - Nghệ thuật', 'Kỹ năng mềm',
            'Khởi nghiệp', 'Thể thao', 'Định hướng nghề nghiệp',
            'Học thuật', 'Tình nguyện',
          ]),
        ],
      ),
    );
  }

  Widget _buildCategoryGroup(
      String groupName, List<int> ids, List<String> labels) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(groupName,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xff273143),
            )),
        const SizedBox(height: 8),
        Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(ids.length, (i) {
                final id = ids[i];
                final label = labels[i];
                final isSelected =
                    _formCtrl.selectedCategoryOptionIds.contains(id);
                return GestureDetector(
                  onTap: () => _formCtrl.toggleCategoryOption(id),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF06B6D4).withOpacity(0.1)
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF06B6D4)
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? const Color(0xFF06B6D4)
                            : const Color(0xff64748B),
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }),
            )),
      ],
    );
  }

  Widget _buildQuestionSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Câu hỏi ứng tuyển',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff273143))),
          const SizedBox(height: 8),
          Text(
            'Thêm câu hỏi để thu thập thông tin từ ứng viên CTV',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (_formCtrl.requirementQuestions.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.quiz_outlined,
                          size: 36, color: Colors.grey.shade300),
                      const SizedBox(height: 8),
                      Text('Chưa có câu hỏi nào',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade500)),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () => _showAddQuestionDialog(),
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Thêm câu hỏi'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF06B6D4),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: [
                ...List.generate(_formCtrl.requirementQuestions.length, (i) {
                  final q = _formCtrl.requirementQuestions[i];
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF06B6D4).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                _getQuestionTypeLabel(q.questionType),
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF06B6D4),
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            if (q.isRequired) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text('Bắt buộc',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                            const Spacer(),
                            GestureDetector(
                              onTap: () =>
                                  _showAddQuestionDialog(index: i, existing: q),
                              child: const Icon(Icons.edit,
                                  size: 16, color: Color(0xff64748B)),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () =>
                                  _formCtrl.removeRequirementQuestion(i),
                              child: const Icon(Icons.delete_outline,
                                  size: 16, color: Colors.red),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(q.questionText,
                            style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xff273143),
                                fontWeight: FontWeight.w500)),
                        if (q.options != null && q.options!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: q.options!
                                .map((o) => Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(o.optionValue,
                                          style: const TextStyle(
                                              fontSize: 11,
                                              color: Color(0xff64748B))),
                                    ))
                                .toList(),
                          ),
                        ],
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => _showAddQuestionDialog(),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Thêm câu hỏi'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF06B6D4),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  String _getQuestionTypeLabel(RequirementQuestionType type) {
    switch (type) {
      case RequirementQuestionType.text:
        return 'TEXT';
      case RequirementQuestionType.singleChoice:
        return '1 CHỌN';
      case RequirementQuestionType.multipleChoice:
        return 'NHIỀU CHỌN';
    }
  }

  void _showAddQuestionDialog({int? index, RequirementQuestionCreateParams? existing}) {
    final contentCtrl = TextEditingController(text: existing?.questionText ?? '');
    final isRequired = existing?.isRequired ?? false;
    final selectedType = existing?.questionType ?? RequirementQuestionType.text;
    final optionCtrls = <TextEditingController>[];
    if (existing?.options != null) {
      for (final o in existing!.options!) {
        optionCtrls.add(TextEditingController(text: o.optionValue ?? ''));
      }
    }
    if (optionCtrls.isEmpty) {
      optionCtrls.add(TextEditingController());
      optionCtrls.add(TextEditingController());
    }
    final typeRx = selectedType.obs;
    final requiredRx = isRequired.obs;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(index == null ? 'Thêm câu hỏi' : 'Sửa câu hỏi'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: contentCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nội dung câu hỏi',
                  hintText: 'VD: Bạn có kinh nghiệm tham gia sự kiện?',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              const Text('Loại câu hỏi',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 8),
              Obx(() => Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildReqTypeChip(typeRx, RequirementQuestionType.text, 'Text'),
                      _buildReqTypeChip(typeRx, RequirementQuestionType.singleChoice, '1 chọn'),
                      _buildReqTypeChip(typeRx, RequirementQuestionType.multipleChoice, 'Nhiều chọn'),
                    ],
                  )),
              const SizedBox(height: 16),
              Obx(() {
                final type = typeRx.value;
                if (type == RequirementQuestionType.text) {
                  return const SizedBox.shrink();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tùy chọn',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        TextButton.icon(
                          onPressed: () {
                            optionCtrls.add(TextEditingController());
                          },
                          icon: const Icon(Icons.add, size: 14),
                          label: const Text('Thêm'),
                          style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF06B6D4)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(optionCtrls.length, (i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: optionCtrls[i],
                                decoration: InputDecoration(
                                  hintText: 'Tùy chọn ${i + 1}',
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                ),
                              ),
                            ),
                            if (optionCtrls.length > 2)
                              IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: () {
                                  optionCtrls[i].dispose();
                                  optionCtrls.removeAt(i);
                                },
                              ),
                          ],
                        ),
                      );
                    }),
                  ],
                );
              }),
              const SizedBox(height: 12),
              Obx(() => CheckboxListTile(
                    value: requiredRx.value,
                    onChanged: (v) => requiredRx.value = v ?? false,
                    title: const Text('Bắt buộc trả lời',
                        style: TextStyle(fontSize: 13)),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    activeColor: const Color(0xFF06B6D4),
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              for (final c in optionCtrls) {
                c.dispose();
              }
              Get.back();
            },
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (contentCtrl.text.trim().isEmpty) return;
              final type = typeRx.value;
              final needsOptions = type == RequirementQuestionType.singleChoice ||
                  type == RequirementQuestionType.multipleChoice;
              final options = needsOptions
                  ? optionCtrls
                      .where((c) => c.text.trim().isNotEmpty)
                      .map((c) => QuestionOptionCreateParams(
                          optionValue: c.text.trim()))
                      .toList()
                  : null;

              final question = RequirementQuestionCreateParams(
                questionText: contentCtrl.text.trim(),
                questionType: type,
                isRequired: requiredRx.value,
                options: options,
              );

              if (index != null) {
                _formCtrl.updateRequirementQuestion(index, question);
              } else {
                _formCtrl.addRequirementQuestion(question);
              }

              for (final c in optionCtrls) {
                c.dispose();
              }
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF06B6D4),
            ),
            child: Text(index == null ? 'Thêm' : 'Lưu'),
          ),
        ],
      ),
    );
  }

  Widget _buildReqTypeChip(Rx<RequirementQuestionType> rx,
      RequirementQuestionType type, String label) {
    return GestureDetector(
      onTap: () => rx.value = type,
      child: Obx(() {
        final isSelected = rx.value == type;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF06B6D4).withOpacity(0.1)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? const Color(0xFF06B6D4) : Colors.grey.shade300,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? const Color(0xFF06B6D4) : Colors.grey.shade600,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        );
      }),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: const [
        BoxShadow(
            color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 8)
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xff475569))),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime? value,
    required void Function(DateTime?) onChanged,
    String? Function(DateTime?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xff475569))),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now().add(const Duration(days: 1)),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (time != null) {
                onChanged(
                    DateTime(date.year, date.month, date.day, time.hour, time.minute));
              } else {
                onChanged(date);
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today,
                    size: 16, color: Color(0xff94A3B8)),
                const SizedBox(width: 8),
                Text(
                  value != null ? AppDateUtils.formatDate(value) : 'Chọn ngày',
                  style: TextStyle(
                      fontSize: 14,
                      color: value != null
                          ? const Color(0xff273143)
                          : Colors.grey.shade400),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPublishButton() {
    return Obx(() => SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed:
                _formCtrl.isSubmitting.value ? null : () => _handleSubmit(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF06B6D4),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: _formCtrl.isSubmitting.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : const Text('Đăng tuyển',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
          ),
        ));
  }

  void _handleSubmit() {
    if (_selectedEvent == null) {
      AppSnackbarUtils.showError('Lỗi', 'Vui lòng chọn sự kiện');
      return;
    }
    _formCtrl.submit(_selectedEvent!.eventId!);
  }
}
