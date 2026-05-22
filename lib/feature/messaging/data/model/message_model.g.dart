// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageModelImpl _$$MessageModelImplFromJson(Map<String, dynamic> json) =>
    _$MessageModelImpl(
      messageId: (json['messageId'] as num?)?.toInt(),
      conversationId: (json['conversationId'] as num?)?.toInt(),
      senderId: (json['senderId'] as num?)?.toInt(),
      content: json['content'] as String?,
      isRead: json['isRead'] as bool?,
      isDeleted: json['isDeleted'] as bool?,
      createdTime: json['createdTime'] == null
          ? null
          : DateTime.parse(json['createdTime'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    );

Map<String, dynamic> _$$MessageModelImplToJson(_$MessageModelImpl instance) =>
    <String, dynamic>{
      'messageId': instance.messageId,
      'conversationId': instance.conversationId,
      'senderId': instance.senderId,
      'content': instance.content,
      'isRead': instance.isRead,
      'isDeleted': instance.isDeleted,
      'createdTime': instance.createdTime?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };
