import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class VenueListParams {
  final int page;
  final int size;

  const VenueListParams({
    this.page = 0,
    this.size = 20,
  });
}

class VenueCreateParams {
  final String? name;
  final String? address;
  final int? capacity;
  final double? latitude;
  final double? longitude;
  final String? mapUrl;

  const VenueCreateParams({
    this.name,
    this.address,
    this.capacity,
    this.latitude,
    this.longitude,
    this.mapUrl,
  });

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (address != null) 'address': address,
        if (capacity != null) 'capacity': capacity,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (mapUrl != null) 'mapUrl': mapUrl,
      };
}
