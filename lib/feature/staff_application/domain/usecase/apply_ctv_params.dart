class AnswerItem {
  final int questionId;
  final String? answerText;
  final List<int>? selectedOptionIds;

  const AnswerItem({
    required this.questionId,
    this.answerText,
    this.selectedOptionIds,
  });

  Map<String, dynamic> toJson() => {
        'questionId': questionId,
        if (answerText != null) 'answerText': answerText,
        if (selectedOptionIds != null) 'selectedOptionIds': selectedOptionIds,
      };
}

class ApplyCtvParams {
  final int eventId;
  final String? cvUrl;
  final List<AnswerItem> answers;

  const ApplyCtvParams({
    required this.eventId,
    this.cvUrl,
    required this.answers,
  });

  Map<String, dynamic> toJson() => {
        'eventId': eventId,
        if (cvUrl != null) 'cvUrl': cvUrl,
        'answers': answers.map((e) => e.toJson()).toList(),
      };
}
