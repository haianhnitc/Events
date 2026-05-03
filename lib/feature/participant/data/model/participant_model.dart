import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/user_management/data/model/user_summary_model.dart';

part 'participant_model.freezed.dart';
part 'participant_model.g.dart';

@freezed
class ParticipantModel with _$ParticipantModel {
  const factory ParticipantModel({
    int? eventParticipantId,
    int? eventId,
    UserSummaryModel? user,
    String? participantQrContent,
    DateTime? participantQrIssuedAt,
    ParticipantType? participantType,
    int? ticketId,
    ParticipantStatus? status,
    bool? hasCheckedIn,
    DateTime? registeredTime,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    bool? isCheckOut,
    bool? hasFeedback,
    DateTime? feedbackSubmittedTime,
    int? applicationId,
    int? recruitmentId,
    String? eventTitle,
  }) = _ParticipantModel;

  factory ParticipantModel.fromJson(Map<String, dynamic> json) =>
      _$ParticipantModelFromJson(json);

  factory ParticipantModel.fromEntity(ParticipantEntity entity) {
    return ParticipantModel(
      eventParticipantId: entity.eventParticipantId,
      eventId: entity.eventId,
      user: entity.user != null
          ? UserSummaryModel.fromEntity(entity.user!)
          : null,
      participantQrContent: entity.participantQrContent,
      participantQrIssuedAt: entity.participantQrIssuedAt,
      participantType: entity.participantType,
      ticketId: entity.ticketId,
      status: entity.status,
      hasCheckedIn: entity.hasCheckedIn,
      registeredTime: entity.registeredTime,
      checkInTime: entity.checkInTime,
      checkOutTime: entity.checkOutTime,
      isCheckOut: entity.isCheckOut,
      hasFeedback: entity.hasFeedback,
      feedbackSubmittedTime: entity.feedbackSubmittedTime,
      applicationId: entity.applicationId,
      recruitmentId: entity.recruitmentId,
      eventTitle: entity.eventTitle,
    );
  }
}

extension ParticipantModelExtension on ParticipantModel {
  ParticipantEntity toEntity() {
    return ParticipantEntity(
      eventParticipantId: eventParticipantId,
      eventId: eventId,
      user: user?.toEntity(),
      participantQrContent: participantQrContent,
      participantQrIssuedAt: participantQrIssuedAt,
      participantType: participantType,
      ticketId: ticketId,
      status: status,
      hasCheckedIn: hasCheckedIn,
      registeredTime: registeredTime,
      checkInTime: checkInTime,
      checkOutTime: checkOutTime,
      isCheckOut: isCheckOut,
      hasFeedback: hasFeedback,
      feedbackSubmittedTime: feedbackSubmittedTime,
      applicationId: applicationId,
      recruitmentId: recruitmentId,
      eventTitle: eventTitle,
    );
  }
}
