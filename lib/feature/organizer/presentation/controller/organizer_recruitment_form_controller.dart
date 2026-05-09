import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/feature/recruitment/domain/entity/ctv_recruitment_entity.dart';
import 'package:events_app/feature/organizer/presentation/page/recruitment/organizer_recruitment_list_page.dart';
import 'package:events_app/feature/organizer/recruitment/domain/usecase/organizer_recruitment_usecase.dart';
import 'package:events_app/feature/organizer/recruitment/domain/usecase/organizer_recruitment_params.dart';

class OrganizerRecruitmentFormController extends GetxController {
  GetOrganizerRecruitmentByIdUsecase get _getByIdUsecase =>
      networkGetIt<GetOrganizerRecruitmentByIdUsecase>();
  CreateOrganizerRecruitmentUsecase get _createUsecase =>
      networkGetIt<CreateOrganizerRecruitmentUsecase>();
  UpdateOrganizerRecruitmentUsecase get _updateUsecase =>
      networkGetIt<UpdateOrganizerRecruitmentUsecase>();

  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final roleNameController = TextEditingController();
  final quantityController = TextEditingController();
  final rewardCoinController = TextEditingController();
  final youthUnionPointController = TextEditingController();
  final cashRewardController = TextEditingController();
  final certificateNameController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final Rx<CtvRecruitmentEntity?> editingRecruitment = Rx<CtvRecruitmentEntity?>(null);
  final Rx<DateTime?> startTime = Rx<DateTime?>(null);
  final Rx<DateTime?> registerOpenTime = Rx<DateTime?>(null);

  final Rx<int?> bannerFileId = Rx<int?>(null);
  final Rx<String?> bannerPreviewUrl = Rx<String?>(null);

  final RxList<int> selectedCategoryOptionIds = <int>[].obs;
  final RxList<RequirementQuestionCreateParams> requirementQuestions =
      <RequirementQuestionCreateParams>[].obs;

  bool get isEditMode => editingRecruitment.value != null;

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    roleNameController.dispose();
    quantityController.dispose();
    rewardCoinController.dispose();
    youthUnionPointController.dispose();
    cashRewardController.dispose();
    certificateNameController.dispose();
    super.onClose();
  }

  void initForEdit(CtvRecruitmentEntity r) {
    editingRecruitment.value = r;
    titleController.text = r.title ?? '';
    descriptionController.text = r.description ?? '';
    roleNameController.text = r.roleName ?? '';
    quantityController.text = (r.quantity ?? 0).toString();
    rewardCoinController.text = (r.rewardCoin ?? 0).toString();
    youthUnionPointController.text = (r.youthUnionPoint ?? 0).toString();
    cashRewardController.text = (r.cashRewardAmount ?? 0).toString();
    certificateNameController.text = r.certificateName ?? '';
    startTime.value = r.startTime;
    registerOpenTime.value = r.registerOpenTime;
    bannerPreviewUrl.value = r.banner;
    bannerFileId.value = null;

    selectedCategoryOptionIds.clear();
    requirementQuestions.clear();
    if (r.categories != null) {
      for (final cat in r.categories!) {
        if (cat.options != null) {
          for (final opt in cat.options!) {
            if (opt.categoryOptionId != null) {
              selectedCategoryOptionIds.add(opt.categoryOptionId!);
            }
          }
        }
      }
    }
  }

  void initForCreate() {
    editingRecruitment.value = null;
    titleController.clear();
    descriptionController.clear();
    roleNameController.clear();
    quantityController.text = '10';
    rewardCoinController.text = '0';
    youthUnionPointController.text = '0';
    cashRewardController.text = '0';
    certificateNameController.clear();
    startTime.value = null;
    registerOpenTime.value = null;
    bannerFileId.value = null;
    bannerPreviewUrl.value = null;
    selectedCategoryOptionIds.clear();
    requirementQuestions.clear();
  }

  void onBannerUploaded(int fileId, String url) {
    bannerFileId.value = fileId;
    bannerPreviewUrl.value = url;
  }

  void setStartTime(DateTime? dt) { startTime.value = dt; }
  void setRegisterOpenTime(DateTime? dt) { registerOpenTime.value = dt; }

  Future<void> loadRecruitment(int recruitmentId) => loadForEdit(recruitmentId);

  void toggleCategoryOption(int id) {
    if (selectedCategoryOptionIds.contains(id)) {
      selectedCategoryOptionIds.remove(id);
    } else {
      selectedCategoryOptionIds.add(id);
    }
  }

  void addRequirementQuestion(RequirementQuestionCreateParams q) {
    requirementQuestions.add(q);
  }

  void removeRequirementQuestion(int index) {
    if (index >= 0 && index < requirementQuestions.length) {
      requirementQuestions.removeAt(index);
    }
  }

  void updateRequirementQuestion(int index, RequirementQuestionCreateParams q) {
    if (index >= 0 && index < requirementQuestions.length) {
      requirementQuestions[index] = q;
    }
  }

  Future<void> loadForEdit(int recruitmentId) async {
    isLoading.value = true;
    final result = await _getByIdUsecase(recruitmentId);
    result.fold(
      (failure) {
        _handleFailure(failure);
        isLoading.value = false;
        Get.back();
      },
      (r) {
        initForEdit(r);
        isLoading.value = false;
      },
    );
  }

  Future<void> submit(int eventId) async {
    if (!formKey.currentState!.validate()) return;
    if (isSubmitting.value) return;
    isSubmitting.value = true;

    final params = CreateRecruitmentParams(
      eventId: eventId,
      title: titleController.text,
      bannerFileId: bannerFileId.value,
      roleName: roleNameController.text.isEmpty ? null : roleNameController.text,
      description: descriptionController.text.isEmpty ? null : descriptionController.text,
      startTime: startTime.value,
      quantity: int.tryParse(quantityController.text),
      rewardCoin: int.tryParse(rewardCoinController.text),
      youthUnionPoint: int.tryParse(youthUnionPointController.text),
      cashRewardAmount: int.tryParse(cashRewardController.text),
      certificateName: certificateNameController.text.isEmpty ? null : certificateNameController.text,
      isOpen: true,
      categoryOptionIds:
          selectedCategoryOptionIds.isEmpty ? null : selectedCategoryOptionIds.toList(),
      requirementQuestions:
          requirementQuestions.isEmpty ? null : requirementQuestions.toList(),
    );

    final result = isEditMode
        ? await _updateUsecase(UpdateRecruitmentParamsWrapper(
            id: editingRecruitment.value!.ctvRecruitmentId!,
            params: UpdateRecruitmentParams(
              title: titleController.text,
              bannerFileId: bannerFileId.value,
              roleName: roleNameController.text.isEmpty ? null : roleNameController.text,
              description: descriptionController.text.isEmpty ? null : descriptionController.text,
              startTime: startTime.value,
              quantity: int.tryParse(quantityController.text),
              rewardCoin: int.tryParse(rewardCoinController.text),
              youthUnionPoint: int.tryParse(youthUnionPointController.text),
              cashRewardAmount: int.tryParse(cashRewardController.text),
              certificateName: certificateNameController.text.isEmpty ? null : certificateNameController.text,
              isOpen: editingRecruitment.value?.isOpen,
              categoryOptionIds:
                  selectedCategoryOptionIds.isEmpty ? null : selectedCategoryOptionIds.toList(),
              requirementQuestions:
                  requirementQuestions.isEmpty ? null : requirementQuestions.toList(),
            ),
          ))
        : await _createUsecase(params);

    result.fold(
      (failure) {
        _handleFailure(failure);
        isSubmitting.value = false;
      },
      (r) {
        AppSnackbarUtils.showSuccess(
          'Thành công',
          isEditMode ? 'Cập nhật tuyển dụng thành công' : 'Tạo tuyển dụng thành công',
        );
        Get.until((route) => route.isFirst);
        Get.to(() => const OrganizerRecruitmentListPage());
        isSubmitting.value = false;
      },
    );
  }

  String? validateTitle(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập tiêu đề';
    if (value.length < 10) return 'Tiêu đề phải có ít nhất 10 ký tự';
    if (value.length > 200) return 'Tiêu đề không quá 200 ký tự';
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập mô tả';
    if (value.length < 10) return 'Mô tả phải có ít nhất 10 ký tự';
    if (value.length > 5000) return 'Mô tả không quá 5000 ký tự';
    return null;
  }

  String? validateRoleName(String? value) {
    if (value == null || value.isEmpty) return null;
    if (value.length > 100) return 'Tên vai trò không quá 100 ký tự';
    return null;
  }

  String? validateStartTime(DateTime? value) {
    if (value == null) return 'Vui lòng chọn thời gian bắt đầu';
    if (value.isBefore(DateTime.now())) {
      return 'Thời gian bắt đầu phải sau thời điểm hiện tại';
    }
    return null;
  }

  String? validateRewardCoin(String? value) {
    if (value == null || value.isEmpty) return null;
    final coin = int.tryParse(value);
    if (coin == null) return 'Số coin không hợp lệ';
    if (coin < 0) return 'Số coin không được nhỏ hơn 0';
    if (coin > 100000) return 'Số coin không quá 100.000';
    return null;
  }

  String? validateCashRewardAmount(String? value) {
    if (value == null || value.isEmpty) return null;
    final amount = int.tryParse(value);
    if (amount == null) return 'Số tiền không hợp lệ';
    if (amount < 0) return 'Số tiền không được nhỏ hơn 0';
    if (amount > 100000000) return 'Số tiền không quá 100.000.000';
    return null;
  }

  String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) return null;
    final qty = int.tryParse(value);
    if (qty == null) return 'Số lượng không hợp lệ';
    if (qty < 1) return 'Số lượng phải lớn hơn 0';
    if (qty > 1000) return 'Số lượng không quá 1000';
    return null;
  }

  String? validateCoin(String? value) {
    if (value == null || value.isEmpty) return null;
    final coin = int.tryParse(value);
    if (coin == null) return 'Số coin không hợp lệ';
    if (coin < 0) return 'Số coin không nhỏ hơn 0';
    if (coin > 100000) return 'Số coin không quá 100.000';
    return null;
  }

  String? validateYouthUnionPoint(String? value) {
    if (value == null || value.isEmpty) return null;
    final point = int.tryParse(value);
    if (point == null) return 'Số điểm không hợp lệ';
    if (point < 0) return 'Số điểm không nhỏ hơn 0';
    if (point > 100) return 'Số điểm không quá 100';
    return null;
  }

  void _handleFailure(FailureEntity failure) {
    AuthController.handleFailure(failure);
  }
}
