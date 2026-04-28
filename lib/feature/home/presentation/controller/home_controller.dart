import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/event_management/domain/usecase/get_featured_events_usecase.dart';
import 'package:events_app/feature/user_management/domain/entity/rank_entity.dart';
import 'package:events_app/feature/user_management/domain/repository/user_repository.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  HomeController() {
    _getFeaturedEventsUsecase = getIt<GetFeaturedEventsUsecase>();
    _userRepo = getIt<UserRepository>();
  }

  late final GetFeaturedEventsUsecase _getFeaturedEventsUsecase;
  late final UserRepository _userRepo;

  final RxList<EventSummaryEntity> featuredEvents = <EventSummaryEntity>[].obs;
  final Rx<RankEntity?> userRank = Rx<RankEntity?>(null);
  final RxBool isLoading = true.obs;
  final RxBool isLoadingRank = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadFeaturedEvents();
    _loadUserRank();
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

  Future<void> _loadUserRank() async {
    isLoadingRank.value = true;
    final userId = _getCurrentUserId();
    if (userId == null) {
      isLoadingRank.value = false;
      return;
    }

    final result = await _userRepo.getUserRank(userId);
    result.fold(
      (failure) => isLoadingRank.value = false,
      (rank) {
        userRank.value = rank;
        isLoadingRank.value = false;
      },
    );
  }

  int? _getCurrentUserId() {
    try {
      return AuthController.to.currentUser.value?.userId;
    } catch (_) {
      return null;
    }
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
