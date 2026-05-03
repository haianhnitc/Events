import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/news/data/datasource/notification_datasource.dart';
import 'package:events_app/feature/news/data/model/notification_model.dart';
import 'package:events_app/feature/news/domain/entity/notification_entity.dart';
import 'package:events_app/feature/news/domain/repository/notification_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationDatasource _datasource;

  NotificationRepositoryImpl(this._datasource);

  @override
  Future<Either<FailureEntity, List<NotificationEntity>>> getNotificationList({
    int? page,
    int? size,
  }) async {
    final response = await _datasource.getNotificationList(page: page, size: size);
    return response.toEither().map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }

  @override
  Future<Either<FailureEntity, NotificationEntity>> getNotificationById(int id) async {
    final response = await _datasource.getNotificationById(id);
    return response.toEitherNullable().map((model) => model.toEntity());
  }

  @override
  Future<Either<FailureEntity, void>> markAsRead(int id) async {
    final response = await _datasource.markAsRead(id);
    return response.toEitherUnit();
  }

  @override
  Future<Either<FailureEntity, void>> markAllAsRead() async {
    final response = await _datasource.markAllAsRead();
    return response.toEitherUnit();
  }
}
