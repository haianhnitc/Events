import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';
import 'package:events_app/feature/participant/domain/repository/participant_repository.dart';
import 'package:injectable/injectable.dart';

class GetMyParticipantsParams {
  final int userId;
  final int page;
  final int size;
  const GetMyParticipantsParams({required this.userId, this.page = 0, this.size = 20});
}

@injectable
class GetMyParticipantsUsecase implements UseCase<List<ParticipantEntity>, GetMyParticipantsParams> {
  final ParticipantRepository _repository;
  GetMyParticipantsUsecase(this._repository);

  @override
  Future<Either<FailureEntity, List<ParticipantEntity>>> call(GetMyParticipantsParams params) async {
    return await _repository.getMyParticipants(params);
  }
}

@injectable
class GetParticipantByIdUsecase implements UseCase<ParticipantEntity, int> {
  final ParticipantRepository _repository;
  GetParticipantByIdUsecase(this._repository);

  @override
  Future<Either<FailureEntity, ParticipantEntity>> call(int id) async {
    return await _repository.getParticipantById(id);
  }
}