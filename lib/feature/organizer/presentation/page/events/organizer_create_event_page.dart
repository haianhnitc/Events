import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/organizer/event/domain/usecase/event_params.dart';
import 'package:events_app/common/presentation/widget/avatar_upload_widget.dart';
import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/feature/event_management/domain/entity/event_entity.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_create_event_controller.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_event_detail_controller.dart';
import 'package:events_app/feature/organizer/presentation/widget/event/venue_picker_dialog.dart';
import 'package:events_app/feature/venue/domain/entity/venue_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrganizerCreateEventPage extends StatefulWidget {
  final int? eventId;
  final EventEntity? event;

  const OrganizerCreateEventPage({super.key, this.eventId, this.event});

  @override
  State<OrganizerCreateEventPage> createState() =>
      _OrganizerCreateEventPageState();
}

class _OrganizerCreateEventPageState extends State<OrganizerCreateEventPage> {
  late OrganizerCreateEventController _ctrl;
  final _pageController = PageController();
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.put(OrganizerCreateEventController());
    if (widget.eventId != null && widget.event != null) {
      _ctrl.initForEdit(widget.event!);
    } else if (widget.eventId != null) {
      _loadEventAndInitEdit();
    } else {
      _ctrl.initForCreate();
    }
    _ctrl.loadVenues();
  }

  Future<void> _loadEventAndInitEdit() async {
    await _ctrl.loadEventForEdit(widget.eventId!);
  }

  @override
  void dispose() {
    _pageController.dispose();
    Get.delete<OrganizerCreateEventController>();
    super.dispose();
  }

  void _goToStep(int step) {
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xff64748B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.eventId != null ? 'Chỉnh sửa sự kiện' : 'Tạo sự kiện mới',
          style: const TextStyle(
              color: Color(0xff273143),
              fontSize: 17,
              fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (_ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            _buildStepIndicator(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildBasicInfoStep(),
                  _buildDateTimeStep(),
                  _buildRecruitmentStep(),
                  _buildRewardStep(),
                  _buildCategoryStep(),
                  _buildFeedbackStep(),
                  _buildReviewStep(),
                ],
              ),
            ),
            _buildBottomActions(),
          ],
        );
      }),
    );
  }

  Widget _buildStepIndicator() {
    final steps = [
      'Cơ bản',
      'Thời gian',
      'CTV',
      'Phần thưởng',
      'Danh mục',
      'Feedback',
      'Xem lại'
    ];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: List.generate(steps.length, (i) {
          final isActive = i <= _currentStep;
          final isCurrent = i == _currentStep;
          return Expanded(
            child: GestureDetector(
              onTap: i < _currentStep ? () => _goToStep(i) : null,
              child: Column(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFF06B6D4)
                          : Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isActive && i < _currentStep
                          ? const Icon(Icons.check, size: 14, color: Colors.white)
                          : Text(
                              '${i + 1}',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: isActive ? Colors.white : Colors.grey,
                                  fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    steps[i],
                    style: TextStyle(
                        fontSize: 10,
                        color: isCurrent
                            ? const Color(0xFF06B6D4)
                            : Colors.grey.shade600,
                        fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _ctrl.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionCard([
              _buildSectionTitle('Hình ảnh sự kiện'),
              const SizedBox(height: 12),
              _buildBannerUpload(),
            ]),
            const SizedBox(height: 16),
            _buildSectionCard([
              _buildSectionTitle('Thông tin cơ bản'),
              const SizedBox(height: 12),
              _buildFormField(
                controller: _ctrl.titleController,
                label: 'Tên sự kiện',
                hint: 'VD: Tech Summit 2026',
                validator: _ctrl.validateTitle,
              ),
              const SizedBox(height: 12),
              _buildFormField(
                controller: _ctrl.descriptionController,
                label: 'Mô tả',
                hint: 'Mô tả chi tiết về sự kiện...',
                maxLines: 4,
                validator: _ctrl.validateDescription,
              ),
            ]),
            const SizedBox(height: 16),
            _buildSectionCard([
              _buildSectionTitle('Địa điểm'),
              const SizedBox(height: 12),
              Obx(() {
                final selectedVenue = _ctrl.selectedVenue.value;
                return GestureDetector(
                  onTap: () async {
                    final result = await VenuePickerDialog.show(
                      context,
                      selectedVenue: selectedVenue,
                    );
                    if (result != null) {
                      if (result.createdNew && result.venue != null) {
                        _ctrl.venueList.add(result.venue!);
                        _ctrl.selectedVenue.value = result.venue;
                      } else {
                        _ctrl.selectedVenue.value = result.venue;
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 18, color: Color(0xff64748B)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            selectedVenue?.name ?? 'Chọn địa điểm',
                            style: TextStyle(
                              fontSize: 14,
                              color: selectedVenue != null
                                  ? const Color(0xff273143)
                                  : Colors.grey.shade400,
                            ),
                          ),
                        ),
                        if (selectedVenue != null)
                          IconButton(
                            icon: const Icon(Icons.close, size: 16),
                            onPressed: () => _ctrl.selectedVenue.value = null,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerUpload() {
    return Obx(() => BannerUploadWidget(
          previewUrl: _ctrl.bannerPreviewUrl.value,
          fileType: FileType.eventBanner,
          height: 160,
          onSuccess: (fileId, url) => _ctrl.onBannerUploaded(fileId, url),
          onRemove: () {
            _ctrl.bannerFileId.value = null;
            _ctrl.bannerPreviewUrl.value = null;
          },
        ));
  }

  Widget _buildDateTimeStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSectionCard([
            _buildSectionTitle('Thời gian sự kiện'),
            const SizedBox(height: 12),
            _buildDateTimeField(
              label: 'Thời gian bắt đầu',
              value: _ctrl.startTime.value,
              onChanged: _ctrl.setStartTime,
              validator: _ctrl.validateStartTime,
            ),
            const SizedBox(height: 12),
            _buildDateTimeField(
              label: 'Thời gian kết thúc',
              value: _ctrl.endTime.value,
              onChanged: _ctrl.setEndTime,
              validator: _ctrl.validateEndTime,
            ),
          ]),
          const SizedBox(height: 16),
          _buildSectionCard([
            _buildSectionTitle('Thời gian đăng ký'),
            const SizedBox(height: 12),
            _buildDateTimeField(
              label: 'Mở đăng ký từ',
              value: _ctrl.registerOpenTime.value,
              onChanged: _ctrl.setRegisterOpenTime,
              validator: _ctrl.validateRegisterOpenTime,
              firstDate: DateTime.now(),
            ),
          ]),
          const SizedBox(height: 16),
          _buildSectionCard([
            _buildSectionTitle('Giá vé'),
            const SizedBox(height: 12),
            _buildFormField(
              controller: _ctrl.priceController,
              label: 'Giá vé (VNĐ)',
              hint: '0 = Miễn phí',
              keyboardType: TextInputType.number,
              validator: _ctrl.validatePrice,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildRecruitmentStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSectionCard([
            _buildSectionTitle('Hình thức tuyển người tham gia'),
            const SizedBox(height: 12),
            Obx(() => _buildRecruitmentTypeOption(
                  EventRecruitmentType.attendeeOnly,
                  'Chỉ người tham dự',
                  'Chỉ attendee có thể đăng ký và nhận vé.',
                  Icons.person_outline,
                )),
            const SizedBox(height: 10),
            Obx(() => _buildRecruitmentTypeOption(
                  EventRecruitmentType.ctvOnly,
                  'Chỉ Cộng tác viên (CTV)',
                  'Chỉ CTV được tuyển qua đơn ứng tuyển.',
                  Icons.group_outlined,
                )),
            const SizedBox(height: 10),
            Obx(() => _buildRecruitmentTypeOption(
                  EventRecruitmentType.both,
                  'Cả hai',
                  'Cả attendee và CTV đều có thể tham gia.',
                  Icons.people_outline,
                )),
          ]),
        ],
      ),
    );
  }

  Widget _buildRewardStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSectionCard([
            _buildSectionTitle('Phần thưởng cho người hoàn thành'),
            const SizedBox(height: 12),
            _buildFormField(
              controller: _ctrl.rewardCoinController,
              label: 'Coin thưởng',
              hint: '0',
              keyboardType: TextInputType.number,
              validator: _ctrl.validateRewardCoin,
            ),
            const SizedBox(height: 12),
            _buildFormField(
              controller: _ctrl.youthUnionPointController,
              label: 'Điểm đoàn',
              hint: '0',
              keyboardType: TextInputType.number,
              validator: _ctrl.validateYouthUnionPoint,
            ),
            const SizedBox(height: 12),
            _buildFormField(
              controller: _ctrl.certificateNameController,
              label: 'Tên chứng chỉ',
              hint: 'VD: Certificate of Attendance',
              validator: _ctrl.validateCertificateName,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildCategoryStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard([
            _buildSectionTitle('Danh mục sự kiện'),
            const SizedBox(height: 8),
            Text(
              'Chọn các danh mục phù hợp để sự kiện dễ tìm thấy hơn',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            _buildCategoryGroup(
              'Trường đại học',
              [1, 2, 3, 4, 5, 6, 7, 8],
              [
                'ĐH Bách Khoa TP.HCM', 'ĐH Thể dục Thể thao Hà Nội',
                'ĐH Ngoại thương', 'ĐH Ngoại ngữ - ĐHQGHN',
                'ĐH Công nghệ - ĐHQGHN', 'ĐH Y Hà Nội',
                'ĐH FPT Hà Nội', 'ĐH Quốc gia TP.HCM',
              ],
            ),
            const SizedBox(height: 16),
            _buildCategoryGroup(
              'Lĩnh vực',
              [9, 10, 11, 12, 13, 14, 15, 16],
              [
                'Công nghệ', 'Văn hóa - Nghệ thuật', 'Kỹ năng mềm',
                'Khởi nghiệp', 'Thể thao', 'Định hướng nghề nghiệp',
                'Học thuật', 'Tình nguyện',
              ],
            ),
            const SizedBox(height: 16),
            _buildCategoryGroup(
              'Giá / Lương',
              [17, 18, 19],
              ['Miễn phí', '0 - 150,000đ', '150,000đ - 300,000đ'],
            ),
            const SizedBox(height: 16),
            _buildCategoryGroup(
              'Tiêu chí',
              [20, 21],
              ['Chứng chỉ 5 tốt', 'Cộng điểm đoàn'],
            ),
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
        Text(
          groupName,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xff273143),
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(ids.length, (i) {
                final id = ids[i];
                final label = labels[i];
                final isSelected =
                    _ctrl.selectedCategoryOptionIds.contains(id);
                return GestureDetector(
                  onTap: () => _ctrl.toggleCategoryOption(id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
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

  Widget _buildFeedbackStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard([
            _buildSectionTitle('Câu hỏi phản hồi'),
            const SizedBox(height: 8),
            Text(
              'Thêm câu hỏi để thu thập phản hồi từ người tham dự',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (_ctrl.feedbackQuestions.isEmpty) {
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
                            size: 40, color: Colors.grey.shade300),
                        const SizedBox(height: 8),
                        Text('Chưa có câu hỏi nào',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey.shade500)),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () => _showAddFeedbackQuestionDialog(),
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
                  ...List.generate(_ctrl.feedbackQuestions.length, (i) {
                    final q = _ctrl.feedbackQuestions[i];
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
                                  color: const Color(0xFF06B6D4)
                                      .withOpacity(0.1),
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
                                onTap: () => _showAddFeedbackQuestionDialog(
                                    index: i, existing: q),
                                child: const Icon(Icons.edit,
                                    size: 16, color: Color(0xff64748B)),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => _ctrl.removeFeedbackQuestion(i),
                                child: const Icon(Icons.delete_outline,
                                    size: 16, color: Colors.red),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(q.questionContent,
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
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                    onPressed: () => _showAddFeedbackQuestionDialog(),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Thêm câu hỏi'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF06B6D4),
                    ),
                  ),
                ],
              );
            }),
          ]),
        ],
      ),
    );
  }

  String _getQuestionTypeLabel(FeedbackQuestionType type) {
    switch (type) {
      case FeedbackQuestionType.text:
        return 'TEXT';
      case FeedbackQuestionType.rating:
        return 'RATING';
      case FeedbackQuestionType.singleChoice:
        return '1 CHỌN';
      case FeedbackQuestionType.multipleChoice:
        return 'NHIỀU CHỌN';
    }
  }

  void _showAddFeedbackQuestionDialog({int? index, FeedbackQuestionCreateParams? existing}) {
    final contentCtrl = TextEditingController(text: existing?.questionContent ?? '');
    final isRequired = existing?.isRequired ?? false;
    final selectedType = existing?.questionType ?? FeedbackQuestionType.text;
    final optionCtrls = <TextEditingController>[];
    if (existing?.options != null) {
      for (final o in existing!.options!) {
        optionCtrls.add(TextEditingController(text: o.optionValue));
      }
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
                  hintText: 'VD: Bạn hài lòng với sự kiện này không?',
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
                      _buildTypeChip(typeRx, FeedbackQuestionType.text, 'Text'),
                      _buildTypeChip(typeRx, FeedbackQuestionType.rating, 'Rating'),
                      _buildTypeChip(typeRx, FeedbackQuestionType.singleChoice, '1 chọn'),
                      _buildTypeChip(typeRx, FeedbackQuestionType.multipleChoice, 'Nhiều chọn'),
                    ],
                  )),
              const SizedBox(height: 16),
              Obx(() {
                final type = typeRx.value;
                if (type == FeedbackQuestionType.text ||
                    type == FeedbackQuestionType.rating) {
                  return const SizedBox.shrink();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tùy chọn',
                            style:
                                TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
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
            onPressed: () => Get.back(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (contentCtrl.text.trim().isEmpty) return;
              final type = typeRx.value;
              final needsOptions = type == FeedbackQuestionType.singleChoice ||
                  type == FeedbackQuestionType.multipleChoice;
              final options = needsOptions
                  ? optionCtrls
                      .where((c) => c.text.trim().isNotEmpty)
                      .map((c) => FeedbackOptionCreateParams(
                          optionValue: c.text.trim()))
                      .toList()
                  : null;

              final question = FeedbackQuestionCreateParams(
                questionContent: contentCtrl.text.trim(),
                questionType: type,
                isRequired: requiredRx.value,
                options: options,
              );

              if (index != null) {
                _ctrl.updateFeedbackQuestion(index, question);
              } else {
                _ctrl.addFeedbackQuestion(question);
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

  Widget _buildTypeChip(Rx<FeedbackQuestionType> rx, FeedbackQuestionType type, String label) {
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

  Widget _buildReviewStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            return _buildSectionCard([
              _buildSectionTitle('Xem lại thông tin'),
              const SizedBox(height: 12),
              if (_ctrl.bannerPreviewUrl.value != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    _ctrl.bannerPreviewUrl.value!,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 120,
                      color: Colors.grey.shade200,
                      child: const Center(child: Icon(Icons.image, color: Colors.grey)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              _buildReviewRow('Tên sự kiện', _ctrl.titleController.text),
              _buildReviewRow(
                  'Địa điểm', _ctrl.selectedVenue.value?.name ?? 'Chưa chọn'),
              _buildReviewRow(
                  'Bắt đầu',
                  _ctrl.startTime.value != null
                      ? AppDateUtils.formatDate(_ctrl.startTime.value!)
                      : 'Chưa chọn'),
              _buildReviewRow(
                  'Kết thúc',
                  _ctrl.endTime.value != null
                      ? AppDateUtils.formatDate(_ctrl.endTime.value!)
                      : 'Chưa chọn'),
              _buildReviewRow(
                  'Giá vé',
                  (int.tryParse(_ctrl.priceController.text) ?? 0) == 0
                      ? 'Miễn phí'
                      : '${_ctrl.priceController.text} VNĐ'),
              _buildReviewRow('Hình thức tuyển',
                  _ctrl.recruitmentType.value.name),
              _buildReviewRow(
                  'Coin thưởng', _ctrl.rewardCoinController.text),
              _buildReviewRow(
                  'Điểm đoàn', _ctrl.youthUnionPointController.text),
              _buildReviewRow(
                  'Danh mục đã chọn',
                  _ctrl.selectedCategoryOptionIds.isEmpty
                      ? 'Chưa chọn'
                      : '${_ctrl.selectedCategoryOptionIds.length} danh mục'),
              _buildReviewRow(
                  'Câu hỏi feedback',
                  _ctrl.feedbackQuestions.isEmpty
                      ? 'Không có'
                      : '${_ctrl.feedbackQuestions.length} câu hỏi'),
            ]);
          }),
        ],
      ),
    );
  }

  Widget _buildSectionCard(List<Widget> children) {
    return Container(
      width: double.infinity,
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
        children: children,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Color(0xff273143)),
    );
  }

  Widget _buildFormField({
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

  Widget _buildDateTimeField({
    required String label,
    required DateTime? value,
    required void Function(DateTime?) onChanged,
    String? Function(DateTime?)? validator,
    DateTime? firstDate,
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
              initialDate: value ?? DateTime.now().add(const Duration(days: 7)),
              firstDate: firstDate ?? DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
            );
            if (date != null) {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (time != null) {
                onChanged(DateTime(
                    date.year, date.month, date.day, time.hour, time.minute));
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
                  value != null
                      ? AppDateUtils.formatDate(value)
                      : 'Chọn ngày và giờ',
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

  Widget _buildRecruitmentTypeOption(
      EventRecruitmentType type, String label, String description, IconData icon) {
    final isSelected = _ctrl.recruitmentType.value == type;
    return GestureDetector(
      onTap: () => _ctrl.setRecruitmentType(type),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF06B6D4).withOpacity(0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF06B6D4) : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isSelected
                    ? const Color(0xFF06B6D4)
                    : Colors.grey.shade600),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected
                            ? const Color(0xFF06B6D4)
                            : const Color(0xff273143),
                      )),
                  Text(description,
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade600)),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle,
                  size: 18, color: Color(0xFF06B6D4)),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label,
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff273143))),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, -2),
              blurRadius: 8),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _goToStep(_currentStep - 1),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFF06B6D4)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Quay lại',
                      style: TextStyle(
                          color: Color(0xFF06B6D4),
                          fontWeight: FontWeight.w600)),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 12),
            Expanded(
              child: Obx(() => ElevatedButton(
                    onPressed: _ctrl.isSubmitting.value
                        ? null
                        : () => _handleNext(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF06B6D4),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: _ctrl.isSubmitting.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : Obx(() => Text(
                            _currentStep == 6
                                ? (_ctrl.isEditMode ? 'Cập nhật sự kiện' : 'Tạo sự kiện')
                                : 'Tiếp tục',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600))),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNext() {
    if (_currentStep == 0) {
      final title = _ctrl.validateTitle(_ctrl.titleController.text);
      final desc = _ctrl.validateDescription(_ctrl.descriptionController.text);
      final venue = _ctrl.validateVenue(null);
      if (title != null) {
        AppSnackbarUtils.showError('Lỗi', title);
        return;
      }
      if (desc != null) {
        AppSnackbarUtils.showError('Lỗi', desc);
        return;
      }
      if (venue != null) {
        AppSnackbarUtils.showError('Lỗi', venue);
        return;
      }
    }
    if (_currentStep == 1) {
      final start = _ctrl.validateStartTime(_ctrl.startTime.value);
      final end = _ctrl.validateEndTime(_ctrl.endTime.value);
      if (start != null) {
        AppSnackbarUtils.showError('Lỗi', start);
        return;
      }
      if (end != null) {
        AppSnackbarUtils.showError('Lỗi', end);
        return;
      }
    }
    if (_currentStep < 6) {
      _goToStep(_currentStep + 1);
    } else {
      _ctrl.submit();
    }
  }
}
