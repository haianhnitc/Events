import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import '../../domain/entity/notification_entity.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required int notificationId,
    String? title,
    String? body,
    NotificationCreatedBy? createdBy,
    NotificationTargetType? targetType,
    int? targetId,
    String? deeplink,
    DateTime? createdTime,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      notificationId: entity.notificationId ?? 0,
      title: entity.title,
      body: entity.body,
      createdBy: entity.createdBy,
      targetType: entity.targetType,
      targetId: entity.targetId,
      deeplink: entity.deeplink,
      createdTime: entity.createdTime,
    );
  }
}

extension NotificationModelExtension on NotificationModel {
  NotificationEntity toEntity() {
    return NotificationEntity(
      notificationId: notificationId,
      title: title,
      body: body,
      createdBy: createdBy,
      targetType: targetType,
      targetId: targetId,
      deeplink: deeplink,
      createdTime: createdTime,
    );
  }
}
