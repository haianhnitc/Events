import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/user_management/domain/entity/user_summary_entity.dart';

class ParticipantEntity {
  final int? eventParticipantId;
  final int? eventId;
  final UserSummaryEntity? user;
  final String? participantQrContent;
  final DateTime? participantQrIssuedAt;
  final ParticipantType? participantType;
  final int? ticketId;
  final ParticipantStatus? status;
  final bool? hasCheckedIn;
  final DateTime? registeredTime;
  final DateTime? checkInTime;
  final bool? isCheckOut;
  final DateTime? checkOutTime;
  final bool? hasFeedback;
  final DateTime? feedbackSubmittedTime;
  final int? applicationId;
  final int? recruitmentId;
  final String? eventTitle;

  ParticipantEntity({
    this.eventParticipantId,
    this.eventId,
    this.user,
    this.participantQrContent,
    this.participantQrIssuedAt,
    this.participantType,
    this.ticketId,
    this.status,
    this.hasCheckedIn,
    this.registeredTime,
    this.checkInTime,
    this.isCheckOut,
    this.checkOutTime,
    this.hasFeedback,
    this.feedbackSubmittedTime,
    this.applicationId,
    this.recruitmentId,
    this.eventTitle,
  });

  ParticipantEntity copyWith({
    int? eventParticipantId,
    int? eventId,
    UserSummaryEntity? user,
    String? participantQrContent,
    DateTime? participantQrIssuedAt,
    ParticipantType? participantType,
    int? ticketId,
    ParticipantStatus? status,
    bool? hasCheckedIn,
    DateTime? registeredTime,
    DateTime? checkInTime,
    bool? isCheckOut,
    DateTime? checkOutTime,
    bool? hasFeedback,
    DateTime? feedbackSubmittedTime,
    int? applicationId,
    int? recruitmentId,
    String? eventTitle,
  }) {
    return ParticipantEntity(
      eventParticipantId: eventParticipantId ?? this.eventParticipantId,
      eventId: eventId ?? this.eventId,
      user: user ?? this.user,
      participantQrContent: participantQrContent ?? this.participantQrContent,
      participantQrIssuedAt:
          participantQrIssuedAt ?? this.participantQrIssuedAt,
      participantType: participantType ?? this.participantType,
      ticketId: ticketId ?? this.ticketId,
      status: status ?? this.status,
      hasCheckedIn: hasCheckedIn ?? this.hasCheckedIn,
      registeredTime: registeredTime ?? this.registeredTime,
      checkInTime: checkInTime ?? this.checkInTime,
      isCheckOut: isCheckOut ?? this.isCheckOut,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      hasFeedback: hasFeedback ?? this.hasFeedback,
      feedbackSubmittedTime:
          feedbackSubmittedTime ?? this.feedbackSubmittedTime,
      applicationId: applicationId ?? this.applicationId,
      recruitmentId: recruitmentId ?? this.recruitmentId,
      eventTitle: eventTitle ?? this.eventTitle,
    );
  }

  @override
  String toString() =>
      'ParticipantEntity(id: $eventParticipantId, user: ${user?.fullName}, type: $participantType)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ParticipantEntity &&
        other.eventParticipantId == eventParticipantId;
  }

  @override
  int get hashCode => Object.hash(eventParticipantId, user?.userId);
}
