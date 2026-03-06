import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class FeedbackQuestionEntity {
  final int? feedbackQuestionId;
  final int? eventId;
  final String? questionContent;
  final FeedbackQuestionType? questionType;
  final DateTime? createdTime;

  FeedbackQuestionEntity({
    this.feedbackQuestionId,
    this.eventId,
    this.questionContent,
    this.questionType,
    this.createdTime,
  });
}
