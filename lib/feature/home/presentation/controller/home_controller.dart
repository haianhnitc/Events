import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/event_management/domain/usecase/get_featured_events_usecase.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  HomeController() {
    _getFeaturedEventsUsecase = getIt<GetFeaturedEventsUsecase>();
  }

  late final GetFeaturedEventsUsecase _getFeaturedEventsUsecase;

  final RxList<EventSummaryEntity> featuredEvents = <EventSummaryEntity>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadFeaturedEvents();
  }

  Future<void> loadFeaturedEvents() async {
    isLoading.value = true;

    final result = await _getFeaturedEventsUsecase();

    result.fold(
      (failure) {
        _handleFailure(failure);
        isLoading.value = false;
      },
      (data) {
        featuredEvents.assignAll(data);
        isLoading.value = false;
      },
    );
  }

  void _handleFailure(FailureEntity failure) {
    failure.when(
      serverFailure: (_, message) =>
          AppSnackbarUtils.showError('Lỗi', message),
      dataParsingFailure: () =>
          AppSnackbarUtils.showError('Lỗi', 'Không đọc được dữ liệu'),
      noConnectionFailure: () =>
          AppSnackbarUtils.showError('Lỗi', 'Không có kết nối mạng'),
      systemFailure: (_, message) =>
          AppSnackbarUtils.showError('Lỗi', message),
    );
  }
}
