import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/recruitment/data/datasource/ctv_recruitment_datasource.dart';
import 'package:events_app/feature/recruitment/data/model/ctv_recruitment_model.dart';
import 'package:events_app/feature/recruitment/domain/entity/ctv_recruitment_entity.dart';
import 'package:events_app/feature/recruitment/domain/repository/ctv_recruitment_repository.dart';
import 'package:events_app/feature/recruitment/domain/usecase/ctv_recruitment_usecase.dart';
import 'package:events_app/feature/recruitment/data/model/requirement_question_model.dart';
import 'package:events_app/feature/recruitment/domain/entity/requirement_question_entity.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CtvRecruitmentRepository)
class CtvRecruitmentRepositoryImpl implements CtvRecruitmentRepository {
  final CtvRecruitmentDatasource _datasource;

  CtvRecruitmentRepositoryImpl(this._datasource);

  @override
  Future<Either<FailureEntity, List<CtvRecruitmentEntity>>> getRecruitments(
      GetRecruitmentsParams params) async {
    final response = await _datasource.getRecruitments(
        eventId: params.eventId, page: params.page, size: params.size);
    return response.toEither().map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }

  @override
  Future<Either<FailureEntity, CtvRecruitmentEntity>> getRecruitmentById(
      int id) async {
    final response = await _datasource.getRecruitmentById(id);
    return response.toEitherNullable().map((m) => m.toEntity());
  }

  @override
  Future<Either<FailureEntity, List<RequirementQuestionEntity>>>
      getRecruitmentQuestions(int recruitmentId) async {
    final response = await _datasource.getRecruitmentQuestions(recruitmentId);
    return response.toEither().map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }
}
