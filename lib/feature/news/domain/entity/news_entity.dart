import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class NewsEntity {
  final int? newsId;
  final String? title;
  final String? content;
  final String? banner;
  final String? tag;
  final NewsTargetType? targetType;
  final int? targetId;
  final int? totalRewardCoin;
  final int? rewardPerMinute;
  final DateTime? createdTime;

  NewsEntity({
    this.newsId,
    this.title,
    this.content,
    this.banner,
    this.tag,
    this.targetType,
    this.targetId,
    this.totalRewardCoin,
    this.rewardPerMinute,
    this.createdTime,
  });
}
