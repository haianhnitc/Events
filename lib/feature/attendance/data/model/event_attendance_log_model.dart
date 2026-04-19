import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/attendance/domain/entity/event_attendance_log_entity.dart';
import 'package:events_app/feature/participant/data/model/participant_model.dart';
import 'package:events_app/feature/user_management/data/model/user_summary_model.dart';

part 'event_attendance_log_model.freezed.dart';
part 'event_attendance_log_model.g.dart';

@freezed
class EventAttendanceLogModel with _$EventAttendanceLogModel {
  const factory EventAttendanceLogModel({
    int? eventAttendanceLogId,
    AttendanceLogType? type,
    ScanMethod? scanMethod,
    double? latitude,
    double? longitude,
    bool? isValid,
    DateTime? createdTime,
    ParticipantModel? eventParticipant,
    UserSummaryModel? scannedByUser,
  }) = _EventAttendanceLogModel;

  factory EventAttendanceLogModel.fromJson(Map<String, dynamic> json) =>
      _$EventAttendanceLogModelFromJson(json);

  factory EventAttendanceLogModel.fromEntity(EventAttendanceLogEntity entity) {
    return EventAttendanceLogModel(
      eventAttendanceLogId: entity.eventAttendanceLogId,
      type: entity.type,
      scanMethod: entity.scanMethod,
      latitude: entity.latitude,
      longitude: entity.longitude,
      isValid: entity.isValid,
      createdTime: entity.createdTime,
      eventParticipant: entity.eventParticipant != null
          ? ParticipantModel.fromEntity(entity.eventParticipant!)
          : null,
      scannedByUser: entity.scannedByUser != null
          ? UserSummaryModel.fromEntity(entity.scannedByUser!)
          : null,
    );
  }
}

extension EventAttendanceLogModelExtension on EventAttendanceLogModel {
  EventAttendanceLogEntity toEntity() {
    return EventAttendanceLogEntity(
      eventAttendanceLogId: eventAttendanceLogId,
      type: type,
      scanMethod: scanMethod,
      latitude: latitude,
      longitude: longitude,
      isValid: isValid,
      createdTime: createdTime,
      eventParticipant: eventParticipant?.toEntity(),
      scannedByUser: scannedByUser?.toEntity(),
    );
  }
}
