import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/news/domain/entity/notification_entity.dart';

abstract class NotificationRepository {
  Future<Either<FailureEntity, List<NotificationEntity>>> getNotificationList({
    int? page,
    int? size,
  });
  Future<Either<FailureEntity, NotificationEntity>> getNotificationById(int id);
  Future<Either<FailureEntity, void>> markAsRead(int id);
  Future<Either<FailureEntity, void>> markAllAsRead();
}
