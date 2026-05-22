// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_analytics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventAnalyticsModelImpl _$$EventAnalyticsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$EventAnalyticsModelImpl(
      eventId: (json['eventId'] as num?)?.toInt(),
      eventTitle: json['eventTitle'] as String?,
      genderDistribution: json['genderDistribution'] == null
          ? null
          : GenderDistributionModel.fromJson(
              json['genderDistribution'] as Map<String, dynamic>),
      majorDistribution: (json['majorDistribution'] as List<dynamic>?)
          ?.map((e) =>
              CategoryDistributionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      schoolDistribution: (json['schoolDistribution'] as List<dynamic>?)
          ?.map((e) =>
              CategoryDistributionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      ageDistribution: (json['ageDistribution'] as List<dynamic>?)
          ?.map((e) =>
              CategoryDistributionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      checkInTimeline: (json['checkInTimeline'] as List<dynamic>?)
          ?.map((e) => TimelineDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastUpdateTime: json['lastUpdateTime'] == null
          ? null
          : DateTime.parse(json['lastUpdateTime'] as String),
    );

Map<String, dynamic> _$$EventAnalyticsModelImplToJson(
        _$EventAnalyticsModelImpl instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'eventTitle': instance.eventTitle,
      'genderDistribution': instance.genderDistribution,
      'majorDistribution': instance.majorDistribution,
      'schoolDistribution': instance.schoolDistribution,
      'ageDistribution': instance.ageDistribution,
      'checkInTimeline': instance.checkInTimeline,
      'lastUpdateTime': instance.lastUpdateTime?.toIso8601String(),
    };
