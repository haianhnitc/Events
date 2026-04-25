import 'package:get/get.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/portfolio/domain/entity/portfolio_detail_entity.dart';
import 'package:events_app/feature/user_management/domain/repository/user_repository.dart';

class PortfolioDetailController extends GetxController {
  UserRepository get _userRepo => networkGetIt<UserRepository>();

  final RxBool isLoading = false.obs;
  final Rx<PortfolioDetailEntity?> portfolio = Rx<PortfolioDetailEntity?>(null);

  int? _portfolioId;

  void initWithId(int id) {
    _portfolioId = id;
    loadDetail();
  }

  Future<void> loadDetail() async {
    if (_portfolioId == null) return;
    isLoading.value = true;
    final result = await _userRepo.getPortfolioDetail(_portfolioId!);
    result.fold<void>(
      (failure) => isLoading.value = false,
      (data) {
        if (data != null) portfolio.value = data;
        isLoading.value = false;
      },
    );
  }

  bool get isOwner {
    final currentUserId = AuthController.to.currentUser.value?.userId;
    final ownerId = portfolio.value?.userId;
    return currentUserId != null && currentUserId == ownerId;
  }

  bool get isPublished => portfolio.value?.isPublished == true;
  int? get currentUserId => AuthController.to.currentUser.value?.userId;
}
