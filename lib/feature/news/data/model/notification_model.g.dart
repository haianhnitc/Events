// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationModelImpl(
      notificationId: (json['notificationId'] as num).toInt(),
      title: json['title'] as String?,
      body: json['body'] as String?,
      createdBy: $enumDecodeNullable(
          _$NotificationCreatedByEnumMap, json['createdBy']),
      targetType: $enumDecodeNullable(
          _$NotificationTargetTypeEnumMap, json['targetType']),
      targetId: (json['targetId'] as num?)?.toInt(),
      deeplink: json['deeplink'] as String?,
      createdTime: json['createdTime'] == null
          ? null
          : DateTime.parse(json['createdTime'] as String),
    );

Map<String, dynamic> _$$NotificationModelImplToJson(
        _$NotificationModelImpl instance) =>
    <String, dynamic>{
      'notificationId': instance.notificationId,
      'title': instance.title,
      'body': instance.body,
      'createdBy': _$NotificationCreatedByEnumMap[instance.createdBy],
      'targetType': _$NotificationTargetTypeEnumMap[instance.targetType],
      'targetId': instance.targetId,
      'deeplink': instance.deeplink,
      'createdTime': instance.createdTime?.toIso8601String(),
    };

const _$NotificationCreatedByEnumMap = {
  NotificationCreatedBy.admin: 'ADMIN',
  NotificationCreatedBy.system: 'SYSTEM',
};

const _$NotificationTargetTypeEnumMap = {
  NotificationTargetType.event: 'EVENT',
  NotificationTargetType.ctvRecruitment: 'CTV_RECRUITMENT',
  NotificationTargetType.portfolio: 'PORTFOLIO',
  NotificationTargetType.userProfile: 'USER_PROFILE',
  NotificationTargetType.transaction: 'TRANSACTION',
  NotificationTargetType.news: 'NEWS',
  NotificationTargetType.none: 'NONE',
};
