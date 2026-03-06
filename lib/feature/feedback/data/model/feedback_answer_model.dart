import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/feedback_answer_entity.dart';

part 'feedback_answer_model.freezed.dart';
part 'feedback_answer_model.g.dart';

@freezed
class FeedbackAnswerModel with _$FeedbackAnswerModel {
  const factory FeedbackAnswerModel({
    int? feedbackAnswerId,
    int? attendanceFeedbackId,
    int? feedbackQuestionId,
    String? answerValue,
    DateTime? createdTime,
  }) = _FeedbackAnswerModel;

  factory FeedbackAnswerModel.fromJson(Map<String, dynamic> json) =>
      _$FeedbackAnswerModelFromJson(json);

  factory FeedbackAnswerModel.fromEntity(FeedbackAnswerEntity entity) {
    return FeedbackAnswerModel(
      feedbackAnswerId: entity.feedbackAnswerId,
      attendanceFeedbackId: entity.attendanceFeedbackId,
      feedbackQuestionId: entity.feedbackQuestionId,
      answerValue: entity.answerValue,
      createdTime: entity.createdTime,
    );
  }
}

extension FeedbackAnswerModelExtension on FeedbackAnswerModel {
  FeedbackAnswerEntity toEntity() {
    return FeedbackAnswerEntity(
      feedbackAnswerId: feedbackAnswerId,
      attendanceFeedbackId: attendanceFeedbackId,
      feedbackQuestionId: feedbackQuestionId,
      answerValue: answerValue,
      createdTime: createdTime,
    );
  }
}
