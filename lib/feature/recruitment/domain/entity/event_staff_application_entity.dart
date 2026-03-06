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
}
