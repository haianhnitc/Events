import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';
import 'package:events_app/feature/registration/domain/repository/registration_repository.dart';
import 'package:injectable/injectable.dart';

class CreateRegistrationParams {
  final int eventId;
  const CreateRegistrationParams({required this.eventId});

  Map<String, dynamic> toJson() => {'eventId': eventId};
}

@injectable
class CreateRegistrationUsecase implements UseCase<ParticipantEntity, CreateRegistrationParams> {
  final RegistrationRepository _repository;
  CreateRegistrationUsecase(this._repository);

  @override
  Future<Either<FailureEntity, ParticipantEntity>> call(CreateRegistrationParams params) async {
    return await _repository.createRegistration(params);
  }
}

class GetMyRegistrationsParams {
  final int userId;
  final int page;
  final int size;
  const GetMyRegistrationsParams({required this.userId, this.page = 0, this.size = 20});
}

@injectable
class GetMyRegistrationsUsecase implements UseCase<List<ParticipantEntity>, GetMyRegistrationsParams> {
  final RegistrationRepository _repository;
  GetMyRegistrationsUsecase(this._repository);

  @override
  Future<Either<FailureEntity, List<ParticipantEntity>>> call(GetMyRegistrationsParams params) async {
    return await _repository.getMyRegistrations(params.userId, page: params.page, size: params.size);
  }
}

@injectable
class GetRegistrationByIdUsecase implements UseCase<ParticipantEntity, int> {
  final RegistrationRepository _repository;
  GetRegistrationByIdUsecase(this._repository);

  @override
  Future<Either<FailureEntity, ParticipantEntity>> call(int id) async {
    return await _repository.getRegistrationById(id);
  }
}

@injectable
class CancelRegistrationUsecase implements UseCase<Unit, int> {
  final RegistrationRepository _repository;
  CancelRegistrationUsecase(this._repository);

  @override
  Future<Either<FailureEntity, Unit>> call(int id) async {
    return await _repository.cancelRegistration(id);
  }
}
