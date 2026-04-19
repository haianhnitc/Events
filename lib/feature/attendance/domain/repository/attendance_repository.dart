import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/attendance/domain/entity/attendance_entity.dart';
import 'package:events_app/feature/attendance/domain/usecase/scan_qr_params.dart';

abstract class AttendanceRepository {
  Future<Either<FailureEntity, AttendanceQrEntity>> getParticipantQr(int eventParticipantId);
  Future<Either<FailureEntity, AttendanceQrEntity>> getEventQr(int eventId);
  Future<Either<FailureEntity, AttendanceScanResultEntity>> scanQr(ScanQrParams params);
  Future<Either<FailureEntity, AttendanceScanResultEntity>> selfCheckin(ScanQrParams params);
}
