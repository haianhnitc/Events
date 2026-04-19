import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/event_management/domain/repository/event_repository.dart';
import 'package:injectable/injectable.dart';

class GetEventsParams {
  final int? categoryId;
  final int? status;
  final int page;
  final int size;
  final String? keyword;

  const GetEventsParams({
    this.categoryId,
    this.status,
    this.page = 0,
    this.size = 20,
    this.keyword,
  });
}

@injectable
class GetEventsUsecase implements UseCase<List<EventSummaryEntity>, GetEventsParams> {
  final EventRepository _repository;

  GetEventsUsecase(this._repository);

  @override
  Future<Either<FailureEntity, List<EventSummaryEntity>>> call(GetEventsParams params) async {
    return await _repository.getEvents(
      categoryId: params.categoryId,
      status: params.status,
      page: params.page,
      size: params.size,
      keyword: params.keyword,
    );
  }
}