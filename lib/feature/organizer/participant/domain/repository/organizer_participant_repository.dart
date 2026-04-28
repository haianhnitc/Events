import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';
import 'package:events_app/feature/organizer/participant/domain/usecase/organizer_participant_params.dart';

abstract class OrganizerParticipantRepository {
  Future<Either<FailureEntity, List<ParticipantEntity>>> getParticipants(
      GetOrganizerParticipantsParams params);
  Future<Either<FailureEntity, ParticipantEntity>> getParticipantById(int id);
  Future<Either<FailureEntity, ParticipantEntity>> createParticipant(
      CreateOrganizerParticipantParams params);
  Future<Either<FailureEntity, Unit>> deleteParticipant(int id);
}