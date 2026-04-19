import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class CreateOrganizerParticipantParams {
  final int? eventId;
  final int? userId;
  final String? email;
  final ParticipantType participantType;

  const CreateOrganizerParticipantParams({
    required this.eventId,
    this.userId,
    this.email,
    required this.participantType,
  });

  Map<String, dynamic> toJson() => {
        if (eventId != null) 'eventId': eventId,
        if (userId != null) 'userId': userId,
        if (email != null && email!.isNotEmpty) 'email': email,
        'participantType': participantType.apiValue,
      };
}

class GetOrganizerParticipantsParams {
  final int? eventId;
  final String? participantType;
  final int page;
  final int size;

  const GetOrganizerParticipantsParams({
    this.eventId,
    this.participantType,
    this.page = 0,
    this.size = 20,
  });
}

class GetOrganizerTicketsParams {
  final int? eventId;
  final int page;
  final int size;

  const GetOrganizerTicketsParams({
    this.eventId,
    this.page = 0,
    this.size = 20,
  });
}