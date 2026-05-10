import 'package:events_app/common/presentation/widget/avatar_upload_widget.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/presentation/widget/app_date_time_picker.dart';
import 'package:events_app/feature/common/utils/app_date_utils.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/organizer/presentation/widget/recruitment/requirement_question_sheet.dart';
import 'package:events_app/feature/organizer/recruitment/domain/usecase/organizer_recruitment_params.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_event_list_controller.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_recruitment_form_controller.dart';
import 'package:events_app/feature/organizer/presentation/widget/organizer_event_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrganizerRecruitmentFormPage extends StatefulWidget {
  final int? eventId;
  final int? recruitmentId;

  const OrganizerRecruitmentFormPage(
      {super.key, this.eventId, this.recruitmentId});

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _eventCtrl.loadEvents(reset: true);
    });

    if (widget.recruitmentId != null) {
      _formCtrl.loadRecruitment(widget.recruitmentId!);
    } else if (widget.eventId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final event = _eventCtrl.events
            .firstWhereOrNull((e) => e.eventId == widget.eventId);
        if (event != null) {
          setState(() => _selectedEvent = event);
        }
      });
    }

    ever(_formCtrl.editingRecruitment, (r) {
      if (r != null && r.eventId != null) {
        final event =
            _eventCtrl.events.firstWhereOrNull((e) => e.eventId == r.eventId);
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
          child: Form(
            key: _formCtrl.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_selectedEvent != null) ...[
                  _buildEventInfoSection(),
                  const SizedBox(height: 16),
                ],
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
            if (_eventCtrl.isLoading.value && _eventCtrl.events.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return GestureDetector(
              onTap: () {
                OrganizerEventPickerSheet.show(
                  context: context,
                  events: _eventCtrl.events
                      .where((e) => e.status == EventStatus.published)
                      .toList(),
                  title: 'Chọn sự kiện tuyển CTV',
                  onSelected: (e) => setState(() => _selectedEvent = e),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedEvent?.title ?? 'Chọn sự kiện',
                        style: TextStyle(
                          fontSize: 14,
                          color: _selectedEvent != null
                              ? const Color(0xff273143)
                              : Colors.grey.shade400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down,
                        color: Colors.grey.shade400, size: 20),
                  ],
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
                onSuccess: (fileId, url) =>
                    _formCtrl.onBannerUploaded(fileId, url),
                onRemove: () {
                  _formCtrl.bannerFileId.value = null;
                  _formCtrl.bannerPreviewUrl.value = null;
                },
              )),
        ],
      ),
    );
  }

  Widget _buildEventInfoSection() {
    final ev = _selectedEvent;
    if (ev == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.event, size: 16, color: Color(0xFF06B6D4)),
              SizedBox(width: 6),
              Text('Thông tin sự kiện liên kết',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff273143))),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Tiêu đề sự kiện', ev.title ?? 'N/A'),
          const SizedBox(height: 8),
          if (ev.startTime != null) ...[
            _buildInfoRow('Thời gian', AppDateUtils.formatDate(ev.startTime!)),
            const SizedBox(height: 8),
          ],
          if (ev.capacity != null || ev.totalParticipants != null) ...[
            _buildInfoRow(
              'Sức chứa',
              ev.capacity != null
                  ? '${ev.totalParticipants ?? 0} / ${ev.capacity}'
                  : '${ev.totalParticipants ?? 0} người',
            ),
            const SizedBox(height: 8),
          ],
          if (ev.status != null) ...[
            _buildInfoRow('Trạng thái', _getEventStatusLabel(ev.status!)),
            const SizedBox(height: 8),
          ],
          if (ev.price != null && ev.price != 0) ...[
            _buildInfoRow('Phí tham gia', _formatPrice(ev.price!)),
            const SizedBox(height: 8),
          ],
          if (ev.youthUnionPoint != null && ev.youthUnionPoint != 0) ...[
            _buildInfoRow('Điểm đoàn', '${ev.youthUnionPoint} điểm'),
            const SizedBox(height: 8),
          ],
          if (ev.certificateName != null && ev.certificateName!.isNotEmpty) ...[
            _buildInfoRow('Chứng chỉ', ev.certificateName!),
            const SizedBox(height: 8),
          ],
          if (ev.banner != null) ...[
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                ev.banner!,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatPrice(int price) {
    if (price == 0) return 'Miễn phí';
    return '${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}đ';
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        ),
        Expanded(
          child: Text(value,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff273143))),
        ),
      ],
    );
  }

  String _getEventStatusLabel(EventStatus status) {
    switch (status) {
      case EventStatus.draft:
        return 'Bản nháp';
      case EventStatus.published:
        return 'Đã xuất bản';
      case EventStatus.closed:
        return 'Đã đóng';
      case EventStatus.cancelled:
        return 'Đã hủy';
      case EventStatus.locked:
        return 'Bị khóa';
    }
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
          AppDateTimePicker(
            label: 'Mở đăng ký từ',
            value: _formCtrl.registerOpenTime.value,
            onChanged: _formCtrl.setRegisterOpenTime,
          ),
          const SizedBox(height: 12),
          AppDateTimePicker(
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
          _buildCategoryGroup('Lĩnh vực', [
            9,
            10,
            11,
            12,
            13,
            14,
            15,
            16
          ], [
            'Công nghệ',
            'Văn hóa - Nghệ thuật',
            'Kỹ năng mềm',
            'Khởi nghiệp',
            'Thể thao',
            'Định hướng nghề nghiệp',
            'Học thuật',
            'Tình nguyện',
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
                        onPressed: () => RequirementQuestionSheet.show(
                          context,
                          onSave: (q) => _formCtrl.addRequirementQuestion(q),
                        ),
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
                  return RequirementQuestionCard(
                    question: q,
                    onRemove: () => _formCtrl.removeRequirementQuestion(i),
                    onEdit: () => RequirementQuestionSheet.show(
                      context,
                      existing: q,
                      onSave: (updated) =>
                          _formCtrl.updateRequirementQuestion(i, updated),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => RequirementQuestionSheet.show(
                    context,
                    onSave: (q) => _formCtrl.addRequirementQuestion(q),
                  ),
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

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: const [
        BoxShadow(color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 8)
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
