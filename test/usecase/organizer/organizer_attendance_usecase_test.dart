import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/organizer/attendance/domain/repository/organizer_attendance_repository.dart';
import 'package:events_app/feature/organizer/attendance/domain/usecase/organizer_attendance_usecase.dart';
import 'package:events_app/feature/organizer/attendance/domain/usecase/organizer_attendance_params.dart';
import 'package:events_app/feature/attendance/domain/entity/attendance_entity.dart';
import 'package:events_app/feature/attendance/domain/entity/event_attendance_log_entity.dart';

class MockOrganizerAttendanceRepository extends Mock
    implements OrganizerAttendanceRepository {}

void main() {
  late MockOrganizerAttendanceRepository mockRepository;

  setUp(() {
    mockRepository = MockOrganizerAttendanceRepository();
  });

  setUpAll(() {
    registerFallbackValue(OrganizerManualAttendanceParams(eventParticipantId: 1));
    registerFallbackValue(GetOrganizerAttendanceLogsParams(
      eventId: null,
      page: 0,
      size: 20,
    ));
  });

  group('GetOrganizerParticipantQrUsecase', () {
    late GetOrganizerParticipantQrUsecase usecase;

    setUp(() {
      usecase = GetOrganizerParticipantQrUsecase(mockRepository);
    });

    test('success', () async {
      when(() => mockRepository.getParticipantQr(any())).thenAnswer(
        (_) async => Right(AttendanceQrEntity()),
      );

      final result = await usecase(1);

      expect(result.isRight(), true);
    });

    test('404 returns Left', () async {
      when(() => mockRepository.getParticipantQr(any())).thenAnswer(
        (_) async => Left(FailureEntity.serverFailure('404', 'Not found')),
      );

      final result = await usecase(999);

      expect(result.isLeft(), true);
    });
  });

  group('GetOrganizerEventQrUsecase', () {
    late GetOrganizerEventQrUsecase usecase;

    setUp(() {
      usecase = GetOrganizerEventQrUsecase(mockRepository);
    });

    test('success CHECKIN', () async {
      when(() => mockRepository.getEventQr(any(), any())).thenAnswer(
        (_) async => Right(AttendanceQrEntity()),
      );

      final params = GetOrganizerEventQrParams(eventId: 1, action: 'CHECKIN');
      final result = await usecase(params);

      expect(result.isRight(), true);
    });

    test('success CHECKOUT', () async {
      when(() => mockRepository.getEventQr(any(), any())).thenAnswer(
        (_) async => Right(AttendanceQrEntity()),
      );

      final params = GetOrganizerEventQrParams(eventId: 1, action: 'CHECKOUT');
      final result = await usecase(params);

      expect(result.isRight(), true);
    });
  });

  group('OrganizerManualCheckInUsecase', () {
    late OrganizerManualCheckInUsecase usecase;

    setUp(() {
      usecase = OrganizerManualCheckInUsecase(mockRepository);
    });

    test('success', () async {
      when(() => mockRepository.manualCheckIn(any())).thenAnswer(
        (_) async => Right(EventAttendanceLogEntity()),
      );

      final params = OrganizerManualAttendanceParams(eventParticipantId: 1);
      final result = await usecase(params);

      expect(result.isRight(), true);
    });

    test('400 returns Left', () async {
      when(() => mockRepository.manualCheckIn(any())).thenAnswer(
        (_) async => Left(FailureEntity.serverFailure('400', 'Invalid')),
      );

      final params = OrganizerManualAttendanceParams(eventParticipantId: 1);
      final result = await usecase(params);

      expect(result.isLeft(), true);
    });
  });

  group('OrganizerManualCheckOutUsecase', () {
    late OrganizerManualCheckOutUsecase usecase;

    setUp(() {
      usecase = OrganizerManualCheckOutUsecase(mockRepository);
    });

    test('success', () async {
      when(() => mockRepository.manualCheckOut(any())).thenAnswer(
        (_) async => Right(EventAttendanceLogEntity()),
      );

      final params = OrganizerManualAttendanceParams(eventParticipantId: 1);
      final result = await usecase(params);

      expect(result.isRight(), true);
    });
  });

  group('GetOrganizerAttendanceLogsUsecase', () {
    late GetOrganizerAttendanceLogsUsecase usecase;

    setUp(() {
      usecase = GetOrganizerAttendanceLogsUsecase(mockRepository);
    });

    test('success', () async {
      when(() => mockRepository.getAttendanceLogs(any())).thenAnswer(
        (_) async => Right(<EventAttendanceLogEntity>[]),
      );

      final params = GetOrganizerAttendanceLogsParams(
        eventId: null,
        page: 0,
        size: 20,
      );
      final result = await usecase(params);

      expect(result.isRight(), true);
    });

    test('empty', () async {
      when(() => mockRepository.getAttendanceLogs(any())).thenAnswer(
        (_) async => const Right([]),
      );

      final params = GetOrganizerAttendanceLogsParams(
        eventId: null,
        page: 0,
        size: 20,
      );
      final result = await usecase(params);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not return Left'),
        (r) => expect(r, isEmpty),
      );
    });
  });
}
