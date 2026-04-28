import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:events_app/feature/attendance/domain/entity/attendance_entity.dart';
import 'package:events_app/feature/attendance/domain/entity/event_attendance_log_entity.dart';
import 'package:events_app/feature/organizer/attendance/domain/repository/organizer_attendance_repository.dart';
import 'package:events_app/feature/organizer/attendance/domain/usecase/organizer_attendance_params.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetOrganizerParticipantQrUsecase implements UseCase<AttendanceQrEntity, int> {
  final OrganizerAttendanceRepository _repository;
  GetOrganizerParticipantQrUsecase(this._repository);

  @override
  Future<Either<FailureEntity, AttendanceQrEntity>> call(int eventParticipantId) async {
    return await _repository.getParticipantQr(eventParticipantId);
  }
}

@injectable
class GetOrganizerEventQrUsecase implements UseCase<AttendanceQrEntity, GetOrganizerEventQrParams> {
  final OrganizerAttendanceRepository _repository;
  GetOrganizerEventQrUsecase(this._repository);

  @override
  Future<Either<FailureEntity, AttendanceQrEntity>> call(GetOrganizerEventQrParams params) async {
    return await _repository.getEventQr(params.eventId, params.action);
  }
}

@injectable
class OrganizerManualCheckInUsecase
    implements UseCase<EventAttendanceLogEntity, OrganizerManualAttendanceParams> {
  final OrganizerAttendanceRepository _repository;
  OrganizerManualCheckInUsecase(this._repository);

  @override
  Future<Either<FailureEntity, EventAttendanceLogEntity>> call(
      OrganizerManualAttendanceParams params) async {
    return await _repository.manualCheckIn(params);
  }
}

@injectable
class OrganizerManualCheckOutUsecase
    implements UseCase<EventAttendanceLogEntity, OrganizerManualAttendanceParams> {
  final OrganizerAttendanceRepository _repository;
  OrganizerManualCheckOutUsecase(this._repository);

  @override
  Future<Either<FailureEntity, EventAttendanceLogEntity>> call(
      OrganizerManualAttendanceParams params) async {
    return await _repository.manualCheckOut(params);
  }
}

@injectable
class GetOrganizerAttendanceLogsUsecase
    implements UseCase<List<EventAttendanceLogEntity>, GetOrganizerAttendanceLogsParams> {
  final OrganizerAttendanceRepository _repository;
  GetOrganizerAttendanceLogsUsecase(this._repository);

  @override
  Future<Either<FailureEntity, List<EventAttendanceLogEntity>>> call(
      GetOrganizerAttendanceLogsParams params) async {
    return await _repository.getAttendanceLogs(params);
  }
}
