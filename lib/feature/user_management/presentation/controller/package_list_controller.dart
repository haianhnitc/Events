import 'package:get/get.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/common/domain/entity/package_entity.dart';
import 'package:events_app/feature/user_management/domain/entity/user_package_entity.dart';
import 'package:events_app/feature/payment/presentation/page/shared_payment_flow_args.dart';
import 'package:events_app/feature/payment/presentation/page/shared_payment_flow_page.dart';
import 'package:events_app/feature/user_management/domain/repository/user_repository.dart';

class PackageListController extends GetxController {
  UserRepository get _userRepo => networkGetIt<UserRepository>();

  final RxList<PackageEntity> availablePackages = <PackageEntity>[].obs;
  final RxList<UserPackageEntity> myPackages = <UserPackageEntity>[].obs;
  final RxList<UserPackageEntity> expiredPackages = <UserPackageEntity>[].obs;

  final RxBool isLoadingAvailable = true.obs;
  final RxBool isLoadingMyPackages = true.obs;
  final RxBool isLoadingExpired = true.obs;

  final RxBool hasMoreAvailable = true.obs;
  final RxBool hasMoreMyPackages = true.obs;
  final RxBool hasMoreExpired = true.obs;

  int _availablePage = 0;
  int _myPackagesPage = 0;
  int _expiredPage = 0;
  static const int pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {
    loadAvailablePackages();
    loadMyPackages();
    loadExpiredPackages();
  }

  void onTabChanged(int index) {
    switch (index) {
      case 0:
        if (availablePackages.isEmpty) loadAvailablePackages();
        break;
      case 1:
        if (myPackages.isEmpty) loadMyPackages();
        break;
      case 2:
        if (expiredPackages.isEmpty) loadExpiredPackages();
        break;
    }
  }

  Future<void> loadAvailablePackages({bool refresh = false}) async {
    if (isLoadingAvailable.value) return;
    if (refresh) {
      _availablePage = 0;
      hasMoreAvailable.value = true;
      availablePackages.clear();
    }
    if (!hasMoreAvailable.value && !refresh) return;

    isLoadingAvailable.value = true;

    final result = await _userRepo.getPackages(
      page: _availablePage,
      size: pageSize,
    );

    result.fold(
      (failure) => isLoadingAvailable.value = false,
      (data) {
        if (data.isEmpty) {
          hasMoreAvailable.value = false;
        } else {
          if (refresh) {
            availablePackages.assignAll(data);
          } else {
            availablePackages.addAll(data);
          }
          _availablePage++;
          hasMoreAvailable.value = data.length >= pageSize;
        }
        isLoadingAvailable.value = false;
      },
    );
  }

  Future<void> loadMyPackages({bool refresh = false}) async {
    if (isLoadingMyPackages.value) return;
    if (refresh) {
      _myPackagesPage = 0;
      hasMoreMyPackages.value = true;
      myPackages.clear();
    }
    if (!hasMoreMyPackages.value && !refresh) return;

    isLoadingMyPackages.value = true;

    final result = await _userRepo.getUserPackages(
      page: _myPackagesPage,
      size: pageSize,
    );

    result.fold(
      (failure) => isLoadingMyPackages.value = false,
      (data) {
        if (data.isEmpty) {
          hasMoreMyPackages.value = false;
        } else {
          if (refresh) {
            myPackages.assignAll(data);
          } else {
            myPackages.addAll(data);
          }
          _myPackagesPage++;
          hasMoreMyPackages.value = data.length >= pageSize;
        }
        isLoadingMyPackages.value = false;
      },
    );
  }

  Future<void> loadExpiredPackages({bool refresh = false}) async {
    if (isLoadingExpired.value) return;
    if (refresh) {
      _expiredPage = 0;
      hasMoreExpired.value = true;
      expiredPackages.clear();
    }
    if (!hasMoreExpired.value && !refresh) return;

    isLoadingExpired.value = true;

    final result = await _userRepo.getExpiredPackages(
      page: _expiredPage,
      size: pageSize,
    );

    result.fold(
      (failure) => isLoadingExpired.value = false,
      (data) {
        if (data.isEmpty) {
          hasMoreExpired.value = false;
        } else {
          if (refresh) {
            expiredPackages.assignAll(data);
          } else {
            expiredPackages.addAll(data);
          }
          _expiredPage++;
          hasMoreExpired.value = data.length >= pageSize;
        }
        isLoadingExpired.value = false;
      },
    );
  }

  void onPurchasePackage(PackageEntity package) {
    final pkgId = package.packageId;
    final price = package.price ?? 0;
    if (pkgId == null) return;

    final args = SharedPaymentFlowArgs.forPackagePurchase(
      packageId: pkgId,
      originalAmount: price,
      autoRenew: false,
      package: package,
    );

    Get.to(() => SharedPaymentCheckoutPage(args: args));
  }

  void onRenewPackage(UserPackageEntity userPackage) {
    final userPkgId = userPackage.userPackageId;
    if (userPkgId == null) return;

    final args = SharedPaymentFlowArgs.forPackageRenewal(
      userPackageId: userPkgId,
      originalAmount: 0,
    );

    Get.to(() => SharedPaymentCheckoutPage(args: args));
  }
}
