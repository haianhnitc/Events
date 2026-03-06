import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/user_follow_entity.dart';

part 'user_follow_model.freezed.dart';
part 'user_follow_model.g.dart';

@freezed
class UserFollowModel with _$UserFollowModel {
  const factory UserFollowModel({
    int? followerId,
    int? followingId,
    DateTime? updatedTime,
  }) = _UserFollowModel;

  factory UserFollowModel.fromJson(Map<String, dynamic> json) =>
      _$UserFollowModelFromJson(json);

  factory UserFollowModel.fromEntity(UserFollowEntity entity) {
    return UserFollowModel(
      followerId: entity.followerId,
      followingId: entity.followingId,
      updatedTime: entity.updatedTime,
    );
  }
}

extension UserFollowModelExtension on UserFollowModel {
  UserFollowEntity toEntity() {
    return UserFollowEntity(
      followerId: followerId,
      followingId: followingId,
      updatedTime: updatedTime,
    );
  }
}
