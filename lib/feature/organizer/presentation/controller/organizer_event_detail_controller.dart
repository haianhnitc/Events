import 'package:get/get.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/event_management/domain/entity/event_entity.dart';
import 'package:events_app/feature/organizer/event/domain/usecase/organizer_event_usecase.dart';
import 'package:events_app/feature/organizer/event/domain/usecase/event_params.dart';

class OrganizerEventDetailController extends GetxController {
  GetOrganizerEventByIdUsecase get _getEventByIdUsecase =>
      networkGetIt<GetOrganizerEventByIdUsecase>();
  UpdateOrganizerEventUsecase get _updateEventUsecase =>
      networkGetIt<UpdateOrganizerEventUsecase>();
  PublishOrganizerEventUsecase get _publishEventUsecase =>
      networkGetIt<PublishOrganizerEventUsecase>();

  final Rx<EventEntity?> event = Rx<EventEntity?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isActionLoading = false.obs;

  int? _eventId;
  void setEventId(int id) => _eventId = id;

  @override
  void onInit() {
    super.onInit();
    if (_eventId != null) loadEvent(_eventId!);
  }

  Future<void> loadEvent(int eventId) async {
    if (isLoading.value) return;
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
    isActionLoading.value = true;
    final result = await _publishEventUsecase(_eventId!);
    result.fold(
      (failure) {
        _handleFailure(failure);
        isActionLoading.value = false;
      },
      (updatedEvent) {
        AppSnackbarUtils.showSuccess('Thành công', 'Xuất bản sự kiện thành công');
        event.value = updatedEvent;
        isActionLoading.value = false;
      },
    );
  }

  Future<void> closeEvent() async {
    if (_eventId == null || isActionLoading.value) return;
    isActionLoading.value = true;
    final params = EventUpdateParams(status: EventStatus.closed);
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
        isActionLoading.value = false;
      },
    );
  }

  Future<void> deleteEvent() async {
    if (_eventId == null || isActionLoading.value) return;
    isActionLoading.value = true;
    final params = EventUpdateParams(status: EventStatus.cancelled);
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
        AppSnackbarUtils.showSuccess('Thành công', 'Hủy sự kiện thành công');
        event.value = updatedEvent;
        isActionLoading.value = false;
      },
    );
  }

  void _handleFailure(FailureEntity failure) {
    failure.when(
      serverFailure: (_, message) => AppSnackbarUtils.showError('Lỗi', message ?? 'Thao tác thất bại'),
      dataParsingFailure: () => AppSnackbarUtils.showError('Lỗi', 'Không đọc được dữ liệu'),
      noConnectionFailure: () => AppSnackbarUtils.showError('Lỗi', 'Không có kết nối mạng'),
      systemFailure: (_, message) => AppSnackbarUtils.showError('Lỗi', message ?? 'Lỗi hệ thống'),
    );
  }
}
