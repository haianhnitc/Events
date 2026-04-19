import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:events_app/feature/event_management/domain/entity/event_entity.dart';
import 'package:events_app/feature/event_management/domain/repository/event_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetEventByIdUsecase implements UseCase<EventEntity, int> {
  final EventRepository _repository;

  GetEventByIdUsecase(this._repository);

  @override
  Future<Either<FailureEntity, EventEntity>> call(int id) async {
    return await _repository.getEventById(id);
  }
}