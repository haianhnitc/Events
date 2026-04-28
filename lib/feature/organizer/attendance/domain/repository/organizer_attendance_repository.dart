import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/attendance/domain/entity/attendance_entity.dart';
import 'package:events_app/feature/attendance/domain/entity/event_attendance_log_entity.dart';
import 'package:events_app/feature/organizer/attendance/domain/usecase/organizer_attendance_params.dart';

abstract class OrganizerAttendanceRepository {
  Future<Either<FailureEntity, AttendanceQrEntity>> getEventQr(int eventId, String action);
  Future<Either<FailureEntity, AttendanceQrEntity>> getParticipantQr(int eventParticipantId);

  Future<Either<FailureEntity, EventAttendanceLogEntity>> manualCheckIn(OrganizerManualAttendanceParams params);
  Future<Either<FailureEntity, EventAttendanceLogEntity>> manualCheckOut(OrganizerManualAttendanceParams params);

  Future<Either<FailureEntity, List<EventAttendanceLogEntity>>> getAttendanceLogs(
      GetOrganizerAttendanceLogsParams params);
}
