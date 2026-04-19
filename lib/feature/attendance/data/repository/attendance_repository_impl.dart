import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/attendance/data/datasource/attendance_datasource.dart';
import 'package:events_app/feature/attendance/data/model/attendance_model.dart';
import 'package:events_app/feature/attendance/domain/entity/attendance_entity.dart';
import 'package:events_app/feature/attendance/domain/repository/attendance_repository.dart';
import 'package:events_app/feature/attendance/domain/usecase/scan_qr_params.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AttendanceRepository)
class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceDatasource _datasource;

  AttendanceRepositoryImpl(this._datasource);

  @override
  Future<Either<FailureEntity, AttendanceQrEntity>> getParticipantQr(
      int eventParticipantId) async {
    final response = await _datasource.getParticipantQr(eventParticipantId);
    return response.toEitherNullable().map((m) => m.toEntity());
  }

  @override
  Future<Either<FailureEntity, AttendanceQrEntity>> getEventQr(
      int eventId) async {
    final response = await _datasource.getEventQr(eventId);
    return response.toEitherNullable().map((m) => m.toEntity());
  }

  @override
  Future<Either<FailureEntity, AttendanceScanResultEntity>> scanQr(
      ScanQrParams params) async {
    final response = await _datasource.scanQr(params);
    return response.toEitherNullable().map((m) => m.toEntity());
  }

  @override
  Future<Either<FailureEntity, AttendanceScanResultEntity>> selfCheckin(
      ScanQrParams params) async {
    final response = await _datasource.selfCheckin(params);
    return response.toEitherNullable().map((m) => m.toEntity());
  }
}
