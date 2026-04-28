import 'dart:math' as math;

import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/presentation/controller/category_controller.dart';
import 'package:events_app/feature/common/presentation/controller/filter_selection_controller.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/event_management/domain/usecase/get_events_usecase.dart';
import 'package:events_app/feature/event_management/presentation/utils/category_filter_utils.dart';
import 'package:events_app/feature/event_management/presentation/utils/event_action_utils.dart';
import 'package:events_app/feature/recruitment/domain/entity/ctv_recruitment_entity.dart';
import 'package:events_app/feature/recruitment/domain/usecase/ctv_recruitment_usecase.dart';
import 'package:events_app/feature/recruitment/domain/entity/requirement_question_entity.dart';
import 'package:events_app/feature/staff_application/domain/usecase/apply_ctv_params.dart';
import 'package:events_app/feature/staff_application/domain/usecase/staff_application_usecase.dart';
import 'package:get/get.dart';

class CtvController extends GetxController
    implements FilterSelectionController {
  CtvController() {
    _getRecruitmentsUsecase = networkGetIt<GetRecruitmentsUsecase>();
    _getRecruitmentQuestionsUsecase =
        networkGetIt<GetRecruitmentQuestionsUsecase>();
    _createStaffApplicationUsecase =
        networkGetIt<CreateStaffApplicationUsecase>();
    _getEventsUsecase = networkGetIt<GetEventsUsecase>();
  }

  late final GetRecruitmentsUsecase _getRecruitmentsUsecase;
  late final GetRecruitmentQuestionsUsecase _getRecruitmentQuestionsUsecase;
  late final CreateStaffApplicationUsecase _createStaffApplicationUsecase;
  late final GetEventsUsecase _getEventsUsecase;

  CategoryController get _categoryController => Get.find<CategoryController>();

  final List<CtvRecruitmentEntity> _allRecruitments = [];
  final List<CtvRecruitmentEntity> _filteredRecruitments = <CtvRecruitmentEntity>[];
  final int _pageSize = 20;

  final Map<int, EventSummaryEntity> _eventById = {};

  final RxList<EventSummaryEntity> _cachedEvents = <EventSummaryEntity>[].obs;
  final RxList<CtvRecruitmentEntity> recruitments = <CtvRecruitmentEntity>[].obs;
  final Rx<CtvRecruitmentEntity?> selectedRecruitment =
      (null as CtvRecruitmentEntity?).obs;
  @override
  final RxMap<int, List<String>> selectedFilters = <int, List<String>>{}.obs;
  final RxString keyword = ''.obs;
  final RxBool hasMore = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isLoadingEvents = false.obs;

  int _currentPage = 0;
  int _visibleCount = 0;

  @override
  void onInit() {
    super.onInit();
    loadRecruitments();
    _watchCategories();
  }

  void _watchCategories() {
    ever(_categoryController.categories, (_) => _reapplyFiltersIfReady());
  }

  void _reapplyFiltersIfReady() {
    if (!_categoryController.hasLoaded.value) return;
    if (_allRecruitments.isEmpty) {
      loadRecruitments(refresh: true);
      return;
    }
    _applyFiltersAndSync();
  }

  Future<void> loadRecruitments({bool refresh = false}) async {
    if (isLoadingMore.value) return;

    if (refresh) {
      _currentPage = 0;
      _allRecruitments.clear();
      _filteredRecruitments.clear();
      hasMore.value = true;
      _visibleCount = 0;
    }

    if (!hasMore.value && !refresh) return;

    isLoading.value = _currentPage == 0;
    isLoadingMore.value = _currentPage > 0;

    final result = await _getRecruitmentsUsecase(
      GetRecruitmentsParams(
        page: _currentPage,
        size: _pageSize,
      ),
    );

    result.fold(
      (failure) {
        _handleFailure(failure);
        isLoading.value = false;
        isLoadingMore.value = false;
      },
      (data) async {
        if (data.isEmpty) {
          hasMore.value = false;
        } else {
          if (refresh) {
            _allRecruitments.clear();
          }
          _allRecruitments.addAll(data);
          _currentPage++;
          hasMore.value = data.length >= _pageSize;
          await _ensureEventsLoaded();
          _reapplyFiltersIfReady();
        }
        isLoading.value = false;
        isLoadingMore.value = false;
      },
    );
  }

  void openCtvDetail(CtvRecruitmentEntity recruitment) {
    selectedRecruitment.value = recruitment;
  }

  void closeCtvDetail() {
    selectedRecruitment.value = null;
  }

  @override
  void applyFilters(Map<int, List<String>> filters) {
    selectedFilters.assignAll(filters);
    _applyFiltersAndSync();
  }

  void setSearchKeyword(String value) {
    keyword.value = value.trim().toLowerCase();
    loadRecruitments(refresh: true);
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
    loadRecruitments();
  }

  Future<void> _ensureEventsLoaded() async {
    if (_cachedEvents.isNotEmpty) return;
    if (isLoadingEvents.value) return;
    isLoadingEvents.value = true;

    final result = await _getEventsUsecase(
      const GetEventsParams(page: 0, size: 100),
    );

      result.fold(
        (failure) {
          _handleFailure(failure);
          isLoadingEvents.value = false;
        },
      (data) {
        _cachedEvents.assignAll(data);
        _eventById.clear();
        for (final event in data) {
          if (event.eventId != null) {
            _eventById[event.eventId!] = event;
          }
        }
      },
    );

    isLoadingEvents.value = false;
  }

  void _applyFiltersAndSync() {
    final query = keyword.value;
    _filteredRecruitments
      ..clear()
      ..addAll(
        _allRecruitments.where((item) {
          final relatedEvent =
              item.eventId != null ? _eventById[item.eventId!] : null;
          final matchesCategory = CategoryFilterUtils.matchesCtvByEntity(
            item,
            selectedFilters,
            relatedEvent,
            allCategories: _categoryController.categories.toList(),
          );
          final matchesKeyword = query.isEmpty ||
              (item.title ?? '').toLowerCase().contains(query) ||
              (item.roleName ?? '').toLowerCase().contains(query) ||
              (item.description ?? '').toLowerCase().contains(query) ||
              (relatedEvent?.title ?? '').toLowerCase().contains(query);

          return matchesCategory && matchesKeyword;
        }),
      );

    _visibleCount = math.min(_pageSize, _filteredRecruitments.length);
    _syncVisibleRecruitments();
  }

  void _syncVisibleRecruitments() {
    final visibleCount = math.min(_visibleCount, _filteredRecruitments.length);
    recruitments.assignAll(_filteredRecruitments.take(visibleCount));
    hasMore.value = visibleCount < _filteredRecruitments.length;
  }

  bool handleBackPressed() {
    if (selectedRecruitment.value != null) {
      closeCtvDetail();
      return false;
    }

    return true;
  }

  void refreshApplyState([int? ctvRecruitmentId]) {
    loadRecruitments(refresh: true);
  }

  Future<List<RequirementQuestionEntity>> getRecruitmentQuestions(
      int ctvRecruitmentId) async {
    final result =
        await _getRecruitmentQuestionsUsecase(ctvRecruitmentId);
    return result.fold(
      (failure) {
        _handleFailure(failure);
        return <RequirementQuestionEntity>[];
      },
      (data) => data,
    );
  }

  Future<bool> submitCtvApplication({
    required int ctvRecruitmentId,
    required Map<int, String> textAnswers,
    required Map<int, int?> singleChoiceAnswers,
    required Map<int, Set<int>> multiChoiceAnswers,
    Map<int, String> ratingAnswers = const {},
  }) async {
    final recruitmentItem =
        _allRecruitments.where((r) => r.ctvRecruitmentId == ctvRecruitmentId).firstOrNull;
    final userEventState = recruitmentItem?.userEventState;

    if (userEventState == UserEventState.ctvApplied ||
        userEventState == UserEventState.ctv) {
      AppSnackbarUtils.showInfo(
        'Không thể ứng tuyển',
        'Bạn đã ứng tuyển hoặc đã là CTV của đợt tuyển dụng này.',
      );
      return false;
    }

    final recruitmentQuestions =
        await getRecruitmentQuestions(ctvRecruitmentId);
    final answers = <AnswerItem>[];

    for (final question in recruitmentQuestions) {
      final qId = question.questionId;
      if (qId == null) continue;

      switch (question.questionType) {
        case RequirementQuestionType.text:
          final text = textAnswers[qId];
          if (text != null && text.trim().isNotEmpty) {
            answers.add(AnswerItem(
              questionId: qId,
              answerText: text.trim(),
            ));
          }
          break;
        case RequirementQuestionType.singleChoice:
          final selectedId = singleChoiceAnswers[qId];
          if (selectedId != null) {
            answers.add(AnswerItem(
              questionId: qId,
              selectedOptionIds: [selectedId],
            ));
          }
          break;
        case RequirementQuestionType.multipleChoice:
          final selectedIds = multiChoiceAnswers[qId];
          if (selectedIds != null && selectedIds.isNotEmpty) {
            answers.add(AnswerItem(
              questionId: qId,
              selectedOptionIds: selectedIds.toList(),
            ));
          }
          break;
        case RequirementQuestionType.rating:
          final ratingStr = ratingAnswers[qId];
          final rating = ratingStr != null ? int.tryParse(ratingStr) : null;
          if (rating != null && rating > 0) {
            answers.add(AnswerItem(
              questionId: qId,
              answerText: rating.toString(),
            ));
          }
          break;
        case null:
          break;
      }
    }

    final resolvedEventId = recruitmentItem?.eventId;

    if (resolvedEventId == null) {
      AppSnackbarUtils.showError('Lỗi', 'Không tìm thấy sự kiện liên quan.');
      return false;
    }

    final params = ApplyCtvParams(
      eventId: resolvedEventId,
      answers: answers,
    );

    final result = await _createStaffApplicationUsecase(params);

    return result.fold(
      (failure) {
        _handleFailure(failure);
        return false;
      },
      (application) {
        refreshApplyState(ctvRecruitmentId);
        AppSnackbarUtils.showSuccess(
          'Ứng tuyển thành công',
          'Hồ sơ của bạn đã được gửi.',
        );
        return true;
      },
    );
  }

  ActionButtonState getApplyActionState(
    CtvRecruitmentEntity recruitment,
  ) {
    return getApplyActionStateByValues(
      isOpen: recruitment.isOpen,
      quantity: recruitment.quantity,
      userEventState: recruitment.userEventState,
    );
  }

  ActionButtonState getApplyActionStateByValues({
    required bool? isOpen,
    required int? quantity,
    required UserEventState? userEventState,
  }) {
    return EventActionUtils.getCtvApplyState(
      isOpen: isOpen,
      quantity: quantity,
      userEventState: userEventState,
    );
  }

  void _handleFailure(FailureEntity failure) {
    failure.when(
      serverFailure: (_, message) =>
          AppSnackbarUtils.showError('Lỗi', message),
      dataParsingFailure: () =>
          AppSnackbarUtils.showError('Lỗi', 'Không đọc được dữ liệu'),
      noConnectionFailure: () =>
          AppSnackbarUtils.showError('Lỗi', 'Không có kết nối mạng'),
      systemFailure: (_, message) =>
          AppSnackbarUtils.showError('Lỗi', message),
    );
  }
}
