import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/staff_application/domain/entity/staff_application_entity.dart';
import 'package:events_app/feature/organizer/staff_application/domain/usecase/organizer_staff_application_params.dart';

abstract class OrganizerStaffApplicationRepository {
  Future<Either<FailureEntity, List<StaffApplicationEntity>>> getStaffApplications(
      GetOrganizerStaffApplicationsParams params);
  Future<Either<FailureEntity, StaffApplicationEntity>> getStaffApplicationById(int id);
  Future<Either<FailureEntity, StaffApplicationEntity>> approveStaffApplication(
      ApproveStaffApplicationParams params);
}