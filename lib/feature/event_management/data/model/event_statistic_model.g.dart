// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_statistic_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventStatisticModelImpl _$$EventStatisticModelImplFromJson(
        Map<String, dynamic> json) =>
    _$EventStatisticModelImpl(
      eventId: (json['eventId'] as num?)?.toInt(),
      eventTitle: json['eventTitle'] as String?,
      recruitmentType: json['recruitmentType'] as String?,
      totalRegistered: (json['totalRegistered'] as num?)?.toInt() ?? 0,
      totalCheckedIn: (json['totalCheckedIn'] as num?)?.toInt() ?? 0,
      totalCheckedOut: (json['totalCheckedOut'] as num?)?.toInt() ?? 0,
      totalAttendees: (json['totalAttendees'] as num?)?.toInt() ?? 0,
      totalCtv: (json['totalCtv'] as num?)?.toInt() ?? 0,
      totalTicketsSold: (json['totalTicketsSold'] as num?)?.toInt() ?? 0,
      totalFeedbacks: (json['totalFeedbacks'] as num?)?.toInt() ?? 0,
      totalViews: (json['totalViews'] as num?)?.toInt() ?? 0,
      lastUpdateTime: json['lastUpdateTime'] == null
          ? null
          : DateTime.parse(json['lastUpdateTime'] as String),
    );

Map<String, dynamic> _$$EventStatisticModelImplToJson(
        _$EventStatisticModelImpl instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'eventTitle': instance.eventTitle,
      'recruitmentType': instance.recruitmentType,
      'totalRegistered': instance.totalRegistered,
      'totalCheckedIn': instance.totalCheckedIn,
      'totalCheckedOut': instance.totalCheckedOut,
      'totalAttendees': instance.totalAttendees,
      'totalCtv': instance.totalCtv,
      'totalTicketsSold': instance.totalTicketsSold,
      'totalFeedbacks': instance.totalFeedbacks,
      'totalViews': instance.totalViews,
      'lastUpdateTime': instance.lastUpdateTime?.toIso8601String(),
    };
