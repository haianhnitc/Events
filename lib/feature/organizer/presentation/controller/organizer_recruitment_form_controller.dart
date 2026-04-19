import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/common/utils/upload_helper.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/usecase/upload_file_params.dart';
import 'package:events_app/feature/common/usecase/upload_file_usecase.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/feature/recruitment/domain/entity/ctv_recruitment_entity.dart';
import 'package:events_app/feature/organizer/recruitment/domain/usecase/organizer_recruitment_usecase.dart';
import 'package:events_app/feature/organizer/recruitment/domain/usecase/organizer_recruitment_params.dart';

class OrganizerRecruitmentFormController extends GetxController {
  GetOrganizerRecruitmentByIdUsecase get _getByIdUsecase =>
      networkGetIt<GetOrganizerRecruitmentByIdUsecase>();
  CreateOrganizerRecruitmentUsecase get _createUsecase =>
      networkGetIt<CreateOrganizerRecruitmentUsecase>();
  UpdateOrganizerRecruitmentUsecase get _updateUsecase =>
      networkGetIt<UpdateOrganizerRecruitmentUsecase>();
  UploadFileUsecase get _uploadFileUsecase => networkGetIt<UploadFileUsecase>();

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
  final RxBool isUploadingBanner = false.obs;
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

  Future<void> loadRecruitment(int recruitmentId) async {
    if (isLoading.value) return;
    isLoading.value = true;
    final result = await _getByIdUsecase(recruitmentId);
    result.fold(
      (failure) {
        _handleFailure(failure);
        isLoading.value = false;
      },
      (data) {
        editingRecruitment.value = data;
        _populateForm(data);
        isLoading.value = false;
      },
    );
  }

  void _populateForm(CtvRecruitmentEntity r) {
    titleController.text = r.title ?? '';
    descriptionController.text = r.description ?? '';
    roleNameController.text = r.roleName ?? '';
    quantityController.text = r.quantity?.toString() ?? '1';
    rewardCoinController.text = r.rewardCoin?.toString() ?? '0';
    youthUnionPointController.text = r.youthUnionPoint?.toString() ?? '0';
    cashRewardController.text = r.cashRewardAmount?.toString() ?? '0';
    certificateNameController.text = r.certificateName ?? '';
    startTime.value = r.startTime;
    registerOpenTime.value = r.registerOpenTime;
    bannerPreviewUrl.value = r.banner;
    bannerFileId.value = null;
  }

  void initForCreate() {
    editingRecruitment.value = null;
    titleController.clear();
    descriptionController.clear();
    roleNameController.clear();
    quantityController.text = '1';
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

  void setStartTime(DateTime? dt) { startTime.value = dt; }
  void setRegisterOpenTime(DateTime? dt) { registerOpenTime.value = dt; }

  Future<void> pickAndUploadBanner() async {
    final result = await ImagePickerService().pickSingleImage();
    if (result == null) return;

    isUploadingBanner.value = true;
    try {
      final uploadResult = await _uploadFileUsecase(UploadFileParams(
        filePath: result.filePath,
        fileType: FileType.recruitmentBanner,
      ));

      uploadResult.fold(
        (failure) {
          _handleFailure(failure);
        },
        (fileEntity) {
          bannerFileId.value = fileEntity.fileId;
          bannerPreviewUrl.value = fileEntity.url;
          AppSnackbarUtils.showSuccess('Thành công', 'Tải ảnh lên thành công');
        },
      );
    } finally {
      isUploadingBanner.value = false;
    }
  }

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

  Future<void> submit(int eventId) async {
    if (!formKey.currentState!.validate()) return;
    if (isSubmitting.value) return;
    isSubmitting.value = true;

    final result = isEditMode
        ? await _updateUsecase(UpdateRecruitmentParamsWrapper(
            id: editingRecruitment.value!.ctvRecruitmentId!,
            params: UpdateRecruitmentParams(
              title: titleController.text,
              description: descriptionController.text,
              roleName: roleNameController.text.isEmpty ? null : roleNameController.text,
              quantity: int.tryParse(quantityController.text),
              rewardCoin: int.tryParse(rewardCoinController.text),
              youthUnionPoint: int.tryParse(youthUnionPointController.text),
              cashRewardAmount: int.tryParse(cashRewardController.text),
              certificateName: certificateNameController.text.isEmpty ? null : certificateNameController.text,
              startTime: startTime.value,
              bannerFileId: bannerFileId.value,
              isOpen: true,
              categoryOptionIds: selectedCategoryOptionIds.isEmpty ? null : selectedCategoryOptionIds.toList(),
              requirementQuestions: requirementQuestions.isEmpty ? null : requirementQuestions.toList(),
            ),
          ))
        : await _createUsecase(CreateRecruitmentParams(
            eventId: eventId,
            title: titleController.text,
            description: descriptionController.text,
            roleName: roleNameController.text.isEmpty ? null : roleNameController.text,
            quantity: int.tryParse(quantityController.text),
            rewardCoin: int.tryParse(rewardCoinController.text),
            youthUnionPoint: int.tryParse(youthUnionPointController.text),
            cashRewardAmount: int.tryParse(cashRewardController.text),
            certificateName: certificateNameController.text.isEmpty ? null : certificateNameController.text,
            startTime: startTime.value,
            bannerFileId: bannerFileId.value,
            isOpen: true,
            categoryOptionIds: selectedCategoryOptionIds.isEmpty ? null : selectedCategoryOptionIds.toList(),
            requirementQuestions: requirementQuestions.isEmpty ? null : requirementQuestions.toList(),
          ));

    result.fold(
      (failure) {
        _handleFailure(failure);
        isSubmitting.value = false;
      },
      (recruitment) {
        AppSnackbarUtils.showSuccess('Thành công',
            isEditMode ? 'Cập nhật tuyển CTV thành công' : 'Tạo tuyển CTV thành công');
        isSubmitting.value = false;
        Get.back(result: recruitment);
      },
    );
  }

  String? validateTitle(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập tiêu đề tuyển dụng';
    if (value.length < 10) return 'Tiêu đề phải có ít nhất 10 ký tự';
    if (value.length > 200) return 'Tiêu đề không được quá 200 ký tự';
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập mô tả công việc';
    if (value.length < 50) return 'Mô tả phải có ít nhất 50 ký tự';
    if (value.length > 5000) return 'Mô tả không được quá 5000 ký tự';
    return null;
  }

  String? validateRoleName(String? value) {
    if (value == null || value.isEmpty) return null;
    if (value.length < 5) return 'Vai trò phải có ít nhất 5 ký tự';
    if (value.length > 200) return 'Vai trò không được quá 200 ký tự';
    return null;
  }

  String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập số lượng';
    final qty = int.tryParse(value);
    if (qty == null) return 'Số lượng không hợp lệ';
    if (qty < 1) return 'Số lượng phải lớn hơn 0';
    if (qty > 1000) return 'Số lượng không được quá 1000';
    return null;
  }

  String? validateRewardCoin(String? value) {
    if (value == null || value.isEmpty) return null;
    final coin = int.tryParse(value);
    if (coin == null) return 'Số coin không hợp lệ';
    if (coin < 0) return 'Số coin không được nhỏ hơn 0';
    if (coin > 100000) return 'Số coin không được quá 100.000';
    return null;
  }

  String? validateYouthUnionPoint(String? value) {
    if (value == null || value.isEmpty) return null;
    final point = int.tryParse(value);
    if (point == null) return 'Số điểm không hợp lệ';
    if (point < 0) return 'Số điểm không được nhỏ hơn 0';
    if (point > 100) return 'Số điểm không được quá 100';
    return null;
  }

  String? validateCashRewardAmount(String? value) {
    if (value == null || value.isEmpty) return null;
    final amount = int.tryParse(value);
    if (amount == null) return 'Số tiền không hợp lệ';
    if (amount < 0) return 'Số tiền không được nhỏ hơn 0';
    if (amount > 100000000) return 'Số tiền không được quá 100.000.000 đ';
    return null;
  }

  String? validateStartTime(DateTime? value) {
    if (value == null) return 'Vui lòng chọn thời gian bắt đầu tuyển dụng';
    if (value.isBefore(DateTime.now())) return 'Thời gian bắt đầu phải sau thời điểm hiện tại';
    return null;
  }

  void _handleFailure(FailureEntity failure) {
    failure.when(
      serverFailure: (_, message) => AppSnackbarUtils.showError('Lỗi', message ?? 'Thao tác thất bại'),
      dataParsingFailure: () => AppSnackbarUtils.showError('Lỗi', 'Không đọc được dữ liệu'),
      noConnectionFailure: () => AppSnackbarUtils.showError('Lỗi', 'Không có kết nối mạng'),
      systemFailure: (_, message) => AppSnackbarUtils.showError('Lỗi', message ?? 'Lỗi hệ thống'),
    );
  }
}
