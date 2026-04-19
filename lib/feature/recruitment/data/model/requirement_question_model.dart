import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/recruitment/domain/entity/question_option_entity.dart';
import 'package:events_app/feature/recruitment/domain/entity/requirement_question_entity.dart';
import 'question_option_model.dart';

part 'requirement_question_model.freezed.dart';
part 'requirement_question_model.g.dart';

@freezed
class RequirementQuestionModel with _$RequirementQuestionModel {
  const factory RequirementQuestionModel({
    int? questionId,
    int? ctvRecruitmentId,
    String? questionText,
    RequirementQuestionType? questionType,
    bool? isRequired,
    List<QuestionOptionModel>? options,
  }) = _RequirementQuestionModel;

  factory RequirementQuestionModel.fromJson(Map<String, dynamic> json) =>
      _$RequirementQuestionModelFromJson(json);

  factory RequirementQuestionModel.fromEntity(
      RequirementQuestionEntity entity) {
    return RequirementQuestionModel(
      questionId: entity.questionId,
      ctvRecruitmentId: entity.ctvRecruitmentId,
      questionText: entity.questionText,
      questionType: entity.questionType,
      isRequired: entity.isRequired,
      options: entity.options?.map(QuestionOptionModel.fromEntity).toList(),
    );
  }
}

extension RequirementQuestionModelExtension on RequirementQuestionModel {
  RequirementQuestionEntity toEntity() {
    return RequirementQuestionEntity(
      questionId: questionId,
      ctvRecruitmentId: ctvRecruitmentId,
      questionText: questionText,
      questionType: questionType,
      isRequired: isRequired,
      options: options?.map((o) => QuestionOptionEntity(
        optionId: o.optionId,
        questionId: o.questionId,
        optionValue: o.optionValue,
      )).toList(),
    );
  }
}
