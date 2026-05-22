// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_follow_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserFollowModelImpl _$$UserFollowModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserFollowModelImpl(
      followerId: (json['followerId'] as num?)?.toInt(),
      followingId: (json['followingId'] as num?)?.toInt(),
      updatedTime: json['updatedTime'] == null
          ? null
          : DateTime.parse(json['updatedTime'] as String),
    );

Map<String, dynamic> _$$UserFollowModelImplToJson(
        _$UserFollowModelImpl instance) =>
    <String, dynamic>{
      'followerId': instance.followerId,
      'followingId': instance.followingId,
      'updatedTime': instance.updatedTime?.toIso8601String(),
    };
