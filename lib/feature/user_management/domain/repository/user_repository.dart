import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/user_management/domain/entity/user_entity.dart';
import 'package:events_app/feature/user_management/domain/usecase/update_current_user_usecase.dart';

abstract class UserRepository {
  Future<Either<FailureEntity, UserEntity?>> getCurrentUser();

  Future<Either<FailureEntity, UserEntity?>> updateCurrentUser(
      UpdateCurrentUserParams params);

  Future<Either<FailureEntity, List<EventSummaryEntity>>> getUserParticipatedEvents({
    required int userId,
    String? participantType,
    int page = 0,
    int size = 20,
  });
}
