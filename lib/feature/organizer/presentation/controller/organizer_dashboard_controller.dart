import 'package:get/get.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/user_management/domain/entity/organization_dashboard_entity.dart';
import 'package:events_app/feature/organizer/organization/domain/usecase/organizer_organization_usecase.dart';
import 'package:events_app/common/helpers/no_params.dart';

class OrganizerDashboardController extends GetxController {
  GetOrganizerDashboardUsecase get _getDashboardUsecase =>
      networkGetIt<GetOrganizerDashboardUsecase>();

  final Rx<OrganizationDashboardEntity?> dashboard =
      Rx<OrganizationDashboardEntity?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    if (isLoading.value) return;
    isLoading.value = true;
    final result = await _getDashboardUsecase(NoParams());
    result.fold(
      (failure) => _handleFailure(failure),
      (data) => dashboard.value = data,
    );
    isLoading.value = false;
  }

  Future<void> refreshDashboard() async {
    if (isRefreshing.value) return;
    isRefreshing.value = true;
    final result = await _getDashboardUsecase(NoParams());
    result.fold(
      (failure) => _handleFailure(failure),
      (data) => dashboard.value = data,
    );
    isRefreshing.value = false;
  }

  void _handleFailure(FailureEntity failure) {
    failure.when(
      serverFailure: (_, message) => AppSnackbarUtils.showError(
          'Lỗi', message ?? 'Lấy dashboard thất bại'),
      dataParsingFailure: () =>
          AppSnackbarUtils.showError('Lỗi', 'Không đọc được dữ liệu dashboard'),
      noConnectionFailure: () =>
          AppSnackbarUtils.showError('Lỗi', 'Không có kết nối mạng'),
      systemFailure: (_, message) =>
          AppSnackbarUtils.showError('Lỗi', message ?? 'Lỗi hệ thống'),
    );
  }
}
