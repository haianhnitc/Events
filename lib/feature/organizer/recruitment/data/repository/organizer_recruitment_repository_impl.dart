import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/organizer/recruitment/data/datasource/organizer_recruitment_datasource.dart';
import 'package:events_app/feature/recruitment/data/model/ctv_recruitment_model.dart';
import 'package:events_app/feature/recruitment/domain/entity/ctv_recruitment_entity.dart';
import 'package:events_app/feature/organizer/recruitment/domain/repository/organizer_recruitment_repository.dart';
import 'package:events_app/feature/organizer/recruitment/domain/usecase/organizer_recruitment_params.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OrganizerRecruitmentRepository)
class OrganizerRecruitmentRepositoryImpl
    implements OrganizerRecruitmentRepository {
  final OrganizerRecruitmentDatasource _datasource;

  OrganizerRecruitmentRepositoryImpl(this._datasource);

  @override
  Future<Either<FailureEntity, List<CtvRecruitmentEntity>>> getRecruitments({
    int? eventId,
    String? keyword,
    int page = 0,
    int size = 20,
  }) async {
    final response = await _datasource.getRecruitments(
        eventId: eventId, keyword: keyword, page: page, size: size);
    return response
        .toEither()
        .map((models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  Future<Either<FailureEntity, CtvRecruitmentEntity>> getRecruitmentById(
      int id) async {
    final response = await _datasource.getRecruitmentById(id);
    return response.toEitherNullable().map((m) => m.toEntity());
  }

  @override
  Future<Either<FailureEntity, CtvRecruitmentEntity>> createRecruitment(
    CreateRecruitmentParams params,
  ) async {
    final response = await _datasource.createRecruitment(params);
    return response.toEitherNullable().map((m) => m.toEntity());
  }

  @override
  Future<Either<FailureEntity, CtvRecruitmentEntity>> updateRecruitment(
    int id,
    UpdateRecruitmentParams params,
  ) async {
    final response = await _datasource.updateRecruitment(id, params);
    return response.toEitherNullable().map((m) => m.toEntity());
  }

  @override
  Future<Either<FailureEntity, Unit>> closeRecruitment(int id) async {
    final response = await _datasource.closeRecruitment(id);
    return response.toEitherUnit();
  }

  @override
  Future<Either<FailureEntity, Unit>> deleteRecruitment(int id) async {
    final response = await _datasource.deleteRecruitment(id);
    return response.toEitherUnit();
  }
}
