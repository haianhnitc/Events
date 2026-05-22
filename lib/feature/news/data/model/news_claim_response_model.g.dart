// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_claim_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NewsClaimResponseModelImpl _$$NewsClaimResponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NewsClaimResponseModelImpl(
      coinsEarned: (json['coinsEarned'] as num?)?.toInt(),
      remainingRewardCoin: (json['remainingRewardCoin'] as num?)?.toInt(),
      exhausted: json['exhausted'] as bool?,
    );

Map<String, dynamic> _$$NewsClaimResponseModelImplToJson(
        _$NewsClaimResponseModelImpl instance) =>
    <String, dynamic>{
      'coinsEarned': instance.coinsEarned,
      'remainingRewardCoin': instance.remainingRewardCoin,
      'exhausted': instance.exhausted,
    };
