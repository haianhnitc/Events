import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class OrganizerManualAttendanceParams {
  final int eventParticipantId;

  const OrganizerManualAttendanceParams({required this.eventParticipantId});

  Map<String, dynamic> toJson() => {'eventParticipantId': eventParticipantId};
}

class GetOrganizerAttendanceLogsParams {
  final int? eventId;
  final int page;
  final int size;

  const GetOrganizerAttendanceLogsParams({
    this.eventId,
    this.page = 0,
    this.size = 20,
  });
}

class GetOrganizerEventQrParams {
  final int eventId;
  final String action;

  const GetOrganizerEventQrParams({required this.eventId, required this.action});
}
