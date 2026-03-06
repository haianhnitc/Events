import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class EventParticipantEntity {
  final int? eventParticipantId;
  final int? eventId;
  final int? userId;
  final ParticipantType? participantType;
  final EventParticipantStatus? status;
  final int? ticketId;
  final int? eventStaffApplicationId;
  final bool? isCheckIn;
  final bool? isCheckOut;
  final bool? hasFeedback;
  final DateTime? createdTime;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final DateTime? feedbackSubmittedTime;

  EventParticipantEntity({
    this.eventParticipantId,
    this.eventId,
    this.userId,
    this.participantType,
    this.status,
    this.ticketId,
    this.eventStaffApplicationId,
    this.isCheckIn,
    this.isCheckOut,
    this.hasFeedback,
    this.createdTime,
    this.checkInTime,
    this.checkOutTime,
    this.feedbackSubmittedTime,
  });
}
