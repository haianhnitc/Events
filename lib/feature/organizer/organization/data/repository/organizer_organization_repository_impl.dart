import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/user_management/data/model/organization_profile_model.dart';
import 'package:events_app/feature/user_management/data/model/organization_dashboard_model.dart';
import 'package:events_app/feature/user_management/domain/entity/organization_profile_entity.dart';
import 'package:events_app/feature/user_management/domain/entity/organization_dashboard_entity.dart';
import 'package:events_app/feature/organizer/organization/data/datasource/organizer_organization_datasource.dart';
import 'package:events_app/feature/organizer/organization/domain/repository/organizer_organization_repository.dart';
import 'package:events_app/feature/organizer/organization/domain/usecase/organization_params.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OrganizerOrganizationRepository)
class OrganizerOrganizationRepositoryImpl implements OrganizerOrganizationRepository {
  final OrganizerOrganizationDatasource _datasource;

  OrganizerOrganizationRepositoryImpl(this._datasource);

  @override
  Future<Either<FailureEntity, OrganizationProfileEntity>> updateProfile(
      int organizationId, OrganizationProfileUpdateParams params) async {
    final response = await _datasource.updateProfile(organizationId, params);
    return response.toEitherNullable().map((m) => m.toEntity());
  }

  @override
  Future<Either<FailureEntity, OrganizationDashboardEntity>> getDashboard() async {
    final response = await _datasource.getDashboard();
    return response.toEitherNullable().map((m) => m.toEntity());
  }
}
