import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/recruitment/domain/entity/ctv_recruitment_entity.dart';
import 'package:events_app/feature/organizer/recruitment/domain/usecase/organizer_recruitment_params.dart';

abstract class OrganizerRecruitmentRepository {
  Future<Either<FailureEntity, List<CtvRecruitmentEntity>>> getRecruitments({
    int? eventId, String? keyword, int page, int size,
  });
  Future<Either<FailureEntity, CtvRecruitmentEntity>> getRecruitmentById(int id);
  Future<Either<FailureEntity, CtvRecruitmentEntity>> createRecruitment(CreateRecruitmentParams params);
  Future<Either<FailureEntity, CtvRecruitmentEntity>> updateRecruitment(int id, UpdateRecruitmentParams params);
  Future<Either<FailureEntity, Unit>> closeRecruitment(int id);
  Future<Either<FailureEntity, Unit>> deleteRecruitment(int id);
}