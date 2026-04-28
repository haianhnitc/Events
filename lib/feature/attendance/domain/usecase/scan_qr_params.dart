class ScanQrParams {
  final int? eventParticipantId;
  final String qrContent;
  final double? latitude;
  final double? longitude;

  const ScanQrParams({
    this.eventParticipantId,
    required this.qrContent,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() => {
        'eventParticipantId': eventParticipantId,
        'qrContent': qrContent,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      };
}

class GetParticipantQrParams {
  final int eventParticipantId;
  const GetParticipantQrParams({required this.eventParticipantId});
}

class GetEventQrParams {
  final int eventId;
  final String action;
  const GetEventQrParams({required this.eventId, required this.action});
}
