import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/common/presentation/widget/avatar_upload_widget.dart';
import 'package:events_app/common/presentation/widget/custom_text_field.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/user_management/domain/entity/user_entity.dart';
import 'package:events_app/feature/user_management/domain/entity/organization_profile_entity.dart';
import 'package:events_app/feature/user_management/presentation/controller/my_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final MyProfileController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(MyProfileController());
    _controller.loadUser();
  }

  @override
  void dispose() {
    Get.delete<MyProfileController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff64748B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Chỉnh sửa hồ sơ',
          style: TextStyle(
            color: Color(0xff273143),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final user = AuthController.to.currentUser.value;
        if (user == null) {
          return const Center(
              child: Text('Không tìm thấy thông tin người dùng.'));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _controller.formKey,
            child: Column(
              children: [
                _buildAvatarSection(user),
                const SizedBox(height: 16),
                _buildInfoSection(user),
                const SizedBox(height: 16),
                _buildEditableFieldsSection(user),
                const SizedBox(height: 16),
                _buildSubmitButton(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildAvatarSection(UserEntity user) {
    final isOrg = user.role == UserRole.organization;
    final previewUrl =
        isOrg ? user.organizationProfile?.logoUrl : user.userProfile?.avatarUrl;

    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 8),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AvatarUploadWidget(
              previewUrl: previewUrl,
              fileType: isOrg ? FileType.organizationLogo : FileType.avatar,
              radius: 52,
              onSuccess: (fileId, url) {
                if (isOrg) {
                  _controller.logoFileId.value = fileId;
                  _controller.logoPreviewUrl.value = url;
                } else {
                  _controller.onAvatarUploaded(fileId, url);
                }
              },
            ),
            const SizedBox(height: 12),
            Text(
              'Nhấn vào biểu tượng máy ảnh để đổi ${isOrg ? 'logo' : 'ảnh đại diện'}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Color(0xff67688C)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(UserEntity user) {
    final isOrg = user.role == UserRole.organization;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            isOrg ? 'Thông tin tổ chức' : 'Thông tin cá nhân',
            Icons.person_outlined,
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: const Color(0x0F273143)),
          const SizedBox(height: 12),
          if (isOrg)
            _buildOrgInfoList(user.organizationProfile)
          else
            _buildUserInfoList(user),
        ],
      ),
    );
  }

  Widget _buildUserInfoList(UserEntity user) {
    final profile = user.userProfile;
    return Column(
      children: [
        _infoRow('Họ tên', profile?.fullName ?? '—', isEditable: true),
        _infoRow('Giới tính', profile?.gender ?? '—', isEditable: true),
        _infoRow('Ngày sinh', _formatBirthDate(profile?.dateOfBirth),
            isEditable: true),
        const SizedBox(height: 12),
        Container(height: 1, color: const Color(0x0F273143)),
        const SizedBox(height: 12),
        _infoRow('Email', user.email),
        _infoRow('Mã sinh viên', profile?.studentCode ?? '—'),
        _infoRow('Trường đại học', profile?.university ?? '—'),
        _infoRow('Khoa', profile?.faculty ?? '—'),
        _infoRow('Ngành học', profile?.major ?? '—'),
      ],
    );
  }

  Widget _buildOrgInfoList(OrganizationProfileEntity? org) {
    return Column(
      children: [
        _infoRow('Địa chỉ trụ sở', org?.address ?? '—', isEditable: true),
        _infoRow('Mô tả', org?.description ?? '—',
            isEditable: true, maxLines: 3),
        const SizedBox(height: 12),
        Container(height: 1, color: const Color(0x0F273143)),
        const SizedBox(height: 12),
        _infoRow('Tên tổ chức', org?.organizationName ?? '—'),
        _infoRow('Loại hình', _orgTypeLabel(org?.organizationType)),
        _infoRow(
            'Trạng thái xác minh', _verificationLabel(org?.verificationStatus)),
      ],
    );
  }

  Widget _infoRow(String label, String value,
      {bool isEditable = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style:
                        const TextStyle(fontSize: 13, color: Color(0xff67688C)),
                  ),
                ),
                if (isEditable)
                  const Icon(Icons.edit, size: 12, color: Color(0xff06B6D4)),
                if (isEditable) const SizedBox(width: 4),
              ],
            ),
          ),
          Expanded(
            child: Text(
              value == '—' ? 'Chưa cập nhật' : value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: value == '—'
                    ? const Color(0xff67688C)
                    : const Color(0xff273143),
              ),
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xff06B6D4)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xff273143),
          ),
        ),
      ],
    );
  }

  Widget _buildEditableFieldsSection(UserEntity user) {
    final isOrg = user.role == UserRole.organization;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
              'Thông tin có thể chỉnh sửa', Icons.edit_outlined),
          const SizedBox(height: 12),
          Container(height: 1, color: const Color(0x0F273143)),
          const SizedBox(height: 12),
          if (isOrg)
            ..._buildOrgEditableFields()
          else
            ..._buildUserEditableFields(),
        ],
      ),
    );
  }

  List<Widget> _buildUserEditableFields() {
    return [
      CustomTextField(
        controller: _controller.fullNameController,
        labelText: 'Họ tên',
        hintText: 'Nhập họ tên của bạn',
        prefixIcon: const Icon(Icons.person_outline,
            color: Color(0xff64748B), size: 20),
        validator: _controller.validateFullName,
        textInputAction: TextInputAction.next,
      ),
      const SizedBox(height: 14),
      _buildGenderDropdown(),
      const SizedBox(height: 14),
      _buildDatePicker(),
    ];
  }

  List<Widget> _buildOrgEditableFields() {
    return [
      CustomTextField(
        controller: _controller.addressController,
        labelText: 'Địa chỉ trụ sở',
        hintText: 'Nhập địa chỉ trụ sở',
        prefixIcon: const Icon(Icons.location_on_outlined,
            color: Color(0xff64748B), size: 20),
        validator: _controller.validateAddress,
        textInputAction: TextInputAction.next,
        maxLines: 2,
      ),
      const SizedBox(height: 14),
      CustomTextField(
        controller: _controller.descriptionController,
        labelText: 'Mô tả',
        hintText: 'Nhập mô tả về tổ chức',
        prefixIcon: const Icon(Icons.description_outlined,
            color: Color(0xff64748B), size: 20),
        validator: _controller.validateDescription,
        textInputAction: TextInputAction.done,
        maxLines: 4,
      ),
    ];
  }

  Widget _buildGenderDropdown() {
    return Obx(() {
      return CustomDropdownField<String>(
        value: _controller.selectedGender.value,
        labelText: 'Giới tính',
        items: const [
          DropdownMenuItem(value: 'NAM', child: Text('Nam')),
          DropdownMenuItem(value: 'NỮ', child: Text('Nữ')),
          DropdownMenuItem(value: 'KHÁC', child: Text('Khác')),
        ],
        onChanged: (value) => _controller.setGender(value),
      );
    });
  }

  Widget _buildDatePicker() {
    return Obx(() {
      final selectedDate = _controller.selectedBirthDate.value;
      return GestureDetector(
        onTap: () => _pickDate(context),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'Ngày sinh',
            prefixIcon: const Icon(Icons.cake_outlined,
                color: Color(0xff64748B), size: 20),
            suffixIcon: const Icon(Icons.calendar_today,
                color: Color(0xff64748B), size: 18),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          child: Text(
            selectedDate != null
                ? '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}'
                : 'Chọn ngày sinh',
            style: TextStyle(
              fontSize: 14,
              color: selectedDate != null
                  ? const Color(0xff273143)
                  : Colors.grey.shade400,
            ),
          ),
        ),
      );
    });
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate:
          _controller.selectedBirthDate.value ?? DateTime(now.year - 20),
      firstDate: DateTime(1950),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff06B6D4),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xff273143),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      _controller.setBirthDate(picked);
    }
  }

  Widget _buildSubmitButton() {
    return Obx(() {
      final isLoading = _controller.isSubmitting.value;
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: isLoading ? null : _controller.submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff06B6D4),
            disabledBackgroundColor: Colors.grey.shade300,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : const Text(
                  'Lưu thay đổi',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
        ),
      );
    });
  }

  String _formatBirthDate(DateTime? date) {
    if (date == null) return '—';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _orgTypeLabel(OrganizationType? type) {
    switch (type) {
      case OrganizationType.university:
        return 'Trường đại học';
      case OrganizationType.club:
        return 'Câu lạc bộ';
      case OrganizationType.company:
        return 'Công ty';
      default:
        return '—';
    }
  }

  String _verificationLabel(VerificationStatus? status) {
    switch (status) {
      case VerificationStatus.approved:
        return 'Đã phê duyệt';
      case VerificationStatus.pending:
        return 'Đang chờ';
      case VerificationStatus.rejected:
        return 'Bị từ chối';
      default:
        return '—';
    }
  }
}
