import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/user_management/domain/entity/organization_profile_entity.dart';
import 'package:events_app/feature/user_management/domain/entity/organization_dashboard_entity.dart';
import 'package:events_app/feature/organizer/organization/domain/usecase/organization_params.dart';

abstract class OrganizerOrganizationRepository {
  Future<Either<FailureEntity, OrganizationProfileEntity>> updateProfile(
      int organizationId, OrganizationProfileUpdateParams params);
  Future<Either<FailureEntity, OrganizationDashboardEntity>> getDashboard(
      int organizationId);
}
