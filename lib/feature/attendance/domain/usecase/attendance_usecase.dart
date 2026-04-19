import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:events_app/feature/attendance/domain/entity/attendance_entity.dart';
import 'package:events_app/feature/attendance/domain/entity/event_attendance_log_entity.dart';
import 'package:events_app/feature/attendance/domain/repository/attendance_repository.dart';
import 'package:events_app/feature/attendance/domain/usecase/scan_qr_params.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetParticipantQrUsecase implements UseCase<AttendanceQrEntity, GetParticipantQrParams> {
  final AttendanceRepository _repository;
  GetParticipantQrUsecase(this._repository);

  @override
  Future<Either<FailureEntity, AttendanceQrEntity>> call(GetParticipantQrParams params) async {
    return await _repository.getParticipantQr(params.eventParticipantId);
  }
}

@injectable
class GetEventQrUsecase implements UseCase<AttendanceQrEntity, int> {
  final AttendanceRepository _repository;
  GetEventQrUsecase(this._repository);

  @override
  Future<Either<FailureEntity, AttendanceQrEntity>> call(int eventId) async {
    return await _repository.getEventQr(eventId);
  }
}

@injectable
class ScanQrUsecase implements UseCase<AttendanceScanResultEntity, ScanQrParams> {
  final AttendanceRepository _repository;
  ScanQrUsecase(this._repository);

  @override
  Future<Either<FailureEntity, AttendanceScanResultEntity>> call(ScanQrParams params) async {
    return await _repository.scanQr(params);
  }
}

@injectable
class SelfCheckInUsecase implements UseCase<AttendanceScanResultEntity, ScanQrParams> {
  final AttendanceRepository _repository;
  SelfCheckInUsecase(this._repository);

  @override
  Future<Either<FailureEntity, AttendanceScanResultEntity>> call(ScanQrParams params) async {
    return await _repository.selfCheckin(params);
  }
}
