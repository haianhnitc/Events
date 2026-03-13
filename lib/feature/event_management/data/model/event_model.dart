import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import '../../domain/entity/event_entity.dart';

part 'event_model.freezed.dart';
part 'event_model.g.dart';

@freezed
class EventModel with _$EventModel {
  const factory EventModel({
    int? eventId,
    int? userId,
    int? venueId,
    EventRecruitmentType? recruitmentType,
    String? title,
    String? description,
    String? banner,
    @Default(EventStatus.draft) EventStatus? status,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? registerOpenTime,
    DateTime? createdTime,
  }) = _EventModel;

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  factory EventModel.fromEntity(EventEntity entity) {
    return EventModel(
      eventId: entity.eventId,
      userId: entity.userId,
      venueId: entity.venueId,
      recruitmentType: entity.recruitmentType,
      title: entity.title,
      description: entity.description,
      banner: entity.banner,
      status: entity.status,
      startTime: entity.startTime,
      endTime: entity.endTime,
      registerOpenTime: entity.registerOpenTime,
      createdTime: entity.createdTime,
    );
  }
}

extension EventModelExtension on EventModel {
  EventEntity toEntity() {
    return EventEntity(
      eventId: eventId,
      userId: userId,
      venueId: venueId,
      recruitmentType: recruitmentType,
      title: title,
      description: description,
      banner: banner,
      status: status,
      startTime: startTime,
      endTime: endTime,
      registerOpenTime: registerOpenTime,
      createdTime: createdTime,
    );
  }
}
