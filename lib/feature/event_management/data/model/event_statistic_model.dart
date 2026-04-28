import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/event_statistic_entity.dart';

part 'event_statistic_model.freezed.dart';
part 'event_statistic_model.g.dart';

@freezed
class EventStatisticModel with _$EventStatisticModel {
  const factory EventStatisticModel({
    int? eventId,
    String? eventTitle,
    String? recruitmentType,
    @Default(0) int? totalRegistered,
    @Default(0) int? totalCheckedIn,
    @Default(0) int? totalCheckedOut,
    @Default(0) int? totalAttendees,
    @Default(0) int? totalCtv,
    @Default(0) int? totalTicketsSold,
    @Default(0) int? totalFeedbacks,
    @Default(0) int? totalViews,
    DateTime? lastUpdateTime,
  }) = _EventStatisticModel;

  factory EventStatisticModel.fromJson(Map<String, dynamic> json) =>
      _$EventStatisticModelFromJson(json);

  factory EventStatisticModel.fromEntity(EventStatisticEntity entity) {
    return EventStatisticModel(
      eventId: entity.eventId,
      eventTitle: entity.eventTitle,
      recruitmentType: entity.recruitmentType,
      totalRegistered: entity.totalRegistered,
      totalCheckedIn: entity.totalCheckedIn,
      totalCheckedOut: entity.totalCheckedOut,
      totalAttendees: entity.totalAttendees,
      totalCtv: entity.totalCtv,
      totalTicketsSold: entity.totalTicketsSold,
      totalFeedbacks: entity.totalFeedbacks,
      totalViews: entity.totalViews,
      lastUpdateTime: entity.lastUpdateTime,
    );
  }
}

extension EventStatisticModelExtension on EventStatisticModel {
  EventStatisticEntity toEntity() {
    return EventStatisticEntity(
      eventId: eventId,
      eventTitle: eventTitle,
      recruitmentType: recruitmentType,
      totalRegistered: totalRegistered,
      totalCheckedIn: totalCheckedIn,
      totalCheckedOut: totalCheckedOut,
      totalAttendees: totalAttendees,
      totalCtv: totalCtv,
      totalTicketsSold: totalTicketsSold,
      totalFeedbacks: totalFeedbacks,
      totalViews: totalViews,
      lastUpdateTime: lastUpdateTime,
    );
  }
}
