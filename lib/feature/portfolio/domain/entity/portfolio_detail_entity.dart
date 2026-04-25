import 'package:events_app/feature/user_management/domain/entity/user_summary_entity.dart';
import 'package:events_app/feature/portfolio/domain/entity/portfolio_event_entity.dart';

class PortfolioItemEntity {
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

  PortfolioItemEntity({
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

class PortfolioDetailEntity {
  final int? portfolioId;
  final UserSummaryEntity? user;
  final int? userId;
  final String? portfolioCode;
  final String? title;
  final String? description;
  final bool? isPublished;
  final DateTime? createdTime;
  final DateTime? publishTime;
  final int? viewCount;
  final int? downloadCount;
  final int? price;
  final String? thumbnail;
  final int? itemCount;
  final List<PortfolioEventEntity>? items;

  PortfolioDetailEntity({
    this.portfolioId,
    this.user,
    this.userId,
    this.portfolioCode,
    this.title,
    this.description,
    this.isPublished,
    this.createdTime,
    this.publishTime,
    this.viewCount,
    this.downloadCount,
    this.price,
    this.thumbnail,
    this.itemCount,
    this.items,
  });
}
