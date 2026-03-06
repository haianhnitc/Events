import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import '../../domain/entity/event_attendance_log_entity.dart';

part 'event_attendance_log_model.freezed.dart';
part 'event_attendance_log_model.g.dart';

@freezed
class EventAttendanceLogModel with _$EventAttendanceLogModel {
  const factory EventAttendanceLogModel({
    int? eventAttendanceLogId,
    int? eventParticipantId,
    AttendanceLogType? type,
    String? qrToken,
    ScanMethod? scanMethod,
    double? latitude,
    double? longitude,
    bool? isValid,
    int? scannedByUserId,
    DateTime? createdTime,
  }) = _EventAttendanceLogModel;

  factory EventAttendanceLogModel.fromJson(Map<String, dynamic> json) =>
      _$EventAttendanceLogModelFromJson(json);

  factory EventAttendanceLogModel.fromEntity(EventAttendanceLogEntity entity) {
    return EventAttendanceLogModel(
      eventAttendanceLogId: entity.eventAttendanceLogId,
      eventParticipantId: entity.eventParticipantId,
      type: entity.type,
      qrToken: entity.qrToken,
      scanMethod: entity.scanMethod,
      latitude: entity.latitude,
      longitude: entity.longitude,
      isValid: entity.isValid,
      scannedByUserId: entity.scannedByUserId,
      createdTime: entity.createdTime,
    );
  }
}

extension EventAttendanceLogModelExtension on EventAttendanceLogModel {
  EventAttendanceLogEntity toEntity() {
    return EventAttendanceLogEntity(
      eventAttendanceLogId: eventAttendanceLogId,
      eventParticipantId: eventParticipantId,
      type: type,
      qrToken: qrToken,
      scanMethod: scanMethod,
      latitude: latitude,
      longitude: longitude,
      isValid: isValid,
      scannedByUserId: scannedByUserId,
      createdTime: createdTime,
    );
  }
}
