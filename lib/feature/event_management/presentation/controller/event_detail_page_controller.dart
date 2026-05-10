import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/utils/category_label_utils.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/feature/event_management/domain/entity/event_entity.dart';
import 'package:events_app/feature/event_management/domain/usecase/get_event_by_id_usecase.dart';
import 'package:events_app/feature/payment/presentation/page/shared_payment_flow_args.dart';
import 'package:events_app/feature/payment/presentation/page/shared_payment_flow_page.dart';
import 'package:events_app/feature/registration/presentation/controller/registration_controller.dart';
import 'package:events_app/feature/event_management/presentation/utils/event_action_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventDetailPageController extends GetxController {
  EventDetailPageController({required this.eventId}) {
    _getEventByIdUsecase = networkGetIt<GetEventByIdUsecase>();
  }

  late final GetEventByIdUsecase _getEventByIdUsecase;

  final int? eventId;
  final Rxn<EventEntity> event = Rxn<EventEntity>();
  final RxBool isRefreshing = false.obs;
  final RxBool isSubmittingRegistration = false.obs;

  bool get isLoading => isRefreshing.value;

  static String tagFor(int? eventId) => 'event_detail_${eventId ?? 'unknown'}';

  static void refreshByEventId(int? eventId) {
    if (eventId == null) return;
    final tag = tagFor(eventId);
    if (Get.isRegistered<EventDetailPageController>(tag: tag)) {
      Get.find<EventDetailPageController>(tag: tag).refreshEvent();
    }
  }

  @override
  void onInit() {
    super.onInit();
    _loadEvent();
    _watchRegistrationUpdates();
  }

  void _watchRegistrationUpdates() {
    final regCtrl = RegistrationController.ensureInstance();
    ever(regCtrl.eventStateUpdate, (tuple) {
      final (updatedEventId, newState) = tuple;
      debugPrint(
          '[EventDetail] ever triggered — eventId=$updatedEventId, newState=$newState, currentEventId=${event.value?.eventId}');
      if (event.value?.eventId == updatedEventId) {
        debugPrint('[EventDetail] ever updating userEventState');
        event.value = event.value?.copyWith(userEventState: newState);
      }
    });
  }

  Future<void> _loadEvent() async {
    if (eventId == null) {
      isRefreshing.value = false;
      return;
    }

    isRefreshing.value = true;

    final result = await _getEventByIdUsecase(eventId!);

    result.fold(
      (failure) {
        _handleFailure(failure);
        isRefreshing.value = false;
      },
      (data) {
        event.value = data;
        isRefreshing.value = false;
      },
    );
  }

  Future<void> refreshEvent() async {
    debugPrint('[EventDetail] refreshEvent() CALLED — eventId=$eventId');
    await _loadEvent();
    debugPrint(
        '[EventDetail] refreshEvent() DONE — event.value?.eventId=${event.value?.eventId}, userEventState=${event.value?.userEventState}');
  }

  List<String> get categoryValues =>
      CategoryLabelUtils.valuesFromEntities(event.value?.categories);

  List<CategoryDisplayGroup> get categoryGroups =>
      CategoryLabelUtils.groupsFromEntities(event.value?.categories);

  bool get hasCertificate =>
      (event.value?.certificateName ?? '').trim().isNotEmpty;

  bool get hasRewardInfo =>
      (event.value?.rewardCoin ?? 0) > 0 ||
      (event.value?.youthUnionPoint ?? 0) > 0 ||
      hasCertificate;

  String get priceLabel {
    final value = event.value?.price;
    return value == null ? 'Miễn phí' : '$value VNĐ';
  }

  int get venueCapacity => event.value?.venue?.capacity ?? 0;

  int get totalParticipants => event.value?.totalParticipants ?? 0;

  int get remainingSlots {
    final remaining = venueCapacity - totalParticipants;
    if (remaining <= 0) return 0;
    return remaining;
  }

  int get registrationPercent {
    if (venueCapacity <= 0) return 0;
    return ((totalParticipants * 100) / venueCapacity).toInt().clamp(0, 100);
  }

  double get registrationProgress {
    if (venueCapacity <= 0) return 0;
    return (totalParticipants / venueCapacity).clamp(0.0, 1.0);
  }

  Future<void> registerAndHandlePayment() async {
    if (isSubmittingRegistration.value) return;
    final currentEvent = event.value;
    final currentEventId = currentEvent?.eventId;
    if (currentEventId == null) return;

    isSubmittingRegistration.value = true;
    try {
      final participant =
          await RegistrationController.ensureInstance().registerForEvent(
        currentEventId,
      );

      if (participant == null) {
        isSubmittingRegistration.value = false;
        return;
      }

      final ticketId = participant.ticketId;
      final eventPrice = currentEvent?.price ?? 0;

      if (ticketId == null && eventPrice > 0) {
        AppSnackbarUtils.showError(
          'Lỗi hệ thống',
          'Không nhận được thông tin vé. Vui lòng thử lại sau.',
        );
        isSubmittingRegistration.value = false;
        return;
      }

      if (ticketId == null || eventPrice == 0) {
        AppSnackbarUtils.showSuccess(
            'Thành công', 'Đăng ký tham gia thành công!');
        RegistrationController.ensureInstance().eventStateUpdate.value =
            (currentEventId, UserEventState.attendee);
        isSubmittingRegistration.value = false;
        return;
      }

      if (eventPrice > 0) {
        final result = await Get.to(
          () => SharedPaymentCheckoutPage(
            args: SharedPaymentFlowArgs.forTicket(
              title: currentEvent?.title ?? 'Thanh toán vé sự kiện',
              originalAmount: eventPrice,
              ticketId: ticketId,
              event: currentEvent,
            ),
          ),
        );
        if (result == true) {
          refreshEvent();
        }
        isSubmittingRegistration.value = false;
      }
    } catch (_) {
      isSubmittingRegistration.value = false;
    }
  }

  List<String> get benefits {
    final currentEvent = event.value;
    if (currentEvent == null) return const <String>[];

    final items = <String>[];
    if (currentEvent.price == null) {
      items.add('Miễn phí tham dự');
    }
    if ((currentEvent.rewardCoin ?? 0) > 0) {
      items.add('Nhận ngay ${currentEvent.rewardCoin} xu');
    }
    if ((currentEvent.youthUnionPoint ?? 0) > 0) {
      items.add('Nhận ngay ${currentEvent.youthUnionPoint} điểm đoàn');
    }
    if ((currentEvent.certificateName ?? '').trim().isNotEmpty) {
      items.add(currentEvent.certificateName!.trim());
    }

    items.add('Kết nối với sinh viên cùng sở thích');
    items.add('Gặp mặt các diễn giả hàng đầu');
    return items;
  }

  ActionButtonState get actionState {
    final currentEvent = event.value;
    return EventActionUtils.getEventRegisterState(
      status: currentEvent?.status,
      registerOpenTime: currentEvent?.registerOpenTime,
      endTime: currentEvent?.endTime,
      capacity: currentEvent?.venue?.capacity,
      totalParticipants: currentEvent?.totalParticipants,
      userEventState: currentEvent?.userEventState,
    );
  }

  void _handleFailure(FailureEntity failure) {
    AuthController.handleFailure(failure);
  }
}
