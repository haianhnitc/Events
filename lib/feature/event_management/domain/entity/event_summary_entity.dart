import 'package:events_app/feature/common/domain/entity/category_entity.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class EventSummaryEntity {
  final int? eventId;
  final String? title;
  final String? banner;
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime? registerOpenTime;
  final EventStatus? status;
  final int? price;
  final String? certificateName;
  final List<CategoryEntity>? categories;
  final int? capacity;
  final int? totalParticipants;
  final UserEventState? userEventState;
  final int? youthUnionPoint;
  final EventRecruitmentType? recruitmentType;

  EventSummaryEntity({
    this.eventId,
    this.title,
    this.banner,
    this.startTime,
    this.endTime,
    this.registerOpenTime,
    this.status,
    this.price,
    this.certificateName,
    this.categories,
    this.capacity,
    this.totalParticipants,
    this.userEventState,
    this.youthUnionPoint,
    this.recruitmentType,
  });

  EventSummaryEntity copyWith({
    int? eventId,
    String? title,
    String? banner,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? registerOpenTime,
    EventStatus? status,
    int? price,
    String? certificateName,
    List<CategoryEntity>? categories,
    int? capacity,
    int? totalParticipants,
    UserEventState? userEventState,
    int? youthUnionPoint,
    EventRecruitmentType? recruitmentType,
  }) {
    return EventSummaryEntity(
      eventId: eventId ?? this.eventId,
      title: title ?? this.title,
      banner: banner ?? this.banner,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      registerOpenTime: registerOpenTime ?? this.registerOpenTime,
      status: status ?? this.status,
      price: price ?? this.price,
      certificateName: certificateName ?? this.certificateName,
      categories: categories ?? this.categories,
      capacity: capacity ?? this.capacity,
      totalParticipants: totalParticipants ?? this.totalParticipants,
      userEventState: userEventState ?? this.userEventState,
      youthUnionPoint: youthUnionPoint ?? this.youthUnionPoint,
      recruitmentType: recruitmentType ?? this.recruitmentType,
    );
  }

  @override
  String toString() => 'EventSummaryEntity(id: $eventId, title: $title)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventSummaryEntity && other.eventId == eventId;
  }

  @override
  int get hashCode => eventId.hashCode;
}
