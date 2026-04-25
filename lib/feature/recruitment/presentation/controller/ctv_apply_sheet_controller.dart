import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/recruitment/domain/entity/requirement_question_entity.dart';
import 'package:events_app/feature/recruitment/presentation/controller/ctv_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CtvApplySheetController extends GetxController {
  static String buildTag({
    required int ctvRecruitmentId,
    int? eventId,
  }) {
    return 'ctv_apply_sheet_${ctvRecruitmentId}_${eventId ?? 0}';
  }

  static CtvApplySheetController attach({
    required int ctvRecruitmentId,
    int? eventId,
  }) {
    final tag = buildTag(ctvRecruitmentId: ctvRecruitmentId, eventId: eventId);
    if (Get.isRegistered<CtvApplySheetController>(tag: tag)) {
      return Get.find<CtvApplySheetController>(tag: tag);
    }

    return Get.put(
      CtvApplySheetController(
        ctvRecruitmentId: ctvRecruitmentId,
        ctvController: Get.find<CtvController>(),
      ),
      tag: tag,
    );
  }

  static void detach({
    required int ctvRecruitmentId,
    int? eventId,
  }) {
    final tag = buildTag(ctvRecruitmentId: ctvRecruitmentId, eventId: eventId);
    if (Get.isRegistered<CtvApplySheetController>(tag: tag)) {
      Get.delete<CtvApplySheetController>(tag: tag);
    }
  }

  CtvApplySheetController({
    required this.ctvRecruitmentId,
    required this.ctvController,
  });

  final int ctvRecruitmentId;
  final CtvController ctvController;

  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxList<RequirementQuestionEntity> questions =
      <RequirementQuestionEntity>[].obs;

  final Map<int, TextEditingController> _textControllers = {};
  final Map<int, int?> _singleChoiceAnswers = {};
  final Map<int, Set<int>> _multiChoiceAnswers = {};
  final Map<int, int> _ratingAnswers = {};

  @override
  void onInit() {
    super.onInit();
    loadQuestions();
  }

  @override
  void onClose() {
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
    super.onClose();
  }

  Future<void> loadQuestions() async {
    isLoading.value = true;
    try {
      final questionItems =
          await ctvController.getRecruitmentQuestions(ctvRecruitmentId);
      questions.assignAll(questionItems);
      _initAnswerStates(questionItems);
    } finally {
      isLoading.value = false;
    }
  }

  void _initAnswerStates(List<RequirementQuestionEntity> questionItems) {
    for (final question in questionItems) {
      final questionId = question.questionId;
      if (questionId == null) continue;

      if (question.questionType == RequirementQuestionType.text) {
        _textControllers.putIfAbsent(questionId, () => TextEditingController());
      } else if (question.questionType == RequirementQuestionType.singleChoice) {
        _singleChoiceAnswers.putIfAbsent(questionId, () => null);
      } else if (question.questionType == RequirementQuestionType.rating) {
        _ratingAnswers.putIfAbsent(questionId, () => 0);
      } else {
        _multiChoiceAnswers.putIfAbsent(questionId, () => <int>{});
      }
    }
  }

  TextEditingController? textControllerFor(int questionId) {
    return _textControllers[questionId];
  }

  int? singleChoiceValueFor(int questionId) {
    return _singleChoiceAnswers[questionId];
  }

  int ratingValueFor(int questionId) {
    return _ratingAnswers[questionId] ?? 0;
  }

  void updateRating({
    required int questionId,
    required int value,
  }) {
    _ratingAnswers[questionId] = value;
    questions.refresh();
  }

  bool isMultiChoiceSelected(int questionId, int optionId) {
    return _multiChoiceAnswers[questionId]?.contains(optionId) ?? false;
  }

  void updateSingleChoice({
    required int questionId,
    required int optionId,
  }) {
    _singleChoiceAnswers[questionId] = optionId;
    questions.refresh();
  }

  void updateMultiChoice({
    required int questionId,
    required int optionId,
    required bool checked,
  }) {
    final bucket = _multiChoiceAnswers.putIfAbsent(questionId, () => <int>{});
    if (checked) {
      bucket.add(optionId);
    } else {
      bucket.remove(optionId);
    }
    questions.refresh();
  }

  Future<bool> submit() async {
    if (isSubmitting.value) return false;

    final textAnswers = <int, String>{
      for (final entry in _textControllers.entries)
        entry.key: entry.value.text.trim(),
    };
    final ratingAnswers = Map<int, String>.fromEntries(
      _ratingAnswers.entries
          .where((e) => e.value > 0)
          .map((e) => MapEntry(e.key, e.value.toString())),
    );

    try {
      isSubmitting.value = true;
      return await ctvController.submitCtvApplication(
        ctvRecruitmentId: ctvRecruitmentId,
        textAnswers: textAnswers,
        singleChoiceAnswers: _singleChoiceAnswers,
        multiChoiceAnswers: _multiChoiceAnswers,
        ratingAnswers: ratingAnswers,
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}
