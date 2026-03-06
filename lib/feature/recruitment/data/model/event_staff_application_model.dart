import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import '../../domain/entity/event_staff_application_entity.dart';

part 'event_staff_application_model.freezed.dart';
part 'event_staff_application_model.g.dart';

@freezed
class EventStaffApplicationModel with _$EventStaffApplicationModel {
  const factory EventStaffApplicationModel({
    int? eventStaffApplicationId,
    int? eventId,
    int? userId,
    String? position,
    @Default(StaffApplicationStatus.pending) StaffApplicationStatus? status,
    String? cvUrl,
    String? rejectReason,
    DateTime? appliedTime,
    DateTime? reviewedTime,
  }) = _EventStaffApplicationModel;

  factory EventStaffApplicationModel.fromJson(Map<String, dynamic> json) =>
      _$EventStaffApplicationModelFromJson(json);

  factory EventStaffApplicationModel.fromEntity(
      EventStaffApplicationEntity entity) {
    return EventStaffApplicationModel(
      eventStaffApplicationId: entity.eventStaffApplicationId,
      eventId: entity.eventId,
      userId: entity.userId,
      position: entity.position,
      status: entity.status,
      cvUrl: entity.cvUrl,
      rejectReason: entity.rejectReason,
      appliedTime: entity.appliedTime,
      reviewedTime: entity.reviewedTime,
    );
  }
}

extension EventStaffApplicationModelExtension on EventStaffApplicationModel {
  EventStaffApplicationEntity toEntity() {
    return EventStaffApplicationEntity(
      eventStaffApplicationId: eventStaffApplicationId,
      eventId: eventId,
      userId: userId,
      position: position,
      status: status,
      cvUrl: cvUrl,
      rejectReason: rejectReason,
      appliedTime: appliedTime,
      reviewedTime: reviewedTime,
    );
  }
}
