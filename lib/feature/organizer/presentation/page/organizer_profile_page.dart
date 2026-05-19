import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/common/presentation/widget/avatar_upload_widget.dart';
import 'package:events_app/common/presentation/widget/custom_text_field.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_profile_controller.dart';
import 'package:events_app/routes/navbar/organizer_nav_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrganizerProfilePage extends StatefulWidget {
  const OrganizerProfilePage({super.key});

  @override
  State<OrganizerProfilePage> createState() => _OrganizerProfilePageState();
}

class _OrganizerProfilePageState extends State<OrganizerProfilePage> {
  late final OrganizerProfileController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(OrganizerProfileController());
    _controller.loadProfile();
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
          'Hồ sơ tổ chức',
          style: TextStyle(
            color: Color(0xff273143),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _controller.submit,
            child: const Text(
              'Lưu',
              style: TextStyle(
                color: Color(0xFF06B6D4),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildLogoSection(),
            const SizedBox(height: 16),
            _buildReadOnlyInfoSection(),
            const SizedBox(height: 16),
            _buildEditableFieldsSection(),
            const SizedBox(height: 16),
            _buildMenuSection(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              offset: Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => AvatarUploadWidget(
                  previewUrl: _controller.logoPreviewUrl.value,
                  fileType: FileType.organizationLogo,
                  radius: 52,
                  onSuccess: (fileId, url) =>
                      _controller.onLogoUploaded(fileId, url),
                )),
            const SizedBox(height: 12),
            const Text(
              'Nhấn vào biểu tượng máy ảnh để đổi logo',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Color(0xff67688C)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyInfoSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Thông tin tổ chức', Icons.business_outlined),
          const SizedBox(height: 12),
          Container(height: 1, color: const Color(0x0F273143)),
          const SizedBox(height: 12),
          Obx(() {
            final org = _controller.orgProfile.value;
            return Column(
              children: [
                _infoRow(
                  'Tên tổ chức',
                  org?.organizationName ?? '—',
                ),
                _infoRow(
                  'Loại hình',
                  _orgTypeLabel(org?.organizationType),
                ),
                _infoRow(
                  'Trạng thái xác minh',
                  _verificationLabel(org?.verificationStatus),
                  valueColor: _verificationColor(org?.verificationStatus),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEditableFieldsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Form(
        key: _controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
                'Thông tin có thể chỉnh sửa', Icons.edit_outlined),
            const SizedBox(height: 12),
            Container(height: 1, color: const Color(0x0F273143)),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _controller.addressController,
              labelText: 'Địa chỉ trụ sở',
              hintText: 'Nhập địa chỉ trụ sở tổ chức',
              prefixIcon: const Icon(
                Icons.location_on_outlined,
                color: Color(0xff64748B),
                size: 20,
              ),
              validator: _controller.validateAddress,
              textInputAction: TextInputAction.next,
              maxLines: 2,
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: _controller.descriptionController,
              labelText: 'Mô tả',
              hintText: 'Mô tả về tổ chức của bạn',
              prefixIcon: const Icon(
                Icons.description_outlined,
                color: Color(0xff64748B),
                size: 20,
              ),
              validator: _controller.validateDescription,
              textInputAction: TextInputAction.done,
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.lock_outline,
            label: 'Đổi mật khẩu',
            onTap: () => _controller.showResetPasswordDialog(context),
          ),
          const Divider(height: 1),
          _buildMenuItem(
            icon: Icons.info_outline,
            label: 'Về ứng dụng',
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'Events App',
              applicationVersion: '1.0.0',
              applicationLegalese: '© 2026 Events App. All rights reserved.',
            ),
          ),
          // const Divider(height: 1),
          // _buildMenuItem(
          //   icon: Icons.key_rounded,
          //   label: '[DEV] Copy Token cho Postman',
          //   iconColor: const Color(0xFFB45309),
          //   textColor: const Color(0xFFB45309),
          //   onTap: () => AuthController.to.printAccessTokenForPostman(),
          // ),
          const Divider(height: 1),
          _buildMenuItem(
            icon: Icons.logout,
            label: 'Đăng xuất',
            iconColor: const Color(0xFFEF4444),
            textColor: const Color(0xFFEF4444),
            onTap: () async {
              final confirmed = await Get.dialog<bool>(
                AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.logout,
                          color: Color(0xFFEF4444),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Đăng xuất',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  content: const Text(
                    'Bạn có chắc muốn đăng xuất không?',
                    style: TextStyle(fontSize: 15),
                  ),
                  actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(result: false),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Hủy',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Get.back(result: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Đăng xuất',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                Get.find<AuthController>().logout();
                Get.find<OrganizerNavBarController>().reset();
              }
            },
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

  Widget _infoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: Color(0xff67688C)),
            ),
          ),
          Expanded(
            child: Text(
              value == '—' || value.isEmpty ? 'Chưa cập nhật' : value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: valueColor ??
                    (value == '—' || value.isEmpty
                        ? const Color(0xff67688C)
                        : const Color(0xff273143)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color iconColor = const Color(0xFF06B6D4),
    Color textColor = const Color(0xff273143),
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textColor),
                ),
              ),
              Icon(Icons.chevron_right, size: 20, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
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
        return 'Đang chờ xác minh';
      case VerificationStatus.rejected:
        return 'Bị từ chối';
      default:
        return '—';
    }
  }

  Color _verificationColor(VerificationStatus? status) {
    switch (status) {
      case VerificationStatus.approved:
        return const Color(0xFF22C55E);
      case VerificationStatus.pending:
        return const Color(0xFFF59E0B);
      case VerificationStatus.rejected:
        return const Color(0xFFEF4444);
      default:
        return const Color(0xff273143);
    }
  }
}
