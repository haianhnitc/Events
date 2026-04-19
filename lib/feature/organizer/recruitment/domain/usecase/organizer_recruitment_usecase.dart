import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:events_app/feature/recruitment/domain/entity/ctv_recruitment_entity.dart';
import 'package:events_app/feature/organizer/recruitment/domain/repository/organizer_recruitment_repository.dart';
import 'package:events_app/feature/organizer/recruitment/domain/usecase/organizer_recruitment_params.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetOrganizerRecruitmentsUsecase
    implements UseCase<List<CtvRecruitmentEntity>, GetOrganizerRecruitmentsParams> {
  final OrganizerRecruitmentRepository _repository;
  GetOrganizerRecruitmentsUsecase(this._repository);

  @override
  Future<Either<FailureEntity, List<CtvRecruitmentEntity>>> call(
      GetOrganizerRecruitmentsParams params) async {
    return await _repository.getRecruitments(
      eventId: params.eventId,
      keyword: params.keyword,
      page: params.page,
      size: params.size,
    );
  }
}

@injectable
class GetOrganizerRecruitmentByIdUsecase
    implements UseCase<CtvRecruitmentEntity, int> {
  final OrganizerRecruitmentRepository _repository;
  GetOrganizerRecruitmentByIdUsecase(this._repository);

  @override
  Future<Either<FailureEntity, CtvRecruitmentEntity>> call(int id) async {
    return await _repository.getRecruitmentById(id);
  }
}

@injectable
class CreateOrganizerRecruitmentUsecase
    implements UseCase<CtvRecruitmentEntity, CreateRecruitmentParams> {
  final OrganizerRecruitmentRepository _repository;
  CreateOrganizerRecruitmentUsecase(this._repository);

  @override
  Future<Either<FailureEntity, CtvRecruitmentEntity>> call(
      CreateRecruitmentParams params) async {
    return await _repository.createRecruitment(params);
  }
}

@injectable
class UpdateOrganizerRecruitmentUsecase
    implements UseCase<CtvRecruitmentEntity, UpdateRecruitmentParamsWrapper> {
  final OrganizerRecruitmentRepository _repository;
  UpdateOrganizerRecruitmentUsecase(this._repository);

  @override
  Future<Either<FailureEntity, CtvRecruitmentEntity>> call(
      UpdateRecruitmentParamsWrapper params) async {
    return await _repository.updateRecruitment(params.id, params.params);
  }
}

class UpdateRecruitmentParamsWrapper {
  final int id;
  final UpdateRecruitmentParams params;
  const UpdateRecruitmentParamsWrapper({required this.id, required this.params});
}

@injectable
class CloseOrganizerRecruitmentUsecase implements UseCase<Unit, int> {
  final OrganizerRecruitmentRepository _repository;
  CloseOrganizerRecruitmentUsecase(this._repository);

  @override
  Future<Either<FailureEntity, Unit>> call(int id) async {
    return await _repository.closeRecruitment(id);
  }
}

@injectable
class DeleteOrganizerRecruitmentUsecase implements UseCase<Unit, int> {
  final OrganizerRecruitmentRepository _repository;
  DeleteOrganizerRecruitmentUsecase(this._repository);

  @override
  Future<Either<FailureEntity, Unit>> call(int id) async {
    return await _repository.deleteRecruitment(id);
  }
}