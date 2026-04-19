import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/event_management/data/model/event_summary_model.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/user_management/data/datasource/user_datasource.dart';
import 'package:events_app/feature/user_management/data/model/user_model.dart';
import 'package:events_app/feature/user_management/domain/entity/user_entity.dart';
import 'package:events_app/feature/user_management/domain/repository/user_repository.dart';
import 'package:events_app/feature/user_management/domain/usecase/update_current_user_usecase.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserDatasource _datasource;

  UserRepositoryImpl(this._datasource);

  @override
  Future<Either<FailureEntity, UserEntity?>> getCurrentUser() async {
    final response = await _datasource.getCurrentUser();
    return response.toEitherNullable().map((m) => m?.toEntity());
  }

  @override
  Future<Either<FailureEntity, UserEntity?>> updateCurrentUser(
      UpdateCurrentUserParams params) async {
    final response = await _datasource.updateCurrentUser(params);
    return response.toEitherNullable().map((m) => m?.toEntity());
  }

  @override
  Future<Either<FailureEntity, List<EventSummaryEntity>>> getUserParticipatedEvents({
    required int userId,
    String? participantType,
    int page = 0,
    int size = 20,
  }) async {
    final response = await _datasource.getUserParticipatedEvents(
      userId: userId,
      participantType: participantType,
      page: page,
      size: size,
    );
    return response.toEitherNullable().map((payload) {
      if (payload == null) return <EventSummaryEntity>[];
      final content = payload['content'] as List<dynamic>? ?? [];
      return content
          .map((e) => EventSummaryModel.fromJson(e as Map<String, dynamic>).toEntity())
          .toList();
    });
  }
}
