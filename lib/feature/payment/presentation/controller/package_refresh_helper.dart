import 'package:get/get.dart';

class PackageRefreshHelper {
  static void refreshByPackageId(int packageId) {
    try {
      final ctrl = Get.find<dynamic>(tag: 'package_list');
      ctrl.reloadMyPackages();
      ctrl.loadAvailablePackages(refresh: true);
    } catch (_) {}
  }

  static void refreshPackageList() {
    try {
      final ctrl = Get.find<dynamic>(tag: 'package_list');
      ctrl.reloadMyPackages();
      ctrl.reloadExpiredPackages();
      ctrl.loadAvailablePackages(refresh: true);
    } catch (_) {}
  }
}
