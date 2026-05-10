import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/user_management/domain/entity/rank_entity.dart';
import 'package:events_app/feature/user_management/domain/repository/user_repository.dart';
import 'package:events_app/feature/user_management/presentation/widget/user_detail_bottom_sheet.dart';

class RankListController extends GetxController {
  UserRepository get _userRepo => networkGetIt<UserRepository>();

  final RxList<RankEntity> ranks = <RankEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasMore = true.obs;
  final RxString selectedLevel = 'Tất cả'.obs;
  final Rx<RankEntity?> myRank = Rx<RankEntity?>(null);

  int _currentPage = 0;
  static const int pageSize = 20;

  final List<Map<String, String>> levelFilters = [
    {'label': 'Tất cả', 'value': ''},
    {'label': 'Chiến thần', 'value': 'Chiến thần'},
    {'label': 'Tướng quân', 'value': 'Tướng quân'},
    {'label': 'Chiến binh', 'value': 'Chiến binh'},
    {'label': 'Thợ săn', 'value': 'Thợ săn'},
    {'label': 'Lính mới', 'value': 'Lính mới'},
  ];

  @override
  void onInit() {
    super.onInit();
    loadMyRank();
    loadRanks();
  }

  Future<void> loadRanks({bool refresh = false}) async {
    if (isLoading.value) return;
    if (refresh) {
      _currentPage = 0;
      hasMore.value = true;
      ranks.clear();
    }
    if (!hasMore.value && !refresh) return;

    isLoading.value = true;

    final levelValue = levelFilters
        .firstWhere((f) => f['label'] == selectedLevel.value)['value']!;

    final result = await _userRepo.getRanks(
      levelName: levelValue.isEmpty ? null : levelValue,
      page: _currentPage,
      size: pageSize,
    );

    result.fold(
      (failure) {
        debugPrint('[RankList] getRanks failed: $failure');
        _handleFailure(failure);
        isLoading.value = false;
      },
      (data) {
        if (data.isEmpty) {
          hasMore.value = false;
        } else {
          if (refresh) {
            ranks.assignAll(data);
          } else {
            ranks.addAll(data);
          }
          _currentPage++;
          hasMore.value = data.length >= pageSize;
        }
        isLoading.value = false;
      },
    );
  }

  Future<void> loadMyRank() async {
    final user = AuthController.to.currentUser.value;
    if (user?.userId == null) return;

    final result = await _userRepo.getUserRank(user!.userId!);
    result.fold(
      (failure) => debugPrint('[RankList] getUserRank failed: $failure'),
      (rank) => myRank.value = rank,
    );
  }

  void _handleFailure(FailureEntity failure) {
    AuthController.handleFailure(failure);
  }

  void onLevelChanged(String level) {
    selectedLevel.value = level;
    loadRanks(refresh: true);
  }

  int? get currentUserId => AuthController.to.currentUser.value?.userId;
  String? get currentUserName =>
      AuthController.to.currentUser.value?.userProfile?.fullName ?? 'Bạn';
  String? get currentAvatarUrl =>
      AuthController.to.currentUser.value?.userProfile?.avatarUrl;

  void showUserDetail(RankEntity rank) {
    if (rank.userId == null) return;
    showUserDetailBottomSheet(rank.userId!);
  }
}
