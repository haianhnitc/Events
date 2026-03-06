import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import '../../domain/entity/requirement_question_entity.dart';

part 'requirement_question_model.freezed.dart';
part 'requirement_question_model.g.dart';

@freezed
class RequirementQuestionModel with _$RequirementQuestionModel {
  const factory RequirementQuestionModel({
    int? requirementQuestionId,
    int? ctvRecruitmentId,
    String? questionContent,
    RequirementQuestionType? questionType,
    @Default(false) bool? isRequired,
  }) = _RequirementQuestionModel;

  factory RequirementQuestionModel.fromJson(Map<String, dynamic> json) =>
      _$RequirementQuestionModelFromJson(json);

  factory RequirementQuestionModel.fromEntity(
      RequirementQuestionEntity entity) {
    return RequirementQuestionModel(
      requirementQuestionId: entity.requirementQuestionId,
      ctvRecruitmentId: entity.ctvRecruitmentId,
      questionContent: entity.questionContent,
      questionType: entity.questionType,
      isRequired: entity.isRequired,
    );
  }
}

extension RequirementQuestionModelExtension on RequirementQuestionModel {
  RequirementQuestionEntity toEntity() {
    return RequirementQuestionEntity(
      requirementQuestionId: requirementQuestionId,
      ctvRecruitmentId: ctvRecruitmentId,
      questionContent: questionContent,
      questionType: questionType,
      isRequired: isRequired,
    );
  }
}
