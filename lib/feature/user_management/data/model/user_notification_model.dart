import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/user_notification_entity.dart';

part 'user_notification_model.freezed.dart';
part 'user_notification_model.g.dart';

@freezed
class UserNotificationModel with _$UserNotificationModel {
  const factory UserNotificationModel({
    int? userNotificationId,
    int? userId,
    int? notificationId,
    bool? isRead,
    bool? isDeleted,
    DateTime? createdTime,
    DateTime? deletedAt,
  }) = _UserNotificationModel;

  factory UserNotificationModel.fromJson(Map<String, dynamic> json) =>
      _$UserNotificationModelFromJson(json);

  factory UserNotificationModel.fromEntity(UserNotificationEntity entity) {
    return UserNotificationModel(
      userNotificationId: entity.userNotificationId,
      userId: entity.userId,
      notificationId: entity.notificationId,
      isRead: entity.isRead,
      isDeleted: entity.isDeleted,
      createdTime: entity.createdTime,
      deletedAt: entity.deletedAt,
    );
  }
}

extension UserNotificationModelExtension on UserNotificationModel {
  UserNotificationEntity toEntity() {
    return UserNotificationEntity(
      userNotificationId: userNotificationId,
      userId: userId,
      notificationId: notificationId,
      isRead: isRead,
      isDeleted: isDeleted,
      createdTime: createdTime,
      deletedAt: deletedAt,
    );
  }
}
