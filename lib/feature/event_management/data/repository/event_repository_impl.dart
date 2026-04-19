import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/event_management/data/datasource/event_datasource.dart';
import 'package:events_app/feature/event_management/data/model/event_model.dart';
import 'package:events_app/feature/event_management/data/model/event_summary_model.dart';
import 'package:events_app/feature/event_management/domain/entity/event_entity.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/event_management/domain/repository/event_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: EventRepository)
class EventRepositoryImpl implements EventRepository {
  final EventDatasource _datasource;

  EventRepositoryImpl(this._datasource);

  @override
  Future<Either<FailureEntity, List<EventSummaryEntity>>> getEvents({
    int? categoryId,
    int? status,
    int page = 0,
    int size = 20,
    String? keyword,
  }) async {
    final response = await _datasource.getEvents(
      categoryId: categoryId,
      status: status,
      page: page,
      size: size,
      keyword: keyword,
    );
    return response.toEither().map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }

  @override
  Future<Either<FailureEntity, EventEntity>> getEventById(int id) async {
    final response = await _datasource.getEventById(id);
    return response.toEitherNullable().map((m) => m.toEntity());
  }
}
