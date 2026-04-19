import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/event_management/domain/repository/event_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetFeaturedEventsUsecase
    implements UseCase<List<EventSummaryEntity>, void> {
  final EventRepository _repository;

  GetFeaturedEventsUsecase(this._repository);

  @override
  Future<Either<FailureEntity, List<EventSummaryEntity>>> call(
      [void params]) async {
    return await _repository.getFeaturedEvents();
  }
}
