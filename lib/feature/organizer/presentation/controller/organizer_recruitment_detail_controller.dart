import 'package:flutter/foundation.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/event_management/domain/usecase/get_event_by_id_usecase.dart';
import 'package:events_app/feature/recruitment/domain/entity/ctv_recruitment_entity.dart';
import 'package:events_app/feature/recruitment/domain/usecase/ctv_recruitment_usecase.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_recruitment_list_controller.dart';
import 'package:get/get.dart';

class OrganizerRecruitmentDetailController extends GetxController {
  OrganizerRecruitmentDetailController({required this.recruitmentId}) {
    _getRecruitmentByIdUsecase = networkGetIt<GetRecruitmentByIdUsecase>();
    _getEventByIdUsecase = networkGetIt<GetEventByIdUsecase>();
  }

  late final GetRecruitmentByIdUsecase _getRecruitmentByIdUsecase;
  late final GetEventByIdUsecase _getEventByIdUsecase;

  final int recruitmentId;
  final Rxn<CtvRecruitmentEntity> recruitment = Rxn<CtvRecruitmentEntity>();
  final Rxn<EventStatus> eventStatus = Rxn<EventStatus>();
  final RxBool isLoading = true.obs;

  static String _buildTag(int recruitmentId) =>
      'organizer_recruitment_detail_$recruitmentId';

  static OrganizerRecruitmentDetailController attach(int recruitmentId) {
    final tag = _buildTag(recruitmentId);
    if (Get.isRegistered<OrganizerRecruitmentDetailController>(tag: tag)) {
      return Get.find<OrganizerRecruitmentDetailController>(tag: tag);
    }
    return Get.put(
      OrganizerRecruitmentDetailController(recruitmentId: recruitmentId),
      tag: tag,
    );
  }

  static void detach(int recruitmentId) {
    final tag = _buildTag(recruitmentId);
    if (Get.isRegistered<OrganizerRecruitmentDetailController>(tag: tag)) {
      Get.delete<OrganizerRecruitmentDetailController>(tag: tag);
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadRecruitment();
    _watchRecruitmentUpdates();
  }

  void _watchRecruitmentUpdates() {
    ever(OrganizerRecruitmentListController.recruitmentStateUpdate, (tuple) {
      final (updatedId, newIsOpen) = tuple;
      if (recruitmentId == updatedId) {
        refreshRecruitment();
      }
    });
  }

  Future<void> loadRecruitment() async {
    isLoading.value = true;

    final result = await _getRecruitmentByIdUsecase(recruitmentId);

    result.fold(
      (failure) {
        _handleFailure(failure);
        isLoading.value = false;
      },
      (data) {
        recruitment.value = data;
        _loadEventStatus(data.eventId);
      },
    );
  }

  Future<void> refreshRecruitment() async {
    final result = await _getRecruitmentByIdUsecase(recruitmentId);
    result.fold(
      (failure) {
        debugPrint('[RecruitmentDetail] refresh failed: $failure');
      },
      (data) {
        recruitment.value = data;
        _loadEventStatus(data.eventId);
      },
    );
  }

  Future<void> _loadEventStatus(int? eventId) async {
    if (eventId == null) {
      isLoading.value = false;
      return;
    }

    final result = await _getEventByIdUsecase(eventId);

    result.fold(
      (_) => isLoading.value = false,
      (event) {
        eventStatus.value = event.status;
        isLoading.value = false;
      },
    );
  }

  String? getEditBlockReason() {
    final r = recruitment.value;
    if (r == null) return null;
    if (r.isOpen == true) return 'Bài tuyển đang mở, không thể chỉnh sửa.';
    final status = eventStatus.value;
    if (status != null &&
        status != EventStatus.draft &&
        status != EventStatus.published) {
      return 'Sự kiện đang ở trạng thái "${status.name}", không thể chỉnh sửa bài tuyển.';
    }
    return null;
  }

  bool get canEdit => getEditBlockReason() == null;

  void _handleFailure(FailureEntity failure) {
    AuthController.handleFailure(failure);
  }
}
