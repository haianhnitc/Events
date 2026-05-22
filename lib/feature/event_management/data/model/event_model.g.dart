// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventModelImpl _$$EventModelImplFromJson(Map<String, dynamic> json) =>
    _$EventModelImpl(
      eventId: (json['eventId'] as num?)?.toInt(),
      organizerName: json['organizerName'] as String?,
      venue: json['venue'] == null
          ? null
          : VenueModel.fromJson(json['venue'] as Map<String, dynamic>),
      title: json['title'] as String?,
      description: json['description'] as String?,
      banner: json['banner'] as String?,
      status: $enumDecodeNullable(_$EventStatusEnumMap, json['status']) ??
          EventStatus.draft,
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      registerOpenTime: json['registerOpenTime'] == null
          ? null
          : DateTime.parse(json['registerOpenTime'] as String),
      price: (json['price'] as num?)?.toInt(),
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      rewardCoin: (json['rewardCoin'] as num?)?.toInt(),
      youthUnionPoint: (json['youthUnionPoint'] as num?)?.toInt(),
      certificateName: json['certificateName'] as String?,
      createdTime: json['createdTime'] == null
          ? null
          : DateTime.parse(json['createdTime'] as String),
      totalParticipants: (json['totalParticipants'] as num?)?.toInt(),
      userEventState:
          $enumDecodeNullable(_$UserEventStateEnumMap, json['userEventState']),
      recruitmentType: $enumDecodeNullable(
          _$EventRecruitmentTypeEnumMap, json['recruitmentType']),
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      lastViewedTime: json['lastViewedTime'] == null
          ? null
          : DateTime.parse(json['lastViewedTime'] as String),
    );

Map<String, dynamic> _$$EventModelImplToJson(_$EventModelImpl instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'organizerName': instance.organizerName,
      'venue': instance.venue,
      'title': instance.title,
      'description': instance.description,
      'banner': instance.banner,
      'status': _$EventStatusEnumMap[instance.status],
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'registerOpenTime': instance.registerOpenTime?.toIso8601String(),
      'price': instance.price,
      'categories': instance.categories,
      'rewardCoin': instance.rewardCoin,
      'youthUnionPoint': instance.youthUnionPoint,
      'certificateName': instance.certificateName,
      'createdTime': instance.createdTime?.toIso8601String(),
      'totalParticipants': instance.totalParticipants,
      'userEventState': _$UserEventStateEnumMap[instance.userEventState],
      'recruitmentType':
          _$EventRecruitmentTypeEnumMap[instance.recruitmentType],
      'viewCount': instance.viewCount,
      'lastViewedTime': instance.lastViewedTime?.toIso8601String(),
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
