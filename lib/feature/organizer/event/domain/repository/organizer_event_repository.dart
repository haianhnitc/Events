import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/event_management/domain/entity/event_entity.dart';
import 'package:events_app/feature/event_management/domain/entity/event_statistic_entity.dart';
import 'package:events_app/feature/event_management/domain/entity/event_analytics_entity.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/organizer/event/domain/usecase/event_params.dart';

abstract class OrganizerEventRepository {
  Future<Either<FailureEntity, ({List<EventSummaryEntity> items, int totalElements, int totalPages})>>
      getOrganizerEventList(OrganizerEventListParams params);
  Future<Either<FailureEntity, EventEntity>> createEvent(EventCreateParams params);
  Future<Either<FailureEntity, EventEntity>> updateEvent(int eventId, EventUpdateParams params);
  Future<Either<FailureEntity, Unit>> deleteEvent(int eventId);
  Future<Either<FailureEntity, EventEntity>> publishEvent(int eventId);
  Future<Either<FailureEntity, EventEntity>> getEventById(int eventId);
  Future<Either<FailureEntity, EventStatisticEntity>> getEventStatistics(int eventId);
  Future<Either<FailureEntity, EventAnalyticsEntity>> getEventAnalytics(int eventId);
  Future<Either<FailureEntity, Unit>> createEventCategoryOption(
      EventCategoryOptionCreateParams params);
  Future<Either<FailureEntity, Unit>> updateEventCategoryOption(
      int eventId, int categoryOptionId, EventCategoryOptionUpdateParams params);
  Future<Either<FailureEntity, Unit>> deleteEventCategoryOption(
      int eventId, int categoryOptionId);
}
