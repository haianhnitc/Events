import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:events_app/feature/event_management/domain/entity/event_entity.dart';
import 'package:events_app/feature/event_management/domain/entity/event_statistic_entity.dart';
import 'package:events_app/feature/event_management/domain/entity/event_analytics_entity.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/organizer/event/domain/repository/organizer_event_repository.dart';
import 'package:events_app/feature/organizer/event/domain/usecase/event_params.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetOrganizerEventListUsecase
    implements UseCase<({List<EventSummaryEntity> items, int totalElements, int totalPages}), OrganizerEventListParams> {
  final OrganizerEventRepository _repository;
  GetOrganizerEventListUsecase(this._repository);

  @override
  Future<Either<FailureEntity, ({List<EventSummaryEntity> items, int totalElements, int totalPages})>>
      call(OrganizerEventListParams params) async {
    return await _repository.getOrganizerEventList(params);
  }
}

@injectable
class CreateOrganizerEventUsecase
    implements UseCase<EventEntity, EventCreateParams> {
  final OrganizerEventRepository _repository;
  CreateOrganizerEventUsecase(this._repository);

  @override
  Future<Either<FailureEntity, EventEntity>> call(EventCreateParams params) async {
    return await _repository.createEvent(params);
  }
}

@injectable
class UpdateOrganizerEventUsecase
    implements UseCase<EventEntity, UpdateOrganizerEventParams> {
  final OrganizerEventRepository _repository;
  UpdateOrganizerEventUsecase(this._repository);

  @override
  Future<Either<FailureEntity, EventEntity>> call(UpdateOrganizerEventParams params) async {
    return await _repository.updateEvent(params.eventId, params.params);
  }
}

class UpdateOrganizerEventParams {
  final int eventId;
  final EventUpdateParams params;
  const UpdateOrganizerEventParams({required this.eventId, required this.params});
}

@injectable
class DeleteOrganizerEventUsecase implements UseCase<Unit, int> {
  final OrganizerEventRepository _repository;
  DeleteOrganizerEventUsecase(this._repository);

  @override
  Future<Either<FailureEntity, Unit>> call(int eventId) async {
    return await _repository.deleteEvent(eventId);
  }
}

@injectable
class PublishOrganizerEventUsecase implements UseCase<EventEntity, int> {
  final OrganizerEventRepository _repository;
  PublishOrganizerEventUsecase(this._repository);

  @override
  Future<Either<FailureEntity, EventEntity>> call(int eventId) async {
    return await _repository.publishEvent(eventId);
  }
}

@injectable
class GetOrganizerEventByIdUsecase implements UseCase<EventEntity, int> {
  final OrganizerEventRepository _repository;
  GetOrganizerEventByIdUsecase(this._repository);

  @override
  Future<Either<FailureEntity, EventEntity>> call(int eventId) async {
    return await _repository.getEventById(eventId);
  }
}

@injectable
class GetOrganizerEventStatisticsUsecase
    implements UseCase<EventStatisticEntity, int> {
  final OrganizerEventRepository _repository;
  GetOrganizerEventStatisticsUsecase(this._repository);

  @override
  Future<Either<FailureEntity, EventStatisticEntity>> call(int eventId) async {
    return await _repository.getEventStatistics(eventId);
  }
}

@injectable
class GetOrganizerEventAnalyticsUsecase
    implements UseCase<EventAnalyticsEntity, int> {
  final OrganizerEventRepository _repository;
  GetOrganizerEventAnalyticsUsecase(this._repository);

  @override
  Future<Either<FailureEntity, EventAnalyticsEntity>> call(int eventId) async {
    return await _repository.getEventAnalytics(eventId);
  }
}

@injectable
class CreateOrganizerEventCategoryOptionUsecase
    implements UseCase<Unit, EventCategoryOptionCreateParams> {
  final OrganizerEventRepository _repository;
  CreateOrganizerEventCategoryOptionUsecase(this._repository);

  @override
  Future<Either<FailureEntity, Unit>> call(EventCategoryOptionCreateParams params) async {
    return await _repository.createEventCategoryOption(params);
  }
}

@injectable
class UpdateOrganizerEventCategoryOptionUsecase
    implements UseCase<Unit, UpdateOrganizerEventCategoryOptionParams> {
  final OrganizerEventRepository _repository;
  UpdateOrganizerEventCategoryOptionUsecase(this._repository);

  @override
  Future<Either<FailureEntity, Unit>> call(UpdateOrganizerEventCategoryOptionParams params) async {
    return await _repository.updateEventCategoryOption(
        params.eventId, params.categoryOptionId, params.params);
  }
}

class UpdateOrganizerEventCategoryOptionParams {
  final int eventId;
  final int categoryOptionId;
  final EventCategoryOptionUpdateParams params;
  const UpdateOrganizerEventCategoryOptionParams({
    required this.eventId,
    required this.categoryOptionId,
    required this.params,
  });
}

@injectable
class DeleteOrganizerEventCategoryOptionUsecase
    implements UseCase<Unit, DeleteOrganizerEventCategoryOptionParams> {
  final OrganizerEventRepository _repository;
  DeleteOrganizerEventCategoryOptionUsecase(this._repository);

  @override
  Future<Either<FailureEntity, Unit>> call(DeleteOrganizerEventCategoryOptionParams params) async {
    return await _repository.deleteEventCategoryOption(params.eventId, params.categoryOptionId);
  }
}

class DeleteOrganizerEventCategoryOptionParams {
  final int eventId;
  final int categoryOptionId;
  const DeleteOrganizerEventCategoryOptionParams({
    required this.eventId,
    required this.categoryOptionId,
  });
}
