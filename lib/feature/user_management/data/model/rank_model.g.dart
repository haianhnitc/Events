// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rank_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RankModelImpl _$$RankModelImplFromJson(Map<String, dynamic> json) =>
    _$RankModelImpl(
      userId: (json['userId'] as num?)?.toInt(),
      user: json['user'] == null
          ? null
          : UserSummaryModel.fromJson(json['user'] as Map<String, dynamic>),
      totalCoin: (json['totalCoin'] as num?)?.toInt() ?? 0,
      ranking: (json['ranking'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 1,
      levelName: json['levelName'] as String?,
      updatedTime: json['updatedTime'] == null
          ? null
          : DateTime.parse(json['updatedTime'] as String),
    );

Map<String, dynamic> _$$RankModelImplToJson(_$RankModelImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'user': instance.user,
      'totalCoin': instance.totalCoin,
      'ranking': instance.ranking,
      'level': instance.level,
      'levelName': instance.levelName,
      'updatedTime': instance.updatedTime?.toIso8601String(),
    };
