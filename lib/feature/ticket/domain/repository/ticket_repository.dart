import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/ticket/domain/entity/ticket_entity.dart';

abstract class TicketRepository {
  Future<Either<FailureEntity, List<TicketEntity>>> getMyTickets(int userId, {int page, int size});
  Future<Either<FailureEntity, TicketEntity>> getTicketById(int id);
  Future<Either<FailureEntity, TicketEntity>> updateTicketStatus(int ticketId, String status);
}