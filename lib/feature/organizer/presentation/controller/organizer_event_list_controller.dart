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
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final Rx<EventStatus?> filterStatus = Rx<EventStatus?>(null);
  final RxString searchQuery = ''.obs;
  final RxString sortBy = 'startTime'.obs;
  final RxString sortDirection = 'DESC'.obs;

  int _currentPage = 0;
  int _totalPages = 1;
  bool get _hasMore => _currentPage < _totalPages - 1;

  AuthController get _authController => Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    loadEvents();
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

    result.fold(
      (failure) {
        _handleFailure(failure);
      },
      (data) {
        if (reset) {
          events.assignAll(data.items);
        } else {
          events.addAll(data.items);
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
    if (!_hasMore || isLoading.value) return;
    _currentPage++;
    await loadEvents(reset: false);
  }

  void setFilter(EventStatus? status) {
    filterStatus.value = status;
    loadEvents(reset: true);
  }

  void setSearch(String query) {
    searchQuery.value = query;
    loadEvents(reset: true);
  }

  void setSort(String by, String direction) {
    sortBy.value = by;
    sortDirection.value = direction;
    loadEvents(reset: true);
  }

  List<EventSummaryEntity> get filteredEvents {
    if (searchQuery.value.isEmpty) return events.toList();
    final q = searchQuery.value.toLowerCase();
    return events
        .where((e) => e.title?.toLowerCase().contains(q) ?? false)
        .toList();
  }

  Future<void> deleteEvent(int eventId) async {
    final ev = events.firstWhereOrNull((e) => e.eventId == eventId);
    if (ev?.status != EventStatus.draft && ev?.status != EventStatus.published) {
      AppSnackbarUtils.showError('Không hợp lệ', 'Sự kiện ở trạng thái này không thể hủy.');
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

    final params = EventUpdateParams(status: EventStatus.cancelled);
    final result = await _updateEventUsecase(UpdateOrganizerEventParams(
      eventId: eventId,
      params: params,
    ));
    result.fold(
      (failure) => _handleFailure(failure),
      (event) {
        AppSnackbarUtils.showSuccess('Thành công', 'Hủy sự kiện thành công');
        final index = events.indexWhere((e) => e.eventId == eventId);
        if (index >= 0) {
          events[index] = events[index].copyWith(status: event.status);
        }
      },
    );
  }

  Future<void> publishEvent(int eventId) async {
    final ev = events.firstWhereOrNull((e) => e.eventId == eventId);
    if (ev?.status != EventStatus.draft) {
      AppSnackbarUtils.showError('Không hợp lệ', 'Chỉ sự kiện nháp mới có thể xuất bản.');
      return;
    }
    final result = await _publishEventUsecase(eventId);
    result.fold(
      (failure) => _handleFailure(failure),
      (event) {
        AppSnackbarUtils.showSuccess('Thành công', 'Xuất bản sự kiện thành công');
        final index = events.indexWhere((e) => e.eventId == eventId);
        if (index >= 0) {
          events[index] = events[index].copyWith(status: event.status);
        }
      },
    );
  }

  Future<void> closeEvent(int eventId) async {
    final ev = events.firstWhereOrNull((e) => e.eventId == eventId);
    if (ev?.status != EventStatus.published) {
      AppSnackbarUtils.showError('Không hợp lệ', 'Chỉ sự kiện đã xuất bản mới có thể đóng.');
      return;
    }
    final params = EventUpdateParams(status: EventStatus.closed);
    final result = await _updateEventUsecase(UpdateOrganizerEventParams(
      eventId: eventId,
      params: params,
    ));
    result.fold(
      (failure) => _handleFailure(failure),
      (event) {
        AppSnackbarUtils.showSuccess('Thành công', 'Đóng sự kiện thành công');
        final index = events.indexWhere((e) => e.eventId == eventId);
        if (index >= 0) {
          events[index] = events[index].copyWith(status: event.status);
        }
      },
    );
  }

  void _handleFailure(FailureEntity failure) {
    failure.when(
      serverFailure: (_, message) =>
          AppSnackbarUtils.showError('Lỗi', message ?? 'Thao tác thất bại'),
      dataParsingFailure: () =>
          AppSnackbarUtils.showError('Lỗi', 'Không đọc được dữ liệu'),
      noConnectionFailure: () =>
          AppSnackbarUtils.showError('Lỗi', 'Không có kết nối mạng'),
      systemFailure: (_, message) =>
          AppSnackbarUtils.showError('Lỗi', message ?? 'Lỗi hệ thống'),
    );
  }
}
