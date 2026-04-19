import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';
import 'package:events_app/feature/registration/domain/usecase/registration_usecase.dart';

abstract class RegistrationRepository {
  Future<Either<FailureEntity, ParticipantEntity>> createRegistration(CreateRegistrationParams params);
  Future<Either<FailureEntity, List<ParticipantEntity>>> getMyRegistrations(int userId, {int page, int size});
  Future<Either<FailureEntity, ParticipantEntity>> getRegistrationById(int id);
  Future<Either<FailureEntity, Unit>> cancelRegistration(int id);
}
