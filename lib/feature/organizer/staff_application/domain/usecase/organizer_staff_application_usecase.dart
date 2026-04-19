import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:events_app/feature/staff_application/domain/entity/staff_application_entity.dart';
import 'package:events_app/feature/organizer/staff_application/domain/repository/organizer_staff_application_repository.dart';
import 'package:events_app/feature/organizer/staff_application/domain/usecase/organizer_staff_application_params.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetOrganizerStaffApplicationsUsecase
    implements UseCase<List<StaffApplicationEntity>, GetOrganizerStaffApplicationsParams> {
  final OrganizerStaffApplicationRepository _repository;
  GetOrganizerStaffApplicationsUsecase(this._repository);

  @override
  Future<Either<FailureEntity, List<StaffApplicationEntity>>> call(
      GetOrganizerStaffApplicationsParams params) async {
    return await _repository.getStaffApplications(params);
  }
}

@injectable
class GetOrganizerStaffApplicationByIdUsecase
    implements UseCase<StaffApplicationEntity, int> {
  final OrganizerStaffApplicationRepository _repository;
  GetOrganizerStaffApplicationByIdUsecase(this._repository);

  @override
  Future<Either<FailureEntity, StaffApplicationEntity>> call(int id) async {
    return await _repository.getStaffApplicationById(id);
  }
}

@injectable
class ApproveStaffApplicationUsecase
    implements UseCase<StaffApplicationEntity, ApproveStaffApplicationParams> {
  final OrganizerStaffApplicationRepository _repository;
  ApproveStaffApplicationUsecase(this._repository);

  @override
  Future<Either<FailureEntity, StaffApplicationEntity>> call(
      ApproveStaffApplicationParams params) async {
    return await _repository.approveStaffApplication(params);
  }
}