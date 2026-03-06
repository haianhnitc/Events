import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class NotificationEntity {
  final int? notificationId;
  final String? title;
  final String? body;
  final NotificationCreatedBy? createdBy;
  final NotificationTargetType? targetType;
  final int? targetId;
  final String? deeplink;
  final DateTime? createdTime;

  NotificationEntity({
    this.notificationId,
    this.title,
    this.body,
    this.createdBy,
    this.targetType,
    this.targetId,
    this.deeplink,
    this.createdTime,
  });
}
