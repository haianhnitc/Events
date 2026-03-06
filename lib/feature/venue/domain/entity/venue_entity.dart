class VenueEntity {
  final int? venueId;
  final String? name;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? mapUrl;
  final int? capacity;
  final DateTime? createdTime;

  VenueEntity({
    this.venueId,
    this.name,
    this.address,
    this.latitude,
    this.longitude,
    this.mapUrl,
    this.capacity,
    this.createdTime,
  });
}
