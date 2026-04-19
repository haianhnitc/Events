import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/event_management/domain/entity/event_entity.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';

abstract class EventRepository {
  Future<Either<FailureEntity, List<EventSummaryEntity>>> getEvents({
    int? categoryId,
    int? status,
    int page,
    int size,
    String? keyword,
  });

  Future<Either<FailureEntity, EventEntity>> getEventById(int id);
}