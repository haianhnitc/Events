import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/recruitment/domain/entity/ctv_recruitment_entity.dart';
import 'package:events_app/feature/recruitment/domain/entity/requirement_question_entity.dart';
import 'package:events_app/feature/recruitment/domain/usecase/ctv_recruitment_usecase.dart';

abstract class CtvRecruitmentRepository {
  Future<Either<FailureEntity, List<CtvRecruitmentEntity>>> getRecruitments(
      GetRecruitmentsParams params);
  Future<Either<FailureEntity, CtvRecruitmentEntity>> getRecruitmentById(
      int id);
  Future<Either<FailureEntity, List<RequirementQuestionEntity>>>
      getRecruitmentQuestions(int recruitmentId);
}
