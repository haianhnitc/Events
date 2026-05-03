import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';
import 'package:events_app/feature/registration/domain/usecase/registration_usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class RegistrationController extends GetxController {
  final CreateRegistrationUsecase _createRegistrationUsecase;
  final GetMyRegistrationsUsecase _getMyRegistrationsUsecase;
  final CancelRegistrationUsecase _cancelRegistrationUsecase;
  final int? Function() _getCurrentUserIdFn;

  RegistrationController._({
    required CreateRegistrationUsecase createRegistrationUsecase,
    required GetMyRegistrationsUsecase getMyRegistrationsUsecase,
    required CancelRegistrationUsecase cancelRegistrationUsecase,
    required int? Function() getCurrentUserIdFn,
  })  : _createRegistrationUsecase = createRegistrationUsecase,
        _getMyRegistrationsUsecase = getMyRegistrationsUsecase,
        _cancelRegistrationUsecase = cancelRegistrationUsecase,
        _getCurrentUserIdFn = getCurrentUserIdFn;

  factory RegistrationController() {
    return RegistrationController._(
      createRegistrationUsecase: networkGetIt<CreateRegistrationUsecase>(),
      getMyRegistrationsUsecase: networkGetIt<GetMyRegistrationsUsecase>(),
      cancelRegistrationUsecase: networkGetIt<CancelRegistrationUsecase>(),
      getCurrentUserIdFn: () => AuthController.to.currentUser.value?.userId,
    );
  }

  @visibleForTesting
  static RegistrationController internal({
    required CreateRegistrationUsecase createRegistrationUsecase,
    required GetMyRegistrationsUsecase getMyRegistrationsUsecase,
    required CancelRegistrationUsecase cancelRegistrationUsecase,
    required AuthController Function() authControllerProvider,
  }) {
    return RegistrationController._(
      createRegistrationUsecase: createRegistrationUsecase,
      getMyRegistrationsUsecase: getMyRegistrationsUsecase,
      cancelRegistrationUsecase: cancelRegistrationUsecase,
      getCurrentUserIdFn: () => authControllerProvider().currentUser.value?.userId,
    );
  }

  final RxList<ParticipantEntity> registrations = <ParticipantEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRegistering = false.obs;
  final RxBool hasMore = true.obs;
  final RxInt currentPage = 0.obs;

  static RegistrationController get to => Get.find<RegistrationController>();

  static RegistrationController ensureInstance() {
    if (!Get.isRegistered<RegistrationController>()) {
      Get.put(RegistrationController());
    }
    return Get.find<RegistrationController>();
  }

  @override
  void onInit() {
    super.onInit();
    loadMyRegistrations();
  }

  Future<void> loadMyRegistrations({bool refresh = false}) async {
    if (isLoading.value) return;

    if (refresh) {
      currentPage.value = 0;
      hasMore.value = true;
      registrations.clear();
    }

    if (!hasMore.value) return;

    isLoading.value = true;

    final userId = _getCurrentUserId();
    if (userId == null) {
      isLoading.value = false;
      return;
    }

    final result = await _getMyRegistrationsUsecase(
      GetMyRegistrationsParams(userId: userId, page: currentPage.value, size: 20),
    );

    result.fold(
      (failure) {
        _handleFailure(failure);
        isLoading.value = false;
      },
      (data) {
        if (data.isEmpty) {
          hasMore.value = false;
        } else {
          if (refresh) {
            registrations.value = data;
          } else {
            registrations.addAll(data);
          }
          currentPage.value++;
        }
        isLoading.value = false;
      },
    );
  }

  Future<ParticipantEntity?> registerForEvent(int eventId) async {
    if (isRegistering.value) return null;
    isRegistering.value = true;

    final result = await _createRegistrationUsecase(
      CreateRegistrationParams(eventId: eventId),
    );

    ParticipantEntity? registeredParticipant;

    result.fold(
      (failure) {
        _handleFailure(failure);
        isRegistering.value = false;
      },
      (participant) {
        registrations.insert(0, participant);
        registeredParticipant = participant;
        if (participant.ticketId != null) {
          AppSnackbarUtils.showSuccess('Thành công',
              'Đăng ký thành công! Vui lòng thanh toán để nhận vé.');
        } else {
          AppSnackbarUtils.showSuccess('Thành công', 'Đăng ký tham gia thành công!');
        }
        isRegistering.value = false;
      },
    );

    return registeredParticipant;
  }

  Future<void> cancelRegistration(int registrationId) async {
    isLoading.value = true;

    final result = await _cancelRegistrationUsecase(registrationId);

    result.fold(
      (failure) {
        _handleFailure(failure);
        isLoading.value = false;
      },
      (_) {
        registrations.removeWhere((r) => r.eventParticipantId == registrationId);
        AppSnackbarUtils.showSuccess('Thành công', 'Hủy đăng ký thành công');
        isLoading.value = false;
      },
    );
  }

  int? _getCurrentUserId() {
    return _getCurrentUserIdFn();
  }

  void _handleFailure(FailureEntity failure) {
    failure.when(
      serverFailure: (_, message) => AppSnackbarUtils.showError('Lỗi', message),
      dataParsingFailure: () => AppSnackbarUtils.showError('Lỗi', 'Không đọc được dữ liệu'),
      noConnectionFailure: () => AppSnackbarUtils.showError('Lỗi', 'Không có kết nối mạng'),
      systemFailure: (_, message) => AppSnackbarUtils.showError('Lỗi', message),
    );
  }
}
