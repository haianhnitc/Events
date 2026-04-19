import 'package:events_app/api_template/api_provider.dart';
import 'package:events_app/api_template/api_path.dart';
import 'package:events_app/api_template/base_request/api_request.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/attendance/data/model/attendance_model.dart';
import 'package:events_app/feature/attendance/data/model/event_attendance_log_model.dart';
import 'package:events_app/feature/organizer/attendance/domain/usecase/organizer_attendance_params.dart';
import 'package:injectable/injectable.dart';

abstract class OrganizerAttendanceDatasource {
  Future<ApiResponse<AttendanceQrModel>> getEventQr(int eventId);
  Future<ApiResponse<AttendanceQrModel>> getParticipantQr(int eventParticipantId);
  Future<ApiResponse<EventAttendanceLogModel>> manualCheckIn(OrganizerManualAttendanceParams params);
  Future<ApiResponse<EventAttendanceLogModel>> manualCheckOut(OrganizerManualAttendanceParams params);
  Future<ApiResponse<Map<String, dynamic>>> getAttendanceLogs({
    int? eventId,
    int page = 0,
    int size = 20,
  });
}

@Injectable(as: OrganizerAttendanceDatasource)
class OrganizerAttendanceDatasourceImpl extends ApiProvider
    implements OrganizerAttendanceDatasource {
  OrganizerAttendanceDatasourceImpl({RestClient? client})
      : super(client: client ?? NRDRestClient());

  @override
  Future<ApiResponse<AttendanceQrModel>> getEventQr(int eventId) async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.attendanceQrEvent(eventId),
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
        fallbackError: 'Lấy QR event thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

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
        fallbackError: 'Lấy QR participant thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<EventAttendanceLogModel>> manualCheckIn(
    OrganizerManualAttendanceParams params,
  ) async {
    try {
      final response = await post<Map<String, dynamic>>(
        ApiPath.attendancesManualCheckin,
        (data) => Map<String, dynamic>.from(data as Map),
        body: ApiRequestBody.json(params.toJson()),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<EventAttendanceLogModel>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return EventAttendanceLogModel.fromJson(object);
        },
        fallbackError: 'Check-in thủ công thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<EventAttendanceLogModel>> manualCheckOut(
    OrganizerManualAttendanceParams params,
  ) async {
    try {
      final response = await post<Map<String, dynamic>>(
        ApiPath.attendancesManualCheckout,
        (data) => Map<String, dynamic>.from(data as Map),
        body: ApiRequestBody.json(params.toJson()),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<EventAttendanceLogModel>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return EventAttendanceLogModel.fromJson(object);
        },
        fallbackError: 'Check-out thủ công thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> getAttendanceLogs({
    int? eventId,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'size': size,
      };
      if (eventId != null) queryParams['eventId'] = eventId;

      final response = await get<Map<String, dynamic>>(
        ApiPath.attendances,
        (data) => Map<String, dynamic>.from(data as Map),
        queryParameters: queryParams,
        requireAuth: true,
      );

      return forwardEnvelopeResponse<Map<String, dynamic>>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return object;
        },
        fallbackError: 'Lấy danh sách attendance thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }
}
