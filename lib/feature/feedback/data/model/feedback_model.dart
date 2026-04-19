import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:events_app/feature/feedback/domain/entity/feedback_entity.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/event_management/data/model/event_summary_model.dart';
import 'package:events_app/feature/participant/data/model/participant_model.dart';

part 'feedback_model.freezed.dart';
part 'feedback_model.g.dart';

@freezed
class FeedbackOptionModel with _$FeedbackOptionModel {
  const factory FeedbackOptionModel({
    int? optionId,
    int? questionId,
    String? optionValue,
  }) = _FeedbackOptionModel;

  factory FeedbackOptionModel.fromJson(Map<String, dynamic> json) =>
      _$FeedbackOptionModelFromJson(json);

  factory FeedbackOptionModel.fromEntity(FeedbackOptionEntity entity) {
    return FeedbackOptionModel(
      optionId: entity.optionId,
      questionId: entity.questionId,
      optionValue: entity.optionValue,
    );
  }
}

extension FeedbackOptionModelExtension on FeedbackOptionModel {
  FeedbackOptionEntity toEntity() {
    return FeedbackOptionEntity(
      optionId: optionId,
      questionId: questionId,
      optionValue: optionValue,
    );
  }
}

@freezed
class FeedbackAnswerModel with _$FeedbackAnswerModel {
  const factory FeedbackAnswerModel({
    int? id,
    int? questionId,
    String? questionText,
    FeedbackQuestionType? questionType,
    String? answerValue,
  }) = _FeedbackAnswerModel;

  factory FeedbackAnswerModel.fromJson(Map<String, dynamic> json) =>
      _$FeedbackAnswerModelFromJson(json);

  factory FeedbackAnswerModel.fromEntity(FeedbackAnswerEntity entity) {
    return FeedbackAnswerModel(
      id: entity.id,
      questionId: entity.questionId,
      questionText: entity.questionText,
      questionType: entity.questionType,
      answerValue: entity.answerValue,
    );
  }
}

extension FeedbackAnswerModelExtension on FeedbackAnswerModel {
  FeedbackAnswerEntity toEntity() {
    return FeedbackAnswerEntity(
      id: id,
      questionId: questionId,
      questionText: questionText,
      questionType: questionType,
      answerValue: answerValue,
    );
  }
}

@freezed
class FeedbackQuestionModel with _$FeedbackQuestionModel {
  const factory FeedbackQuestionModel({
    int? feedbackQuestionId,
    EventSummaryModel? event,
    String? questionContent,
    FeedbackQuestionType? questionType,
    bool? isRequired,
    List<FeedbackOptionModel>? options,
  }) = _FeedbackQuestionModel;

  factory FeedbackQuestionModel.fromJson(Map<String, dynamic> json) =>
      _$FeedbackQuestionModelFromJson(json);

  factory FeedbackQuestionModel.fromEntity(FeedbackQuestionEntity entity) {
    return FeedbackQuestionModel(
      feedbackQuestionId: entity.feedbackQuestionId,
      event: entity.event != null ? EventSummaryModel.fromEntity(entity.event!) : null,
      questionContent: entity.questionContent,
      questionType: entity.questionType,
      isRequired: entity.isRequired,
      options: entity.options?.map((e) => FeedbackOptionModel.fromEntity(e)).toList(),
    );
  }
}

extension FeedbackQuestionModelExtension on FeedbackQuestionModel {
  FeedbackQuestionEntity toEntity() {
    return FeedbackQuestionEntity(
      feedbackQuestionId: feedbackQuestionId,
      event: event?.toEntity(),
      questionContent: questionContent,
      questionType: questionType,
      isRequired: isRequired,
      options: options?.map((e) => e.toEntity()).toList(),
    );
  }
}

@freezed
class FeedbackModel with _$FeedbackModel {
  const factory FeedbackModel({
    int? attendanceFeedbackId,
    ParticipantModel? eventParticipant,
    List<FeedbackAnswerModel>? feedbackAnswers,
    String? comment,
    DateTime? createdTime,
  }) = _FeedbackModel;

  factory FeedbackModel.fromJson(Map<String, dynamic> json) =>
      _$FeedbackModelFromJson(json);

  factory FeedbackModel.fromEntity(FeedbackEntity entity) {
    return FeedbackModel(
      attendanceFeedbackId: entity.attendanceFeedbackId,
      eventParticipant: entity.eventParticipant != null
          ? ParticipantModel.fromEntity(entity.eventParticipant!)
          : null,
      feedbackAnswers:
          entity.feedbackAnswers?.map((e) => FeedbackAnswerModel.fromEntity(e)).toList(),
      comment: entity.comment,
      createdTime: entity.createdTime,
    );
  }
}

extension FeedbackModelExtension on FeedbackModel {
  FeedbackEntity toEntity() {
    return FeedbackEntity(
      attendanceFeedbackId: attendanceFeedbackId,
      eventParticipant: eventParticipant?.toEntity(),
      feedbackAnswers: feedbackAnswers?.map((e) => e.toEntity()).toList(),
      comment: comment,
      createdTime: createdTime,
    );
  }
}