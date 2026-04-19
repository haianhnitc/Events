import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/ticket/data/datasource/ticket_datasource.dart';
import 'package:events_app/feature/ticket/data/model/ticket_model.dart';
import 'package:events_app/feature/ticket/domain/entity/ticket_entity.dart';
import 'package:events_app/feature/ticket/domain/repository/ticket_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: TicketRepository)
class TicketRepositoryImpl implements TicketRepository {
  final TicketDatasource _datasource;

  TicketRepositoryImpl(this._datasource);

  @override
  Future<Either<FailureEntity, List<TicketEntity>>> getMyTickets(
    int userId, {
    int page = 0,
    int size = 20,
  }) async {
    final response =
        await _datasource.getMyTickets(userId, page: page, size: size);
    return response.toEither().map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }

  @override
  Future<Either<FailureEntity, TicketEntity>> getTicketById(int id) async {
    final response = await _datasource.getTicketById(id);
    return response.toEitherNullable().map((m) => m.toEntity());
  }

  @override
  Future<Either<FailureEntity, TicketEntity>> updateTicketStatus(
    int ticketId,
    String status,
  ) async {
    final response = await _datasource.updateTicketStatus(ticketId, status);
    return response.toEitherNullable().map((m) => m.toEntity());
  }
}
