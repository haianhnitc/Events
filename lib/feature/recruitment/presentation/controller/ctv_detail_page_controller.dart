import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/feature/common/utils/category_label_utils.dart';
import 'package:events_app/feature/recruitment/domain/entity/ctv_recruitment_entity.dart';
import 'package:events_app/feature/recruitment/domain/usecase/ctv_recruitment_usecase.dart';
import 'package:events_app/feature/event_management/presentation/utils/event_action_utils.dart';
import 'package:events_app/feature/recruitment/presentation/controller/ctv_controller.dart';
import 'package:get/get.dart';

class CtvDetailPageController extends GetxController {
  CtvDetailPageController({required this.ctvRecruitmentId}) {
    _getRecruitmentByIdUsecase = networkGetIt<GetRecruitmentByIdUsecase>();
  }

  late final GetRecruitmentByIdUsecase _getRecruitmentByIdUsecase;

  final int? ctvRecruitmentId;
  final Rxn<CtvRecruitmentEntity> recruitment = Rxn<CtvRecruitmentEntity>();
  final RxBool isLoading = true.obs;
  final CtvController _ctvController = Get.find<CtvController>();

  static String buildTag(int? ctvRecruitmentId) {
    return 'ctv_detail_${ctvRecruitmentId ?? 'unknown'}';
  }

  static CtvDetailPageController attach(int? ctvRecruitmentId) {
    final tag = buildTag(ctvRecruitmentId);
    if (Get.isRegistered<CtvDetailPageController>(tag: tag)) {
      return Get.find<CtvDetailPageController>(tag: tag);
    }

    return Get.put(
      CtvDetailPageController(ctvRecruitmentId: ctvRecruitmentId),
      tag: tag,
    );
  }

  static void detach(int? ctvRecruitmentId) {
    final tag = buildTag(ctvRecruitmentId);
    if (Get.isRegistered<CtvDetailPageController>(tag: tag)) {
      Get.delete<CtvDetailPageController>(tag: tag);
    }
  }

  @override
  void onInit() {
    super.onInit();
    _loadRecruitment();
  }

  Future<void> _loadRecruitment() async {
    if (ctvRecruitmentId == null) {
      isLoading.value = false;
      return;
    }

    isLoading.value = true;

    final result = await _getRecruitmentByIdUsecase(ctvRecruitmentId!);

    result.fold(
      (failure) {
        _handleFailure(failure);
        isLoading.value = false;
      },
      (data) {
        recruitment.value = data;
        isLoading.value = false;
      },
    );
  }

  Future<void> reloadApplicationStatus() async {
    await _loadRecruitment();
    _ctvController.loadRecruitments(refresh: true);
  }

  List<String> get categoryValues =>
      CategoryLabelUtils.valuesFromEntities(recruitment.value?.categories);

  List<CategoryDisplayGroup> get categoryGroups =>
      CategoryLabelUtils.groupsFromEntities(recruitment.value?.categories);

  bool get hasCashReward => (recruitment.value?.cashRewardAmount ?? 0) > 0;

  String get cashRewardLabel =>
      '${recruitment.value?.cashRewardAmount ?? 0} VNĐ';

  bool get hasCertificate =>
      (recruitment.value?.certificateName ?? '').trim().isNotEmpty;

  int get quantity => recruitment.value?.quantity ?? 0;

  int get recruitedCount => recruitment.value?.recruitedCtvCount ?? 0;

  int get remainingSlots {
    final remaining = quantity - recruitedCount;
    if (remaining <= 0) return 0;
    return remaining;
  }

  int get recruitedPercent {
    if (quantity <= 0) return 0;
    return ((recruitedCount * 100) / quantity).toInt().clamp(0, 100);
  }

  double get recruitedProgress {
    if (quantity <= 0) return 0;
    return (recruitedCount / quantity).clamp(0.0, 1.0);
  }

  List<String> get benefits {
    final item = recruitment.value;
    if (item == null) return const <String>[];

    final items = <String>[];
    if ((item.youthUnionPoint ?? 0) > 0) {
      items.add('Nhận ngay ${item.youthUnionPoint} điểm đoàn');
    }
    if ((item.cashRewardAmount ?? 0) > 0) {
      items.add('Lương ${item.cashRewardAmount} VNĐ');
    }
    if ((item.certificateName ?? '').trim().isNotEmpty) {
      items.add(item.certificateName!.trim());
    }

    items.add('Chứng chỉ sinh viên 5 tốt');
    items.add('Được trải nghiệm công việc mong muốn');
    items.add('Được làm việc cùng các chuyên gia');
    return items;
  }

  ActionButtonState get actionState {
    final item = recruitment.value;

    if (item == null) {
      return const ActionButtonState(label: 'Ứng tuyển', isEnabled: false);
    }

    return _ctvController.getApplyActionStateByValues(
      isOpen: item.isOpen,
      quantity: item.quantity,
      userEventState: item.userEventState,
    );
  }

  void _handleFailure(FailureEntity failure) {
    failure.when(
      serverFailure: (_, message) => AppSnackbarUtils.showError('Lỗi', message),
      dataParsingFailure: () =>
          AppSnackbarUtils.showError('Lỗi', 'Không đọc được dữ liệu'),
      noConnectionFailure: () =>
          AppSnackbarUtils.showError('Lỗi', 'Không có kết nối mạng'),
      systemFailure: (_, message) => AppSnackbarUtils.showError('Lỗi', message),
    );
  }
}
