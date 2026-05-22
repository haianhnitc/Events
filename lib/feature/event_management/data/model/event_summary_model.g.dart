// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventSummaryModelImpl _$$EventSummaryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$EventSummaryModelImpl(
      eventId: (json['eventId'] as num?)?.toInt(),
      title: json['title'] as String?,
      banner: json['banner'] as String?,
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      registerOpenTime: json['registerOpenTime'] == null
          ? null
          : DateTime.parse(json['registerOpenTime'] as String),
      status: $enumDecodeNullable(_$EventStatusEnumMap, json['status']),
      price: (json['price'] as num?)?.toInt(),
      certificateName: json['certificateName'] as String?,
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      capacity: (json['capacity'] as num?)?.toInt(),
      totalParticipants: (json['totalParticipants'] as num?)?.toInt(),
      userEventState:
          $enumDecodeNullable(_$UserEventStateEnumMap, json['userEventState']),
      youthUnionPoint: (json['youthUnionPoint'] as num?)?.toInt(),
      recruitmentType: $enumDecodeNullable(
          _$EventRecruitmentTypeEnumMap, json['recruitmentType']),
    );

Map<String, dynamic> _$$EventSummaryModelImplToJson(
        _$EventSummaryModelImpl instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'title': instance.title,
      'banner': instance.banner,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'registerOpenTime': instance.registerOpenTime?.toIso8601String(),
      'status': _$EventStatusEnumMap[instance.status],
      'price': instance.price,
      'certificateName': instance.certificateName,
      'categories': instance.categories,
      'capacity': instance.capacity,
      'totalParticipants': instance.totalParticipants,
      'userEventState': _$UserEventStateEnumMap[instance.userEventState],
      'youthUnionPoint': instance.youthUnionPoint,
      'recruitmentType':
          _$EventRecruitmentTypeEnumMap[instance.recruitmentType],
    };

const _$EventStatusEnumMap = {
  EventStatus.published: 'PUBLISHED',
  EventStatus.closed: 'CLOSED',
  EventStatus.draft: 'DRAFT',
  EventStatus.cancelled: 'CANCELLED',
  EventStatus.locked: 'LOCKED',
};

const _$UserEventStateEnumMap = {
  UserEventState.none: 'NONE',
  UserEventState.attendee: 'ATTENDEE',
  UserEventState.ctv: 'CTV',
  UserEventState.ctvApplied: 'CTV_APPLIED',
  UserEventState.ctvRejected: 'CTV_REJECTED',
};

const _$EventRecruitmentTypeEnumMap = {
  EventRecruitmentType.ctvOnly: 'CTV_ONLY',
  EventRecruitmentType.attendeeOnly: 'ATTENDEE_ONLY',
  EventRecruitmentType.both: 'BOTH',
};
