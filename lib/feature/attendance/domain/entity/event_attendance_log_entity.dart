import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';
import 'package:events_app/feature/user_management/domain/entity/user_summary_entity.dart';

class EventAttendanceLogEntity {
  final int? eventAttendanceLogId;
  final AttendanceLogType? type;
  final ScanMethod? scanMethod;
  final double? latitude;
  final double? longitude;
  final bool? isValid;
  final DateTime? createdTime;
  final ParticipantEntity? eventParticipant;
  final UserSummaryEntity? scannedByUser;

  EventAttendanceLogEntity({
    this.eventAttendanceLogId,
    this.type,
    this.scanMethod,
    this.latitude,
    this.longitude,
    this.isValid,
    this.createdTime,
    this.eventParticipant,
    this.scannedByUser,
  });

  EventAttendanceLogEntity copyWith({
    int? eventAttendanceLogId,
    AttendanceLogType? type,
    ScanMethod? scanMethod,
    double? latitude,
    double? longitude,
    bool? isValid,
    DateTime? createdTime,
    ParticipantEntity? eventParticipant,
    UserSummaryEntity? scannedByUser,
  }) {
    return EventAttendanceLogEntity(
      eventAttendanceLogId: eventAttendanceLogId ?? this.eventAttendanceLogId,
      type: type ?? this.type,
      scanMethod: scanMethod ?? this.scanMethod,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isValid: isValid ?? this.isValid,
      createdTime: createdTime ?? this.createdTime,
      eventParticipant: eventParticipant ?? this.eventParticipant,
      scannedByUser: scannedByUser ?? this.scannedByUser,
    );
  }

  @override
  String toString() =>
      'EventAttendanceLogEntity(id: $eventAttendanceLogId, type: $type, scanMethod: $scanMethod)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventAttendanceLogEntity &&
        other.eventAttendanceLogId == eventAttendanceLogId;
  }

  @override
  int get hashCode => Object.hash(eventAttendanceLogId, runtimeType);
}
