import 'package:get/get.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/user_management/domain/entity/organization_dashboard_entity.dart';
import 'package:events_app/feature/organizer/organization/domain/usecase/organizer_organization_usecase.dart';

class OrganizerDashboardController extends GetxController {
  GetOrganizerDashboardUsecase get _getDashboardUsecase =>
      networkGetIt<GetOrganizerDashboardUsecase>();

  final Rx<OrganizationDashboardEntity?> dashboard =
      Rx<OrganizationDashboardEntity?>(null);

  final RxBool isLoadingMetrics = false.obs;
  final RxBool isLoadingRecentEvents = false.obs;
  final RxBool isLoadingStaffInfo = false.obs;
  final RxBool isRefreshing = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    final orgId = AuthController.to.currentUser.value?.userId;
    if (orgId == null) return;

    isLoadingMetrics.value = true;
    isLoadingRecentEvents.value = true;
    isLoadingStaffInfo.value = true;

    try {
      final result = await _getDashboardUsecase(orgId);

      result.fold(
        (failure) {
          _handleFailure(failure);
          isLoadingMetrics.value = false;
          isLoadingRecentEvents.value = false;
          isLoadingStaffInfo.value = false;
        },
        (data) {
          dashboard.value = data;

          isLoadingMetrics.value = false;

          Future.delayed(const Duration(milliseconds: 50), () {
            isLoadingRecentEvents.value = false;
          });

          Future.delayed(const Duration(milliseconds: 100), () {
            isLoadingStaffInfo.value = false;
          });
        },
      );
    } catch (e) {
      isLoadingMetrics.value = false;
      isLoadingRecentEvents.value = false;
      isLoadingStaffInfo.value = false;
    }
  }

  Future<void> refreshDashboard() async {
    if (isRefreshing.value) return;
    isRefreshing.value = true;
    await loadDashboard();
    isRefreshing.value = false;
  }

  void _handleFailure(FailureEntity failure) {
    AuthController.handleFailure(failure);
  }
}
