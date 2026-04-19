class QuestionOptionEntity {
  final int? optionId;
  final int? questionId;
  final String? optionValue;

  QuestionOptionEntity({
    this.optionId,
    this.questionId,
    this.optionValue,
  });

  QuestionOptionEntity copyWith({
    int? optionId,
    int? questionId,
    String? optionValue,
  }) {
    return QuestionOptionEntity(
      optionId: optionId ?? this.optionId,
      questionId: questionId ?? this.questionId,
      optionValue: optionValue ?? this.optionValue,
    );
  }

  @override
  String toString() => 'QuestionOptionEntity(id: $optionId, value: $optionValue)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QuestionOptionEntity && other.optionId == optionId;
  }

  @override
  int get hashCode => Object.hash(optionId, questionId);
}
