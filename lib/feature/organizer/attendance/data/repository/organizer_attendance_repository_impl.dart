import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/attendance/data/model/attendance_model.dart';
import 'package:events_app/feature/attendance/domain/entity/attendance_entity.dart';
import 'package:events_app/feature/attendance/domain/entity/event_attendance_log_entity.dart';
import 'package:events_app/feature/attendance/data/model/event_attendance_log_model.dart';
import 'package:events_app/feature/organizer/attendance/data/datasource/organizer_attendance_datasource.dart';
import 'package:events_app/feature/organizer/attendance/domain/repository/organizer_attendance_repository.dart';
import 'package:events_app/feature/organizer/attendance/domain/usecase/organizer_attendance_params.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OrganizerAttendanceRepository)
class OrganizerAttendanceRepositoryImpl
    implements OrganizerAttendanceRepository {
  final OrganizerAttendanceDatasource _datasource;

  OrganizerAttendanceRepositoryImpl(this._datasource);

  @override
  Future<Either<FailureEntity, AttendanceQrEntity>> getEventQr(
      int eventId) async {
    final response = await _datasource.getEventQr(eventId);
    return response.toEitherNullable().map((m) => m.toEntity());
  }

  @override
  Future<Either<FailureEntity, AttendanceQrEntity>> getParticipantQr(
      int eventParticipantId) async {
    final response = await _datasource.getParticipantQr(eventParticipantId);
    return response.toEitherNullable().map((m) => m.toEntity());
  }

  @override
  Future<Either<FailureEntity, EventAttendanceLogEntity>> manualCheckIn(
    OrganizerManualAttendanceParams params,
  ) async {
    final response = await _datasource.manualCheckIn(params);
    return response.toEitherNullable().map((m) => m.toEntity());
  }

  @override
  Future<Either<FailureEntity, EventAttendanceLogEntity>> manualCheckOut(
    OrganizerManualAttendanceParams params,
  ) async {
    final response = await _datasource.manualCheckOut(params);
    return response.toEitherNullable().map((m) => m.toEntity());
  }

  @override
  Future<Either<FailureEntity, List<EventAttendanceLogEntity>>>
      getAttendanceLogs(GetOrganizerAttendanceLogsParams params) async {
    final response = await _datasource.getAttendanceLogs(
        eventId: params.eventId, page: params.page, size: params.size);
    return response.toEitherNullable().map((payload) {
      final content = payload?['content'] as List<dynamic>? ?? [];
      return content
          .map((e) =>
              EventAttendanceLogModel.fromJson(e as Map<String, dynamic>)
                  .toEntity())
          .toList();
    });
  }
}
