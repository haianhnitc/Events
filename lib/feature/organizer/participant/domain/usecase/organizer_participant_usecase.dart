import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';
import 'package:events_app/feature/ticket/domain/entity/ticket_entity.dart';
import 'package:events_app/feature/organizer/participant/domain/repository/organizer_participant_repository.dart';
import 'package:events_app/feature/organizer/participant/domain/usecase/organizer_participant_params.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetOrganizerParticipantsUsecase
    implements UseCase<List<ParticipantEntity>, GetOrganizerParticipantsParams> {
  final OrganizerParticipantRepository _repository;
  GetOrganizerParticipantsUsecase(this._repository);

  @override
  Future<Either<FailureEntity, List<ParticipantEntity>>> call(
      GetOrganizerParticipantsParams params) async {
    return await _repository.getParticipants(params);
  }
}

@injectable
class GetOrganizerParticipantByIdUsecase
    implements UseCase<ParticipantEntity, int> {
  final OrganizerParticipantRepository _repository;
  GetOrganizerParticipantByIdUsecase(this._repository);

  @override
  Future<Either<FailureEntity, ParticipantEntity>> call(int id) async {
    return await _repository.getParticipantById(id);
  }
}

@injectable
class CreateOrganizerParticipantUsecase
    implements UseCase<ParticipantEntity, CreateOrganizerParticipantParams> {
  final OrganizerParticipantRepository _repository;
  CreateOrganizerParticipantUsecase(this._repository);

  @override
  Future<Either<FailureEntity, ParticipantEntity>> call(
      CreateOrganizerParticipantParams params) async {
    return await _repository.createParticipant(params);
  }
}

@injectable
class DeleteOrganizerParticipantUsecase implements UseCase<Unit, int> {
  final OrganizerParticipantRepository _repository;
  DeleteOrganizerParticipantUsecase(this._repository);

  @override
  Future<Either<FailureEntity, Unit>> call(int id) async {
    return await _repository.deleteParticipant(id);
  }
}

@injectable
class GetOrganizerTicketsUsecase
    implements UseCase<List<TicketEntity>, GetOrganizerTicketsParams> {
  final OrganizerParticipantRepository _repository;
  GetOrganizerTicketsUsecase(this._repository);

  @override
  Future<Either<FailureEntity, List<TicketEntity>>> call(
      GetOrganizerTicketsParams params) async {
    return await _repository.getTickets(params);
  }
}