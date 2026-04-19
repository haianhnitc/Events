import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:events_app/feature/staff_application/domain/entity/staff_application_entity.dart';
import 'package:events_app/feature/staff_application/domain/repository/staff_application_repository.dart';
import 'package:events_app/feature/staff_application/domain/usecase/apply_ctv_params.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateStaffApplicationUsecase implements UseCase<StaffApplicationEntity, ApplyCtvParams> {
  final StaffApplicationRepository _repository;
  CreateStaffApplicationUsecase(this._repository);

  @override
  Future<Either<FailureEntity, StaffApplicationEntity>> call(ApplyCtvParams params) async {
    return await _repository.createApplication(params);
  }
}

@injectable
class GetStaffApplicationByIdUsecase implements UseCase<StaffApplicationEntity, int> {
  final StaffApplicationRepository _repository;
  GetStaffApplicationByIdUsecase(this._repository);

  @override
  Future<Either<FailureEntity, StaffApplicationEntity>> call(int id) async {
    return await _repository.getApplicationById(id);
  }
}