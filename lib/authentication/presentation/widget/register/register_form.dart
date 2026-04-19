import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/authentication/presentation/widget/terms_privacy_dialog.dart';
import 'package:events_app/common/presentation/widget/avatar_upload_widget.dart';
import 'package:events_app/common/presentation/widget/custom_text_field.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterForm extends StatefulWidget {
  final bool isStudent;
  final bool isGoogleRegister;

  const RegisterForm({
    super.key,
    required this.isStudent,
    this.isGoogleRegister = false,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool _isTermsAccepted = false;

  @override
  Widget build(BuildContext context) {
    final authController = AuthController.to;

    return Obx(
      () => Form(
        key: widget.isStudent
            ? authController.registerStudentFormKey
            : authController.registerOrganizerFormKey,
        child: widget.isStudent
            ? _buildStudentForm(context, authController)
            : _buildOrganizerForm(context, authController),
      ),
    );
  }

  Widget _buildStudentForm(
      BuildContext context, AuthController authController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildAvatarUploadSection(authController),
        const SizedBox(height: 14),
        _buildSectionTitle('Thông tin cá nhân'),
        const SizedBox(height: 14),
        CustomTextField(
          controller: authController.registerFullNameController,
          labelText: 'Họ và tên',
          hintText: 'Nhập họ và tên',
          textInputAction: TextInputAction.next,
          prefixIcon: const Icon(Icons.person_outline,
              size: 20, color: Color(0xff94A3B8)),
          validator: authController.validateFullName,
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: CustomDropdownField<String>(
                value: authController.selectedGender.value,
                labelText: 'Giới tính',
                prefixIcon: const Icon(Icons.wc_outlined,
                    size: 20, color: Color(0xff94A3B8)),
                items: const [
                  DropdownMenuItem(value: 'NAM', child: Text('Nam')),
                  DropdownMenuItem(value: 'NU', child: Text('Nữ')),
                  DropdownMenuItem(value: 'KHAC', child: Text('Khác')),
                ],
                onChanged: authController.setSelectedGender,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildDateField(context, authController),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSectionTitle('Thông tin học tập'),
        const SizedBox(height: 14),
        CustomTextField(
          controller: authController.registerUniversityController,
          labelText: 'Trường đại học',
          hintText: 'Chọn hoặc nhập trường',
          textInputAction: TextInputAction.next,
          prefixIcon: const Icon(Icons.school_outlined,
              size: 20, color: Color(0xff94A3B8)),
        ),
        const SizedBox(height: 14),
        CustomTextField(
          controller: authController.registerStudentIdController,
          labelText: 'Mã sinh viên',
          hintText: 'VD: B21DCCN001',
          textInputAction: TextInputAction.next,
          prefixIcon: const Icon(Icons.badge_outlined,
              size: 20, color: Color(0xff94A3B8)),
        ),
        if (!widget.isGoogleRegister) ...[
          const SizedBox(height: 24),
          _buildSectionTitle('Tài khoản'),
          const SizedBox(height: 14),
          CustomTextField(
            controller: authController.registerEmailController,
            labelText: 'Email',
            hintText: 'email@example.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(Icons.mail_outline,
                size: 20, color: Color(0xff94A3B8)),
            validator: authController.validateEmail,
          ),
          const SizedBox(height: 14),
          CustomTextField(
            controller: authController.registerPasswordController,
            labelText: 'Mật khẩu',
            hintText: 'Nhập mật khẩu',
            obscureText: authController.registerObscurePassword.value,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(Icons.lock_outline,
                size: 20, color: Color(0xff94A3B8)),
            suffixIcon: IconButton(
              onPressed: authController.toggleRegisterPasswordVisibility,
              icon: Icon(
                authController.registerObscurePassword.value
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
                color: const Color(0xff94A3B8),
              ),
            ),
            validator: authController.validateRegisterPassword,
          ),
          const SizedBox(height: 14),
          CustomTextField(
            controller: authController.registerConfirmPasswordController,
            labelText: 'Xác nhận mật khẩu',
            hintText: 'Nhập lại mật khẩu',
            obscureText: authController.registerObscureConfirmPassword.value,
            textInputAction: TextInputAction.done,
            prefixIcon: const Icon(Icons.lock_outline,
                size: 20, color: Color(0xff94A3B8)),
            suffixIcon: IconButton(
              onPressed: authController.toggleRegisterConfirmPasswordVisibility,
              icon: Icon(
                authController.registerObscureConfirmPassword.value
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
                color: const Color(0xff94A3B8),
              ),
            ),
            validator: authController.validateRegisterConfirmPassword,
          ),
        ],
        const SizedBox(height: 20),
        _buildTermsSection(),
        const SizedBox(height: 20),
        _buildSubmitButton(authController),
      ],
    );
  }

  Widget _buildOrganizerForm(
      BuildContext context, AuthController authController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('Thông tin tổ chức'),
        const SizedBox(height: 14),
        CustomTextField(
          controller: authController.organizationNameController,
          labelText: 'Tên tổ chức',
          hintText: 'Tên công ty hoặc câu lạc bộ',
          textInputAction: TextInputAction.next,
          prefixIcon: const Icon(Icons.business_outlined,
              size: 20, color: Color(0xff94A3B8)),
          validator: authController.validateOrganizationName,
        ),
        const SizedBox(height: 14),
        CustomDropdownField<String>(
          value: authController.organizationType.value.name,
          labelText: 'Loại tổ chức',
          prefixIcon: const Icon(Icons.category_outlined,
              size: 20, color: Color(0xff94A3B8)),
          items: const [
            DropdownMenuItem(
                value: 'university', child: Text('Trường đại học')),
            DropdownMenuItem(value: 'club', child: Text('Câu lạc bộ')),
            DropdownMenuItem(value: 'company', child: Text('Công ty')),
          ],
          onChanged: (value) {
            if (value != null) {
              final type = OrganizationType.values.firstWhere(
                (e) => e.name == value,
                orElse: () => OrganizationType.club,
              );
              authController.setOrganizationType(type);
            }
          },
        ),
        const SizedBox(height: 14),
        _buildLogoUploadSection(authController),
        const SizedBox(height: 14),
        CustomTextField(
          controller: authController.organizationAddressController,
          labelText: 'Địa chỉ',
          hintText: 'Địa chỉ trụ sở',
          textInputAction: TextInputAction.next,
          prefixIcon: const Icon(Icons.location_on_outlined,
              size: 20, color: Color(0xff94A3B8)),
        ),
        const SizedBox(height: 14),
        CustomTextField(
          controller: authController.organizationDescriptionController,
          labelText: 'Mô tả',
          hintText: 'Giới thiệu ngắn về tổ chức',
          maxLines: 3,
          textInputAction: TextInputAction.next,
          prefixIcon: const Icon(Icons.description_outlined,
              size: 20, color: Color(0xff94A3B8)),
        ),
        const SizedBox(height: 24),
        _buildSectionTitle('Tài khoản'),
        const SizedBox(height: 14),
        CustomTextField(
          controller: authController.registerEmailController,
          labelText: 'Email',
          hintText: 'Email đăng nhập',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          prefixIcon: const Icon(Icons.mail_outline,
              size: 20, color: Color(0xff94A3B8)),
          validator: authController.validateEmail,
        ),
        const SizedBox(height: 14),
        CustomTextField(
          controller: authController.registerPhoneController,
          labelText: 'Số điện thoại',
          hintText: 'Số điện thoại liên hệ',
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          prefixIcon: const Icon(Icons.phone_outlined,
              size: 20, color: Color(0xff94A3B8)),
        ),
        const SizedBox(height: 14),
        CustomTextField(
          controller: authController.registerPasswordController,
          labelText: 'Mật khẩu',
          hintText: 'Nhập mật khẩu',
          obscureText: authController.registerObscurePassword.value,
          textInputAction: TextInputAction.next,
          prefixIcon: const Icon(Icons.lock_outline,
              size: 20, color: Color(0xff94A3B8)),
          suffixIcon: IconButton(
            onPressed: authController.toggleRegisterPasswordVisibility,
            icon: Icon(
              authController.registerObscurePassword.value
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 20,
              color: const Color(0xff94A3B8),
            ),
          ),
          validator: authController.validateRegisterPassword,
        ),
        const SizedBox(height: 14),
        CustomTextField(
          controller: authController.registerConfirmPasswordController,
          labelText: 'Xác nhận mật khẩu',
          hintText: 'Nhập lại mật khẩu',
          obscureText: authController.registerObscureConfirmPassword.value,
          textInputAction: TextInputAction.done,
          prefixIcon: const Icon(Icons.lock_outline,
              size: 20, color: Color(0xff94A3B8)),
          suffixIcon: IconButton(
            onPressed: authController.toggleRegisterConfirmPasswordVisibility,
            icon: Icon(
              authController.registerObscureConfirmPassword.value
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 20,
              color: const Color(0xff94A3B8),
            ),
          ),
          validator: authController.validateRegisterConfirmPassword,
        ),
        const SizedBox(height: 24),
        _buildSectionTitle('Xác minh tổ chức'),
        const SizedBox(height: 14),
        const Text(
          'Tải lên ít nhất 1 tài liệu xác minh để hoàn tất đăng ký',
          style: TextStyle(fontSize: 13, color: Color(0xff64748B)),
        ),
        const SizedBox(height: 14),
        _buildDocumentUploadSection(authController, context),
        const SizedBox(height: 20),
        _buildTermsSection(),
        const SizedBox(height: 20),
        _buildSubmitButton(authController),
      ],
    );
  }

  Widget _buildAvatarUploadSection(AuthController authController) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Obx(() => AvatarUploadWidget(
                previewUrl: authController.registerAvatarPreviewUrl.value,
                fileType: FileType.avatar,
                radius: 36,
                onSuccess: (fileId, url) =>
                    authController.onAvatarUploadedInRegister(fileId, url),
              )),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ảnh đại diện',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff273143),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Nhấn để tải ảnh lên (tùy chọn)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xff94A3B8)),
        ],
      ),
    );
  }

  Widget _buildLogoUploadSection(AuthController authController) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Obx(() => AvatarUploadWidget(
                previewUrl: authController.registerLogoPreviewUrl.value,
                fileType: FileType.organizationLogo,
                radius: 36,
                onSuccess: (fileId, url) =>
                    authController.onLogoUploadedInRegister(fileId, url),
              )),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Logo tổ chức',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff273143),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Nhấn để tải logo lên (tùy chọn)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xff94A3B8)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xff273143),
      ),
    );
  }

  Widget _buildDateField(BuildContext context, AuthController authController) {
    final birthDate = authController.selectedBirthDate.value;
    final hasValue = birthDate != null;

    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: birthDate ??
              DateTime.now().subtract(const Duration(days: 365 * 18)),
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Color(0xff06B6D4),
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: Color(0xff273143),
                ),
                dialogTheme: DialogThemeData(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              child: child!,
            );
          },
        );
        if (date != null) {
          authController.setSelectedBirthDate(date);
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 20, color: Color(0xff94A3B8)),
                const SizedBox(width: 12),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      hasValue
                          ? '${birthDate.day.toString().padLeft(2, '0')}/${birthDate.month.toString().padLeft(2, '0')}/${birthDate.year}'
                          : 'Ngày sinh',
                      key: ValueKey(hasValue),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            hasValue ? FontWeight.w400 : FontWeight.normal,
                        color: hasValue
                            ? const Color(0xff273143)
                            : Colors.grey.shade400,
                        letterSpacing: hasValue ? 0.5 : 0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          hasValue
              ? Positioned(
                  left: 12,
                  top: -9,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    color: Colors.white,
                    child: const Text(
                      'Ngày sinh',
                      style: TextStyle(
                        color: Color(0xff64748B),
                        fontSize: 10,
                      ),
                    ),
                  ),
                )
              : const SizedBox(height: 0)
        ],
      ),
    );
  }

  Widget _buildTermsSection() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isTermsAccepted = !_isTermsAccepted;
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            margin: const EdgeInsets.only(right: 12, top: 1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: _isTermsAccepted
                    ? const Color(0xff06B6D4)
                    : Colors.grey.shade400,
                width: 1.5,
              ),
              color: _isTermsAccepted
                  ? const Color(0xff06B6D4)
                  : Colors.transparent,
            ),
            child: _isTermsAccepted
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xff64748B),
                  height: 1.4,
                ),
                children: [
                  const TextSpan(text: 'Tôi đồng ý với '),
                  TextSpan(
                    text: 'Điều khoản dịch vụ',
                    style: const TextStyle(
                      color: Color(0xff06B6D4),
                      fontWeight: FontWeight.w500,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _showTermsDialog(),
                  ),
                  const TextSpan(text: ' và '),
                  TextSpan(
                    text: 'Chính sách bảo mật',
                    style: const TextStyle(
                      color: Color(0xff06B6D4),
                      fontWeight: FontWeight.w500,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _showPrivacyDialog(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog() {
    TermsOfServiceDialog.show(context);
  }

  void _showPrivacyDialog() {
    PrivacyPolicyDialog.show(context);
  }

  Widget _buildDocumentUploadSection(
      AuthController authController, BuildContext context) {
    return Obx(() {
      final uploadedDocs = authController.uploadedVerificationDocs;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () => _showDocumentTypePicker(context, authController),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xfff8fafc),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey.shade200,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 32,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Nhấn để tải lên tài liệu',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xff64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'PDF, JPG, PNG (tối đa 5MB)',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (uploadedDocs.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...uploadedDocs
                .map((doc) => _buildDocumentItem(doc, authController)),
          ],
        ],
      );
    });
  }

  Widget _buildDocumentItem(
      Map<String, dynamic> doc, AuthController authController) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xffe0f2fe),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.description_outlined,
              color: Color(0xff06B6D4),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc['fileName'] ?? 'Tài liệu',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff273143),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  doc['type'] ?? 'Tài liệu xác minh',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => authController.removeVerificationDoc(doc['id']),
            icon: Icon(
              Icons.close,
              size: 18,
              color: Colors.grey.shade400,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  void _showDocumentTypePicker(
      BuildContext context, AuthController authController) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Chọn loại tài liệu',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff273143),
              ),
            ),
            const SizedBox(height: 16),
            _buildDocTypeOption(
              'Giấy phép kinh doanh',
              Icons.business,
              () {
                Navigator.pop(context);
                authController.uploadVerificationDocument('BUSINESS_LICENSE');
              },
            ),
            _buildDocTypeOption(
              'Quyết định của trường đại học',
              Icons.school,
              () {
                Navigator.pop(context);
                authController
                    .uploadVerificationDocument('UNIVERSITY_DECISION');
              },
            ),
            _buildDocTypeOption(
              'Giấy phép thành lập câu lạc bộ',
              Icons.groups,
              () {
                Navigator.pop(context);
                authController.uploadVerificationDocument('CLUB_CERTIFICATE');
              },
            ),
            _buildDocTypeOption(
              'Mã số thuế',
              Icons.receipt_long,
              () {
                Navigator.pop(context);
                authController.uploadVerificationDocument('TAX_CODE');
              },
            ),
            _buildDocTypeOption(
              'Loại khác',
              Icons.folder,
              () {
                Navigator.pop(context);
                authController.uploadVerificationDocument('OTHER');
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildDocTypeOption(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: const Color(0xff64748B)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xff273143),
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(AuthController authController) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: _isTermsAccepted && !authController.isLoading.value
            ? () {
                if (widget.isGoogleRegister) {
                  authController.submitGoogleRegister(
                      isStudent: widget.isStudent);
                } else {
                  authController.submitRegister(isStudent: widget.isStudent);
                }
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff06B6D4),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade300,
          disabledForegroundColor: Colors.grey.shade500,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child: authController.isLoading.value
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tạo tài khoản',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 18),
                ],
              ),
      ),
    );
  }
}
