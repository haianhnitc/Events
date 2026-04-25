import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/common/presentation/widget/avatar_upload_widget.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_profile_controller.dart';
import 'package:events_app/feature/user_management/domain/entity/organization_profile_entity.dart';
import 'package:events_app/routes/navbar/organizer_nav_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrganizerProfilePage extends StatefulWidget {
  const OrganizerProfilePage({super.key});

  @override
  State<OrganizerProfilePage> createState() => _OrganizerProfilePageState();
}

class _OrganizerProfilePageState extends State<OrganizerProfilePage> {
  late OrganizerProfileController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(OrganizerProfileController());
    final auth = Get.find<AuthController>();
    final user = auth.currentUser.value;
    if (user != null) {
      _controller.initWithProfile(OrganizationProfileEntity(
        userId: user.userId,
        organizationName: user.organizationProfile?.organizationName ?? user.userProfile?.fullName ?? 'Tổ chức',
        description: user.organizationProfile?.description,
        address: user.organizationProfile?.address,
        logoUrl: user.organizationProfile?.logoUrl ?? user.userProfile?.avatarUrl,
      ));
    }
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
        title: const Text(
          'Hồ sơ tổ chức',
          style: TextStyle(color: Color(0xff273143), fontSize: 17, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              final auth = Get.find<AuthController>();
              final orgId = auth.currentUser.value?.userId;
              if (orgId != null) {
                _controller.updateProfile(orgId);
              }
            },
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
        child: Form(
          key: _controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLogoSection(),
              const SizedBox(height: 24),
              _buildTextField(
                label: 'Tên tổ chức',
                controller: _controller.organizationNameController,
                validator: _controller.validateOrganizationName,
                hint: 'Nhập tên tổ chức của bạn',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Mô tả',
                controller: _controller.descriptionController,
                validator: _controller.validateDescription,
                hint: 'Mô tả về tổ chức',
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Địa chỉ',
                controller: _controller.addressController,
                validator: _controller.validateAddress,
                hint: 'Nhập địa chỉ tổ chức',
              ),
              const SizedBox(height: 24),
              _buildMenuSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 8)],
      ),
      child: Column(
        children: [
          Obx(() => AvatarUploadWidget(
                previewUrl: _controller.logoPreviewUrl.value,
                fileType: FileType.organizationLogo,
                radius: 44,
                onSuccess: (fileId, url) => _controller.onLogoUploaded(fileId, url),
              )),
          const SizedBox(height: 12),
          const Text(
            'Logo tổ chức',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xff273143)),
          ),
          const SizedBox(height: 4),
          Text(
            'Nhấn để thay đổi logo',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    String? hint,
    int maxLines = 1,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xff475569)),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            validator: validator,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF06B6D4), width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 8)],
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
          const Divider(height: 1),
          _buildMenuItem(
            icon: Icons.logout,
            label: 'Đăng xuất',
            iconColor: const Color(0xFFEF4444),
            textColor: const Color(0xFFEF4444),
            onTap: () async {
              final confirmed = await Get.dialog<bool>(
                AlertDialog(
                  title: const Text('Đăng xuất'),
                  content: const Text('Bạn có chắc muốn đăng xuất không?'),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(result: false),
                      child: const Text('Hủy'),
                    ),
                    TextButton(
                      onPressed: () => Get.back(result: true),
                      child: const Text('Đăng xuất', style: TextStyle(color: Color(0xFFEF4444))),
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
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textColor),
                ),
              ),
              Icon(Icons.chevron_right, size: 20, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
