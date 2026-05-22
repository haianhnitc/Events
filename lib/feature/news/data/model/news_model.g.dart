// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NewsModelImpl _$$NewsModelImplFromJson(Map<String, dynamic> json) =>
    _$NewsModelImpl(
      newsId: (json['newsId'] as num?)?.toInt(),
      title: json['title'] as String?,
      content: json['content'] as String?,
      banner: json['banner'] as String?,
      tag: json['tag'] as String?,
      targetType:
          $enumDecodeNullable(_$NewsTargetTypeEnumMap, json['targetType']),
      targetId: (json['targetId'] as num?)?.toInt(),
      totalRewardCoin: (json['totalRewardCoin'] as num?)?.toInt() ?? 0,
      remainingRewardCoin: (json['remainingRewardCoin'] as num?)?.toInt() ?? 0,
      rewardPerMinute: (json['rewardPerMinute'] as num?)?.toInt() ?? 0,
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      createdTime: json['createdTime'] == null
          ? null
          : DateTime.parse(json['createdTime'] as String),
    );

Map<String, dynamic> _$$NewsModelImplToJson(_$NewsModelImpl instance) =>
    <String, dynamic>{
      'newsId': instance.newsId,
      'title': instance.title,
      'content': instance.content,
      'banner': instance.banner,
      'tag': instance.tag,
      'targetType': _$NewsTargetTypeEnumMap[instance.targetType],
      'targetId': instance.targetId,
      'totalRewardCoin': instance.totalRewardCoin,
      'remainingRewardCoin': instance.remainingRewardCoin,
      'rewardPerMinute': instance.rewardPerMinute,
      'viewCount': instance.viewCount,
      'createdTime': instance.createdTime?.toIso8601String(),
    };

const _$NewsTargetTypeEnumMap = {
  NewsTargetType.none: 'NONE',
  NewsTargetType.event: 'EVENT',
  NewsTargetType.user: 'USER',
  NewsTargetType.package: 'PACKAGE',
  NewsTargetType.externalUrl: 'EXTERNAL_URL',
};
