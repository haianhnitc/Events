import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/organizer/participant/data/datasource/organizer_participant_datasource.dart';
import 'package:events_app/feature/participant/data/model/participant_model.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';
import 'package:events_app/feature/organizer/participant/domain/repository/organizer_participant_repository.dart';
import 'package:events_app/feature/organizer/participant/domain/usecase/organizer_participant_params.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OrganizerParticipantRepository)
class OrganizerParticipantRepositoryImpl
    implements OrganizerParticipantRepository {
  final OrganizerParticipantDatasource _datasource;

  OrganizerParticipantRepositoryImpl(this._datasource);

  @override
  Future<Either<FailureEntity, List<ParticipantEntity>>> getParticipants(
      GetOrganizerParticipantsParams params) async {
    final response = await _datasource.getParticipants(
      eventId: params.eventId,
      participantType: params.participantType,
      page: params.page,
      size: params.size,
    );
    return response
        .toEither()
        .map((models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  Future<Either<FailureEntity, ParticipantEntity>> getParticipantById(
      int id) async {
    final response = await _datasource.getParticipantById(id);
    return response.toEitherNullable().map((m) => m.toEntity());
  }

  @override
  Future<Either<FailureEntity, ParticipantEntity>> createParticipant(
      CreateOrganizerParticipantParams params) async {
    final response = await _datasource.createParticipant(params);
    return response.toEitherNullable().map((m) => m.toEntity());
  }

  @override
  Future<Either<FailureEntity, Unit>> deleteParticipant(int id) async {
    final response = await _datasource.deleteParticipant(id);
    return response.toEitherUnit();
  }

}
