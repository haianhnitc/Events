import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:events_app/feature/user_management/domain/entity/organization_profile_entity.dart';
import 'package:events_app/feature/user_management/domain/entity/organization_dashboard_entity.dart';
import 'package:events_app/feature/organizer/organization/domain/repository/organizer_organization_repository.dart';
import 'package:events_app/feature/organizer/organization/domain/usecase/organization_params.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateOrganizerProfileUsecase
    implements
        UseCase<OrganizationProfileEntity, UpdateOrganizerProfileParams> {
  final OrganizerOrganizationRepository _repository;
  UpdateOrganizerProfileUsecase(this._repository);

  @override
  Future<Either<FailureEntity, OrganizationProfileEntity>> call(
      UpdateOrganizerProfileParams params) async {
    return await _repository.updateProfile(
        params.organizationId, params.params);
  }
}

class UpdateOrganizerProfileParams {
  final int organizationId;
  final OrganizationProfileUpdateParams params;
  const UpdateOrganizerProfileParams({
    required this.organizationId,
    required this.params,
  });
}

@injectable
class GetOrganizerDashboardUsecase
    implements UseCase<OrganizationDashboardEntity, int> {
  final OrganizerOrganizationRepository _repository;
  GetOrganizerDashboardUsecase(this._repository);

  @override
  Future<Either<FailureEntity, OrganizationDashboardEntity>> call(
      int organizationId) async {
    return await _repository.getDashboard(organizationId);
  }
}
