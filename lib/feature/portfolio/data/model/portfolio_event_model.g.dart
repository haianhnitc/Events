// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PortfolioItemModelImpl _$$PortfolioItemModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PortfolioItemModelImpl(
      portfolioItemId: (json['portfolioItemId'] as num?)?.toInt(),
      eventId: (json['eventId'] as num?)?.toInt(),
      eventTitle: json['eventTitle'] as String?,
      eventBanner: json['eventBanner'] as String?,
      eventStartTime: json['eventStartTime'] == null
          ? null
          : DateTime.parse(json['eventStartTime'] as String),
      eventEndTime: json['eventEndTime'] == null
          ? null
          : DateTime.parse(json['eventEndTime'] as String),
      eventStatus: json['eventStatus'] as String?,
      participantType: json['participantType'] as String?,
      participantStatus: json['participantStatus'] as String?,
      hasCheckIn: json['hasCheckIn'] as bool?,
      checkInTime: json['checkInTime'] == null
          ? null
          : DateTime.parse(json['checkInTime'] as String),
      hasFeedback: json['hasFeedback'] as bool?,
      feedbackSubmittedTime: json['feedbackSubmittedTime'] == null
          ? null
          : DateTime.parse(json['feedbackSubmittedTime'] as String),
      certificateName: json['certificateName'] as String?,
      youthUnionPoints: (json['youthUnionPoints'] as num?)?.toInt(),
      coinReward: (json['coinReward'] as num?)?.toInt(),
      applicationId: (json['applicationId'] as num?)?.toInt(),
      displayTitle: json['displayTitle'] as String?,
      displayRole: json['displayRole'] as String?,
      displayNote: json['displayNote'] as String?,
      displayOrder: (json['displayOrder'] as num?)?.toInt(),
      createdTime: json['createdTime'] == null
          ? null
          : DateTime.parse(json['createdTime'] as String),
    );

Map<String, dynamic> _$$PortfolioItemModelImplToJson(
        _$PortfolioItemModelImpl instance) =>
    <String, dynamic>{
      'portfolioItemId': instance.portfolioItemId,
      'eventId': instance.eventId,
      'eventTitle': instance.eventTitle,
      'eventBanner': instance.eventBanner,
      'eventStartTime': instance.eventStartTime?.toIso8601String(),
      'eventEndTime': instance.eventEndTime?.toIso8601String(),
      'eventStatus': instance.eventStatus,
      'participantType': instance.participantType,
      'participantStatus': instance.participantStatus,
      'hasCheckIn': instance.hasCheckIn,
      'checkInTime': instance.checkInTime?.toIso8601String(),
      'hasFeedback': instance.hasFeedback,
      'feedbackSubmittedTime':
          instance.feedbackSubmittedTime?.toIso8601String(),
      'certificateName': instance.certificateName,
      'youthUnionPoints': instance.youthUnionPoints,
      'coinReward': instance.coinReward,
      'applicationId': instance.applicationId,
      'displayTitle': instance.displayTitle,
      'displayRole': instance.displayRole,
      'displayNote': instance.displayNote,
      'displayOrder': instance.displayOrder,
      'createdTime': instance.createdTime?.toIso8601String(),
    };
