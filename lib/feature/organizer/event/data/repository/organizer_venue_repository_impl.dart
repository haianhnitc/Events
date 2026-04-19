import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/venue/data/model/venue_model.dart';
import 'package:events_app/feature/venue/domain/entity/venue_entity.dart';
import 'package:events_app/feature/organizer/event/data/datasource/organizer_venue_datasource.dart';
import 'package:events_app/feature/organizer/event/domain/repository/organizer_venue_repository.dart';
import 'package:events_app/feature/organizer/event/domain/usecase/venue_params.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OrganizerVenueRepository)
class OrganizerVenueRepositoryImpl implements OrganizerVenueRepository {
  final OrganizerVenueDatasource _datasource;

  OrganizerVenueRepositoryImpl(this._datasource);

  @override
  Future<Either<FailureEntity, ({List<VenueEntity> items, int totalElements, int totalPages})>>
      getVenues(VenueListParams params) async {
    final response = await _datasource.getVenues(params);
    return response.toEitherNullable().map((page) => (
          items: page.content.map((m) => m.toEntity()).toList(),
          totalElements: page.totalElements,
          totalPages: page.totalPages,
        ));
  }

  @override
  Future<Either<FailureEntity, VenueEntity>> createVenue(VenueCreateParams params) async {
    final response = await _datasource.createVenue(params);
    return response.toEitherNullable().map((m) => m.toEntity());
  }
}
