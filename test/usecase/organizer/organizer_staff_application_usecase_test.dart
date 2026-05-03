import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/organizer/staff_application/domain/repository/organizer_staff_application_repository.dart';
import 'package:events_app/feature/organizer/staff_application/domain/usecase/organizer_staff_application_usecase.dart';
import 'package:events_app/feature/organizer/staff_application/domain/usecase/organizer_staff_application_params.dart';
import 'package:events_app/feature/staff_application/domain/entity/staff_application_entity.dart';

class MockOrganizerStaffApplicationRepository extends Mock
    implements OrganizerStaffApplicationRepository {}

void main() {
  late MockOrganizerStaffApplicationRepository mockRepository;

  setUp(() {
    mockRepository = MockOrganizerStaffApplicationRepository();
  });

  setUpAll(() {
    registerFallbackValue(GetOrganizerStaffApplicationsParams(
      eventId: null,
      keyword: null,
      status: null,
      page: 0,
      size: 20,
    ));
    registerFallbackValue(ApproveStaffApplicationParams(
      applicationId: 1,
      isApproved: true,
    ));
  });

  group('GetOrganizerStaffApplicationsUsecase', () {
    late GetOrganizerStaffApplicationsUsecase usecase;

    setUp(() {
      usecase = GetOrganizerStaffApplicationsUsecase(mockRepository);
    });

    test('success', () async {
      when(() => mockRepository.getStaffApplications(any())).thenAnswer(
        (_) async => Right(<StaffApplicationEntity>[]),
      );

      final params = GetOrganizerStaffApplicationsParams(
        eventId: null,
        keyword: null,
        status: null,
        page: 0,
        size: 20,
      );
      final result = await usecase(params);

      expect(result.isRight(), true);
    });

    test('empty', () async {
      when(() => mockRepository.getStaffApplications(any())).thenAnswer(
        (_) async => const Right([]),
      );

      final params = GetOrganizerStaffApplicationsParams(
        eventId: null,
        keyword: null,
        status: null,
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

    test('with status filter', () async {
      when(() => mockRepository.getStaffApplications(any())).thenAnswer(
        (_) async => Right(<StaffApplicationEntity>[]),
      );

      final params = GetOrganizerStaffApplicationsParams(
        eventId: null,
        keyword: null,
        status: null,
        page: 0,
        size: 20,
      );
      await usecase(params);

      verify(() => mockRepository.getStaffApplications(any())).called(1);
    });
  });

  group('GetOrganizerStaffApplicationByIdUsecase', () {
    late GetOrganizerStaffApplicationByIdUsecase usecase;

    setUp(() {
      usecase = GetOrganizerStaffApplicationByIdUsecase(mockRepository);
    });

    test('success', () async {
      when(() => mockRepository.getStaffApplicationById(any())).thenAnswer(
        (_) async => Right(StaffApplicationEntity()),
      );

      final result = await usecase(1);

      expect(result.isRight(), true);
    });

    test('404 returns Left', () async {
      when(() => mockRepository.getStaffApplicationById(any())).thenAnswer(
        (_) async => Left(FailureEntity.serverFailure('404', 'Not found')),
      );

      final result = await usecase(999);

      expect(result.isLeft(), true);
    });
  });

  group('ApproveStaffApplicationUsecase', () {
    late ApproveStaffApplicationUsecase usecase;

    setUp(() {
      usecase = ApproveStaffApplicationUsecase(mockRepository);
    });

    test('approve success', () async {
      when(() => mockRepository.approveStaffApplication(any())).thenAnswer(
        (_) async => Right(StaffApplicationEntity()),
      );

      final params = ApproveStaffApplicationParams(
        applicationId: 1,
        isApproved: true,
      );
      final result = await usecase(params);

      expect(result.isRight(), true);
    });

    test('reject success', () async {
      when(() => mockRepository.approveStaffApplication(any())).thenAnswer(
        (_) async => Right(StaffApplicationEntity()),
      );

      final params = ApproveStaffApplicationParams(
        applicationId: 1,
        isApproved: false,
        feedback: 'Better luck next time',
      );
      final result = await usecase(params);

      expect(result.isRight(), true);
    });

    test('404 returns Left', () async {
      when(() => mockRepository.approveStaffApplication(any())).thenAnswer(
        (_) async => Left(FailureEntity.serverFailure('404', 'Not found')),
      );

      final params = ApproveStaffApplicationParams(
        applicationId: 999,
        isApproved: true,
      );
      final result = await usecase(params);

      expect(result.isLeft(), true);
    });
  });
}
