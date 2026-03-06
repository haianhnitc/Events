class AttendanceFeedbackEntity {
  final int? attendanceFeedbackId;
  final int? eventParticipantId;
  final String? comment;
  final DateTime? createdTime;

  AttendanceFeedbackEntity({
    this.attendanceFeedbackId,
    this.eventParticipantId,
    this.comment,
    this.createdTime,
  });
}
