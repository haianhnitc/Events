import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/venue_entity.dart';

part 'venue_model.freezed.dart';
part 'venue_model.g.dart';

@freezed
class VenueModel with _$VenueModel {
  const factory VenueModel({
    int? venueId,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    String? mapUrl,
    @Default(0) int? capacity,
    DateTime? createdTime,
  }) = _VenueModel;

  factory VenueModel.fromJson(Map<String, dynamic> json) =>
      _$VenueModelFromJson(json);

  factory VenueModel.fromEntity(VenueEntity entity) {
    return VenueModel(
      venueId: entity.venueId,
      name: entity.name,
      address: entity.address,
      latitude: entity.latitude,
      longitude: entity.longitude,
      mapUrl: entity.mapUrl,
      capacity: entity.capacity,
      createdTime: entity.createdTime,
    );
  }
}

extension VenueModelExtension on VenueModel {
  VenueEntity toEntity() {
    return VenueEntity(
      venueId: venueId,
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      mapUrl: mapUrl,
      capacity: capacity,
      createdTime: createdTime,
    );
  }
}
