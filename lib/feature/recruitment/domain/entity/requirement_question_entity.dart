import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/recruitment/domain/entity/question_option_entity.dart';

class RequirementQuestionEntity {
  final int? questionId;
  final int? ctvRecruitmentId;
  final String? questionText;
  final RequirementQuestionType? questionType;
  final bool? isRequired;
  final List<QuestionOptionEntity>? options;

  RequirementQuestionEntity({
    this.questionId,
    this.ctvRecruitmentId,
    this.questionText,
    this.questionType,
    this.isRequired,
    this.options,
  });

  RequirementQuestionEntity copyWith({
    int? questionId,
    int? ctvRecruitmentId,
    String? questionText,
    RequirementQuestionType? questionType,
    bool? isRequired,
    List<QuestionOptionEntity>? options,
  }) {
    return RequirementQuestionEntity(
      questionId: questionId ?? this.questionId,
      ctvRecruitmentId: ctvRecruitmentId ?? this.ctvRecruitmentId,
      questionText: questionText ?? this.questionText,
      questionType: questionType ?? this.questionType,
      isRequired: isRequired ?? this.isRequired,
      options: options ?? this.options,
    );
  }

  @override
  String toString() =>
      'RequirementQuestionEntity(id: $questionId, type: $questionType)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RequirementQuestionEntity && other.questionId == questionId;
  }

  @override
  int get hashCode => Object.hash(questionId, ctvRecruitmentId);
}
