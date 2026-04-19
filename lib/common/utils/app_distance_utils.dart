import 'dart:math' as math;


double calculateDistance({
  required double lat1,
  required double lng1,
  required double lat2,
  required double lng2,
}) {
  const earthRadius = 6371000.0;

  final dLat = _toRadians(lat2 - lat1);
  final dLng = _toRadians(lng2 - lng1);

  final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(_toRadians(lat1)) *
          math.cos(_toRadians(lat2)) *
          math.sin(dLng / 2) *
          math.sin(dLng / 2);

  final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

  return earthRadius * c;
}

double _toRadians(double degree) => degree * math.pi / 180;

bool isWithinRadius({
  required double userLat,
  required double userLng,
  required double targetLat,
  required double targetLng,
  double radiusMeters = 1000,
}) {
  final distance = calculateDistance(
    lat1: userLat,
    lng1: userLng,
    lat2: targetLat,
    lng2: targetLng,
  );
  return distance <= radiusMeters;
}
