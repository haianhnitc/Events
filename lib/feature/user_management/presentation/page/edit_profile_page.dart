import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/common/presentation/widget/avatar_upload_widget.dart';
import 'package:events_app/common/presentation/widget/custom_text_field.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
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
            fontSize: 17,
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
          return const Center(child: Text('Không tìm thấy thông tin người dùng.'));
        }

        final isOrganization = user.role == UserRole.organization;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAvatarSection(),
                const SizedBox(height: 20),
                if (isOrganization) ...[
                  _buildSectionTitle('Thông tin tổ chức'),
                  const SizedBox(height: 12),
                  ..._buildOrganizationFields(),
                ] else ...[
                  _buildSectionTitle('Thông tin cá nhân'),
                  const SizedBox(height: 12),
                  ..._buildUserFields(),
                ],
                const SizedBox(height: 24),
                _buildSubmitButton(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xff273143),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 8),
        ],
      ),
      child: Column(
        children: [
          Obx(() => AvatarUploadWidget(
                previewUrl: _controller.avatarPreviewUrl.value,
                fileType: FileType.avatar,
                radius: 44,
                onSuccess: (fileId, url) => _controller.onAvatarUploaded(fileId, url),
              )),
          const SizedBox(height: 10),
          const Text(
            'Nhấn vào biểu tượng máy ảnh để đổi ảnh',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xff67688C),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildUserFields() {
    return [
      _buildCard([
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
      ]),
    ];
  }

  List<Widget> _buildOrganizationFields() {
    return [
      _buildCard([
        CustomTextField(
          controller: _controller.addressController,
          labelText: 'Địa chỉ trụ sở (tùy chọn)',
          hintText: 'Nhập địa chỉ trụ sở',
          prefixIcon: const Icon(Icons.location_on_outlined,
              color: Color(0xff64748B), size: 20),
          validator: _controller.validateAddress,
          textInputAction: TextInputAction.next,
          maxLines: 2,
        ),
        const SizedBox(height: 14),
        _buildLogoUploadSection(),
        const SizedBox(height: 14),
        CustomTextField(
          controller: _controller.descriptionController,
          labelText: 'Mô tả (tùy chọn)',
          hintText: 'Nhập mô tả về tổ chức',
          prefixIcon: const Icon(Icons.description_outlined,
              color: Color(0xff64748B), size: 20),
          validator: _controller.validateDescription,
          textInputAction: TextInputAction.done,
          maxLines: 4,
        ),
      ]),
    ];
  }

  Widget _buildLogoUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Logo tổ chức',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xff64748B),
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => AvatarUploadWidget(
              previewUrl: _controller.logoPreviewUrl.value,
              fileType: FileType.organizationLogo,
              radius: 40,
              onSuccess: (fileId, url) => _controller.onLogoUploaded(fileId, url),
            )),
      ],
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 8),
        ],
      ),
      child: Column(children: children),
    );
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
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
      initialDate: _controller.selectedBirthDate.value ?? DateTime(now.year - 20),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
      );
    });
  }
}
