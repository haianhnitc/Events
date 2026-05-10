import 'package:events_app/common/presentation/widget/avatar_upload_widget.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/presentation/widget/app_date_time_picker.dart';
import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/feature/event_management/domain/entity/event_entity.dart';
import 'package:events_app/feature/organizer/event/domain/usecase/event_params.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_create_event_controller.dart';
import 'package:events_app/feature/organizer/presentation/widget/event/form_widgets.dart';
import 'package:events_app/feature/organizer/presentation/widget/event/category_picker.dart';
import 'package:events_app/feature/organizer/presentation/widget/event/feedback_question_sheet.dart';
import 'package:events_app/feature/organizer/presentation/widget/event/venue_picker_dialog.dart';
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
  final _currentStepRx = 0.obs;

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
    _ctrl.loadCategories();
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
    _currentStepRx.value = step;
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
              child: Form(
                key: _ctrl.formKey,
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildBasicInfoStep(),
                    _buildDateTimeStep(),
                    _buildRecruitmentStep(),
                    _buildRewardStep(),
                    CategoryPickerStep(
                      categories: _ctrl.categories,
                      selectedCategoryOptionIds:
                          _ctrl.selectedCategoryOptionIds,
                      isLoading: _ctrl.isLoadingCategories,
                      onToggle: _ctrl.toggleCategoryOption,
                    ),
                    FeedbackQuestionStep(
                      questions: _ctrl.feedbackQuestions,
                      onSave: (q) {
                        _ctrl.addFeedbackQuestion(
                          questionContent: q.questionContent ?? '',
                          questionType:
                              q.questionType ?? FeedbackQuestionType.text,
                          isRequired: q.isRequired ?? false,
                          options: q.options
                              ?.map((o) => o.optionValue ?? '')
                              .toList(),
                        );
                      },
                      onRemoveQuestion: _ctrl.removeFeedbackQuestion,
                    ),
                    _buildReviewStep(),
                  ],
                ),
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
          final isActive = i <= _currentStepRx.value;
          final isCurrent = i == _currentStepRx.value;
          return Expanded(
            child: GestureDetector(
              onTap: i < _currentStepRx.value ? () => _goToStep(i) : null,
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
                      child: isActive && i < _currentStepRx.value
                          ? const Icon(Icons.check,
                              size: 14, color: Colors.white)
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 10,
                        color: isCurrent
                            ? const Color(0xFF06B6D4)
                            : Colors.grey.shade600,
                        fontWeight:
                            isCurrent ? FontWeight.w600 : FontWeight.w400),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormSectionCard(children: [
            const FormSectionTitle('Hình ảnh sự kiện'),
            const SizedBox(height: 12),
            _buildBannerUpload(),
          ]),
          const SizedBox(height: 16),
          FormSectionCard(children: [
            const FormSectionTitle('Thông tin cơ bản'),
            const SizedBox(height: 12),
            FormTextField(
              controller: _ctrl.titleController,
              label: 'Tên sự kiện',
              hint: 'VD: Tech Summit 2026',
              validator: _ctrl.validateTitle,
            ),
            const SizedBox(height: 12),
            FormTextField(
              controller: _ctrl.descriptionController,
              label: 'Mô tả',
              hint: 'Mô tả chi tiết về sự kiện...',
              maxLines: 4,
              validator: _ctrl.validateDescription,
            ),
          ]),
          const SizedBox(height: 16),
          FormSectionCard(children: [
            const FormSectionTitle('Địa điểm'),
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
          FormSectionCard(children: [
            const FormSectionTitle('Thời gian sự kiện'),
            const SizedBox(height: 12),
            AppDateTimePicker(
              label: 'Thời gian bắt đầu',
              value: _ctrl.startTime.value,
              onChanged: _ctrl.setStartTime,
              validator: _ctrl.validateStartTime,
            ),
            const SizedBox(height: 12),
            AppDateTimePicker(
              label: 'Thời gian kết thúc',
              value: _ctrl.endTime.value,
              onChanged: _ctrl.setEndTime,
              validator: _ctrl.validateEndTime,
            ),
          ]),
          const SizedBox(height: 16),
          FormSectionCard(children: [
            const FormSectionTitle('Thời gian đăng ký'),
            const SizedBox(height: 12),
            AppDateTimePicker(
              label: 'Mở đăng ký từ',
              value: _ctrl.registerOpenTime.value,
              onChanged: _ctrl.setRegisterOpenTime,
              validator: _ctrl.validateRegisterOpenTime,
              firstDate: DateTime.now(),
            ),
          ]),
          const SizedBox(height: 16),
          FormSectionCard(children: [
            const FormSectionTitle('Giá vé'),
            const SizedBox(height: 12),
            FormTextField(
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
          FormSectionCard(children: [
            const FormSectionTitle('Hình thức tuyển người tham gia'),
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
          FormSectionCard(children: [
            const FormSectionTitle('Phần thưởng cho người hoàn thành'),
            const SizedBox(height: 12),
            FormTextField(
              controller: _ctrl.rewardCoinController,
              label: 'Coin thưởng',
              hint: '0',
              keyboardType: TextInputType.number,
              validator: _ctrl.validateRewardCoin,
            ),
            const SizedBox(height: 12),
            FormTextField(
              controller: _ctrl.youthUnionPointController,
              label: 'Điểm đoàn',
              hint: '0',
              keyboardType: TextInputType.number,
              validator: _ctrl.validateYouthUnionPoint,
            ),
            const SizedBox(height: 12),
            FormTextField(
              controller: _ctrl.certificateNameController,
              label: 'Tên chứng chỉ',
              hint: 'VD: Certificate of Attendance',
              maxLines: 1,
              validator: _ctrl.validateCertificateName,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildReviewStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            return FormSectionCard(children: [
              const FormSectionTitle('Xem lại thông tin'),
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
                      child: const Center(
                          child: Icon(Icons.image, color: Colors.grey)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              FormReviewRow('Tên sự kiện', _ctrl.titleController.text),
              if (_ctrl.descriptionController.text.isNotEmpty)
                FormReviewRow('Mô tả', _ctrl.descriptionController.text),
              FormReviewRow(
                  'Địa điểm', _ctrl.selectedVenue.value?.name ?? 'Chưa chọn'),
              FormReviewRow(
                  'Bắt đầu',
                  _ctrl.startTime.value != null
                      ? AppDateUtils.formatDate(_ctrl.startTime.value!)
                      : 'Chưa chọn'),
              FormReviewRow(
                  'Kết thúc',
                  _ctrl.endTime.value != null
                      ? AppDateUtils.formatDate(_ctrl.endTime.value!)
                      : 'Chưa chọn'),
              FormReviewRow(
                  'Mở đăng ký',
                  _ctrl.registerOpenTime.value != null
                      ? AppDateUtils.formatDate(_ctrl.registerOpenTime.value!)
                      : 'Chưa chọn'),
              FormReviewRow(
                  'Giá vé',
                  (int.tryParse(_ctrl.priceController.text) ?? 0) == 0
                      ? 'Miễn phí'
                      : '${_ctrl.priceController.text} VNĐ'),
              FormReviewRow(
                  'Hình thức tuyển', _ctrl.recruitmentType.value.displayName),
              FormReviewRow('Coin thưởng', _ctrl.rewardCoinController.text),
              FormReviewRow('Điểm đoàn', _ctrl.youthUnionPointController.text),
              if (_ctrl.certificateNameController.text.isNotEmpty)
                FormReviewRow(
                    'Tên chứng chỉ', _ctrl.certificateNameController.text),
              FormReviewRow(
                  'Danh mục đã chọn',
                  _ctrl.selectedCategoryOptionIds.isEmpty
                      ? 'Chưa chọn'
                      : '${_ctrl.selectedCategoryOptionIds.length} danh mục'),
              FormReviewRow(
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

  Widget _buildRecruitmentTypeOption(EventRecruitmentType type, String label,
      String description, IconData icon) {
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
                      style:
                          TextStyle(fontSize: 11, color: Colors.grey.shade600)),
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
        child: Obx(() => Row(
              children: [
                if (_currentStepRx.value > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _goToStep(_currentStepRx.value - 1),
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
                if (_currentStepRx.value > 0) const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        _ctrl.isSubmitting.value ? null : () => _handleNext(),
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
                        : Text(
                            _currentStepRx.value == 6
                                ? (_ctrl.isEditMode
                                    ? 'Cập nhật sự kiện'
                                    : 'Tạo sự kiện')
                                : 'Tiếp tục',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  void _handleNext() {
    final step = _currentStepRx.value;
    if (step == 0) {
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
    if (step == 1) {
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
    if (step < 6) {
      _goToStep(step + 1);
    } else {
      final title = _ctrl.validateTitle(_ctrl.titleController.text);
      final desc = _ctrl.validateDescription(_ctrl.descriptionController.text);
      final venue = _ctrl.validateVenue(null);
      if (title != null) {
        AppSnackbarUtils.showError('Lỗi', title);
        _goToStep(0);
        return;
      }
      if (desc != null) {
        AppSnackbarUtils.showError('Lỗi', desc);
        _goToStep(0);
        return;
      }
      if (venue != null) {
        AppSnackbarUtils.showError('Lỗi', venue);
        _goToStep(0);
        return;
      }
      final start = _ctrl.validateStartTime(_ctrl.startTime.value);
      if (start != null) {
        AppSnackbarUtils.showError('Lỗi', start);
        _goToStep(1);
        return;
      }
      final end = _ctrl.validateEndTime(_ctrl.endTime.value);
      if (end != null) {
        AppSnackbarUtils.showError('Lỗi', end);
        _goToStep(1);
        return;
      }
      _ctrl.submit();
    }
  }
}
