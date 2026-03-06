import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/rank_entity.dart';

part 'rank_model.freezed.dart';
part 'rank_model.g.dart';

@freezed
class RankModel with _$RankModel {
  const factory RankModel({
    int? userId,
    @Default(1) int? level,
    String? levelName,
    int? ranking,
    @Default(0) int? totalCoin,
    DateTime? updatedTime,
  }) = _RankModel;

  factory RankModel.fromJson(Map<String, dynamic> json) =>
      _$RankModelFromJson(json);

  factory RankModel.fromEntity(RankEntity entity) {
    return RankModel(
      userId: entity.userId,
      level: entity.level,
      levelName: entity.levelName,
      ranking: entity.ranking,
      totalCoin: entity.totalCoin,
      updatedTime: entity.updatedTime,
    );
  }
}

extension RankModelExtension on RankModel {
  RankEntity toEntity() {
    return RankEntity(
      userId: userId,
      level: level,
      levelName: levelName,
      ranking: ranking,
      totalCoin: totalCoin,
      updatedTime: updatedTime,
    );
  }
}
