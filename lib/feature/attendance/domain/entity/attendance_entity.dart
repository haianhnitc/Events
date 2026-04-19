import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class AttendanceQrEntity {
  final String? qrContent;
  final ScanMethod? scanMethod;
  final int? eventId;
  final int? eventParticipantId;
  final DateTime? issuedTime;
  final DateTime? expiryTime;

  AttendanceQrEntity({
    this.qrContent,
    this.scanMethod,
    this.eventId,
    this.eventParticipantId,
    this.issuedTime,
    this.expiryTime,
  });

  bool get isEventQr =>
      scanMethod == ScanMethod.eventQr;

  bool get isStaffQr =>
      scanMethod == ScanMethod.staffQr;

  AttendanceQrEntity copyWith({
    String? qrContent,
    ScanMethod? scanMethod,
    int? eventId,
    int? eventParticipantId,
    DateTime? issuedTime,
    DateTime? expiryTime,
  }) {
    return AttendanceQrEntity(
      qrContent: qrContent ?? this.qrContent,
      scanMethod: scanMethod ?? this.scanMethod,
      eventId: eventId ?? this.eventId,
      eventParticipantId: eventParticipantId ?? this.eventParticipantId,
      issuedTime: issuedTime ?? this.issuedTime,
      expiryTime: expiryTime ?? this.expiryTime,
    );
  }

  @override
  String toString() =>
      'AttendanceQrEntity(eventId: $eventId, scanMethod: $scanMethod)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AttendanceQrEntity &&
        other.qrContent == qrContent &&
        other.eventId == eventId;
  }

  @override
  int get hashCode => Object.hash(qrContent, eventId);
}

class AttendanceScanResultEntity {
  final AttendanceAction? action;
  final int? eventParticipantId;
  final int? attendanceLogId;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String? message;
  final String? participantName;
  final ParticipantType? participantType;
  final int? userId;

  AttendanceScanResultEntity({
    this.action,
    this.eventParticipantId,
    this.attendanceLogId,
    this.checkInTime,
    this.checkOutTime,
    this.message,
    this.participantName,
    this.participantType,
    this.userId,
  });

  AttendanceScanResultEntity copyWith({
    AttendanceAction? action,
    int? eventParticipantId,
    int? attendanceLogId,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    String? message,
    String? participantName,
    ParticipantType? participantType,
    int? userId,
  }) {
    return AttendanceScanResultEntity(
      action: action ?? this.action,
      eventParticipantId: eventParticipantId ?? this.eventParticipantId,
      attendanceLogId: attendanceLogId ?? this.attendanceLogId,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      message: message ?? this.message,
      participantName: participantName ?? this.participantName,
      participantType: participantType ?? this.participantType,
      userId: userId ?? this.userId,
    );
  }

  @override
  String toString() =>
      'AttendanceScanResultEntity(action: $action, epId: $eventParticipantId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AttendanceScanResultEntity &&
        other.attendanceLogId == attendanceLogId;
  }

  @override
  int get hashCode => Object.hash(attendanceLogId, runtimeType);
}
