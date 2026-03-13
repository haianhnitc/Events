import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class EventEntity {
  final int? eventId;
  final int? userId;
  final int? venueId;
  final EventRecruitmentType? recruitmentType;
  final String? title;
  final String? description;
  final String? banner;
  final EventStatus? status;
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime? registerOpenTime;
  final DateTime? createdTime;

  EventEntity({
    this.eventId,
    this.userId,
    this.venueId,
    this.recruitmentType,
    this.title,
    this.description,
    this.banner,
    this.status,
    this.startTime,
    this.endTime,
    this.registerOpenTime,
    this.createdTime,
  });
}
