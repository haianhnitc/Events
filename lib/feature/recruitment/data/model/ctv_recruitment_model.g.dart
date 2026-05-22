// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ctv_recruitment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CtvRecruitmentModelImpl _$$CtvRecruitmentModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CtvRecruitmentModelImpl(
      ctvRecruitmentId: (json['ctvRecruitmentId'] as num?)?.toInt(),
      eventId: (json['eventId'] as num?)?.toInt(),
      eventTitle: json['eventTitle'] as String?,
      organizerName: json['organizerName'] as String?,
      venue: json['venue'] == null
          ? null
          : VenueModel.fromJson(json['venue'] as Map<String, dynamic>),
      recruitmentType: $enumDecodeNullable(
          _$EventRecruitmentTypeEnumMap, json['recruitmentType']),
      rewardCoin: (json['rewardCoin'] as num?)?.toInt(),
      youthUnionPoint: (json['youthUnionPoint'] as num?)?.toInt(),
      cashRewardAmount: (json['cashRewardAmount'] as num?)?.toInt(),
      certificateName: json['certificateName'] as String?,
      title: json['title'] as String?,
      banner: json['banner'] as String?,
      roleName: json['roleName'] as String?,
      description: json['description'] as String?,
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      registerOpenTime: json['registerOpenTime'] == null
          ? null
          : DateTime.parse(json['registerOpenTime'] as String),
      quantity: (json['quantity'] as num?)?.toInt(),
      isOpen: json['isOpen'] as bool?,
      appliedCount: (json['appliedCount'] as num?)?.toInt(),
      recruitedCtvCount: (json['recruitedCtvCount'] as num?)?.toInt(),
      userEventState:
          $enumDecodeNullable(_$UserEventStateEnumMap, json['userEventState']),
      createdTime: json['createdTime'] == null
          ? null
          : DateTime.parse(json['createdTime'] as String),
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      requirementQuestions: (json['requirementQuestions'] as List<dynamic>?)
          ?.map((e) =>
              RequirementQuestionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CtvRecruitmentModelImplToJson(
        _$CtvRecruitmentModelImpl instance) =>
    <String, dynamic>{
      'ctvRecruitmentId': instance.ctvRecruitmentId,
      'eventId': instance.eventId,
      'eventTitle': instance.eventTitle,
      'organizerName': instance.organizerName,
      'venue': instance.venue,
      'recruitmentType':
          _$EventRecruitmentTypeEnumMap[instance.recruitmentType],
      'rewardCoin': instance.rewardCoin,
      'youthUnionPoint': instance.youthUnionPoint,
      'cashRewardAmount': instance.cashRewardAmount,
      'certificateName': instance.certificateName,
      'title': instance.title,
      'banner': instance.banner,
      'roleName': instance.roleName,
      'description': instance.description,
      'startTime': instance.startTime?.toIso8601String(),
      'registerOpenTime': instance.registerOpenTime?.toIso8601String(),
      'quantity': instance.quantity,
      'isOpen': instance.isOpen,
      'appliedCount': instance.appliedCount,
      'recruitedCtvCount': instance.recruitedCtvCount,
      'userEventState': _$UserEventStateEnumMap[instance.userEventState],
      'createdTime': instance.createdTime?.toIso8601String(),
      'categories': instance.categories,
      'requirementQuestions': instance.requirementQuestions,
    };

const _$EventRecruitmentTypeEnumMap = {
  EventRecruitmentType.ctvOnly: 'CTV_ONLY',
  EventRecruitmentType.attendeeOnly: 'ATTENDEE_ONLY',
  EventRecruitmentType.both: 'BOTH',
};

const _$UserEventStateEnumMap = {
  UserEventState.none: 'NONE',
  UserEventState.attendee: 'ATTENDEE',
  UserEventState.ctv: 'CTV',
  UserEventState.ctvApplied: 'CTV_APPLIED',
  UserEventState.ctvRejected: 'CTV_REJECTED',
};
