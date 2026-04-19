import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class FeedbackQuestionCreateParams {
  final String questionContent;
  final FeedbackQuestionType questionType;
  final bool isRequired;
  final List<FeedbackOptionCreateParams>? options;

  const FeedbackQuestionCreateParams({
    required this.questionContent,
    required this.questionType,
    this.isRequired = false,
    this.options,
  });

  Map<String, dynamic> toJson() => {
        'questionContent': questionContent,
        'questionType': questionType.apiValue,
        'isRequired': isRequired,
        if (options != null && options!.isNotEmpty)
          'options': options!.map((e) => e.toJson()).toList(),
      };
}

class FeedbackOptionCreateParams {
  final String optionValue;

  const FeedbackOptionCreateParams({required this.optionValue});

  Map<String, dynamic> toJson() => {'optionValue': optionValue};
}

class OrganizerEventListParams {
  final int organizerId;
  final int page;
  final int size;
  final EventStatus? status;
  final String? keyword;
  final String? sortBy;
  final String? sortDirection;

  const OrganizerEventListParams({
    required this.organizerId,
    this.page = 0,
    this.size = 20,
    this.status,
    this.keyword,
    this.sortBy,
    this.sortDirection,
  });
}

class EventCreateParams {
  final int? venueId;
  final VenueCreateNestedParams? venue;
  final String? title;
  final int? bannerFileId;
  final String? description;
  final int? price;
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime? registerOpenTime;
  final EventRecruitmentType? recruitmentType;
  final int? attendeeRewardCoin;
  final int? attendeeYouthUnionPoint;
  final String? attendeeCertificateName;
  final List<int>? categoryOptionIds;
  final List<FeedbackQuestionCreateParams>? feedbackQuestions;

  const EventCreateParams({
    this.venueId,
    this.venue,
    this.title,
    this.bannerFileId,
    this.description,
    this.price,
    this.startTime,
    this.endTime,
    this.registerOpenTime,
    this.recruitmentType,
    this.attendeeRewardCoin,
    this.attendeeYouthUnionPoint,
    this.attendeeCertificateName,
    this.categoryOptionIds,
    this.feedbackQuestions,
  });

  Map<String, dynamic> toJson() => {
        if (venueId != null) 'venueId': venueId,
        if (venue != null) 'venue': venue!.toJson(),
        if (title != null) 'title': title,
        if (bannerFileId != null) 'bannerFileId': bannerFileId,
        if (description != null) 'description': description,
        if (price != null) 'price': price,
        if (startTime != null) 'startTime': startTime!.toIso8601String(),
        if (endTime != null) 'endTime': endTime!.toIso8601String(),
        if (registerOpenTime != null)
          'registerOpenTime': registerOpenTime!.toIso8601String(),
        if (recruitmentType != null) 'recruitmentType': recruitmentType?.apiValue,
        if (attendeeRewardCoin != null) 'attendeeRewardCoin': attendeeRewardCoin,
        if (attendeeYouthUnionPoint != null)
          'attendeeYouthUnionPoint': attendeeYouthUnionPoint,
        if (attendeeCertificateName != null)
          'attendeeCertificateName': attendeeCertificateName,
        if (categoryOptionIds != null && categoryOptionIds!.isNotEmpty)
          'categoryOptionIds': categoryOptionIds,
        if (feedbackQuestions != null && feedbackQuestions!.isNotEmpty)
          'feedbackQuestions': feedbackQuestions!.map((e) => e.toJson()).toList(),
      };
}

class VenueCreateNestedParams {
  final String? name;
  final String? address;
  final int? capacity;
  final double? latitude;
  final double? longitude;
  final String? mapUrl;

  const VenueCreateNestedParams({
    this.name,
    this.address,
    this.capacity,
    this.latitude,
    this.longitude,
    this.mapUrl,
  });

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (address != null) 'address': address,
        if (capacity != null) 'capacity': capacity,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (mapUrl != null) 'mapUrl': mapUrl,
      };
}

class EventUpdateParams {
  final int? venueId;
  final VenueCreateNestedParams? venue;
  final String? title;
  final int? bannerFileId;
  final String? description;
  final int? price;
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime? registerOpenTime;
  final EventStatus? status;
  final EventRecruitmentType? recruitmentType;
  final int? attendeeRewardCoin;
  final int? attendeeYouthUnionPoint;
  final String? attendeeCertificateName;
  final List<int>? categoryOptionIds;

  const EventUpdateParams({
    this.venueId,
    this.venue,
    this.title,
    this.bannerFileId,
    this.description,
    this.price,
    this.startTime,
    this.endTime,
    this.registerOpenTime,
    this.status,
    this.recruitmentType,
    this.attendeeRewardCoin,
    this.attendeeYouthUnionPoint,
    this.attendeeCertificateName,
    this.categoryOptionIds,
  });

  Map<String, dynamic> toJson() => {
        if (venueId != null) 'venueId': venueId,
        if (venue != null) 'venue': venue!.toJson(),
        if (title != null) 'title': title,
        if (bannerFileId != null) 'bannerFileId': bannerFileId,
        if (description != null) 'description': description,
        if (price != null) 'price': price,
        if (startTime != null) 'startTime': startTime!.toIso8601String(),
        if (endTime != null) 'endTime': endTime!.toIso8601String(),
        if (registerOpenTime != null)
          'registerOpenTime': registerOpenTime!.toIso8601String(),
        if (status != null) 'status': status?.apiValue,
        if (recruitmentType != null) 'recruitmentType': recruitmentType?.apiValue,
        if (attendeeRewardCoin != null) 'attendeeRewardCoin': attendeeRewardCoin,
        if (attendeeYouthUnionPoint != null)
          'attendeeYouthUnionPoint': attendeeYouthUnionPoint,
        if (attendeeCertificateName != null)
          'attendeeCertificateName': attendeeCertificateName,
        if (categoryOptionIds != null && categoryOptionIds!.isNotEmpty)
          'categoryOptionIds': categoryOptionIds,
      };
}

class EventCategoryOptionCreateParams {
  final int eventId;
  final int categoryOptionId;

  const EventCategoryOptionCreateParams({
    required this.eventId,
    required this.categoryOptionId,
  });

  Map<String, dynamic> toJson() => {
        'eventId': eventId,
        'categoryOptionId': categoryOptionId,
      };
}

class EventCategoryOptionUpdateParams {
  final int categoryOptionId;

  const EventCategoryOptionUpdateParams({required this.categoryOptionId});

  Map<String, dynamic> toJson() => {'categoryOptionId': categoryOptionId};
}
