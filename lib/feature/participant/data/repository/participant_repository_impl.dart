import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/participant/data/datasource/participant_datasource.dart';
import 'package:events_app/feature/participant/data/model/participant_model.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';
import 'package:events_app/feature/participant/domain/repository/participant_repository.dart';
import 'package:events_app/feature/participant/domain/usecase/participant_usecase.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ParticipantRepository)
class ParticipantRepositoryImpl implements ParticipantRepository {
  final ParticipantDatasource _datasource;

  ParticipantRepositoryImpl(this._datasource);

  @override
  Future<Either<FailureEntity, List<ParticipantEntity>>> getMyParticipants(
      GetMyParticipantsParams params) async {
    final response = await _datasource.getMyParticipants(params.userId,
        page: params.page, size: params.size);
    return response.toEither().map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }

  @override
  Future<Either<FailureEntity, ParticipantEntity>> getParticipantById(
      int id) async {
    final response = await _datasource.getParticipantById(id);
    return response.toEitherNullable().map((m) => m.toEntity());
  }
}
