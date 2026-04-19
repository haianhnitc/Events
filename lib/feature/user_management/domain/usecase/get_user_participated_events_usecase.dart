import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/user_management/domain/repository/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetUserParticipatedEventsUsecase
    implements UseCase<List<EventSummaryEntity>, GetUserParticipatedEventsParams> {
  final UserRepository _repository;
  GetUserParticipatedEventsUsecase(this._repository);

  @override
  Future<Either<FailureEntity, List<EventSummaryEntity>>> call(
      GetUserParticipatedEventsParams params) async {
    return await _repository.getUserParticipatedEvents(
      userId: params.userId,
      participantType: params.participantType,
      page: params.page,
      size: params.size,
    );
  }
}

class GetUserParticipatedEventsParams {
  final int userId;
  final String? participantType;
  final int page;
  final int size;

  const GetUserParticipatedEventsParams({
    required this.userId,
    this.participantType,
    this.page = 0,
    this.size = 20,
  });
}
