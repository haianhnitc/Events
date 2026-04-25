import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:events_app/feature/news/domain/entity/notification_entity.dart';
import 'package:events_app/feature/news/domain/repository/notification_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetNotificationListUsecase implements UseCase<List<NotificationEntity>, GetNotificationListParams> {
  final NotificationRepository _repository;

  GetNotificationListUsecase(this._repository);

  @override
  Future<Either<FailureEntity, List<NotificationEntity>>> call(GetNotificationListParams params) async {
    return await _repository.getNotificationList(
      page: params.page,
      size: params.size,
    );
  }
}

class GetNotificationListParams {
  final int? page;
  final int? size;

  const GetNotificationListParams({this.page, this.size});
}

@injectable
class GetNotificationByIdUsecase implements UseCase<NotificationEntity, int> {
  final NotificationRepository _repository;

  GetNotificationByIdUsecase(this._repository);

  @override
  Future<Either<FailureEntity, NotificationEntity>> call(int id) async {
    return await _repository.getNotificationById(id);
  }
}

@injectable
class MarkNotificationAsReadUsecase implements UseCase<void, int> {
  final NotificationRepository _repository;

  MarkNotificationAsReadUsecase(this._repository);

  @override
  Future<Either<FailureEntity, void>> call(int id) async {
    return await _repository.markAsRead(id);
  }
}

@injectable
class MarkAllNotificationsAsReadUsecase implements UseCase<void, void> {
  final NotificationRepository _repository;

  MarkAllNotificationsAsReadUsecase(this._repository);

  @override
  Future<Either<FailureEntity, void>> call(void _) async {
    return await _repository.markAllAsRead();
  }
}
