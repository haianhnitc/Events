import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/common/domain/entity/category_entity.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/domain/usecase/category_usecase.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/feature/event_management/domain/entity/event_entity.dart';
import 'package:events_app/feature/feedback/domain/entity/feedback_entity.dart';
import 'package:events_app/feature/organizer/event/domain/usecase/event_params.dart';
import 'package:events_app/feature/organizer/event/domain/usecase/organizer_event_usecase.dart';
import 'package:events_app/feature/organizer/event/domain/usecase/organizer_venue_usecase.dart';
import 'package:events_app/feature/organizer/event/domain/usecase/venue_params.dart';
import 'package:events_app/feature/organizer/feedback/domain/usecase/organizer_feedback_params.dart';
import 'package:events_app/feature/organizer/feedback/domain/usecase/organizer_feedback_usecase.dart';
import 'package:events_app/feature/organizer/presentation/page/events/organizer_event_list_page.dart';
import 'package:events_app/feature/organizer/presentation/widget/event/venue_picker_dialog.dart';
import 'package:events_app/feature/venue/domain/entity/venue_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrganizerCreateEventController extends GetxController {
  CreateOrganizerEventUsecase get _createEventUsecase =>
      networkGetIt<CreateOrganizerEventUsecase>();
  UpdateOrganizerEventUsecase get _updateEventUsecase =>
      networkGetIt<UpdateOrganizerEventUsecase>();
  GetOrganizerEventByIdUsecase get _getEventByIdUsecase =>
      networkGetIt<GetOrganizerEventByIdUsecase>();
  GetCategoriesUsecase get _getCategoriesUsecase =>
      networkGetIt<GetCategoriesUsecase>();
  GetOrganizerFeedbackQuestionsUsecase get _getFeedbackQuestionsUsecase =>
      networkGetIt<GetOrganizerFeedbackQuestionsUsecase>();
  CreateOrganizerFeedbackQuestionUsecase get _createFeedbackQuestionUsecase =>
      networkGetIt<CreateOrganizerFeedbackQuestionUsecase>();
  DeleteFeedbackQuestionsUsecase get _deleteFeedbackQuestionsUsecase =>
      networkGetIt<DeleteFeedbackQuestionsUsecase>();

  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final rewardCoinController = TextEditingController();
  final youthUnionPointController = TextEditingController();
  final certificateNameController = TextEditingController();

  final RxBool isSubmitting = false.obs;
  final RxBool isLoading = false.obs;
  final Rx<VenueEntity?> selectedVenue = Rx<VenueEntity?>(null);
  final Rx<EventRecruitmentType> recruitmentType =
      EventRecruitmentType.both.obs;
  final Rx<DateTime?> startTime = Rx<DateTime?>(null);
  final Rx<DateTime?> endTime = Rx<DateTime?>(null);
  final Rx<DateTime?> registerOpenTime = Rx<DateTime?>(null);

  final Rx<int?> bannerFileId = Rx<int?>(null);
  final Rx<String?> bannerPreviewUrl = Rx<String?>(null);

  final Rx<EventEntity?> editingEvent = Rx<EventEntity?>(null);
  final RxBool isReadOnly = false.obs;
  final RxList<VenueEntity> venueList = <VenueEntity>[].obs;
  final RxBool isLoadingVenues = false.obs;

  final RxList<int> selectedCategoryOptionIds = <int>[].obs;
  final RxList<FeedbackQuestionEntity> feedbackQuestions =
      <FeedbackQuestionEntity>[].obs;
  final RxList<CategoryEntity> categories = <CategoryEntity>[].obs;
  final RxBool isLoadingCategories = false.obs;

  bool get isEditMode => editingEvent.value != null;

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    rewardCoinController.dispose();
    youthUnionPointController.dispose();
    certificateNameController.dispose();
    super.onClose();
  }

  void initForEdit(EventEntity event, {bool readOnly = false}) {
    editingEvent.value = event;
    isReadOnly.value = readOnly;
    titleController.text = event.title ?? '';
    descriptionController.text = event.description ?? '';
    bannerPreviewUrl.value = event.banner;
    bannerFileId.value = null;
    recruitmentType.value = event.recruitmentType ?? EventRecruitmentType.both;
    startTime.value = event.startTime;
    endTime.value = event.endTime;
    registerOpenTime.value = event.registerOpenTime;
    if (event.venue != null) {
      selectedVenue.value = event.venue;
    }
    priceController.text = (event.price ?? 0).toString();
    rewardCoinController.text = (event.rewardCoin ?? 0).toString();
    youthUnionPointController.text = (event.youthUnionPoint ?? 0).toString();
    certificateNameController.text = event.certificateName ?? '';

    selectedCategoryOptionIds.clear();
    feedbackQuestions.clear();
    if (event.categories != null) {
      for (final cat in event.categories!) {
        if (cat.options != null) {
          for (final opt in cat.options!) {
            if (opt.categoryOptionId != null) {
              selectedCategoryOptionIds.add(opt.categoryOptionId!);
            }
          }
        }
      }
    }
  }

  void initForCreate() {
    editingEvent.value = null;
    isReadOnly.value = false;
    titleController.clear();
    descriptionController.clear();
    bannerFileId.value = null;
    bannerPreviewUrl.value = null;
    priceController.text = '0';
    rewardCoinController.text = '0';
    youthUnionPointController.text = '0';
    certificateNameController.clear();
    selectedVenue.value = null;
    recruitmentType.value = EventRecruitmentType.both;
    startTime.value = null;
    endTime.value = null;
    registerOpenTime.value = null;
    selectedCategoryOptionIds.clear();
    feedbackQuestions.clear();
  }

  void onBannerUploaded(int fileId, String url) {
    bannerFileId.value = fileId;
    bannerPreviewUrl.value = url;
  }

  Future<void> loadEventForEdit(int eventId) async {
    isLoading.value = true;
    await Future.wait([loadCategories(), loadVenues()]);
    final eventResult = await _getEventByIdUsecase(eventId);

    await eventResult.fold(
      (failure) async {
        _handleFailure(failure);
        isLoading.value = false;
        Get.back();
      },
      (event) async {
        final isNotDraft =
            event.status != null && event.status != EventStatus.draft;
        initForEdit(event, readOnly: isNotDraft);
        isLoading.value = false;
        await loadVenues();
        await _loadFeedbackQuestions(eventId);
      },
    );
  }

  Future<void> _loadFeedbackQuestions(int eventId) async {
    try {
      final result = await _getFeedbackQuestionsUsecase(eventId);
      result.fold(
        (failure) {},
        (questions) => feedbackQuestions.assignAll(questions),
      );
    } catch (_) {}
  }

  Future<void> loadVenues() async {
    isLoadingVenues.value = true;
    try {
      final usecase = networkGetIt<GetOrganizerVenuesUsecase>();
      final result =
          await usecase.call(const VenueListParams(page: 0, size: 100));
      result.fold(
        (failure) {
          _handleFailure(failure);
        },
        (data) {
          venueList.assignAll(data.items);
        },
      );
    } catch (e) {
      AppSnackbarUtils.showError('Lỗi', 'Không thể tải danh sách địa điểm');
    } finally {
      isLoadingVenues.value = false;
    }
  }

  Future<void> loadCategories() async {
    isLoadingCategories.value = true;
    try {
      final result = await _getCategoriesUsecase.call(null);
      result.fold(
        (failure) {
          _handleFailure(failure);
        },
        (data) {
          categories.assignAll(data);
        },
      );
    } catch (e) {
      AppSnackbarUtils.showError('Lỗi', 'Không thể tải danh mục');
    } finally {
      isLoadingCategories.value = false;
    }
  }

  Future<void> openVenuePicker() async {
    final result = await VenuePickerDialog.show(
      Get.context!,
      selectedVenue: selectedVenue.value,
    );
    if (result != null) {
      if (result.createdNew && result.venue != null) {
        if (!venueList.any((v) => v.venueId == result.venue!.venueId)) {
          venueList.add(result.venue!);
        }
        selectedVenue.value = result.venue;
      } else if (result.venue != null) {
        selectedVenue.value = result.venue;
      }
    }
  }

  void setStartTime(DateTime? dt) {
    startTime.value = dt;
  }

  void setEndTime(DateTime? dt) {
    endTime.value = dt;
  }

  void setRegisterOpenTime(DateTime? dt) {
    registerOpenTime.value = dt;
  }

  void setRecruitmentType(EventRecruitmentType type) {
    recruitmentType.value = type;
  }

  void toggleCategoryOption(int categoryOptionId) {
    if (selectedCategoryOptionIds.contains(categoryOptionId)) {
      selectedCategoryOptionIds.remove(categoryOptionId);
    } else {
      selectedCategoryOptionIds.add(categoryOptionId);
    }
  }

  Future<void> addFeedbackQuestion({
    required String questionContent,
    required FeedbackQuestionType questionType,
    bool isRequired = false,
    List<String>? options,
  }) async {
    if (isEditMode && editingEvent.value?.eventId != null) {
      final eventId = editingEvent.value!.eventId!;
      final result = await _createFeedbackQuestionUsecase(CreateFeedbackQuestionParams(
        eventId: eventId,
        questionContent: questionContent,
        questionType: questionType,
        isRequired: isRequired,
        options: options,
      ));
      result.fold(
        (failure) => _handleFailure(failure),
        (created) => feedbackQuestions.add(created),
      );
    } else {
      feedbackQuestions.add(FeedbackQuestionEntity(
        questionContent: questionContent,
        questionType: questionType,
        isRequired: isRequired,
        options: options?.map((o) => FeedbackOptionEntity(optionValue: o)).toList(),
      ));
    }
  }

  Future<void> removeFeedbackQuestion(int index) async {
    if (index < 0 || index >= feedbackQuestions.length) return;
    final question = feedbackQuestions[index];
    if (isEditMode && question.feedbackQuestionId != null) {
      final result = await _deleteFeedbackQuestionsUsecase(
        DeleteFeedbackQuestionsParams(questionIds: [question.feedbackQuestionId!]),
      );
      result.fold(
        (failure) => _handleFailure(failure),
        (_) => feedbackQuestions.removeAt(index),
      );
    } else {
      feedbackQuestions.removeAt(index);
    }
  }


  Future<void> submit() async {
    if (isReadOnly.value) {
      AppSnackbarUtils.showError('Không thể chỉnh sửa', 'Sự kiện đã xuất bản, không thể chỉnh sửa.');
      return;
    }
    if (formKey.currentState == null) return;
    if (!formKey.currentState!.validate()) return;
    if (isSubmitting.value) return;
    isSubmitting.value = true;

    final createParams = EventCreateParams(
      venueId: selectedVenue.value?.venueId,
      venue: null,
      title: titleController.text,
      bannerFileId: bannerFileId.value,
      description: descriptionController.text,
      price: int.tryParse(priceController.text) ?? 0,
      startTime: startTime.value,
      endTime: endTime.value,
      registerOpenTime: registerOpenTime.value,
      recruitmentType: recruitmentType.value,
      attendeeRewardCoin: int.tryParse(rewardCoinController.text),
      attendeeYouthUnionPoint: int.tryParse(youthUnionPointController.text),
      attendeeCertificateName: certificateNameController.text.isEmpty
          ? null
          : certificateNameController.text,
      categoryOptionIds: selectedCategoryOptionIds.isEmpty
          ? null
          : selectedCategoryOptionIds.toList(),
      feedbackQuestions: feedbackQuestions.isEmpty
          ? null
          : feedbackQuestions
              .map((q) => FeedbackQuestionCreateParams(
                    questionContent: q.questionContent ?? '',
                    questionType: q.questionType ?? FeedbackQuestionType.text,
                    isRequired: q.isRequired ?? false,
                    options: q.options
                        ?.map((o) => FeedbackOptionCreateParams(optionValue: o.optionValue ?? ''))
                        .toList(),
                  ))
              .toList(),
    );

    final result = isEditMode
        ? await _updateEventUsecase(UpdateOrganizerEventParams(
            eventId: editingEvent.value!.eventId!,
            params: EventUpdateParams(
              venueId: selectedVenue.value?.venueId,
              venue: null,
              title: titleController.text,
              bannerFileId: bannerFileId.value,
              description: descriptionController.text,
              price: int.tryParse(priceController.text) ?? 0,
              startTime: startTime.value,
              endTime: endTime.value,
              registerOpenTime: registerOpenTime.value,
              recruitmentType: recruitmentType.value,
              attendeeRewardCoin: int.tryParse(rewardCoinController.text),
              attendeeYouthUnionPoint:
                  int.tryParse(youthUnionPointController.text),
              attendeeCertificateName: certificateNameController.text.isEmpty
                  ? null
                  : certificateNameController.text,
              categoryOptionIds: selectedCategoryOptionIds.isEmpty
                  ? null
                  : selectedCategoryOptionIds.toList(),
            ),
          ))
        : await _createEventUsecase(createParams);

    result.fold(
      (failure) {
        _handleFailure(failure);
        isSubmitting.value = false;
      },
      (event) async {
        AppSnackbarUtils.showSuccess(
            'Thành công',
            isEditMode
                ? 'Cập nhật sự kiện thành công'
                : 'Tạo sự kiện thành công');
        Get.until((route) => route.isFirst);
        Get.to(() => const OrganizerEventListPage());
        isSubmitting.value = false;
      },
    );
  }

  String? validateTitle(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập tiêu đề';
    if (value.length < 10) return 'Tiêu đề phải có ít nhất 10 ký tự';
    if (value.length > 200) return 'Tiêu đề không được quá 200 ký tự';
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập mô tả';
    if (value.length < 50) return 'Mô tả phải có ít nhất 50 ký tự';
    if (value.length > 5000) return 'Mô tả không được quá 5000 ký tự';
    return null;
  }

  String? validateStartTime(DateTime? value) {
    if (value == null) return 'Vui lòng chọn thời gian bắt đầu';
    if (value.isBefore(DateTime.now())) {
      return 'Thời gian bắt đầu phải sau thời điểm hiện tại';
    }
    return null;
  }

  String? validateEndTime(DateTime? value) {
    if (value == null) return 'Vui lòng chọn thời gian kết thúc';
    if (startTime.value != null && value.isBefore(startTime.value!)) {
      return 'Thời gian kết thúc phải sau thời gian bắt đầu';
    }
    return null;
  }

  String? validateVenue(String? value) {
    if (selectedVenue.value == null) {
      return 'Vui lòng chọn địa điểm';
    }
    return null;
  }

  String? validatePrice(String? value) {
    if (value == null || value.isEmpty) return null;
    final price = int.tryParse(value);
    if (price == null) return 'Giá vé không hợp lệ';
    if (price < 0) return 'Giá vé không được nhỏ hơn 0';
    if (price > 100000000) return 'Giá vé không được quá 100.000.000 đ';
    return null;
  }

  String? validateRewardCoin(String? value) {
    if (value == null || value.isEmpty) return null;
    final coin = int.tryParse(value);
    if (coin == null) return 'Số coin không hợp lệ';
    if (coin < 0) return 'Số coin không được nhỏ hơn 0';
    if (coin > 100000) return 'Số coin không được quá 100.000';
    return null;
  }

  String? validateYouthUnionPoint(String? value) {
    if (value == null || value.isEmpty) return null;
    final point = int.tryParse(value);
    if (point == null) return 'Số điểm không hợp lệ';
    if (point < 0) return 'Số điểm không được nhỏ hơn 0';
    if (point > 100) return 'Số điểm không được quá 100';
    return null;
  }

  String? validateCertificateName(String? value) {
    if (value == null || value.isEmpty) return null;
    if (value.length > 200) return 'Tên chứng chỉ không được quá 200 ký tự';
    return null;
  }

  String? validateRegisterOpenTime(DateTime? value) {
    if (value == null) return null;
    if (startTime.value != null && value.isAfter(startTime.value!)) {
      return 'Thời gian mở đăng ký phải trước thời gian bắt đầu';
    }
    return null;
  }

  void _handleFailure(FailureEntity failure) {
    AuthController.handleFailure(failure);
  }
}
