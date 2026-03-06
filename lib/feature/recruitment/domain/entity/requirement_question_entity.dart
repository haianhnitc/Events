import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class RequirementQuestionEntity {
  final int? requirementQuestionId;
  final int? ctvRecruitmentId;
  final String? questionContent;
  final RequirementQuestionType? questionType;
  final bool? isRequired;

  RequirementQuestionEntity({
    this.requirementQuestionId,
    this.ctvRecruitmentId,
    this.questionContent,
    this.questionType,
    this.isRequired,
  });
}
