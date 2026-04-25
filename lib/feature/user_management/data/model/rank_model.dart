import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:events_app/feature/user_management/data/model/user_summary_model.dart';
import '../../domain/entity/rank_entity.dart';

part 'rank_model.freezed.dart';
part 'rank_model.g.dart';

@freezed
class RankModel with _$RankModel {
  const factory RankModel({
    int? userId,
    UserSummaryModel? user,
    @Default(0) int? totalCoin,
    @Default(0) int? ranking,
    @Default(1) int? level,
    String? levelName,
    DateTime? updatedTime,
  }) = _RankModel;

  factory RankModel.fromJson(Map<String, dynamic> json) =>
      _$RankModelFromJson(json);

  factory RankModel.fromEntity(RankEntity entity) {
    return RankModel(
      userId: entity.userId,
      user: entity.user != null
          ? UserSummaryModel.fromEntity(entity.user!)
          : null,
      totalCoin: entity.totalCoin,
      ranking: entity.ranking,
      level: entity.level,
      levelName: entity.levelName,
      updatedTime: entity.updatedTime,
    );
  }
}

extension RankModelExtension on RankModel {
  RankEntity toEntity() {
    return RankEntity(
      userId: userId,
      user: user?.toEntity(),
      totalCoin: totalCoin,
      ranking: ranking,
      level: level,
      levelName: levelName,
      updatedTime: updatedTime,
    );
  }
}
