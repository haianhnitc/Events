import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:events_app/feature/ticket/domain/entity/ticket_entity.dart';
import 'package:events_app/feature/ticket/domain/repository/ticket_repository.dart';
import 'package:injectable/injectable.dart';

class GetMyTicketsParams {
  final int userId;
  final int page;
  final int size;
  const GetMyTicketsParams({required this.userId, this.page = 0, this.size = 20});
}

@injectable
class GetMyTicketsUsecase implements UseCase<List<TicketEntity>, GetMyTicketsParams> {
  final TicketRepository _repository;
  GetMyTicketsUsecase(this._repository);

  @override
  Future<Either<FailureEntity, List<TicketEntity>>> call(GetMyTicketsParams params) async {
    return await _repository.getMyTickets(params.userId, page: params.page, size: params.size);
  }
}

@injectable
class GetTicketByIdUsecase implements UseCase<TicketEntity, int> {
  final TicketRepository _repository;
  GetTicketByIdUsecase(this._repository);

  @override
  Future<Either<FailureEntity, TicketEntity>> call(int id) async {
    return await _repository.getTicketById(id);
  }
}

class UpdateTicketStatusParams {
  final int ticketId;
  final String status;
  const UpdateTicketStatusParams({required this.ticketId, required this.status});
}

@injectable
class UpdateTicketStatusUsecase implements UseCase<TicketEntity, UpdateTicketStatusParams> {
  final TicketRepository _repository;
  UpdateTicketStatusUsecase(this._repository);

  @override
  Future<Either<FailureEntity, TicketEntity>> call(UpdateTicketStatusParams params) async {
    return await _repository.updateTicketStatus(params.ticketId, params.status);
  }
}