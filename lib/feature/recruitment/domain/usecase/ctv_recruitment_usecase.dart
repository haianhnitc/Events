import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:events_app/feature/recruitment/domain/entity/ctv_recruitment_entity.dart';
import 'package:events_app/feature/recruitment/domain/entity/requirement_question_entity.dart';
import 'package:events_app/feature/recruitment/domain/repository/ctv_recruitment_repository.dart';
import 'package:injectable/injectable.dart';

class GetRecruitmentsParams {
  final int? eventId;
  final int page;
  final int size;
  const GetRecruitmentsParams({this.eventId, this.page = 0, this.size = 20});
}

@injectable
class GetRecruitmentsUsecase
    implements UseCase<List<CtvRecruitmentEntity>, GetRecruitmentsParams> {
  final CtvRecruitmentRepository _repository;
  GetRecruitmentsUsecase(this._repository);

  @override
  Future<Either<FailureEntity, List<CtvRecruitmentEntity>>> call(
      GetRecruitmentsParams params) async {
    return await _repository.getRecruitments(params);
  }
}

@injectable
class GetRecruitmentByIdUsecase implements UseCase<CtvRecruitmentEntity, int> {
  final CtvRecruitmentRepository _repository;
  GetRecruitmentByIdUsecase(this._repository);

  @override
  Future<Either<FailureEntity, CtvRecruitmentEntity>> call(int id) async {
    return await _repository.getRecruitmentById(id);
  }
}

@injectable
class GetRecruitmentQuestionsUsecase
    implements UseCase<List<RequirementQuestionEntity>, int> {
  final CtvRecruitmentRepository _repository;
  GetRecruitmentQuestionsUsecase(this._repository);

  @override
  Future<Either<FailureEntity, List<RequirementQuestionEntity>>> call(
      int recruitmentId) async {
    return await _repository.getRecruitmentQuestions(recruitmentId);
  }
}
