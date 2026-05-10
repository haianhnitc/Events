import 'package:get/get.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/event_management/domain/entity/event_entity.dart';
import 'package:events_app/feature/registration/presentation/controller/registration_controller.dart';
import 'package:events_app/feature/organizer/event/domain/usecase/organizer_event_usecase.dart';
import 'package:events_app/feature/organizer/event/domain/usecase/event_params.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_event_list_controller.dart';

class OrganizerEventDetailController extends GetxController {
  GetOrganizerEventByIdUsecase get _getEventByIdUsecase =>
      networkGetIt<GetOrganizerEventByIdUsecase>();
  UpdateOrganizerEventUsecase get _updateEventUsecase =>
      networkGetIt<UpdateOrganizerEventUsecase>();
  PublishOrganizerEventUsecase get _publishEventUsecase =>
      networkGetIt<PublishOrganizerEventUsecase>();

  final Rx<EventEntity?> event = Rx<EventEntity?>(null);
  final RxBool isLoading = true.obs;
  final RxBool isActionLoading = false.obs;
  final RxBool isCancelling = false.obs;

  int? _eventId;
  void setEventId(int id) => _eventId = id;

  @override
  void onInit() {
    super.onInit();
    if (_eventId != null) loadEvent(_eventId!);
    _watchEventUpdates();
  }

  void _watchEventUpdates() {
    ever(OrganizerEventListController.eventStateUpdate, (tuple) {
      final (updatedEventId, newStatus) = tuple;
      if (_eventId == updatedEventId) {
        event.value = event.value?.copyWith(status: newStatus);
      }
    });

    ever(_registrationStateUpdate, (tuple) {
      final (updatedEventId, _) = tuple;
      if (_eventId == updatedEventId) {
        refreshEvent();
      }
    });
  }

  Rx<(int, UserEventState)> get _registrationStateUpdate {
    RegistrationController.ensureInstance();
    return RegistrationController.to.eventStateUpdate;
  }

  Future<void> loadEvent(int eventId) async {
    _eventId = eventId;
    isLoading.value = true;
    final result = await _getEventByIdUsecase(eventId);
    result.fold(
      (failure) => _handleFailure(failure),
      (data) => event.value = data,
    );
    isLoading.value = false;
  }

  Future<void> refreshEvent() async {
    if (_eventId == null) return;
    final result = await _getEventByIdUsecase(_eventId!);
    result.fold(
      (failure) => _handleFailure(failure),
      (data) => event.value = data,
    );
  }

  Future<void> publishEvent() async {
    if (_eventId == null || isActionLoading.value) return;
    final currentStatus = event.value?.status;
    if (currentStatus != EventStatus.draft &&
        currentStatus != EventStatus.cancelled) {
      AppSnackbarUtils.showError('Không hợp lệ',
          'Chỉ sự kiện ở trạng thái nháp hoặc hủy mới có thể xuất bản.');
      return;
    }
    isActionLoading.value = true;
    final result = await _publishEventUsecase(_eventId!);
    result.fold(
      (failure) {
        _handleFailure(failure);
        isActionLoading.value = false;
      },
      (updatedEvent) {
        AppSnackbarUtils.showSuccess(
            'Thành công', 'Xuất bản sự kiện thành công');
        event.value = updatedEvent;
        OrganizerEventListController.eventStateUpdate.value =
            (_eventId!, updatedEvent.status);
        isActionLoading.value = false;
      },
    );
  }

  Future<void> closeEvent() async {
    if (_eventId == null || isActionLoading.value) return;
    final currentStatus = event.value?.status;
    if (currentStatus != EventStatus.published) {
      AppSnackbarUtils.showError(
          'Không hợp lệ', 'Chỉ sự kiện đã xuất bản mới có thể đóng.');
      return;
    }
    isActionLoading.value = true;
    const params = EventUpdateParams(status: EventStatus.closed);
    final result = await _updateEventUsecase(UpdateOrganizerEventParams(
      eventId: _eventId!,
      params: params,
    ));
    result.fold(
      (failure) {
        _handleFailure(failure);
        isActionLoading.value = false;
      },
      (updatedEvent) {
        AppSnackbarUtils.showSuccess('Thành công', 'Đóng sự kiện thành công');
        event.value = updatedEvent;
        OrganizerEventListController.eventStateUpdate.value =
            (_eventId!, updatedEvent.status);
        isActionLoading.value = false;
      },
    );
  }

  Future<void> deleteEvent() async {
    if (_eventId == null || isCancelling.value) return;
    final currentStatus = event.value?.status;
    if (currentStatus != EventStatus.draft &&
        currentStatus != EventStatus.published) {
      AppSnackbarUtils.showError(
          'Không hợp lệ', 'Sự kiện ở trạng thái này không thể hủy.');
      return;
    }
    isCancelling.value = true;
    const params = EventUpdateParams(status: EventStatus.cancelled);
    final result = await _updateEventUsecase(UpdateOrganizerEventParams(
      eventId: _eventId!,
      params: params,
    ));
    result.fold(
      (failure) {
        _handleFailure(failure);
        isCancelling.value = false;
      },
      (updatedEvent) {
        AppSnackbarUtils.showSuccess('Thành công', 'Hủy sự kiện thành công');
        event.value = updatedEvent;
        OrganizerEventListController.eventStateUpdate.value =
            (_eventId!, updatedEvent.status);
        isCancelling.value = false;
      },
    );
  }

  void _handleFailure(FailureEntity failure) {
    AuthController.handleFailure(failure);
  }
}
