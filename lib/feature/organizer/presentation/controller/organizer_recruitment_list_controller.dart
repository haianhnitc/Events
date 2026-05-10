import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
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

  static final Rx<(int, bool?)> recruitmentStateUpdate =
      Rx<(int, bool?)>((0, null));

  @override
  void onInit() {
    super.onInit();
    loadRecruitments(refresh: true);
    _watchRecruitmentUpdates();
  }

  void _watchRecruitmentUpdates() {
    ever(recruitmentStateUpdate, (tuple) {
      final (updatedId, newIsOpen) = tuple;
      final index = recruitments.indexWhere(
          (r) => r.ctvRecruitmentId == updatedId);
      if (index >= 0) {
        recruitments[index] = recruitments[index].copyWith(isOpen: newIsOpen);
      }
    });
  }

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
        recruitmentStateUpdate.value = (recruitmentId, false);
        final index = recruitments.indexWhere((r) => r.ctvRecruitmentId == recruitmentId);
        if (index >= 0) {
          recruitments[index] = recruitments[index].copyWith(isOpen: false);
        }
      },
    );
  }

  void setEventFilter(int? eventId) {
    filterEventId.value = eventId;
    loadRecruitments(refresh: true);
  }

  void _handleFailure(FailureEntity failure) {
    AuthController.handleFailure(failure);
  }
}
