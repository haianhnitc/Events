import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import '../../domain/entity/feedback_question_entity.dart';

part 'feedback_question_model.freezed.dart';
part 'feedback_question_model.g.dart';

@freezed
class FeedbackQuestionModel with _$FeedbackQuestionModel {
  const factory FeedbackQuestionModel({
    int? feedbackQuestionId,
    int? eventId,
    String? questionContent,
    FeedbackQuestionType? questionType,
    DateTime? createdTime,
  }) = _FeedbackQuestionModel;

  factory FeedbackQuestionModel.fromJson(Map<String, dynamic> json) =>
      _$FeedbackQuestionModelFromJson(json);

  factory FeedbackQuestionModel.fromEntity(FeedbackQuestionEntity entity) {
    return FeedbackQuestionModel(
      feedbackQuestionId: entity.feedbackQuestionId,
      eventId: entity.eventId,
      questionContent: entity.questionContent,
      questionType: entity.questionType,
      createdTime: entity.createdTime,
    );
  }
}

extension FeedbackQuestionModelExtension on FeedbackQuestionModel {
  FeedbackQuestionEntity toEntity() {
    return FeedbackQuestionEntity(
      feedbackQuestionId: feedbackQuestionId,
      eventId: eventId,
      questionContent: questionContent,
      questionType: questionType,
      createdTime: createdTime,
    );
  }
}
