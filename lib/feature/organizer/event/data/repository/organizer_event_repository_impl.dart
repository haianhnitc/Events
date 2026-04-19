import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/event_management/data/model/event_analytics_model.dart';
import 'package:events_app/feature/event_management/data/model/event_model.dart';
import 'package:events_app/feature/event_management/data/model/event_summary_model.dart';
import 'package:events_app/feature/event_management/domain/entity/event_entity.dart';
import 'package:events_app/feature/event_management/domain/entity/event_analytics_entity.dart';
import 'package:events_app/feature/event_management/domain/entity/event_statistic_entity.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/event_management/data/model/event_statistic_model.dart';
import 'package:events_app/feature/organizer/event/data/datasource/organizer_event_datasource.dart';
import 'package:events_app/feature/organizer/event/domain/repository/organizer_event_repository.dart';
import 'package:events_app/feature/organizer/event/domain/usecase/event_params.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OrganizerEventRepository)
class OrganizerEventRepositoryImpl implements OrganizerEventRepository {
  final OrganizerEventDatasource _datasource;

  OrganizerEventRepositoryImpl(this._datasource);

  @override
  Future<Either<FailureEntity, ({List<EventSummaryEntity> items, int totalElements, int totalPages})>>
      getOrganizerEventList(OrganizerEventListParams params) async {
    final response = await _datasource.getOrganizerEvents(params);
    return response.toEitherNullable().map((page) => (
          items: page.content.map((m) => m.toEntity()).toList(),
          totalElements: page.totalElements,
          totalPages: page.totalPages,
        ));
  }

  @override
  Future<Either<FailureEntity, EventEntity>> createEvent(
      EventCreateParams params) async {
    final response = await _datasource.createEvent(params);
    return response.toEitherNullable().map((m) => m.toEntity());
  }

  @override
  Future<Either<FailureEntity, EventEntity>> updateEvent(
      int eventId, EventUpdateParams params) async {
    final response = await _datasource.updateEvent(eventId, params);
    return response.toEitherNullable().map((m) => m.toEntity());
  }

  @override
  Future<Either<FailureEntity, Unit>> deleteEvent(int eventId) async {
    final response = await _datasource.deleteEvent(eventId);
    return response.toEitherUnit();
  }

  @override
  Future<Either<FailureEntity, EventEntity>> publishEvent(int eventId) async {
    final response = await _datasource.publishEvent(eventId);
    return response.toEitherNullable().map((m) => m.toEntity());
  }

  @override
  Future<Either<FailureEntity, EventEntity>> getEventById(int eventId) async {
    final response = await _datasource.getEventById(eventId);
    return response.toEitherNullable().map((m) => m.toEntity());
  }

  @override
  Future<Either<FailureEntity, EventStatisticEntity>> getEventStatistics(
      int eventId) async {
    final response = await _datasource.getEventStatistics(eventId);
    return response.toEitherNullable().map((payload) {
      return EventStatisticModel.fromJson(payload ?? {}).toEntity();
    });
  }

  @override
  Future<Either<FailureEntity, EventAnalyticsEntity>> getEventAnalytics(
      int eventId) async {
    final response = await _datasource.getEventAnalytics(eventId);
    return response.toEitherNullable().map((m) => m.toEntity());
  }

  @override
  Future<Either<FailureEntity, Unit>> createEventCategoryOption(
      EventCategoryOptionCreateParams params) async {
    final response = await _datasource.createEventCategoryOption(params);
    return response.toEitherUnit();
  }

  @override
  Future<Either<FailureEntity, Unit>> updateEventCategoryOption(int eventId,
      int categoryOptionId, EventCategoryOptionUpdateParams params) async {
    final response = await _datasource.updateEventCategoryOption(
        eventId, categoryOptionId, params);
    return response.toEitherUnit();
  }

  @override
  Future<Either<FailureEntity, Unit>> deleteEventCategoryOption(
      int eventId, int categoryOptionId) async {
    final response =
        await _datasource.deleteEventCategoryOption(eventId, categoryOptionId);
    return response.toEitherUnit();
  }
}
