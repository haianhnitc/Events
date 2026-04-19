import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';
import 'package:events_app/feature/participant/domain/usecase/participant_usecase.dart';

abstract class ParticipantRepository {
  Future<Either<FailureEntity, List<ParticipantEntity>>> getMyParticipants(
      GetMyParticipantsParams params);
  Future<Either<FailureEntity, ParticipantEntity>> getParticipantById(int id);
}