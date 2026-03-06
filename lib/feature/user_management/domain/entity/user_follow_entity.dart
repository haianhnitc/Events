class UserFollowEntity {
  final int? followerId;
  final int? followingId;
  final DateTime? updatedTime;

  UserFollowEntity({
    this.followerId,
    this.followingId,
    this.updatedTime,
  });
}
