import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import '../../domain/entity/news_entity.dart';

part 'news_model.freezed.dart';
part 'news_model.g.dart';

@freezed
class NewsModel with _$NewsModel {
  const factory NewsModel({
    int? newsId,
    String? title,
    String? content,
    String? banner,
    String? tag,
    NewsTargetType? targetType,
    int? targetId,
    @Default(0) int? totalRewardCoin,
    @Default(0) int? rewardPerMinute,
    DateTime? createdTime,
  }) = _NewsModel;

  factory NewsModel.fromJson(Map<String, dynamic> json) =>
      _$NewsModelFromJson(json);

  factory NewsModel.fromEntity(NewsEntity entity) {
    return NewsModel(
      newsId: entity.newsId,
      title: entity.title,
      content: entity.content,
      banner: entity.banner,
      tag: entity.tag,
      targetType: entity.targetType,
      targetId: entity.targetId,
      totalRewardCoin: entity.totalRewardCoin,
      rewardPerMinute: entity.rewardPerMinute,
      createdTime: entity.createdTime,
    );
  }
}

extension NewsModelExtension on NewsModel {
  NewsEntity toEntity() {
    return NewsEntity(
      newsId: newsId,
      title: title,
      content: content,
      banner: banner,
      tag: tag,
      targetType: targetType,
      targetId: targetId,
      totalRewardCoin: totalRewardCoin,
      rewardPerMinute: rewardPerMinute,
      createdTime: createdTime,
    );
  }
}
