import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/staff_application/domain/entity/staff_application_entity.dart';
import 'package:events_app/feature/organizer/staff_application/domain/usecase/organizer_staff_application_usecase.dart';
import 'package:events_app/feature/organizer/staff_application/domain/usecase/organizer_staff_application_params.dart';

class OrganizerStaffApplicationListController extends GetxController {
  GetOrganizerStaffApplicationsUsecase get _getApplicationsUsecase =>
      networkGetIt<GetOrganizerStaffApplicationsUsecase>();

  final RxList<StaffApplicationEntity> applications = <StaffApplicationEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxInt currentPage = 0.obs;
  final RxBool hasMore = true.obs;
  final Rx<int?> filterEventId = Rx<int?>(null);
  final Rx<int?> filterStatus = Rx<int?>(null);
  final RxString searchQuery = ''.obs;

  Future<void> loadApplications({bool refresh = false}) async {
    if (isLoading.value) return;
    if (refresh) {
      currentPage.value = 0;
      hasMore.value = true;
    }
    if (!hasMore.value && !refresh) return;

    isLoading.value = true;
    final result = await _getApplicationsUsecase(GetOrganizerStaffApplicationsParams(
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
          applications.assignAll(data);
        } else {
          applications.addAll(data);
        }
        hasMore.value = data.length >= 20;
        currentPage.value++;
        isLoading.value = false;
      },
    );
  }

  Future<void> refreshApplications() async {
    if (isRefreshing.value) return;
    isRefreshing.value = true;
    await loadApplications(refresh: true);
    isRefreshing.value = false;
  }

  Future<void> loadMore() async {
    if (!hasMore.value) return;
    await loadApplications();
  }

  void setEventFilter(int? eventId) {
    filterEventId.value = eventId;
    loadApplications(refresh: true);
  }

  int get pendingCount =>
      applications.where((a) => a.status?.name == 'pending').length;

  int get approvedCount =>
      applications.where((a) => a.status?.name == 'approved').length;

  int get rejectedCount =>
      applications.where((a) => a.status?.name == 'rejected').length;

  void _handleFailure(FailureEntity failure) {
    failure.when(
      serverFailure: (_, message) => AppSnackbarUtils.showError('Lỗi', message ?? 'Lấy danh sách thất bại'),
      dataParsingFailure: () => AppSnackbarUtils.showError('Lỗi', 'Không đọc được dữ liệu'),
      noConnectionFailure: () => AppSnackbarUtils.showError('Lỗi', 'Không có kết nối mạng'),
      systemFailure: (_, message) => AppSnackbarUtils.showError('Lỗi', message ?? 'Lỗi hệ thống'),
    );
  }
}
