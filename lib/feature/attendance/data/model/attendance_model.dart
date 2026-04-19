import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:events_app/feature/attendance/domain/entity/attendance_entity.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';

part 'attendance_model.freezed.dart';
part 'attendance_model.g.dart';

@freezed
class AttendanceQrModel with _$AttendanceQrModel {
  const factory AttendanceQrModel({
    String? qrContent,
    ScanMethod? scanMethod,
    int? eventId,
    int? eventParticipantId,
    DateTime? issuedTime,
    DateTime? expiryTime,
  }) = _AttendanceQrModel;

  factory AttendanceQrModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceQrModelFromJson(json);

  factory AttendanceQrModel.fromEntity(AttendanceQrEntity entity) {
    return AttendanceQrModel(
      qrContent: entity.qrContent,
      scanMethod: entity.scanMethod,
      eventId: entity.eventId,
      eventParticipantId: entity.eventParticipantId,
      issuedTime: entity.issuedTime,
      expiryTime: entity.expiryTime,
    );
  }
}

extension AttendanceQrModelExtension on AttendanceQrModel {
  AttendanceQrEntity toEntity() {
    return AttendanceQrEntity(
      qrContent: qrContent,
      scanMethod: scanMethod,
      eventId: eventId,
      eventParticipantId: eventParticipantId,
      issuedTime: issuedTime,
      expiryTime: expiryTime,
    );
  }
}

@freezed
class AttendanceScanResultModel with _$AttendanceScanResultModel {
  const factory AttendanceScanResultModel({
    AttendanceAction? action,
    int? eventParticipantId,
    int? attendanceLogId,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    String? message,
    String? participantName,
    ParticipantType? participantType,
    int? userId,
  }) = _AttendanceScanResultModel;

  factory AttendanceScanResultModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceScanResultModelFromJson(json);

  factory AttendanceScanResultModel.fromEntity(AttendanceScanResultEntity entity) {
    return AttendanceScanResultModel(
      action: entity.action,
      eventParticipantId: entity.eventParticipantId,
      attendanceLogId: entity.attendanceLogId,
      checkInTime: entity.checkInTime,
      checkOutTime: entity.checkOutTime,
      message: entity.message,
      participantName: entity.participantName,
      participantType: entity.participantType,
      userId: entity.userId,
    );
  }
}

extension AttendanceScanResultModelExtension on AttendanceScanResultModel {
  AttendanceScanResultEntity toEntity() {
    return AttendanceScanResultEntity(
      action: action,
      eventParticipantId: eventParticipantId,
      attendanceLogId: attendanceLogId,
      checkInTime: checkInTime,
      checkOutTime: checkOutTime,
      message: message,
      participantName: participantName,
      participantType: participantType,
      userId: userId,
    );
  }
}
