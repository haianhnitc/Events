import 'package:dartz/dartz.dart';
import 'package:events_app/feature/organizer/attendance/data/repository/organizer_attendance_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/organizer/attendance/domain/repository/organizer_attendance_repository.dart';
import 'package:events_app/feature/organizer/attendance/data/datasource/organizer_attendance_datasource.dart';
import 'package:events_app/feature/organizer/attendance/domain/usecase/organizer_attendance_params.dart';
import 'package:events_app/feature/attendance/data/model/attendance_model.dart';
import 'package:events_app/feature/attendance/data/model/event_attendance_log_model.dart';

import '../../helpers/fake_data.dart';
import '../../helpers/api_response_matchers.dart';

class MockOrganizerAttendanceDatasource extends Mock
    implements OrganizerAttendanceDatasource {}

void main() {
  late OrganizerAttendanceRepositoryImpl repository;
  late MockOrganizerAttendanceDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockOrganizerAttendanceDatasource();
    repository = OrganizerAttendanceRepositoryImpl(mockDatasource);
  });

  setUpAll(() {
    registerFallbackValue(
        const OrganizerManualAttendanceParams(eventParticipantId: 1));
  });

  group('getEventQr', () {
    test('success', () async {
      final qrModel = AttendanceQrModel.fromJson(fakeAttendanceQrJson());
      when(() => mockDatasource.getEventQr(any(), any()))
          .thenAnswer((_) async => ApiResponse.success(qrModel));

      final result = await repository.getEventQr(1, 'CHECKIN');

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not return Left'),
        (r) => expect(r.qrContent, isNotNull),
      );
    });

    test('404 returns Left', () async {
      when(() => mockDatasource.getEventQr(any(), any())).thenAnswer(
        (_) async => ApiResponse<AttendanceQrModel>.unexpected(
          const ApiResponseError(
            code: 'ERROR',
            message: 'Error',
            errors: null,
          ),
        ),
      );

      final result = await repository.getEventQr(999, 'CHECKIN');

      expect(result.isLeft(), true);
    });
  });

  group('getParticipantQr', () {
    test('success', () async {
      final qrModel = AttendanceQrModel.fromJson(fakeAttendanceQrJson());
      when(() => mockDatasource.getParticipantQr(any()))
          .thenAnswer((_) async => ApiResponse.success(qrModel));

      final result = await repository.getParticipantQr(1);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not return Left'),
        (r) => expect(r.qrContent, isNotNull),
      );
    });

    test('404', () async {
      when(() => mockDatasource.getParticipantQr(any())).thenAnswer(
        (_) async => ApiResponse<AttendanceQrModel>.unexpected(
          const ApiResponseError(
            code: 'ERROR',
            message: 'Error',
            errors: null,
          ),
        ),
      );

      final result = await repository.getParticipantQr(999);

      expect(result.isLeft(), true);
    });
  });

  group('manualCheckIn', () {
    test('success', () async {
      final logModel =
          EventAttendanceLogModel.fromJson(fakeAttendanceLogJson());
      when(() => mockDatasource.manualCheckIn(any()))
          .thenAnswer((_) async => ApiResponse.success(logModel));

      const params = OrganizerManualAttendanceParams(eventParticipantId: 1);
      final result = await repository.manualCheckIn(params);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not return Left'),
        (r) => expect(r.eventAttendanceLogId, isNotNull),
      );
    });

    test('400 returns Left', () async {
      when(() => mockDatasource.manualCheckIn(any())).thenAnswer(
        (_) async => ApiResponse<EventAttendanceLogModel>.unexpected(
          const ApiResponseError(
            code: 'ERROR',
            message: 'Error',
            errors: null,
          ),
        ),
      );

      const params = OrganizerManualAttendanceParams(eventParticipantId: 1);
      final result = await repository.manualCheckIn(params);

      expect(result.isLeft(), true);
    });
  });

  group('manualCheckOut', () {
    test('success', () async {
      final logModel =
          EventAttendanceLogModel.fromJson(fakeAttendanceLogJson());
      when(() => mockDatasource.manualCheckOut(any()))
          .thenAnswer((_) async => ApiResponse.success(logModel));

      const params = OrganizerManualAttendanceParams(eventParticipantId: 1);
      final result = await repository.manualCheckOut(params);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not return Left'),
        (r) => expect(r.eventAttendanceLogId, isNotNull),
      );
    });
  });

  group('getAttendanceLogs', () {
    test('success returns list', () async {
      final logJson = fakeAttendanceLogJson();
      final response = {
        'content': [logJson],
        'totalElements': 1,
      };
      when(() => mockDatasource.getAttendanceLogs(
            eventId: any(named: 'eventId'),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => ApiResponse.success(response));

      const params = GetOrganizerAttendanceLogsParams(
        eventId: null,
        page: 0,
        size: 20,
      );
      final result = await repository.getAttendanceLogs(params);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not return Left'),
        (r) => expect(r.length, 1),
      );
    });

    test('empty', () async {
      final response = {
        'content': <dynamic>[],
        'totalElements': 0,
      };
      when(() => mockDatasource.getAttendanceLogs(
            eventId: any(named: 'eventId'),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => ApiResponse.success(response));

      const params = GetOrganizerAttendanceLogsParams(
        eventId: null,
        page: 0,
        size: 20,
      );
      final result = await repository.getAttendanceLogs(params);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not return Left'),
        (r) => expect(r, isEmpty),
      );
    });
  });
}
