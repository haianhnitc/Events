import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/organizer/attendance/domain/usecase/organizer_attendance_usecase.dart';
import 'package:events_app/feature/organizer/attendance/domain/usecase/organizer_attendance_params.dart';
import 'package:events_app/feature/attendance/domain/entity/event_attendance_log_entity.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_attendance_list_controller.dart';

class MockGetOrganizerAttendanceLogsUsecase extends Mock
    implements GetOrganizerAttendanceLogsUsecase {}

void main() {
  late OrganizerAttendanceListController controller;
  late MockGetOrganizerAttendanceLogsUsecase mockGetAttendanceLogsUsecase;

  setUp(() {
    Get.testMode = true;
    Get.reset();
    networkGetIt.reset();

    mockGetAttendanceLogsUsecase = MockGetOrganizerAttendanceLogsUsecase();
    networkGetIt.registerSingleton<MockGetOrganizerAttendanceLogsUsecase>(
        mockGetAttendanceLogsUsecase);

    controller = OrganizerAttendanceListController();
  });

  tearDown(() {
    Get.reset();
    networkGetIt.reset();
  });

  setUpAll(() {
    registerFallbackValue(GetOrganizerAttendanceLogsParams(
      eventId: null,
      page: 0,
      size: 20,
    ));
  });

  group('Initial state', () {
    test('empty logs, not loading', () {
      controller.onInit();

      expect(controller.attendanceLogs, isEmpty);
      expect(controller.isLoading.value, false);
    });
  });

  group('loadAttendanceLogs', () {
    test('success populates logs', () async {
      when(() => mockGetAttendanceLogsUsecase(any())).thenAnswer(
        (_) async => Right(<EventAttendanceLogEntity>[]),
      );

      await controller.loadAttendanceLogs();

      expect(controller.isLoading.value, false);
      verify(() => mockGetAttendanceLogsUsecase(any())).called(1);
    });

    test('empty list', () async {
      when(() => mockGetAttendanceLogsUsecase(any())).thenAnswer(
        (_) async => const Right([]),
      );

      await controller.loadAttendanceLogs();

      expect(controller.attendanceLogs, isEmpty);
    });

    test('with eventId filter', () async {
      when(() => mockGetAttendanceLogsUsecase(any())).thenAnswer(
        (_) async => const Right([]),
      );

      controller.setEventFilter(5);
      await controller.loadAttendanceLogs();

      expect(controller.filterEventId.value, 5);
      verify(() => mockGetAttendanceLogsUsecase(any())).called(1);
    });

    test('sets pagination correctly', () async {
      when(() => mockGetAttendanceLogsUsecase(any())).thenAnswer(
        (_) async => const Right([]),
      );

      await controller.loadAttendanceLogs();

      expect(controller.currentPage.value, 0);
      expect(controller.hasMore.value, true);
    });
  });

  group('loadMore', () {
    test('calls loadAttendanceLogs when hasMore', () async {
      when(() => mockGetAttendanceLogsUsecase(any())).thenAnswer(
        (_) async => const Right([]),
      );

      await controller.loadAttendanceLogs();
      await controller.loadMore();

      verify(() => mockGetAttendanceLogsUsecase(any())).called(greaterThan(1));
    });

    test('does nothing when not hasMore', () async {
      when(() => mockGetAttendanceLogsUsecase(any())).thenAnswer(
        (_) async => const Right([]),
      );

      await controller.loadAttendanceLogs();
      controller.hasMore.value = false;
      await controller.loadMore();

      verify(() => mockGetAttendanceLogsUsecase(any())).called(1);
    });

    test('does nothing when loading', () async {
      when(() => mockGetAttendanceLogsUsecase(any())).thenAnswer(
        (_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return const Right([]);
        },
      );

      controller.loadAttendanceLogs();
      await controller.loadMore();

      verifyNever(() => mockGetAttendanceLogsUsecase(any()));
    });
  });
}
