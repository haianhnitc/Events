// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'requirement_question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RequirementQuestionModelImpl _$$RequirementQuestionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RequirementQuestionModelImpl(
      questionId: (json['questionId'] as num?)?.toInt(),
      ctvRecruitmentId: (json['ctvRecruitmentId'] as num?)?.toInt(),
      questionText: json['questionText'] as String?,
      questionType: $enumDecodeNullable(
          _$RequirementQuestionTypeEnumMap, json['questionType']),
      isRequired: json['isRequired'] as bool?,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => QuestionOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$RequirementQuestionModelImplToJson(
        _$RequirementQuestionModelImpl instance) =>
    <String, dynamic>{
      'questionId': instance.questionId,
      'ctvRecruitmentId': instance.ctvRecruitmentId,
      'questionText': instance.questionText,
      'questionType': _$RequirementQuestionTypeEnumMap[instance.questionType],
      'isRequired': instance.isRequired,
      'options': instance.options,
    };

const _$RequirementQuestionTypeEnumMap = {
  RequirementQuestionType.text: 'TEXT',
  RequirementQuestionType.singleChoice: 'SINGLECHOICE',
  RequirementQuestionType.multipleChoice: 'MULTIPLECHOICE',
  RequirementQuestionType.rating: 'RATING',
};
