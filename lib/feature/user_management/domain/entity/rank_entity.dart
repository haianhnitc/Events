class RankEntity {
  final int? userId;
  final int? level;
  final String? levelName;
  final int? ranking;
  final int? totalCoin;
  final DateTime? updatedTime;

  RankEntity({
    this.userId,
    this.level,
    this.levelName,
    this.ranking,
    this.totalCoin,
    this.updatedTime,
  });
}
