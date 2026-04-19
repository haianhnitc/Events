import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/usecase/upload_file_params.dart';
import 'package:events_app/feature/common/usecase/upload_file_usecase.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/common/utils/upload_helper.dart';
import 'package:events_app/feature/user_management/domain/entity/user_entity.dart';
import 'package:events_app/feature/user_management/domain/usecase/update_current_user_usecase.dart';

class MyProfileController extends GetxController {
  UpdateCurrentUserUsecase get _updateUsecase =>
      networkGetIt<UpdateCurrentUserUsecase>();
  UploadFileUsecase get _uploadFileUsecase =>
      networkGetIt<UploadFileUsecase>();

  final formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final Rx<String?> selectedGender = Rx<String?>(null);
  final Rx<DateTime?> selectedBirthDate = Rx<DateTime?>(null);
  final Rx<int?> avatarFileId = Rx<int?>(null);

  final addressController = TextEditingController();
  final logoUrlController = TextEditingController();
  final descriptionController = TextEditingController();

  final RxBool isUploadingAvatar = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxBool isLoading = true.obs;

  final ImagePickerService _imagePickerService = ImagePickerService();

  @override
  void onClose() {
    fullNameController.dispose();
    addressController.dispose();
    logoUrlController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void _loadCurrentUser() {
    final user = AuthController.to.currentUser.value;
    if (user == null) {
      isLoading.value = false;
      return;
    }

    if (user.role == UserRole.organization) {
      _loadOrganization(user);
    } else {
      _loadUser(user);
    }

    isLoading.value = false;
  }

  void _loadUser(UserEntity user) {
    final profile = user.userProfile;
    fullNameController.text = profile?.fullName ?? '';
    selectedGender.value = profile?.gender;
    selectedBirthDate.value = profile?.dateOfBirth;
    avatarFileId.value = null;
  }

  String? get avatarUrl => AuthController.to.currentUser.value?.userProfile?.avatarUrl;

  void _loadOrganization(UserEntity user) {
    final org = user.organizationProfile;
    addressController.text = org?.address ?? '';
    logoUrlController.text = org?.logoUrl ?? '';
    descriptionController.text = org?.description ?? '';
  }

  void setGender(String? gender) { selectedGender.value = gender; }

  void setBirthDate(DateTime? date) { selectedBirthDate.value = date; }

  void setLogoUrl(String? url) { logoUrlController.text = url ?? ''; }

  Future<void> pickAndUploadAvatar() async {
    if (isUploadingAvatar.value) return;

    final result = await _imagePickerService.pickSingleImage();
    if (result == null) return;

    isUploadingAvatar.value = true;
    AppSnackbarUtils.showInfo('Đang tải lên', 'Đang xử lý ảnh...');

    final uploadResult = await _uploadFileUsecase(
      UploadFileParams(
        filePath: result.filePath,
        fileType: FileType.avatar,
      ),
    );

    uploadResult.fold(
      (failure) {
        isUploadingAvatar.value = false;
        _handleFailure(failure);
      },
      (fileEntity) {
        avatarFileId.value = fileEntity.fileId;
        _updateUserAvatar(fileEntity.url);
      },
    );
  }

  Future<void> _updateUserAvatar(String? newUrl) async {
    final updateResult = await _updateUsecase(
      UpdateCurrentUserParams(avatarFileId: avatarFileId.value),
    );

    updateResult.fold(
      (failure) {
        isUploadingAvatar.value = false;
        _handleFailure(failure);
      },
      (updated) {
        isUploadingAvatar.value = false;
        if (updated != null) {
          AuthController.to.currentUser.value = updated;
          if (updated.role == UserRole.organization) {
            logoUrlController.text = updated.organizationProfile?.logoUrl ?? '';
          } else {
            // user avatarUrl sẽ được cập nhật tự động khi load lại
          }
          AppSnackbarUtils.showSuccess('Thành công', 'Cập nhật ảnh đại diện thành công.');
        }
      },
    );
  }

  String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Vui lòng nhập họ tên';
    if (value.trim().length < 2) return 'Họ tên tối thiểu 2 ký tự';
    if (value.trim().length > 100) return 'Họ tên không quá 100 ký tự';
    return null;
  }

  String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    if (value.trim().length > 500) return 'Địa chỉ không quá 500 ký tự';
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    if (value.trim().length > 1000) return 'Mô tả không quá 1000 ký tự';
    return null;
  }

  String? validateLogoUrl(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final uri = Uri.tryParse(value.trim());
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      return 'URL logo không hợp lệ';
    }
    return null;
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    if (isSubmitting.value) return;

    final user = AuthController.to.currentUser.value;
    if (user == null) return;

    final params = user.role == UserRole.organization
        ? _buildOrganizationParams()
        : _buildUserParams();

    if (params.isEmpty) {
      AppSnackbarUtils.showInfo('Không có thay đổi', 'Bạn chưa thay đổi thông tin nào.');
      return;
    }

    isSubmitting.value = true;

    final result = await _updateUsecase(params);

    result.fold(
      (failure) {
        isSubmitting.value = false;
        _handleFailure(failure);
      },
      (updated) {
        isSubmitting.value = false;
        if (updated != null) {
          AuthController.to.currentUser.value = updated;
          AppSnackbarUtils.showSuccess('Thành công', 'Cập nhật thông tin thành công.');
          Get.back();
        }
      },
    );
  }

  UpdateCurrentUserParams _buildUserParams() {
    return UpdateCurrentUserParams(
      fullName: fullNameController.text.trim().isNotEmpty
          ? fullNameController.text.trim()
          : null,
      gender: selectedGender.value,
      dateOfBirth: selectedBirthDate.value,
    );
  }

  UpdateCurrentUserParams _buildOrganizationParams() {
    return UpdateCurrentUserParams(
      address: addressController.text.trim().isNotEmpty
          ? addressController.text.trim()
          : null,
      logoUrl: logoUrlController.text.trim().isNotEmpty
          ? logoUrlController.text.trim()
          : null,
      description: descriptionController.text.trim().isNotEmpty
          ? descriptionController.text.trim()
          : null,
    );
  }

  void _handleFailure(FailureEntity failure) {
    failure.when(
      serverFailure: (_, message) =>
          AppSnackbarUtils.showError('Lỗi', message ?? 'Cập nhật thất bại'),
      dataParsingFailure: () =>
          AppSnackbarUtils.showError('Lỗi', 'Dữ liệu không hợp lệ'),
      noConnectionFailure: () =>
          AppSnackbarUtils.showError('Lỗi', 'Không có kết nối mạng'),
      systemFailure: (_, message) =>
          AppSnackbarUtils.showError('Lỗi', message ?? 'Lỗi hệ thống'),
    );
  }
}
