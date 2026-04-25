import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/portfolio_event_entity.dart';

part 'portfolio_event_model.freezed.dart';
part 'portfolio_event_model.g.dart';

@freezed
class PortfolioItemModel with _$PortfolioItemModel {
  const factory PortfolioItemModel({
    int? portfolioItemId,
    int? eventId,
    String? eventTitle,
    String? eventBanner,
    DateTime? eventStartTime,
    DateTime? eventEndTime,
    String? eventStatus,
    String? participantType,
    String? participantStatus,
    bool? hasCheckIn,
    DateTime? checkInTime,
    bool? hasFeedback,
    DateTime? feedbackSubmittedTime,
    String? certificateName,
    int? youthUnionPoints,
    int? coinReward,
    int? applicationId,
    String? displayTitle,
    String? displayRole,
    String? displayNote,
    int? displayOrder,
    DateTime? createdTime,
  }) = _PortfolioItemModel;

  factory PortfolioItemModel.fromJson(Map<String, dynamic> json) =>
      _$PortfolioItemModelFromJson(json);

  factory PortfolioItemModel.fromEntity(PortfolioEventEntity entity) {
    return PortfolioItemModel(
      portfolioItemId: entity.portfolioItemId,
      eventId: entity.eventId,
      eventTitle: entity.eventTitle,
      eventBanner: entity.eventBanner,
      eventStartTime: entity.eventStartTime,
      eventEndTime: entity.eventEndTime,
      eventStatus: entity.eventStatus,
      participantType: entity.participantType,
      participantStatus: entity.participantStatus,
      hasCheckIn: entity.hasCheckIn,
      checkInTime: entity.checkInTime,
      hasFeedback: entity.hasFeedback,
      feedbackSubmittedTime: entity.feedbackSubmittedTime,
      certificateName: entity.certificateName,
      youthUnionPoints: entity.youthUnionPoints,
      coinReward: entity.coinReward,
      applicationId: entity.applicationId,
      displayTitle: entity.displayTitle,
      displayRole: entity.displayRole,
      displayNote: entity.displayNote,
      displayOrder: entity.displayOrder,
      createdTime: entity.createdTime,
    );
  }
}

extension PortfolioItemModelExtension on PortfolioItemModel {
  PortfolioEventEntity toEntity() {
    return PortfolioEventEntity(
      portfolioItemId: portfolioItemId,
      eventId: eventId,
      eventTitle: eventTitle,
      eventBanner: eventBanner,
      eventStartTime: eventStartTime,
      eventEndTime: eventEndTime,
      eventStatus: eventStatus,
      participantType: participantType,
      participantStatus: participantStatus,
      hasCheckIn: hasCheckIn,
      checkInTime: checkInTime,
      hasFeedback: hasFeedback,
      feedbackSubmittedTime: feedbackSubmittedTime,
      certificateName: certificateName,
      youthUnionPoints: youthUnionPoints,
      coinReward: coinReward,
      applicationId: applicationId,
      displayTitle: displayTitle,
      displayRole: displayRole,
      displayNote: displayNote,
      displayOrder: displayOrder,
      createdTime: createdTime,
    );
  }
}
