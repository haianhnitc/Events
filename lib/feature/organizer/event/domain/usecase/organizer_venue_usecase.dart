import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:events_app/feature/venue/domain/entity/venue_entity.dart';
import 'package:events_app/feature/organizer/event/domain/repository/organizer_venue_repository.dart';
import 'package:events_app/feature/organizer/event/domain/usecase/venue_params.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetOrganizerVenuesUsecase
    implements UseCase<({List<VenueEntity> items, int totalElements, int totalPages}), VenueListParams> {
  final OrganizerVenueRepository _repository;
  GetOrganizerVenuesUsecase(this._repository);

  @override
  Future<Either<FailureEntity, ({List<VenueEntity> items, int totalElements, int totalPages})>>
      call(VenueListParams params) async {
    return await _repository.getVenues(params);
  }
}

@injectable
class CreateOrganizerVenueUsecase
    implements UseCase<VenueEntity, VenueCreateParams> {
  final OrganizerVenueRepository _repository;
  CreateOrganizerVenueUsecase(this._repository);

  @override
  Future<Either<FailureEntity, VenueEntity>> call(VenueCreateParams params) async {
    return await _repository.createVenue(params);
  }
}
