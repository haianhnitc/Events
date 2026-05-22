// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FeedbackOptionModelImpl _$$FeedbackOptionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FeedbackOptionModelImpl(
      optionId: (json['optionId'] as num?)?.toInt(),
      questionId: (json['questionId'] as num?)?.toInt(),
      optionValue: json['optionValue'] as String?,
    );

Map<String, dynamic> _$$FeedbackOptionModelImplToJson(
        _$FeedbackOptionModelImpl instance) =>
    <String, dynamic>{
      'optionId': instance.optionId,
      'questionId': instance.questionId,
      'optionValue': instance.optionValue,
    };

_$FeedbackAnswerModelImpl _$$FeedbackAnswerModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FeedbackAnswerModelImpl(
      id: (json['id'] as num?)?.toInt(),
      questionId: (json['questionId'] as num?)?.toInt(),
      questionText: json['questionText'] as String?,
      questionType: $enumDecodeNullable(
          _$FeedbackQuestionTypeEnumMap, json['questionType']),
      answerValue: json['answerValue'] as String?,
    );

Map<String, dynamic> _$$FeedbackAnswerModelImplToJson(
        _$FeedbackAnswerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'questionId': instance.questionId,
      'questionText': instance.questionText,
      'questionType': _$FeedbackQuestionTypeEnumMap[instance.questionType],
      'answerValue': instance.answerValue,
    };

const _$FeedbackQuestionTypeEnumMap = {
  FeedbackQuestionType.text: 'TEXT',
  FeedbackQuestionType.rating: 'RATING',
  FeedbackQuestionType.singleChoice: 'SINGLECHOICE',
  FeedbackQuestionType.multipleChoice: 'MULTIPLECHOICE',
};

_$FeedbackQuestionModelImpl _$$FeedbackQuestionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FeedbackQuestionModelImpl(
      feedbackQuestionId: (json['feedbackQuestionId'] as num?)?.toInt(),
      event: json['event'] == null
          ? null
          : EventSummaryModel.fromJson(json['event'] as Map<String, dynamic>),
      questionContent: json['questionContent'] as String?,
      questionType: $enumDecodeNullable(
          _$FeedbackQuestionTypeEnumMap, json['questionType']),
      isRequired: json['isRequired'] as bool?,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => FeedbackOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$FeedbackQuestionModelImplToJson(
        _$FeedbackQuestionModelImpl instance) =>
    <String, dynamic>{
      'feedbackQuestionId': instance.feedbackQuestionId,
      'event': instance.event,
      'questionContent': instance.questionContent,
      'questionType': _$FeedbackQuestionTypeEnumMap[instance.questionType],
      'isRequired': instance.isRequired,
      'options': instance.options,
    };

_$FeedbackModelImpl _$$FeedbackModelImplFromJson(Map<String, dynamic> json) =>
    _$FeedbackModelImpl(
      attendanceFeedbackId: (json['attendanceFeedbackId'] as num?)?.toInt(),
      eventParticipant: json['eventParticipant'] == null
          ? null
          : ParticipantModel.fromJson(
              json['eventParticipant'] as Map<String, dynamic>),
      feedbackAnswers: (json['feedbackAnswers'] as List<dynamic>?)
          ?.map((e) => FeedbackAnswerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      comment: json['comment'] as String?,
      createdTime: json['createdTime'] == null
          ? null
          : DateTime.parse(json['createdTime'] as String),
    );

Map<String, dynamic> _$$FeedbackModelImplToJson(_$FeedbackModelImpl instance) =>
    <String, dynamic>{
      'attendanceFeedbackId': instance.attendanceFeedbackId,
      'eventParticipant': instance.eventParticipant,
      'feedbackAnswers': instance.feedbackAnswers,
      'comment': instance.comment,
      'createdTime': instance.createdTime?.toIso8601String(),
    };
