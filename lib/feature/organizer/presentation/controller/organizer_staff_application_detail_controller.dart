import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/staff_application/domain/entity/staff_application_entity.dart';
import 'package:events_app/feature/organizer/staff_application/domain/usecase/organizer_staff_application_usecase.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_staff_application_list_controller.dart';
import 'package:events_app/feature/organizer/staff_application/domain/usecase/organizer_staff_application_params.dart';

class OrganizerStaffApplicationDetailController extends GetxController {
  GetOrganizerStaffApplicationByIdUsecase get _getByIdUsecase =>
      networkGetIt<GetOrganizerStaffApplicationByIdUsecase>();
  ApproveStaffApplicationUsecase get _approveUsecase =>
      networkGetIt<ApproveStaffApplicationUsecase>();

  final Rx<StaffApplicationEntity?> application = Rx<StaffApplicationEntity?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isApproveLoading = false.obs;
  final RxBool isRejectLoading = false.obs;

  bool get isAnyLoading => isApproveLoading.value || isRejectLoading.value;

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
    if (isApproveLoading.value) return;
    isApproveLoading.value = true;

    final result = await _approveUsecase(ApproveStaffApplicationParams(
      applicationId: applicationId,
      isApproved: true,
      feedback: feedback,
    ));

    result.fold(
      (failure) {
        _handleFailure(failure);
        isApproveLoading.value = false;
      },
      (updated) async {
        application.value = updated;
        isApproveLoading.value = false;
        _syncList(updated);
        AppSnackbarUtils.showSuccess('Thành công', 'Duyệt đơn ứng tuyển thành công');
        await Future.delayed(const Duration(milliseconds: 400));
        Get.back();
      },
    );
  }

  Future<void> rejectApplication(int applicationId, {String? feedback}) async {
    if (isRejectLoading.value) return;
    isRejectLoading.value = true;

    final result = await _approveUsecase(ApproveStaffApplicationParams(
      applicationId: applicationId,
      isApproved: false,
      feedback: feedback,
    ));

    result.fold(
      (failure) {
        _handleFailure(failure);
        isRejectLoading.value = false;
      },
      (updated) async {
        application.value = updated;
        isRejectLoading.value = false;
        _syncList(updated);
        AppSnackbarUtils.showSuccess('Thành công', 'Từ chối đơn ứng tuyển thành công');
        await Future.delayed(const Duration(milliseconds: 400));
        Get.back();
      },
    );
  }

  Future<void> showApproveDialog() async {
    if (application.value == null) return;
    final result = await showApproveRejectDialog(
      title: 'Duyệt đơn',
      confirmLabel: 'Duyệt',
      confirmColor: const Color(0xFF10B981),
      hintText: 'Nhập phản hồi cho ứng viên (tùy chọn)',
      icon: Icons.check_circle_outline,
      loadingFlag: isApproveLoading,
    );
    if (result != null) {
      await approveApplication(
        application.value!.applicationId!,
        feedback: result.isEmpty ? null : result,
      );
    }
  }

  Future<void> showRejectDialog() async {
    if (application.value == null) return;
    final result = await showApproveRejectDialog(
      title: 'Từ chối đơn',
      confirmLabel: 'Từ chối',
      confirmColor: const Color(0xFFEF4444),
      hintText: 'Nhập lý do từ chối (tùy chọn)',
      icon: Icons.cancel_outlined,
      loadingFlag: isRejectLoading,
    );
    if (result != null) {
      await rejectApplication(
        application.value!.applicationId!,
        feedback: result.isEmpty ? null : result,
      );
    }
  }

  Future<String?> showApproveRejectDialog({
    required String title,
    required String confirmLabel,
    required Color confirmColor,
    required String hintText,
    required IconData icon,
    required RxBool loadingFlag,
  }) async {
    String feedback = '';
    return await Get.dialog<String>(
      StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                Icon(icon, color: confirmColor, size: 22),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff273143),
                  ),
                ),
              ],
            ),
            content: TextField(
              autofocus: true,
              maxLines: 3,
              onChanged: (v) => feedback = v,
              decoration: InputDecoration(
                hintText: hintText,
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: confirmColor, width: 1.5),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: null),
                child: Text('Hủy', style: TextStyle(color: Colors.grey.shade600)),
              ),
              Obx(() => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmColor,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    onPressed: loadingFlag.value
                        ? null
                        : () {
                            loadingFlag.value = true;
                            Get.back(result: feedback);
                          },
                    child: loadingFlag.value
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : Text(
                            confirmLabel,
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                  )),
            ],
          );
        },
      ),
    );
  }

  String? validateFeedback(String? value) {
    if (value == null || value.isEmpty) return null;
    if (value.length > 1000) return 'Phản hồi không được quá 1000 ký tự';
    return null;
  }

  void _handleFailure(FailureEntity failure) {
    AuthController.handleFailure(failure);
  }

  void _syncList(StaffApplicationEntity updated) {
    if (Get.isRegistered<OrganizerStaffApplicationListController>()) {
      Get.find<OrganizerStaffApplicationListController>().updateApplication(updated);
    }
  }
}
