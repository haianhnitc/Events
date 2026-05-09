import 'dart:math' as math;

import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/common/presentation/controller/category_controller.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/event_management/domain/usecase/get_events_usecase.dart';
import 'package:events_app/feature/event_management/presentation/utils/category_filter_utils.dart';
import 'package:events_app/feature/common/presentation/controller/filter_selection_controller.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:get/get.dart';

class EventController extends GetxController implements FilterSelectionController {
  EventController() {
    _getEventsUsecase = networkGetIt<GetEventsUsecase>();
  }

  late final GetEventsUsecase _getEventsUsecase;

  CategoryController? _categoryControllerRef;

  CategoryController get _categoryController {
    _categoryControllerRef ??= Get.isRegistered<CategoryController>()
        ? Get.find<CategoryController>()
        : null;
    if (_categoryControllerRef == null) {
      throw StateError('CategoryController not registered');
    }
    return _categoryControllerRef!;
  }

  final List<EventSummaryEntity> _allEvents = [];
  final List<EventSummaryEntity> _filteredEvents = <EventSummaryEntity>[];
  final int _pageSize = 20;

  final RxList<EventSummaryEntity> events = <EventSummaryEntity>[].obs;
  final Rx<EventSummaryEntity?> selectedEvent =
      (null as EventSummaryEntity?).obs;
  @override
  final RxMap<int, List<String>> selectedFilters =
      <int, List<String>>{}.obs;
  final RxString keyword = ''.obs;
  final RxBool hasMore = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;

  int _currentPage = 0;
  int _visibleCount = 0;

  @override
  void onInit() {
    super.onInit();
    loadEvents();
    _watchCategories();
  }

  void _watchCategories() {
    if (Get.isRegistered<CategoryController>()) {
      ever(_categoryController.categories, (_) => _reapplyFiltersIfReady());
    }
  }

  void _reapplyFiltersIfReady() {
    if (!Get.isRegistered<CategoryController>()) return;
    final cc = _categoryController;
    if (!cc.hasLoaded.value) return;
    if (_allEvents.isEmpty) {
      loadEvents(refresh: true);
      return;
    }
    _applyFiltersAndSync();
  }

  Future<void> loadEvents({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _allEvents.clear();
      _filteredEvents.clear();
      hasMore.value = true;
      _visibleCount = 0;
    }

    if (!hasMore.value && !refresh) return;

    isLoading.value = _currentPage == 0;
    isLoadingMore.value = _currentPage > 0;

    final result = await _getEventsUsecase(
      GetEventsParams(
        page: _currentPage,
        size: _pageSize,
        keyword: keyword.value.isEmpty ? null : keyword.value,
      ),
    );

    result.fold(
      (failure) {
        _handleFailure(failure);
        isLoading.value = false;
        isLoadingMore.value = false;
      },
      (data) {
        if (data.isEmpty) {
          hasMore.value = false;
        } else {
          if (refresh) {
            _allEvents.clear();
          }
          _allEvents.addAll(data);
          _currentPage++;
          hasMore.value = data.length >= _pageSize;
          _applyFiltersAndSync();
        }
        isLoading.value = false;
        isLoadingMore.value = false;
      },
    );
  }

  void openEventDetail(EventSummaryEntity event) {
    selectedEvent.value = event;
  }

  void closeEventDetail() {
    selectedEvent.value = null;
  }

  @override
  void applyFilters(Map<int, List<String>> filters) {
    selectedFilters.assignAll(filters);
    _applyFiltersAndSync();
  }

  void setSearchKeyword(String value) {
    keyword.value = value.trim().toLowerCase();
    loadEvents(refresh: true);
  }

  @override
  void clearFilters() {
    selectedFilters.clear();
    _applyFiltersAndSync();
  }

  @override
  void toggleFilter(int categoryId, String optionValue) {
    if (!selectedFilters.containsKey(categoryId)) {
      selectedFilters[categoryId] = [];
    }
    if (selectedFilters[categoryId]!.contains(optionValue)) {
      selectedFilters[categoryId]!.remove(optionValue);
    } else {
      selectedFilters[categoryId]!.add(optionValue);
    }

    if ((selectedFilters[categoryId] ?? const <String>[]).isEmpty) {
      selectedFilters.remove(categoryId);
    }

    selectedFilters.refresh();
    _applyFiltersAndSync();
  }

  @override
  bool isSelected(int categoryId, String optionValue) {
    return selectedFilters[categoryId]?.contains(optionValue) ?? false;
  }

  void loadMore() {
    if (isLoadingMore.value || !hasMore.value) return;
    loadEvents();
  }

  void _applyFiltersAndSync() {
    if (!Get.isRegistered<CategoryController>()) return;
    final cc = _categoryController;
    _filteredEvents
      ..clear()
      ..addAll(
        _allEvents.where((event) {
          final matchesCategory = CategoryFilterUtils.matchesEvent(
            event,
            selectedFilters,
            allCategories: cc.categories.toList(),
          );
          final matchesKeyword = keyword.value.isEmpty ||
              (event.title ?? '').toLowerCase().contains(keyword.value);
          return matchesCategory && matchesKeyword;
        }),
      );

    _visibleCount = math.min(_pageSize, _filteredEvents.length);
    _syncVisibleEvents();
  }

  void _syncVisibleEvents() {
    final visibleCount = math.min(_visibleCount, _filteredEvents.length);
    events.assignAll(_filteredEvents.take(visibleCount));
    hasMore.value = visibleCount < _filteredEvents.length;
  }

  bool handleBackPressed() {
    if (selectedEvent.value != null) {
      closeEventDetail();
      return false;
    }

    return true;
  }

  void _handleFailure(FailureEntity failure) {
    AuthController.handleFailure(failure);
  }
}
