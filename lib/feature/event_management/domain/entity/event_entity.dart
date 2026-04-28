import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/domain/entity/category_entity.dart';
import 'package:events_app/feature/venue/domain/entity/venue_entity.dart';

class EventEntity {
  final int? eventId;
  final String? organizerName;
  final VenueEntity? venue;
  final String? title;
  final String? description;
  final String? banner;
  final EventStatus? status;
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime? registerOpenTime;
  final int? price;
  final List<CategoryEntity>? categories;
  final int? rewardCoin;
  final int? youthUnionPoint;
  final String? certificateName;
  final DateTime? createdTime;
  final int? totalParticipants;
  final UserEventState? userEventState;
  final EventRecruitmentType? recruitmentType;
  final int? viewCount;
  final DateTime? lastViewedTime;

  EventEntity({
    this.eventId,
    this.organizerName,
    this.venue,
    this.title,
    this.description,
    this.banner,
    this.status,
    this.startTime,
    this.endTime,
    this.registerOpenTime,
    this.price,
    this.categories,
    this.rewardCoin,
    this.youthUnionPoint,
    this.certificateName,
    this.createdTime,
    this.totalParticipants,
    this.userEventState,
    this.recruitmentType,
    this.viewCount,
    this.lastViewedTime,
  });

  EventEntity copyWith({
    int? eventId,
    String? organizerName,
    VenueEntity? venue,
    String? title,
    String? description,
    String? banner,
    EventStatus? status,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? registerOpenTime,
    int? price,
    List<CategoryEntity>? categories,
    int? rewardCoin,
    int? youthUnionPoint,
    String? certificateName,
    DateTime? createdTime,
    int? totalParticipants,
    UserEventState? userEventState,
    EventRecruitmentType? recruitmentType,
    int? viewCount,
    DateTime? lastViewedTime,
  }) {
    return EventEntity(
      eventId: eventId ?? this.eventId,
      organizerName: organizerName ?? this.organizerName,
      venue: venue ?? this.venue,
      title: title ?? this.title,
      description: description ?? this.description,
      banner: banner ?? this.banner,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      registerOpenTime: registerOpenTime ?? this.registerOpenTime,
      price: price ?? this.price,
      categories: categories ?? this.categories,
      rewardCoin: rewardCoin ?? this.rewardCoin,
      youthUnionPoint: youthUnionPoint ?? this.youthUnionPoint,
      certificateName: certificateName ?? this.certificateName,
      createdTime: createdTime ?? this.createdTime,
      totalParticipants: totalParticipants ?? this.totalParticipants,
      userEventState: userEventState ?? this.userEventState,
      recruitmentType: recruitmentType ?? this.recruitmentType,
      viewCount: viewCount ?? this.viewCount,
      lastViewedTime: lastViewedTime ?? this.lastViewedTime,
    );
  }

  @override
  String toString() => 'EventEntity(id: $eventId, title: $title)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventEntity && other.eventId == eventId;
  }

  @override
  int get hashCode => Object.hash(eventId, title);
}
