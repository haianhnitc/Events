import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class EventAttendanceLogEntity {
  final int? eventAttendanceLogId;
  final int? eventParticipantId;
  final AttendanceLogType? type;
  final String? qrToken;
  final ScanMethod? scanMethod;
  final double? latitude;
  final double? longitude;
  final bool? isValid;
  final int? scannedByUserId;
  final DateTime? createdTime;

  EventAttendanceLogEntity({
    this.eventAttendanceLogId,
    this.eventParticipantId,
    this.type,
    this.qrToken,
    this.scanMethod,
    this.latitude,
    this.longitude,
    this.isValid,
    this.scannedByUserId,
    this.createdTime,
  });
}
