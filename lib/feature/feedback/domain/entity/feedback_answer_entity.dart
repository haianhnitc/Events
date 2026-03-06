class FeedbackAnswerEntity {
  final int? feedbackAnswerId;
  final int? attendanceFeedbackId;
  final int? feedbackQuestionId;
  final String? answerValue;
  final DateTime? createdTime;

  FeedbackAnswerEntity({
    this.feedbackAnswerId,
    this.attendanceFeedbackId,
    this.feedbackQuestionId,
    this.answerValue,
    this.createdTime,
  });
}
