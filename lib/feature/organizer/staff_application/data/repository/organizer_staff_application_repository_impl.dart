import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/organizer/staff_application/data/datasource/organizer_staff_application_datasource.dart';
import 'package:events_app/feature/staff_application/data/model/staff_application_model.dart';
import 'package:events_app/feature/staff_application/domain/entity/staff_application_entity.dart';
import 'package:events_app/feature/organizer/staff_application/domain/repository/organizer_staff_application_repository.dart';
import 'package:events_app/feature/organizer/staff_application/domain/usecase/organizer_staff_application_params.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OrganizerStaffApplicationRepository)
class OrganizerStaffApplicationRepositoryImpl
    implements OrganizerStaffApplicationRepository {
  final OrganizerStaffApplicationDatasource _datasource;

  OrganizerStaffApplicationRepositoryImpl(this._datasource);

  @override
  Future<Either<FailureEntity, List<StaffApplicationEntity>>>
      getStaffApplications(GetOrganizerStaffApplicationsParams params) async {
    final response = await _datasource.getStaffApplications(
      eventId: params.eventId,
      keyword: params.keyword,
      status: params.status,
      page: params.page,
      size: params.size,
    );
    return response
        .toEither()
        .map((models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  Future<Either<FailureEntity, StaffApplicationEntity>> getStaffApplicationById(
      int id) async {
    final response = await _datasource.getStaffApplicationById(id);
    return response.toEitherNullable().map((m) => m.toEntity());
  }

  @override
  Future<Either<FailureEntity, StaffApplicationEntity>> approveStaffApplication(
      ApproveStaffApplicationParams params) async {
    final response = await _datasource.approveStaffApplication(params);
    return response.toEitherNullable().map((m) => m.toEntity());
  }
}
