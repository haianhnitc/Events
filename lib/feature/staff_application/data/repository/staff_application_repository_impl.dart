import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/staff_application/data/datasource/staff_application_datasource.dart';
import 'package:events_app/feature/staff_application/data/model/staff_application_model.dart';
import 'package:events_app/feature/staff_application/domain/entity/staff_application_entity.dart';
import 'package:events_app/feature/staff_application/domain/repository/staff_application_repository.dart';
import 'package:events_app/feature/staff_application/domain/usecase/apply_ctv_params.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: StaffApplicationRepository)
class StaffApplicationRepositoryImpl implements StaffApplicationRepository {
  final StaffApplicationDatasource _datasource;

  StaffApplicationRepositoryImpl(this._datasource);

  @override
  Future<Either<FailureEntity, StaffApplicationEntity>> createApplication(
    ApplyCtvParams params,
  ) async {
    final response = await _datasource.createApplication(params);
    return response.toEitherNullable().map((m) => m.toEntity());
  }

  @override
  Future<Either<FailureEntity, StaffApplicationEntity>> getApplicationById(
      int id) async {
    final response = await _datasource.getApplicationById(id);
    return response.toEitherNullable().map((m) => m.toEntity());
  }
}
