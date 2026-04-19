import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/venue/domain/entity/venue_entity.dart';
import 'package:events_app/feature/organizer/event/domain/usecase/venue_params.dart';

abstract class OrganizerVenueRepository {
  Future<Either<FailureEntity, ({List<VenueEntity> items, int totalElements, int totalPages})>>
      getVenues(VenueListParams params);
  Future<Either<FailureEntity, VenueEntity>> createVenue(VenueCreateParams params);
}
