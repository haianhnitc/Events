// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ctv_recruitment_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CtvRecruitmentSummaryModelImpl _$$CtvRecruitmentSummaryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CtvRecruitmentSummaryModelImpl(
      ctvRecruitmentId: (json['ctvRecruitmentId'] as num?)?.toInt(),
      eventId: (json['eventId'] as num?)?.toInt(),
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      title: json['title'] as String?,
      banner: json['banner'] as String?,
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      roleName: json['roleName'] as String?,
      description: json['description'] as String?,
      certificateName: json['certificateName'] as String?,
      cashRewardAmount: (json['cashRewardAmount'] as num?)?.toInt(),
      quantity: (json['quantity'] as num?)?.toInt(),
      isOpen: json['isOpen'] as bool?,
      appliedCount: (json['appliedCount'] as num?)?.toInt(),
      userEventState:
          $enumDecodeNullable(_$UserEventStateEnumMap, json['userEventState']),
      createdTime: json['createdTime'] == null
          ? null
          : DateTime.parse(json['createdTime'] as String),
      youthUnionPoint: (json['youthUnionPoint'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$CtvRecruitmentSummaryModelImplToJson(
        _$CtvRecruitmentSummaryModelImpl instance) =>
    <String, dynamic>{
      'ctvRecruitmentId': instance.ctvRecruitmentId,
      'eventId': instance.eventId,
      'categories': instance.categories,
      'title': instance.title,
      'banner': instance.banner,
      'startTime': instance.startTime?.toIso8601String(),
      'roleName': instance.roleName,
      'description': instance.description,
      'certificateName': instance.certificateName,
      'cashRewardAmount': instance.cashRewardAmount,
      'quantity': instance.quantity,
      'isOpen': instance.isOpen,
      'appliedCount': instance.appliedCount,
      'userEventState': _$UserEventStateEnumMap[instance.userEventState],
      'createdTime': instance.createdTime?.toIso8601String(),
      'youthUnionPoint': instance.youthUnionPoint,
    };

const _$UserEventStateEnumMap = {
  UserEventState.none: 'NONE',
  UserEventState.attendee: 'ATTENDEE',
  UserEventState.ctv: 'CTV',
  UserEventState.ctvApplied: 'CTV_APPLIED',
  UserEventState.ctvRejected: 'CTV_REJECTED',
};
