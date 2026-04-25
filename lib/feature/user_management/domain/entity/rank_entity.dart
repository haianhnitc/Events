import 'package:events_app/feature/user_management/domain/entity/user_summary_entity.dart';

class RankEntity {
  final int? userId;
  final UserSummaryEntity? user;
  final int? totalCoin;
  final int? ranking;
  final int? level;
  final String? levelName;
  final DateTime? updatedTime;

  RankEntity({
    this.userId,
    this.user,
    this.totalCoin,
    this.ranking,
    this.level,
    this.levelName,
    this.updatedTime,
  });
}
