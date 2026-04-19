import 'package:freezed_annotation/freezed_annotation.dart';

part 'news_claim_response_model.freezed.dart';
part 'news_claim_response_model.g.dart';

@freezed
class NewsClaimResponseModel with _$NewsClaimResponseModel {
  const factory NewsClaimResponseModel({
    int? coinsEarned,
    int? remainingRewardCoin,
    bool? exhausted,
  }) = _NewsClaimResponseModel;

  factory NewsClaimResponseModel.fromJson(Map<String, dynamic> json) =>
      _$NewsClaimResponseModelFromJson(json);
}
