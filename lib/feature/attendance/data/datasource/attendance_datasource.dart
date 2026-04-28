import 'package:events_app/api_template/api_provider.dart';
import 'package:events_app/api_template/api_path.dart';
import 'package:events_app/api_template/base_request/api_request.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/attendance/data/model/attendance_model.dart';
import 'package:events_app/feature/attendance/domain/usecase/scan_qr_params.dart';
import 'package:injectable/injectable.dart';

abstract class AttendanceDatasource {
  Future<ApiResponse<AttendanceQrModel>> getParticipantQr(int eventParticipantId);
  Future<ApiResponse<AttendanceQrModel>> getEventQr(int eventId, String action);
  Future<ApiResponse<AttendanceScanResultModel>> scanQr(ScanQrParams params);
  Future<ApiResponse<AttendanceScanResultModel>> selfCheckin(ScanQrParams params);
}

@Injectable(as: AttendanceDatasource)
class AttendanceDatasourceImpl extends ApiProvider implements AttendanceDatasource {
  AttendanceDatasourceImpl({RestClient? client})
      : super(client: client ?? NRDRestClient());

  @override
  Future<ApiResponse<AttendanceQrModel>> getParticipantQr(int eventParticipantId) async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.attendanceQrParticipant(eventParticipantId),
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<AttendanceQrModel>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return AttendanceQrModel.fromJson(object);
        },
        fallbackError: 'Lấy QR thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<AttendanceQrModel>> getEventQr(int eventId, String action) async {
    try {
      final response = await get<Map<String, dynamic>>(
        '${ApiPath.attendanceQrEvent(eventId)}?action=$action',
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<AttendanceQrModel>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return AttendanceQrModel.fromJson(object);
        },
        fallbackError: 'Lấy QR sự kiện thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<AttendanceScanResultModel>> scanQr(ScanQrParams params) async {
    try {
      final response = await post<Map<String, dynamic>>(
        ApiPath.attendancesScanQr,
        (data) => Map<String, dynamic>.from(data as Map),
        body: ApiRequestBody.json(params.toJson()),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<AttendanceScanResultModel>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return AttendanceScanResultModel.fromJson(object);
        },
        fallbackError: 'Quét QR thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<AttendanceScanResultModel>> selfCheckin(ScanQrParams params) async {
    try {
      final response = await post<Map<String, dynamic>>(
        ApiPath.attendancesSelfCheckin,
        (data) => Map<String, dynamic>.from(data as Map),
        body: ApiRequestBody.json(params.toJson()),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<AttendanceScanResultModel>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return AttendanceScanResultModel.fromJson(object);
        },
        fallbackError: 'Self check-in thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }
}
