// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_application_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StaffApplicationModelImpl _$$StaffApplicationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$StaffApplicationModelImpl(
      applicationId: (json['applicationId'] as num?)?.toInt(),
      applicant: json['applicant'] == null
          ? null
          : UserSummaryModel.fromJson(
              json['applicant'] as Map<String, dynamic>),
      eventId: (json['eventId'] as num?)?.toInt(),
      eventTitle: json['eventTitle'] as String?,
      roleName: json['roleName'] as String?,
      cvUrl: json['cvUrl'] as String?,
      status:
          $enumDecodeNullable(_$StaffApplicationStatusEnumMap, json['status']),
      rejectionReason: json['rejectionReason'] as String?,
      appliedTime: json['appliedTime'] == null
          ? null
          : DateTime.parse(json['appliedTime'] as String),
      reviewedTime: json['reviewedTime'] == null
          ? null
          : DateTime.parse(json['reviewedTime'] as String),
      applicationAnswers: (json['applicationAnswers'] as List<dynamic>?)
          ?.map(
              (e) => ApplicationAnswerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$StaffApplicationModelImplToJson(
        _$StaffApplicationModelImpl instance) =>
    <String, dynamic>{
      'applicationId': instance.applicationId,
      'applicant': instance.applicant,
      'eventId': instance.eventId,
      'eventTitle': instance.eventTitle,
      'roleName': instance.roleName,
      'cvUrl': instance.cvUrl,
      'status': _$StaffApplicationStatusEnumMap[instance.status],
      'rejectionReason': instance.rejectionReason,
      'appliedTime': instance.appliedTime?.toIso8601String(),
      'reviewedTime': instance.reviewedTime?.toIso8601String(),
      'applicationAnswers': instance.applicationAnswers,
    };

const _$StaffApplicationStatusEnumMap = {
  StaffApplicationStatus.pending: 'PENDING',
  StaffApplicationStatus.approved: 'APPROVED',
  StaffApplicationStatus.rejected: 'REJECTED',
};

_$ApplicationAnswerModelImpl _$$ApplicationAnswerModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ApplicationAnswerModelImpl(
      id: (json['id'] as num?)?.toInt(),
      eventStaffApplicationId:
          (json['eventStaffApplicationId'] as num?)?.toInt(),
      questionId: (json['questionId'] as num?)?.toInt(),
      questionText: json['questionText'] as String?,
      questionType: $enumDecodeNullable(
          _$RequirementQuestionTypeEnumMap, json['questionType']),
      answerValue: json['answerValue'] as String?,
      selectedOptionIds: (json['selectedOptionIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$$ApplicationAnswerModelImplToJson(
        _$ApplicationAnswerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventStaffApplicationId': instance.eventStaffApplicationId,
      'questionId': instance.questionId,
      'questionText': instance.questionText,
      'questionType': _$RequirementQuestionTypeEnumMap[instance.questionType],
      'answerValue': instance.answerValue,
      'selectedOptionIds': instance.selectedOptionIds,
    };

const _$RequirementQuestionTypeEnumMap = {
  RequirementQuestionType.text: 'TEXT',
  RequirementQuestionType.singleChoice: 'SINGLECHOICE',
  RequirementQuestionType.multipleChoice: 'MULTIPLECHOICE',
  RequirementQuestionType.rating: 'RATING',
};
