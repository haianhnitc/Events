import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/organizer/organization/domain/repository/organizer_organization_repository.dart';
import 'package:events_app/feature/organizer/organization/domain/usecase/organizer_organization_usecase.dart';
import 'package:events_app/feature/user_management/domain/entity/organization_profile_entity.dart';
import 'package:events_app/feature/user_management/domain/entity/organization_dashboard_entity.dart';
import 'package:events_app/feature/organizer/organization/domain/usecase/organization_params.dart';

class FakeOrganizationProfileUpdateParams extends Fake
    implements OrganizationProfileUpdateParams {}

class MockOrganizerOrganizationRepository extends Mock
    implements OrganizerOrganizationRepository {}

void main() {
  late MockOrganizerOrganizationRepository mockRepository;

  setUp(() {
    mockRepository = MockOrganizerOrganizationRepository();
  });

  setUpAll(() {
    registerFallbackValue(FakeOrganizationProfileUpdateParams());
    registerFallbackValue(const UpdateOrganizerProfileParams(
        organizationId: 1, params: OrganizationProfileUpdateParams()));
  });

  group('UpdateOrganizerProfileUsecase', () {
    late UpdateOrganizerProfileUsecase usecase;

    setUp(() {
      usecase = UpdateOrganizerProfileUsecase(mockRepository);
    });

    test('success', () async {
      when(() => mockRepository.updateProfile(any(), any())).thenAnswer(
        (_) async => Right(OrganizationProfileEntity()),
      );

      const params = UpdateOrganizerProfileParams(
        organizationId: 1,
        params: OrganizationProfileUpdateParams(
            organizationName: 'Updated Org'),
      );
      final result = await usecase(params);

      expect(result.isRight(), true);
    });

    test('400 returns Left', () async {
      when(() => mockRepository.updateProfile(any(), any())).thenAnswer(
        (_) async =>
            const Left(FailureEntity.serverFailure('400', 'Invalid data')),
      );

      const params = UpdateOrganizerProfileParams(
        organizationId: 1,
        params: OrganizationProfileUpdateParams(organizationName: ''),
      );
      final result = await usecase(params);

      expect(result.isLeft(), true);
    });
  });

  group('GetOrganizerDashboardUsecase', () {
    late GetOrganizerDashboardUsecase usecase;

    setUp(() {
      usecase = GetOrganizerDashboardUsecase(mockRepository);
    });

    test('success', () async {
      when(() => mockRepository.getDashboard(any())).thenAnswer(
        (_) async => Right(OrganizationDashboardEntity()),
      );

      final result = await usecase(1);

      expect(result.isRight(), true);
    });

    test('401 returns Left', () async {
      when(() => mockRepository.getDashboard(any())).thenAnswer(
        (_) async =>
            const Left(FailureEntity.serverFailure('401', 'Unauthorized')),
      );

      final result = await usecase(1);

      expect(result.isLeft(), true);
    });
  });
}
