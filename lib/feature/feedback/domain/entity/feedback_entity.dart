import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';

class FeedbackQuestionEntity {
  final int? feedbackQuestionId;
  final EventSummaryEntity? event;
  final String? questionContent;
  final FeedbackQuestionType? questionType;
  final bool? isRequired;
  final List<FeedbackOptionEntity>? options;

  FeedbackQuestionEntity({
    this.feedbackQuestionId,
    this.event,
    this.questionContent,
    this.questionType,
    this.isRequired,
    this.options,
  });

  int? get eventId => event?.eventId;

  FeedbackQuestionEntity copyWith({
    int? feedbackQuestionId,
    EventSummaryEntity? event,
    String? questionContent,
    FeedbackQuestionType? questionType,
    bool? isRequired,
    List<FeedbackOptionEntity>? options,
  }) {
    return FeedbackQuestionEntity(
      feedbackQuestionId: feedbackQuestionId ?? this.feedbackQuestionId,
      event: event ?? this.event,
      questionContent: questionContent ?? this.questionContent,
      questionType: questionType ?? this.questionType,
      isRequired: isRequired ?? this.isRequired,
      options: options ?? this.options,
    );
  }

  @override
  String toString() =>
      'FeedbackQuestionEntity(id: $feedbackQuestionId, type: $questionType)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FeedbackQuestionEntity &&
        other.feedbackQuestionId == feedbackQuestionId;
  }

  @override
  int get hashCode => Object.hash(feedbackQuestionId, questionContent, eventId);
}

class FeedbackOptionEntity {
  final int? optionId;
  final int? questionId;
  final String? optionValue;

  FeedbackOptionEntity({
    this.optionId,
    this.questionId,
    this.optionValue,
  });

  FeedbackOptionEntity copyWith({
    int? optionId,
    int? questionId,
    String? optionValue,
  }) {
    return FeedbackOptionEntity(
      optionId: optionId ?? this.optionId,
      questionId: questionId ?? this.questionId,
      optionValue: optionValue ?? this.optionValue,
    );
  }

  @override
  String toString() => 'FeedbackOptionEntity(id: $optionId, questionId: $questionId, value: $optionValue)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FeedbackOptionEntity && other.optionId == optionId;
  }

  @override
  int get hashCode => Object.hash(optionId, questionId, optionValue);
}

class FeedbackAnswerEntity {
  final int? id;
  final int? questionId;
  final String? questionText;
  final FeedbackQuestionType? questionType;
  final String? answerValue;

  FeedbackAnswerEntity({
    this.id,
    this.questionId,
    this.questionText,
    this.questionType,
    this.answerValue,
  });

  FeedbackAnswerEntity copyWith({
    int? id,
    int? questionId,
    String? questionText,
    FeedbackQuestionType? questionType,
    String? answerValue,
  }) {
    return FeedbackAnswerEntity(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      questionText: questionText ?? this.questionText,
      questionType: questionType ?? this.questionType,
      answerValue: answerValue ?? this.answerValue,
    );
  }

  @override
  String toString() =>
      'FeedbackAnswerEntity(id: $id, questionId: $questionId, value: $answerValue)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FeedbackAnswerEntity && other.id == id;
  }

  @override
  int get hashCode => Object.hash(id, questionId);
}

class FeedbackEntity {
  final int? attendanceFeedbackId;
  final ParticipantEntity? eventParticipant;
  final List<FeedbackAnswerEntity>? feedbackAnswers;
  final String? comment;
  final DateTime? createdTime;

  FeedbackEntity({
    this.attendanceFeedbackId,
    this.eventParticipant,
    this.feedbackAnswers,
    this.comment,
    this.createdTime,
  });

  FeedbackEntity copyWith({
    int? attendanceFeedbackId,
    ParticipantEntity? eventParticipant,
    List<FeedbackAnswerEntity>? feedbackAnswers,
    String? comment,
    DateTime? createdTime,
  }) {
    return FeedbackEntity(
      attendanceFeedbackId: attendanceFeedbackId ?? this.attendanceFeedbackId,
      eventParticipant: eventParticipant ?? this.eventParticipant,
      feedbackAnswers: feedbackAnswers ?? this.feedbackAnswers,
      comment: comment ?? this.comment,
      createdTime: createdTime ?? this.createdTime,
    );
  }

  @override
  String toString() =>
      'FeedbackEntity(id: $attendanceFeedbackId, participant: ${eventParticipant?.eventParticipantId})';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FeedbackEntity &&
        other.attendanceFeedbackId == attendanceFeedbackId;
  }

  @override
  int get hashCode => Object.hash(attendanceFeedbackId, eventParticipant?.eventParticipantId);
}