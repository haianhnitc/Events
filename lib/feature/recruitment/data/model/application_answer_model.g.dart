// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_answer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApplicationAnswerModelImpl _$$ApplicationAnswerModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ApplicationAnswerModelImpl(
      applicationAnswerId: (json['applicationAnswerId'] as num?)?.toInt(),
      eventStaffApplicationId:
          (json['eventStaffApplicationId'] as num?)?.toInt(),
      requirementQuestionId: (json['requirementQuestionId'] as num?)?.toInt(),
      answerValue: json['answerValue'] as String?,
    );

Map<String, dynamic> _$$ApplicationAnswerModelImplToJson(
        _$ApplicationAnswerModelImpl instance) =>
    <String, dynamic>{
      'applicationAnswerId': instance.applicationAnswerId,
      'eventStaffApplicationId': instance.eventStaffApplicationId,
      'requirementQuestionId': instance.requirementQuestionId,
      'answerValue': instance.answerValue,
    };
