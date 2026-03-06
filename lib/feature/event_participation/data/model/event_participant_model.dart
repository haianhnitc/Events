import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import '../../domain/entity/event_participant_entity.dart';

part 'event_participant_model.freezed.dart';
part 'event_participant_model.g.dart';

@freezed
class EventParticipantModel with _$EventParticipantModel {
  const factory EventParticipantModel({
    int? eventParticipantId,
    int? eventId,
    int? userId,
    int? ticketId,
    int? eventStaffApplicationId,
    ParticipantType? participantType,
    @Default(EventParticipantStatus.registered) EventParticipantStatus? status,
    @Default(false) bool? isCheckIn,
    DateTime? checkInTime,
    @Default(false) bool? isCheckOut,
    DateTime? checkOutTime,
    @Default(false) bool? hasFeedback,
    DateTime? feedbackSubmittedTime,
    DateTime? createdTime,
  }) = _EventParticipantModel;

  factory EventParticipantModel.fromJson(Map<String, dynamic> json) =>
      _$EventParticipantModelFromJson(json);

  factory EventParticipantModel.fromEntity(EventParticipantEntity entity) {
    return EventParticipantModel(
      eventParticipantId: entity.eventParticipantId,
      eventId: entity.eventId,
      userId: entity.userId,
      participantType: entity.participantType,
      status: entity.status,
      ticketId: entity.ticketId,
      eventStaffApplicationId: entity.eventStaffApplicationId,
      isCheckIn: entity.isCheckIn,
      isCheckOut: entity.isCheckOut,
      hasFeedback: entity.hasFeedback,
      createdTime: entity.createdTime,
      checkInTime: entity.checkInTime,
      checkOutTime: entity.checkOutTime,
      feedbackSubmittedTime: entity.feedbackSubmittedTime,
    );
  }
}

extension EventParticipantModelExtension on EventParticipantModel {
  EventParticipantEntity toEntity() {
    return EventParticipantEntity(
      eventParticipantId: eventParticipantId,
      eventId: eventId,
      userId: userId,
      participantType: participantType,
      status: status,
      ticketId: ticketId,
      eventStaffApplicationId: eventStaffApplicationId,
      isCheckIn: isCheckIn,
      isCheckOut: isCheckOut,
      hasFeedback: hasFeedback,
      createdTime: createdTime,
      checkInTime: checkInTime,
      checkOutTime: checkOutTime,
      feedbackSubmittedTime: feedbackSubmittedTime,
    );
  }
}
