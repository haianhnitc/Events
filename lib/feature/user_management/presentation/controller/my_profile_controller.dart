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
import 'package:events_app/feature/user_management/domain/entity/rank_entity.dart';
import 'package:events_app/feature/common/domain/entity/package_entity.dart';
import 'package:events_app/feature/user_management/domain/entity/user_package_entity.dart';
import 'package:events_app/feature/user_management/domain/repository/user_repository.dart';
import 'package:events_app/feature/user_management/domain/usecase/update_current_user_usecase.dart';

class MyProfileController extends GetxController {
  UpdateCurrentUserUsecase get _updateUsecase =>
      networkGetIt<UpdateCurrentUserUsecase>();
  UserRepository get _userRepo => networkGetIt<UserRepository>();

  final formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final Rx<String?> selectedGender = Rx<String?>(null);
  final Rx<DateTime?> selectedBirthDate = Rx<DateTime?>(null);
  final Rx<int?> avatarFileId = Rx<int?>(null);
  final Rx<String?> avatarPreviewUrl = Rx<String?>(null);

  final Rx<int?> logoFileId = Rx<int?>(null);
  final Rx<String?> logoPreviewUrl = Rx<String?>(null);
  final addressController = TextEditingController();
  final descriptionController = TextEditingController();

  final RxBool isSubmitting = false.obs;
  final RxBool isLoading = true.obs;

  // Rank, package, portfolio data
  final Rx<RankEntity?> userRank = Rx<RankEntity?>(null);
  final RxList<UserPackageEntity> userPackages = <UserPackageEntity>[].obs;
  final RxBool isLoadingRank = false.obs;
  final RxBool isLoadingPackages = false.obs;

  @override
  void onClose() {
    fullNameController.dispose();
    addressController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void loadUser() {
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

  Future<void> loadRankAndPackages() async {
    final user = AuthController.to.currentUser.value;
    if (user == null) return;

    if (user.userId != null) {
      _fetchUserRank(user.userId!);
      _fetchUserPackages();
    }
  }

  Future<void> _fetchUserRank(int userId) async {
    isLoadingRank.value = true;
    final result = await _userRepo.getUserRank(userId);
    result.fold(
      (failure) => isLoadingRank.value = false,
      (rank) {
        userRank.value = rank;
        isLoadingRank.value = false;
      },
    );
  }

  Future<void> _fetchUserPackages() async {
    isLoadingPackages.value = true;
    final result = await _userRepo.getUserPackages();
    result.fold(
      (failure) => isLoadingPackages.value = false,
      (packages) {
        userPackages.value = packages;
        isLoadingPackages.value = false;
      },
    );
  }

  void _loadUser(UserEntity user) {
    final profile = user.userProfile;
    fullNameController.text = profile?.fullName ?? '';
    selectedGender.value = profile?.gender;
    selectedBirthDate.value = profile?.dateOfBirth;
    avatarFileId.value = null;
    avatarPreviewUrl.value = profile?.avatarUrl;
  }

  void _loadOrganization(UserEntity user) {
    final org = user.organizationProfile;
    addressController.text = org?.address ?? '';
    descriptionController.text = org?.description ?? '';
    logoFileId.value = null;
    logoPreviewUrl.value = org?.logoUrl;
  }

  void setGender(String? gender) {
    selectedGender.value = gender;
  }

  void setBirthDate(DateTime? date) {
    selectedBirthDate.value = date;
  }

  void onAvatarUploaded(int fileId, String url) {
    avatarFileId.value = fileId;
    avatarPreviewUrl.value = url;
  }

  void onLogoUploaded(int fileId, String url) {
    logoFileId.value = fileId;
    logoPreviewUrl.value = url;
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

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    if (isSubmitting.value) return;

    final user = AuthController.to.currentUser.value;
    if (user == null) return;

    final params = user.role == UserRole.organization
        ? _buildOrganizationParams()
        : _buildUserParams();

    if (params.isEmpty) {
      AppSnackbarUtils.showInfo(
          'Không có thay đổi', 'Bạn chưa thay đổi thông tin nào.');
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
          AppSnackbarUtils.showSuccess(
              'Thành công', 'Cập nhật thông tin thành công.');
          Future.delayed(const Duration(milliseconds: 800), () => Get.back());
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
      avatarFileId: avatarFileId.value,
    );
  }

  UpdateCurrentUserParams _buildOrganizationParams() {
    return UpdateCurrentUserParams(
      address: addressController.text.trim().isNotEmpty
          ? addressController.text.trim()
          : null,
      logoFileId: logoFileId.value,
      description: descriptionController.text.trim().isNotEmpty
          ? descriptionController.text.trim()
          : null,
    );
  }

  void _handleFailure(FailureEntity failure) {
    AuthController.handleFailure(failure);
  }
}
