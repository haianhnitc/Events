// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserNotificationModelImpl _$$UserNotificationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserNotificationModelImpl(
      userNotificationId: (json['userNotificationId'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      notificationId: (json['notificationId'] as num?)?.toInt(),
      isRead: json['isRead'] as bool?,
      isDeleted: json['isDeleted'] as bool?,
      createdTime: json['createdTime'] == null
          ? null
          : DateTime.parse(json['createdTime'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    );

Map<String, dynamic> _$$UserNotificationModelImplToJson(
        _$UserNotificationModelImpl instance) =>
    <String, dynamic>{
      'userNotificationId': instance.userNotificationId,
      'userId': instance.userId,
      'notificationId': instance.notificationId,
      'isRead': instance.isRead,
      'isDeleted': instance.isDeleted,
      'createdTime': instance.createdTime?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };
