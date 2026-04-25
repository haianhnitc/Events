import 'package:get/get.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/user_management/domain/entity/user_entity.dart';
import 'package:events_app/feature/user_management/domain/repository/user_repository.dart';

class UserDetailController extends GetxController {
  final UserRepository _userRepo = networkGetIt<UserRepository>();

  final Rx<UserEntity?> user = Rx<UserEntity?>(null);
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;

  Future<void> load(int userId) async {
    isLoading.value = true;
    error.value = '';

    final result = await _userRepo.getUserById(userId);
    result.fold(
      (failure) {
        error.value = failure.errorCode() ?? 'Lỗi khi tải thông tin';
        isLoading.value = false;
      },
      (data) {
        user.value = data;
        isLoading.value = false;
      },
    );
  }

  String get fullName =>
      user.value?.userProfile?.fullName ?? user.value?.email ?? 'Người dùng';

  String get avatarUrl => user.value?.userProfile?.avatarUrl ?? '';

  String? get university => user.value?.userProfile?.university;

  String? get faculty => user.value?.userProfile?.faculty;

  String? get major => user.value?.userProfile?.major;

  String? get phoneNumber => user.value?.phoneNumber;

  String? get email => user.value?.email;

  int get currentCoin => user.value?.currentCoin ?? 0;

  String get roleLabel {
    switch (user.value?.role) {
      case UserRole.admin:
        return 'Quản trị';
      case UserRole.organization:
        return 'Tổ chức';
      case UserRole.user:
      case null:
        return 'Người dùng';
    }
  }

  String get joinedDate {
    final d = user.value?.createdTime;
    if (d == null) return '';
    return '${d.day}/${d.month}/${d.year}';
  }
}
