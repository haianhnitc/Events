import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/usecase/upload_file_params.dart';
import 'package:events_app/feature/common/usecase/upload_file_usecase.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/common/utils/upload_helper.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/user_management/domain/entity/organization_profile_entity.dart';
import 'package:events_app/feature/organizer/organization/domain/usecase/organizer_organization_usecase.dart';
import 'package:events_app/feature/organizer/organization/domain/usecase/organization_params.dart';

class OrganizerProfileController extends GetxController {
  UpdateOrganizerProfileUsecase get _updateProfileUsecase =>
      networkGetIt<UpdateOrganizerProfileUsecase>();
  UploadFileUsecase get _uploadFileUsecase =>
      networkGetIt<UploadFileUsecase>();

  final formKey = GlobalKey<FormState>();
  final organizationNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final addressController = TextEditingController();

  final RxBool isSubmitting = false.obs;
  final RxBool isUploadingLogo = false.obs;
  final Rx<String?> logoUrl = Rx<String?>(null);
  final Rx<OrganizationProfileEntity?> profile = Rx<OrganizationProfileEntity?>(null);

  final ImagePickerService _imagePickerService = ImagePickerService();

  @override
  void onClose() {
    organizationNameController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    super.onClose();
  }

  void initWithProfile(OrganizationProfileEntity p) {
    profile.value = p;
    organizationNameController.text = p.organizationName ?? '';
    descriptionController.text = p.description ?? '';
    addressController.text = p.address ?? '';
    logoUrl.value = p.logoUrl;
  }

  void selectLogoUrl(String url) { logoUrl.value = url; }

  Future<void> pickAndUploadLogo() async {
    if (isUploadingLogo.value) return;

    final result = await _imagePickerService.pickSingleImage();
    if (result == null) return;

    isUploadingLogo.value = true;
    AppSnackbarUtils.showInfo('Đang tải lên', 'Đang xử lý logo...');

    final uploadResult = await _uploadFileUsecase(UploadFileParams(
      filePath: result.filePath,
      fileType: FileType.organizationLogo,
    ));

    uploadResult.fold(
      (failure) {
        final message = failure.when(
          serverFailure: (_, msg) => msg,
          dataParsingFailure: () => 'Lỗi xử lý dữ liệu',
          noConnectionFailure: () => 'Không có kết nối mạng',
          systemFailure: (_, msg) => msg,
        );
        AppSnackbarUtils.showError('Tải lên thất bại', message ?? 'Lỗi');
        isUploadingLogo.value = false;
      },
      (fileEntity) {
        logoUrl.value = fileEntity.url;
        AppSnackbarUtils.showSuccess('Thành công', 'Logo đã được tải lên');
        isUploadingLogo.value = false;
      },
    );
  }

  Future<void> showResetPasswordDialog(BuildContext context) async {
    final auth = AuthController.to;
    final emailController = TextEditingController(text: auth.loginEmailController.text);
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Đặt lại mật khẩu'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nhập email đã đăng ký để nhận liên kết đặt lại mật khẩu.',
                style: TextStyle(fontSize: 13, color: Color(0xff64748B)),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Vui lòng nhập email';
                  if (!v.contains('@')) return 'Email không hợp lệ';
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          Obx(() => ElevatedButton(
                onPressed: auth.isLoading.value
                    ? null
                    : () async {
                        if (!formKey.currentState!.validate()) return;
                        Navigator.pop(ctx);
                        await auth.sendResetPasswordEmail(email: emailController.text.trim());
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF06B6D4),
                ),
                child: auth.isLoading.value
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Gửi', style: TextStyle(color: Colors.white)),
              )),
        ],
      ),
    );

    emailController.dispose();
  }

  Future<void> updateProfile(int organizationId) async {
    if (!formKey.currentState!.validate()) return;
    if (isSubmitting.value) return;
    isSubmitting.value = true;

    final result = await _updateProfileUsecase(UpdateOrganizerProfileParams(
      organizationId: organizationId,
      params: OrganizationProfileUpdateParams(
        organizationName: organizationNameController.text,
        description: descriptionController.text.isEmpty ? null : descriptionController.text,
        address: addressController.text.isEmpty ? null : addressController.text,
        logoUrl: logoUrl.value,
      ),
    ));

    result.fold(
      (failure) {
        _handleFailure(failure);
        isSubmitting.value = false;
      },
      (updated) {
        AppSnackbarUtils.showSuccess('Thành công', 'Cập nhật hồ sơ thành công');
        profile.value = updated;
        isSubmitting.value = false;
        Get.back();
      },
    );
  }

  String? validateOrganizationName(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập tên tổ chức';
    if (value.length < 3) return 'Tên tổ chức phải có ít nhất 3 ký tự';
    if (value.length > 200) return 'Tên tổ chức không được quá 200 ký tự';
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập mô tả';
    if (value.length < 10) return 'Mô tả phải có ít nhất 10 ký tự';
    if (value.length > 1000) return 'Mô tả không được quá 1000 ký tự';
    return null;
  }

  String? validateAddress(String? value) {
    if (value == null || value.isEmpty) return null;
    if (value.length < 10) return 'Địa chỉ phải có ít nhất 10 ký tự';
    if (value.length > 500) return 'Địa chỉ không được quá 500 ký tự';
    return null;
  }

  String? validateLogoUrl(String? value) {
    if (value == null || value.isEmpty) return null;
    final uri = Uri.tryParse(value);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      return 'Đường dẫn logo không hợp lệ';
    }
    return null;
  }

  void _handleFailure(FailureEntity failure) {
    failure.when(
      serverFailure: (_, message) => AppSnackbarUtils.showError('Lỗi', message ?? 'Cập nhật thất bại'),
      dataParsingFailure: () => AppSnackbarUtils.showError('Lỗi', 'Không đọc được dữ liệu'),
      noConnectionFailure: () => AppSnackbarUtils.showError('Lỗi', 'Không có kết nối mạng'),
      systemFailure: (_, message) => AppSnackbarUtils.showError('Lỗi', message ?? 'Lỗi hệ thống'),
    );
  }
}
