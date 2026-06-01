import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/organizer/event/domain/usecase/organizer_event_usecase.dart';
import 'package:events_app/feature/organizer/event/domain/usecase/event_params.dart';

class OrganizerEventListController extends GetxController {
  GetOrganizerEventListUsecase get _getEventListUsecase =>
      networkGetIt<GetOrganizerEventListUsecase>();
  PublishOrganizerEventUsecase get _publishEventUsecase =>
      networkGetIt<PublishOrganizerEventUsecase>();
  UpdateOrganizerEventUsecase get _updateEventUsecase =>
      networkGetIt<UpdateOrganizerEventUsecase>();

  final RxList<EventSummaryEntity> events = <EventSummaryEntity>[].obs;
  final RxList<EventSummaryEntity> _displayedEvents =
      <EventSummaryEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final Rx<EventStatus?> filterStatus = Rx<EventStatus?>(null);
  final RxString searchQuery = ''.obs;
  final RxString sortBy = 'startTime'.obs;
  final RxString sortDirection = 'DESC'.obs;

  int _currentPage = 0;
  int _totalPages = 1;
  bool get hasMore => _currentPage < _totalPages - 1;

  int _requestId = 0;

  AuthController get _authController => Get.find<AuthController>();

  static final Rx<(int, EventStatus?)> eventStateUpdate =
      Rx<(int, EventStatus?)>((0, null));

  @override
  void onInit() {
    super.onInit();
    _loadAllEventsCache();
    loadEvents(reset: true);
    _watchEventUpdates();
  }

  Future<void> _loadAllEventsCache() async {
    final organizerId = _organizerId;
    if (organizerId == null) return;

    final params = OrganizerEventListParams(
      organizerId: organizerId,
      page: 0,
      size: 9999,
      status: null,
      keyword: null,
      sortBy: sortBy.value,
      sortDirection: sortDirection.value,
    );

    final result = await _getEventListUsecase(params);
    result.fold(
      (failure) => _handleFailure(failure),
      (data) {
        final uniqueItems = <int, EventSummaryEntity>{};
        for (final item in data.items) {
          if (item.eventId != null) {
            uniqueItems[item.eventId!] = item;
          }
        }
        events.assignAll(uniqueItems.values.toList());
      },
    );
  }

  void _watchEventUpdates() {
    ever(eventStateUpdate, (tuple) {
      final (updatedEventId, newStatus) = tuple;
      if (newStatus == null) return;
      final idx = events.indexWhere((e) => e.eventId == updatedEventId);
      if (idx >= 0) {
        events[idx] = events[idx].copyWith(status: newStatus);
      }
      final displayIdx =
          _displayedEvents.indexWhere((e) => e.eventId == updatedEventId);
      if (displayIdx >= 0) {
        _displayedEvents[displayIdx] =
            _displayedEvents[displayIdx].copyWith(status: newStatus);
      }
    });
  }

  int? get _organizerId => _authController.currentUser.value?.userId;

  Future<void> loadEvents({bool reset = true}) async {
    if (isLoading.value) return;
    if (reset) {
      _currentPage = 0;
      _totalPages = 1;
    }

    final organizerId = _organizerId;
    if (organizerId == null) {
      AppSnackbarUtils.showError('Lỗi', 'Không xác định được tài khoản');
      return;
    }

    isLoading.value = true;

    final currentRequestId = _requestId;

    final params = OrganizerEventListParams(
      organizerId: organizerId,
      page: _currentPage,
      size: 20,
      status: filterStatus.value,
      keyword: searchQuery.value.isNotEmpty ? searchQuery.value : null,
      sortBy: sortBy.value,
      sortDirection: sortDirection.value,
    );

    final result = await _getEventListUsecase(params);

    if (currentRequestId != _requestId) {
      isLoading.value = false;
      return;
    }

    result.fold(
      (failure) {
        _handleFailure(failure);
      },
      (data) {
        if (reset) {
          _displayedEvents.assignAll(data.items);
        } else {
          for (final item in data.items) {
            if (item.eventId != null &&
                !_displayedEvents.any((e) => e.eventId == item.eventId)) {
              _displayedEvents.add(item);
            }
          }
        }
        _totalPages = data.totalPages;
      },
    );

    isLoading.value = false;
  }

  Future<void> refreshEvents() async {
    if (isRefreshing.value) return;
    isRefreshing.value = true;
    await loadEvents(reset: true);
    isRefreshing.value = false;
  }

  Future<void> loadMore() async {
    if (!hasMore || isLoading.value) return;
    _currentPage++;
    await loadEvents(reset: false);
  }

  void setFilter(EventStatus? status) {
    filterStatus.value = status;
    _requestId++;
    loadEvents(reset: true);
  }

  void setSearch(String query) {
    searchQuery.value = query;
    _requestId++;
    loadEvents(reset: true);
  }

  void setSort(String by, String direction) {
    sortBy.value = by;
    sortDirection.value = direction;
    _requestId++;
    loadEvents(reset: true);
  }

  List<EventSummaryEntity> get filteredEvents {
    if (searchQuery.value.isEmpty) return _displayedEvents.toList();
    final q = searchQuery.value.toLowerCase();
    return _displayedEvents
        .where((e) => e.title?.toLowerCase().contains(q) ?? false)
        .toList();
  }

  Future<void> deleteEvent(int eventId) async {
    final ev = events.firstWhereOrNull((e) => e.eventId == eventId);
    if (ev?.status != EventStatus.draft &&
        ev?.status != EventStatus.published) {
      AppSnackbarUtils.showError(
          'Không hợp lệ', 'Sự kiện ở trạng thái này không thể hủy.');
      return;
    }
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Xác nhận hủy'),
        content: const Text('Bạn có chắc muốn hủy sự kiện này không?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    const params = EventUpdateParams(status: EventStatus.cancelled);
    final result = await _updateEventUsecase(UpdateOrganizerEventParams(
      eventId: eventId,
      params: params,
    ));
    result.fold(
      (failure) => _handleFailure(failure),
      (event) {
        AppSnackbarUtils.showSuccess('Thành công', 'Hủy sự kiện thành công');
        eventStateUpdate.value = (eventId, event.status);
        _syncEventStatus(eventId, event.status);
      },
    );
  }

  void _syncEventStatus(int eventId, EventStatus? newStatus) {
    if (newStatus == null) return;
    final idx = events.indexWhere((e) => e.eventId == eventId);
    if (idx >= 0) events[idx] = events[idx].copyWith(status: newStatus);
    final displayIdx = _displayedEvents.indexWhere((e) => e.eventId == eventId);
    if (displayIdx >= 0) {
      _displayedEvents[displayIdx] =
          _displayedEvents[displayIdx].copyWith(status: newStatus);
    }
  }

  Future<void> publishEvent(int eventId) async {
    final ev = events.firstWhereOrNull((e) => e.eventId == eventId);
    if (ev?.status != EventStatus.draft) {
      AppSnackbarUtils.showError(
          'Không hợp lệ', 'Chỉ sự kiện nháp mới có thể xuất bản.');
      return;
    }
    final result = await _publishEventUsecase(eventId);
    result.fold(
      (failure) => _handleFailure(failure),
      (event) {
        AppSnackbarUtils.showSuccess(
            'Thành công', 'Xuất bản sự kiện thành công');
        eventStateUpdate.value = (eventId, event.status);
        _syncEventStatus(eventId, event.status);
      },
    );
  }

  Future<void> closeEvent(int eventId) async {
    final ev = events.firstWhereOrNull((e) => e.eventId == eventId);
    if (ev?.status != EventStatus.published) {
      AppSnackbarUtils.showError(
          'Không hợp lệ', 'Chỉ sự kiện đã xuất bản mới có thể đóng.');
      return;
    }
    const params = EventUpdateParams(status: EventStatus.closed);
    final result = await _updateEventUsecase(UpdateOrganizerEventParams(
      eventId: eventId,
      params: params,
    ));
    result.fold(
      (failure) => _handleFailure(failure),
      (event) {
        AppSnackbarUtils.showSuccess('Thành công', 'Đóng sự kiện thành công');
        eventStateUpdate.value = (eventId, event.status);
        _syncEventStatus(eventId, event.status);
      },
    );
  }

  void _handleFailure(FailureEntity failure) {
    AuthController.handleFailure(failure);
  }
}
