import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/staff_application/domain/entity/staff_application_entity.dart';
import 'package:events_app/feature/organizer/staff_application/domain/usecase/organizer_staff_application_usecase.dart';
import 'package:events_app/feature/organizer/staff_application/domain/usecase/organizer_staff_application_params.dart';

class OrganizerStaffApplicationDetailController extends GetxController {
  GetOrganizerStaffApplicationByIdUsecase get _getByIdUsecase =>
      networkGetIt<GetOrganizerStaffApplicationByIdUsecase>();
  ApproveStaffApplicationUsecase get _approveUsecase =>
      networkGetIt<ApproveStaffApplicationUsecase>();

  final Rx<StaffApplicationEntity?> application = Rx<StaffApplicationEntity?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isActionLoading = false.obs;

  Future<void> loadApplication(int applicationId) async {
    if (isLoading.value) return;
    isLoading.value = true;
    final result = await _getByIdUsecase(applicationId);
    result.fold(
      (failure) {
        _handleFailure(failure);
        isLoading.value = false;
      },
      (data) {
        application.value = data;
        isLoading.value = false;
      },
    );
  }

  Future<void> approveApplication(int applicationId, {String? feedback}) async {
    if (isActionLoading.value) return;
    isActionLoading.value = true;

    final result = await _approveUsecase(ApproveStaffApplicationParams(
      applicationId: applicationId,
      isApproved: true,
      feedback: feedback,
    ));

    result.fold(
      (failure) {
        _handleFailure(failure);
        isActionLoading.value = false;
      },
      (updated) {
        AppSnackbarUtils.showSuccess('Thành công', 'Duyệt đơn ứng tuyển thành công');
        application.value = updated;
        isActionLoading.value = false;
      },
    );
  }

  Future<void> rejectApplication(int applicationId, {String? feedback}) async {
    if (isActionLoading.value) return;
    isActionLoading.value = true;

    final result = await _approveUsecase(ApproveStaffApplicationParams(
      applicationId: applicationId,
      isApproved: false,
      feedback: feedback,
    ));

    result.fold(
      (failure) {
        _handleFailure(failure);
        isActionLoading.value = false;
      },
      (updated) {
        AppSnackbarUtils.showSuccess('Thành công', 'Từ chối đơn ứng tuyển thành công');
        application.value = updated;
        isActionLoading.value = false;
      },
    );
  }

  Future<void> showApproveDialog() async {
    final feedbackController = TextEditingController();
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Duyệt đơn'),
        content: TextField(
          controller: feedbackController,
          decoration: const InputDecoration(
            labelText: 'Phản hồi (tùy chọn)',
            hintText: 'Nhập phản hồi cho ứng viên',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Hủy')),
          ElevatedButton(onPressed: () => Get.back(result: true), child: const Text('Duyệt')),
        ],
      ),
    );
    if (confirmed == true && application.value != null) {
      await approveApplication(
        application.value!.applicationId!,
        feedback: feedbackController.text.isEmpty ? null : feedbackController.text,
      );
    }
    feedbackController.dispose();
  }

  Future<void> showRejectDialog() async {
    final feedbackController = TextEditingController();
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Từ chối đơn'),
        content: TextField(
          controller: feedbackController,
          decoration: const InputDecoration(
            labelText: 'Lý do từ chối (tùy chọn)',
            hintText: 'Nhập lý do từ chối',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Hủy')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Get.back(result: true),
            child: const Text('Từ chối'),
          ),
        ],
      ),
    );
    if (confirmed == true && application.value != null) {
      await rejectApplication(
        application.value!.applicationId!,
        feedback: feedbackController.text.isEmpty ? null : feedbackController.text,
      );
    }
    feedbackController.dispose();
  }

  String? validateFeedback(String? value) {
    if (value == null || value.isEmpty) return null;
    if (value.length > 1000) return 'Phản hồi không được quá 1000 ký tự';
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
