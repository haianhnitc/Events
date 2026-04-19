import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/participant/data/model/participant_model.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';
import 'package:events_app/feature/registration/data/datasource/registration_datasource.dart';
import 'package:events_app/feature/registration/domain/repository/registration_repository.dart';
import 'package:events_app/feature/registration/domain/usecase/registration_usecase.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: RegistrationRepository)
class RegistrationRepositoryImpl implements RegistrationRepository {
  final RegistrationDatasource _datasource;

  RegistrationRepositoryImpl(this._datasource);

  @override
  Future<Either<FailureEntity, ParticipantEntity>> createRegistration(
      CreateRegistrationParams params) async {
    final response = await _datasource.createRegistration(params);
    return response.toEitherNullable().map((m) => m.toEntity());
  }

  @override
  Future<Either<FailureEntity, List<ParticipantEntity>>> getMyRegistrations(
    int userId, {
    int page = 0,
    int size = 20,
  }) async {
    final response =
        await _datasource.getMyRegistrations(userId, page: page, size: size);
    return response.toEither().map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }

  @override
  Future<Either<FailureEntity, ParticipantEntity>> getRegistrationById(
      int id) async {
    final response = await _datasource.getRegistrationById(id);
    return response.toEitherNullable().map((m) => m.toEntity());
  }

  @override
  Future<Either<FailureEntity, Unit>> cancelRegistration(int id) async {
    final response = await _datasource.cancelRegistration(id);
    return response.toEitherUnit();
  }
}
