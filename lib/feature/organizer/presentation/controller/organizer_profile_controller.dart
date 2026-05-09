import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/feature/organizer/organization/domain/usecase/organizer_organization_usecase.dart';
import 'package:events_app/feature/organizer/organization/domain/usecase/organization_params.dart';
import 'package:events_app/feature/user_management/domain/entity/organization_profile_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrganizerProfileController extends GetxController {
  UpdateOrganizerProfileUsecase get _updateProfileUsecase =>
      networkGetIt<UpdateOrganizerProfileUsecase>();

  final formKey = GlobalKey<FormState>();
  final addressController = TextEditingController();
  final descriptionController = TextEditingController();

  final RxBool isSubmitting = false.obs;

  final Rx<int?> logoFileId = Rx<int?>(null);
  final Rx<String?> logoPreviewUrl = Rx<String?>(null);

  final Rx<OrganizationProfileEntity?> orgProfile =
      Rx<OrganizationProfileEntity?>(null);

  @override
  void onClose() {
    addressController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void loadProfile() {
    final user = AuthController.to.currentUser.value;
    if (user == null) return;

    final org = user.organizationProfile;
    orgProfile.value = org;

    addressController.text = org?.address ?? '';
    descriptionController.text = org?.description ?? '';
    logoFileId.value = null;
    logoPreviewUrl.value = org?.logoUrl;
  }

  void onLogoUploaded(int fileId, String url) {
    logoFileId.value = fileId;
    logoPreviewUrl.value = url;
  }

  Future<void> showResetPasswordDialog(BuildContext context) async {
    final auth = AuthController.to;
    final emailController =
        TextEditingController(text: auth.loginEmailController.text);
    final resetFormKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Đặt lại mật khẩu'),
        content: Form(
          key: resetFormKey,
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
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Vui lòng nhập email';
                  }
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
                onPressed: auth.isLoadingEmail.value
                    ? null
                    : () async {
                        if (!resetFormKey.currentState!.validate()) return;
                        Navigator.pop(ctx);
                        await auth.sendResetPasswordEmail(
                            email: emailController.text.trim());
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF06B6D4),
                ),
                child: auth.isLoadingEmail.value
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Gửi',
                        style: TextStyle(color: Colors.white)),
              )),
        ],
      ),
    );

    emailController.dispose();
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    if (isSubmitting.value) return;

    final userId = AuthController.to.currentUser.value?.userId;
    if (userId == null) return;

    isSubmitting.value = true;

    final result = await _updateProfileUsecase(UpdateOrganizerProfileParams(
      organizationId: userId,
      params: OrganizationProfileUpdateParams(
        address: addressController.text.isEmpty
            ? null
            : addressController.text,
        logoFileId: logoFileId.value,
        description: descriptionController.text.isEmpty
            ? null
            : descriptionController.text,
      ),
    ));

    result.fold(
      (failure) {
        _handleFailure(failure);
        isSubmitting.value = false;
      },
      (updated) {
        isSubmitting.value = false;
        if (updated != null) {
          orgProfile.value = updated;
          AuthController.to.currentUser.value =
              AuthController.to.currentUser.value?.copyWith(
            organizationProfile: updated,
          );
          AppSnackbarUtils.showSuccess(
              'Thành công', 'Cập nhật hồ sơ thành công');
        }
      },
    );
  }

  String? validateAddress(String? value) {
    if (value == null || value.isEmpty) return null;
    if (value.length > 500) return 'Địa chỉ không quá 500 ký tự';
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.isEmpty) return null;
    if (value.length > 1000) return 'Mô tả không quá 1000 ký tự';
    return null;
  }

  void _handleFailure(FailureEntity failure) {
    AuthController.handleFailure(failure);
  }
}
