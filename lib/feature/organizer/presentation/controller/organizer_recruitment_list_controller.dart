import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/recruitment/domain/entity/ctv_recruitment_entity.dart';
import 'package:events_app/feature/organizer/recruitment/domain/usecase/organizer_recruitment_usecase.dart';
import 'package:events_app/feature/organizer/recruitment/domain/usecase/organizer_recruitment_params.dart';

class OrganizerRecruitmentListController extends GetxController {
  GetOrganizerRecruitmentsUsecase get _getRecruitmentsUsecase =>
      networkGetIt<GetOrganizerRecruitmentsUsecase>();
  DeleteOrganizerRecruitmentUsecase get _deleteRecruitmentUsecase =>
      networkGetIt<DeleteOrganizerRecruitmentUsecase>();
  CloseOrganizerRecruitmentUsecase get _closeRecruitmentUsecase =>
      networkGetIt<CloseOrganizerRecruitmentUsecase>();
  UpdateOrganizerRecruitmentUsecase get _updateRecruitmentUsecase =>
      networkGetIt<UpdateOrganizerRecruitmentUsecase>();

  final RxList<CtvRecruitmentEntity> recruitments = <CtvRecruitmentEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxInt currentPage = 0.obs;
  final RxBool hasMore = true.obs;
  final Rx<int?> filterEventId = Rx<int?>(null);
  final RxString searchQuery = ''.obs;

  Future<void> loadRecruitments({bool refresh = false}) async {
    if (isLoading.value) return;
    if (refresh) {
      currentPage.value = 0;
      hasMore.value = true;
    }
    if (!hasMore.value && !refresh) return;

    isLoading.value = true;
    final result = await _getRecruitmentsUsecase(GetOrganizerRecruitmentsParams(
      eventId: filterEventId.value,
      keyword: searchQuery.value.isEmpty ? null : searchQuery.value,
      page: currentPage.value,
      size: 20,
    ));
    result.fold(
      (failure) {
        _handleFailure(failure);
        isLoading.value = false;
      },
      (data) {
        if (refresh) {
          recruitments.assignAll(data);
        } else {
          recruitments.addAll(data);
        }
        hasMore.value = data.length >= 20;
        currentPage.value++;
        isLoading.value = false;
      },
    );
  }

  Future<void> refreshRecruitments() async {
    if (isRefreshing.value) return;
    isRefreshing.value = true;
    await loadRecruitments(refresh: true);
    isRefreshing.value = false;
  }

  Future<void> loadMore() async {
    if (!hasMore.value) return;
    await loadRecruitments();
  }

  Future<void> deleteRecruitment(int recruitmentId) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc muốn xóa bài tuyển dụng này không?'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Hủy')),
          TextButton(onPressed: () => Get.back(result: true), child: const Text('Xóa')),
        ],
      ),
    );
    if (confirmed != true) return;

    final result = await _deleteRecruitmentUsecase(recruitmentId);
    result.fold(
      (failure) => _handleFailure(failure),
      (_) {
        AppSnackbarUtils.showSuccess('Thành công', 'Xóa bài tuyển dụng thành công');
        recruitments.removeWhere((r) => r.ctvRecruitmentId == recruitmentId);
      },
    );
  }

  Future<void> closeRecruitment(int recruitmentId) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Xác nhận đóng tuyển'),
        content: const Text('Bạn có chắc muốn đóng tuyển CTV không?'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Hủy')),
          TextButton(onPressed: () => Get.back(result: true), child: const Text('Đóng tuyển')),
        ],
      ),
    );
    if (confirmed != true) return;

    final result = await _closeRecruitmentUsecase(recruitmentId);
    result.fold(
      (failure) => _handleFailure(failure),
      (_) {
        AppSnackbarUtils.showSuccess('Thành công', 'Đóng tuyển CTV thành công');
        final index = recruitments.indexWhere((r) => r.ctvRecruitmentId == recruitmentId);
        if (index >= 0) {
          recruitments[index] = recruitments[index].copyWith(isOpen: false);
        }
      },
    );
  }

  Future<void> reopenRecruitment(int recruitmentId) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Xác nhận mở lại tuyển'),
        content: const Text('Bạn có chắc muốn mở lại tuyển CTV không?'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Hủy')),
          TextButton(onPressed: () => Get.back(result: true), child: const Text('Mở lại')),
        ],
      ),
    );
    if (confirmed != true) return;

    final recruitment = recruitments.firstWhereOrNull((r) => r.ctvRecruitmentId == recruitmentId);
    if (recruitment == null) return;

    final params = CreateRecruitmentParams(
      eventId: recruitment.eventId ?? 0,
      title: recruitment.title,
      description: recruitment.description,
      roleName: recruitment.roleName,
      quantity: recruitment.quantity,
      rewardCoin: recruitment.rewardCoin,
      youthUnionPoint: recruitment.youthUnionPoint,
      cashRewardAmount: recruitment.cashRewardAmount,
      certificateName: recruitment.certificateName,
      startTime: recruitment.startTime,
      isOpen: true,
    );

    final result = await _updateRecruitmentUsecase(
      UpdateRecruitmentParamsWrapper(
        id: recruitmentId,
        params: UpdateRecruitmentParams(
          title: recruitment.title,
          description: recruitment.description,
          roleName: recruitment.roleName,
          quantity: recruitment.quantity,
          rewardCoin: recruitment.rewardCoin,
          youthUnionPoint: recruitment.youthUnionPoint,
          cashRewardAmount: recruitment.cashRewardAmount,
          certificateName: recruitment.certificateName,
          startTime: recruitment.startTime,
          isOpen: true,
        ),
      ),
    );
    result.fold(
      (failure) => _handleFailure(failure),
      (updated) {
        AppSnackbarUtils.showSuccess('Thành công', 'Mở lại tuyển CTV thành công');
        final index = recruitments.indexWhere((r) => r.ctvRecruitmentId == recruitmentId);
        if (index >= 0) {
          recruitments[index] = recruitments[index].copyWith(isOpen: true);
        }
      },
    );
  }

  void setEventFilter(int? eventId) {
    filterEventId.value = eventId;
    loadRecruitments(refresh: true);
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
