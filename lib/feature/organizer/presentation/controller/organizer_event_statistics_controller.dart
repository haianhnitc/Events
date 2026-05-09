import 'package:get/get.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/event_management/domain/entity/event_statistic_entity.dart';
import 'package:events_app/feature/event_management/domain/entity/event_analytics_entity.dart';
import 'package:events_app/feature/organizer/event/domain/usecase/organizer_event_usecase.dart';

class OrganizerEventStatisticsController extends GetxController {
  GetOrganizerEventStatisticsUsecase get _getStatisticsUsecase =>
      networkGetIt<GetOrganizerEventStatisticsUsecase>();
  GetOrganizerEventAnalyticsUsecase get _getAnalyticsUsecase =>
      networkGetIt<GetOrganizerEventAnalyticsUsecase>();

  final Rx<EventStatisticEntity?> statistics = Rx<EventStatisticEntity?>(null);
  final Rx<EventAnalyticsEntity?> analytics = Rx<EventAnalyticsEntity?>(null);
  final RxBool isLoadingStats = false.obs;
  final RxBool isLoadingAnalytics = false.obs;
  final RxBool isRefreshing = false.obs;
  final Rx<DateTime?> analyticsLastFetch = Rx<DateTime?>(null);

  static const _analyticsCacheDuration = Duration(minutes: 5);

  int? _eventId;

  void setEventId(int id) {
    _eventId = id;
    loadAll();
  }

  Future<void> loadAll() async {
    if (_eventId == null) return;
    await Future.wait([loadStatistics(), loadAnalytics()]);
  }

  Future<void> loadStatistics() async {
    if (_eventId == null || isLoadingStats.value) return;
    isLoadingStats.value = true;
    final result = await _getStatisticsUsecase(_eventId!);
    result.fold(
      (failure) => _handleFailure(failure),
      (data) => statistics.value = data,
    );
    isLoadingStats.value = false;
  }

  Future<void> loadAnalytics() async {
    if (_eventId == null || isLoadingAnalytics.value) return;

    if (analytics.value != null && analyticsLastFetch.value != null) {
      final elapsed = DateTime.now().difference(analyticsLastFetch.value!);
      if (elapsed < _analyticsCacheDuration) return;
    }

    isLoadingAnalytics.value = true;
    final result = await _getAnalyticsUsecase(_eventId!);
    result.fold(
      (failure) => _handleFailure(failure),
      (data) {
        analytics.value = data;
        analyticsLastFetch.value = DateTime.now();
      },
    );
    isLoadingAnalytics.value = false;
  }

  Future<void> refreshAnalytics() async {
    if (_eventId == null || isLoadingAnalytics.value) return;
    isLoadingAnalytics.value = true;
    final result = await _getAnalyticsUsecase(_eventId!);
    result.fold(
      (failure) => _handleFailure(failure),
      (data) {
        analytics.value = data;
        analyticsLastFetch.value = DateTime.now();
      },
    );
    isLoadingAnalytics.value = false;
  }

  Future<void> refresh() async {
    if (isRefreshing.value) return;
    isRefreshing.value = true;
    await Future.wait([loadStatistics(), refreshAnalytics()]);
    isRefreshing.value = false;
  }

  void _handleFailure(FailureEntity failure) {
    AuthController.handleFailure(failure);
  }
}
