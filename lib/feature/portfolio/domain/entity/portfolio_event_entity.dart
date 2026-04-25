class PortfolioEventEntity {
  final int? portfolioItemId;
  final int? eventId;
  final String? eventTitle;
  final String? eventBanner;
  final DateTime? eventStartTime;
  final DateTime? eventEndTime;
  final String? eventStatus;
  final String? participantType;
  final String? participantStatus;
  final bool? hasCheckIn;
  final DateTime? checkInTime;
  final bool? hasFeedback;
  final DateTime? feedbackSubmittedTime;
  final String? certificateName;
  final int? youthUnionPoints;
  final int? coinReward;
  final int? applicationId;
  final String? displayTitle;
  final String? displayRole;
  final String? displayNote;
  final int? displayOrder;
  final DateTime? createdTime;

  PortfolioEventEntity({
    this.portfolioItemId,
    this.eventId,
    this.eventTitle,
    this.eventBanner,
    this.eventStartTime,
    this.eventEndTime,
    this.eventStatus,
    this.participantType,
    this.participantStatus,
    this.hasCheckIn,
    this.checkInTime,
    this.hasFeedback,
    this.feedbackSubmittedTime,
    this.certificateName,
    this.youthUnionPoints,
    this.coinReward,
    this.applicationId,
    this.displayTitle,
    this.displayRole,
    this.displayNote,
    this.displayOrder,
    this.createdTime,
  });
}
