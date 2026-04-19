import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class EventStaffApplicationEntity {
  final int? eventStaffApplicationId;
  final int? eventId;
  final int? userId;
  final String? position;
  final StaffApplicationStatus? status;
  final String? cvUrl;
  final String? rejectReason;
  final DateTime? appliedTime;
  final DateTime? reviewedTime;

  EventStaffApplicationEntity({
    this.eventStaffApplicationId,
    this.eventId,
    this.userId,
    this.position,
    this.status,
    this.cvUrl,
    this.rejectReason,
    this.appliedTime,
    this.reviewedTime,
  });

  EventStaffApplicationEntity copyWith({
    int? eventStaffApplicationId,
    int? eventId,
    int? userId,
    String? position,
    StaffApplicationStatus? status,
    String? cvUrl,
    String? rejectReason,
    DateTime? appliedTime,
    DateTime? reviewedTime,
  }) {
    return EventStaffApplicationEntity(
      eventStaffApplicationId: eventStaffApplicationId ?? this.eventStaffApplicationId,
      eventId: eventId ?? this.eventId,
      userId: userId ?? this.userId,
      position: position ?? this.position,
      status: status ?? this.status,
      cvUrl: cvUrl ?? this.cvUrl,
      rejectReason: rejectReason ?? this.rejectReason,
      appliedTime: appliedTime ?? this.appliedTime,
      reviewedTime: reviewedTime ?? this.reviewedTime,
    );
  }

  @override
  String toString() =>
      'EventStaffApplicationEntity(id: $eventStaffApplicationId, status: $status)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventStaffApplicationEntity &&
        other.eventStaffApplicationId == eventStaffApplicationId;
  }

  @override
  int get hashCode => Object.hash(eventStaffApplicationId, eventId);
}
