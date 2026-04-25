import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/common/domain/entity/category_entity.dart';
import 'package:events_app/feature/common/domain/usecase/category_usecase.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  GetCategoriesUsecase get _getCategoriesUsecase =>
      networkGetIt<GetCategoriesUsecase>();

  final RxList<CategoryEntity> categories = <CategoryEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasLoaded = false.obs;

  Future<void> loadCategories() async {
    if (hasLoaded.value) return;
    isLoading.value = true;
    try {
      final result = await _getCategoriesUsecase.call(null);
      result.fold(
        (failure) {
          _showFailure(failure);
        },
        (data) {
          categories.assignAll(data);
          hasLoaded.value = true;
        },
      );
    } catch (e) {
      AppSnackbarUtils.showError('Lỗi', 'Không thể tải danh mục');
    } finally {
      isLoading.value = false;
    }
  }

  void _showFailure(failure) {
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
