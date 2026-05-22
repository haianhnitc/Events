// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversationModelImpl _$$ConversationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ConversationModelImpl(
      conversationId: (json['conversationId'] as num?)?.toInt(),
      userId1: (json['userId1'] as num?)?.toInt(),
      userId2: (json['userId2'] as num?)?.toInt(),
      createdTime: json['createdTime'] == null
          ? null
          : DateTime.parse(json['createdTime'] as String),
      lastMessageAt: json['lastMessageAt'] == null
          ? null
          : DateTime.parse(json['lastMessageAt'] as String),
    );

Map<String, dynamic> _$$ConversationModelImplToJson(
        _$ConversationModelImpl instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'userId1': instance.userId1,
      'userId2': instance.userId2,
      'createdTime': instance.createdTime?.toIso8601String(),
      'lastMessageAt': instance.lastMessageAt?.toIso8601String(),
    };
