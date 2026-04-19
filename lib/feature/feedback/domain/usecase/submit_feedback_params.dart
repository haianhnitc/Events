class FeedbackAnswerItem {
  final int questionId;
  final String? answerValue;
  final List<int>? selectedOptionIds;

  const FeedbackAnswerItem({
    required this.questionId,
    this.answerValue,
    this.selectedOptionIds,
  });

  Map<String, dynamic> toJson() => {
        'questionId': questionId,
        if (answerValue != null) 'answerValue': answerValue,
        if (selectedOptionIds != null && selectedOptionIds!.isNotEmpty)
          'selectedOptionIds': selectedOptionIds,
      };
}

class SubmitFeedbackParams {
  final int eventId;
  final String? comment;
  final List<FeedbackAnswerItem> answers;

  const SubmitFeedbackParams({
    required this.eventId,
    this.comment,
    required this.answers,
  });

  Map<String, dynamic> toJson() => {
        'eventId': eventId,
        if (comment != null) 'comment': comment,
        'answers': answers.map((e) => e.toJson()).toList(),
      };
}
