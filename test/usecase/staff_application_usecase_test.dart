import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/staff_application/domain/entity/staff_application_entity.dart';
import 'package:events_app/feature/staff_application/domain/repository/staff_application_repository.dart';
import 'package:events_app/feature/staff_application/domain/usecase/apply_ctv_params.dart';
import 'package:events_app/feature/staff_application/domain/usecase/staff_application_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockStaffApplicationRepository extends Mock
    implements StaffApplicationRepository {}

class FakeApplyCtvParams extends Fake implements ApplyCtvParams {}

void main() {
  late MockStaffApplicationRepository mockRepository;
  late CreateStaffApplicationUsecase createStaffApplicationUsecase;
  late GetStaffApplicationByIdUsecase getStaffApplicationByIdUsecase;

  setUpAll(() {
    registerFallbackValue(FakeApplyCtvParams());
  });

  setUp(() {
    mockRepository = MockStaffApplicationRepository();
    createStaffApplicationUsecase =
        CreateStaffApplicationUsecase(mockRepository);
    getStaffApplicationByIdUsecase =
        GetStaffApplicationByIdUsecase(mockRepository);
  });

  group('CreateStaffApplicationUsecase', () {
    test('trả về StaffApplicationEntity khi repository thành công', () async {
      final entity = StaffApplicationEntity(
        applicationId: 5,
        roleName: 'Tình nguyện viên',
      );
      when(() => mockRepository.createApplication(any()))
          .thenAnswer((_) async => Right(entity));

      const params = ApplyCtvParams(eventId: 1, answers: []);
      final result = await createStaffApplicationUsecase(params);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (application) => expect(application.applicationId, equals(5)),
      );
    });

    test('trả về Left khi repository trả conflict', () async {
      when(() => mockRepository.createApplication(any())).thenAnswer(
          (_) async =>
              const Left(FailureEntity.serverFailure('409', 'Conflict')));

      const params = ApplyCtvParams(eventId: 1, answers: []);
      final result = await createStaffApplicationUsecase(params);

      expect(result.isLeft(), isTrue);
    });

    test('trả về Left khi repository thất bại', () async {
      when(() => mockRepository.createApplication(any())).thenAnswer(
          (_) async =>
              const Left(FailureEntity.serverFailure('500', 'Server error')));

      const params = ApplyCtvParams(eventId: 1, answers: []);
      final result = await createStaffApplicationUsecase(params);

      expect(result.isLeft(), isTrue);
    });
  });

  group('GetStaffApplicationByIdUsecase', () {
    test('trả về StaffApplicationEntity khi repository thành công', () async {
      final entity = StaffApplicationEntity(
        applicationId: 10,
        eventTitle: 'Test Event',
      );
      when(() => mockRepository.getApplicationById(any()))
          .thenAnswer((_) async => Right(entity));

      final result = await getStaffApplicationByIdUsecase(10);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (application) => expect(application.applicationId, equals(10)),
      );
    });

    test('trả về Left khi repository trả notFound', () async {
      when(() => mockRepository.getApplicationById(any())).thenAnswer(
          (_) async =>
              const Left(FailureEntity.serverFailure('404', 'Not found')));

      final result = await getStaffApplicationByIdUsecase(9999);

      expect(result.isLeft(), isTrue);
    });
  });
}
