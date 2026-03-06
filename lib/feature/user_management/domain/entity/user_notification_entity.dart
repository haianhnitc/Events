class UserNotificationEntity {
  final int? userNotificationId;
  final int? userId;
  final int? notificationId;
  final bool? isRead;
  final bool? isDeleted;
  final DateTime? createdTime;
  final DateTime? deletedAt;

  UserNotificationEntity({
    this.userNotificationId,
    this.userId,
    this.notificationId,
    this.isRead,
    this.isDeleted,
    this.createdTime,
    this.deletedAt,
  });
}
