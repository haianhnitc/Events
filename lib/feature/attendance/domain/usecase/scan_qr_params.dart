import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class ScanQrParams {
  final int? eventParticipantId;
  final String qrContent;
  final AttendanceAction action;
  final double? latitude;
  final double? longitude;

  const ScanQrParams({
    this.eventParticipantId,
    required this.qrContent,
    required this.action,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() => {
        'eventParticipantId': eventParticipantId,
        'qrContent': qrContent,
        'action': action.apiValue,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      };
}

class GetParticipantQrParams {
  final int eventParticipantId;
  const GetParticipantQrParams({required this.eventParticipantId});
}
