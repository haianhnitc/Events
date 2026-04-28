import 'package:get/get.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/portfolio/domain/entity/portfolio_entity.dart';
import 'package:events_app/feature/user_management/domain/repository/user_repository.dart';

class PortfolioListController extends GetxController {
  UserRepository get _userRepo => networkGetIt<UserRepository>();

  final RxList<PortfolioEntity> publishedPortfolios = <PortfolioEntity>[].obs;
  final RxList<PortfolioEntity> draftPortfolios = <PortfolioEntity>[].obs;

  final RxBool isLoadingPublished = false.obs;
  final RxBool isLoadingDrafts = false.obs;
  final RxBool hasMorePublished = true.obs;
  final RxBool hasMoreDrafts = true.obs;

  int _publishedPage = 0;
  int _draftsPage = 0;
  static const int pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    loadAll();
  }

  void loadAll() {
    loadPublished(refresh: true);
    loadDrafts(refresh: true);
  }

  Future<void> loadPublished({bool refresh = false}) async {
    if (isLoadingPublished.value) return;
    if (refresh) {
      _publishedPage = 0;
      hasMorePublished.value = true;
      publishedPortfolios.clear();
    }
    if (!hasMorePublished.value && !refresh) return;

    isLoadingPublished.value = true;

    final userId = AuthController.to.currentUser.value?.userId;
    final result = await _userRepo.getPortfolios(
      userId: userId,
      isPublished: true,
      page: _publishedPage,
      size: pageSize,
    );

    result.fold(
      (failure) => isLoadingPublished.value = false,
      (data) {
        if (data.isEmpty) {
          hasMorePublished.value = false;
        } else {
          if (refresh) {
            publishedPortfolios.assignAll(data);
          } else {
            publishedPortfolios.addAll(data);
          }
          _publishedPage++;
          hasMorePublished.value = data.length >= pageSize;
        }
        isLoadingPublished.value = false;
      },
    );
  }

  Future<void> loadDrafts({bool refresh = false}) async {
    if (isLoadingDrafts.value) return;
    if (refresh) {
      _draftsPage = 0;
      hasMoreDrafts.value = true;
      draftPortfolios.clear();
    }
    if (!hasMoreDrafts.value && !refresh) return;

    isLoadingDrafts.value = true;

    final userId = AuthController.to.currentUser.value?.userId;
    final result = await _userRepo.getPortfolios(
      userId: userId,
      isPublished: false,
      page: _draftsPage,
      size: pageSize,
    );

    result.fold(
      (failure) => isLoadingDrafts.value = false,
      (data) {
        if (data.isEmpty) {
          hasMoreDrafts.value = false;
        } else {
          if (refresh) {
            draftPortfolios.assignAll(data);
          } else {
            draftPortfolios.addAll(data);
          }
          _draftsPage++;
          hasMoreDrafts.value = data.length >= pageSize;
        }
        isLoadingDrafts.value = false;
      },
    );
  }

  void onTabChanged(int index) {
    if (index == 0 && publishedPortfolios.isEmpty) {
      loadPublished();
    } else if (index == 1 && draftPortfolios.isEmpty) {
      loadDrafts();
    }
  }
}
