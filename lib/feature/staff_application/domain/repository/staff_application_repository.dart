import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/staff_application/domain/entity/staff_application_entity.dart';
import 'package:events_app/feature/staff_application/domain/usecase/apply_ctv_params.dart';

abstract class StaffApplicationRepository {
  Future<Either<FailureEntity, StaffApplicationEntity>> createApplication(ApplyCtvParams params);
  Future<Either<FailureEntity, StaffApplicationEntity>> getApplicationById(int id);
}