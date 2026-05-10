import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/organizer/recruitment/domain/repository/organizer_recruitment_repository.dart';
import 'package:events_app/feature/organizer/recruitment/domain/usecase/organizer_recruitment_params.dart';
import 'package:events_app/feature/organizer/recruitment/domain/usecase/organizer_recruitment_usecase.dart';
import 'package:events_app/feature/recruitment/domain/entity/ctv_recruitment_entity.dart';

class MockOrganizerRecruitmentRepository extends Mock
    implements OrganizerRecruitmentRepository {}

void main() {
  late MockOrganizerRecruitmentRepository mockRepository;

  setUp(() {
    mockRepository = MockOrganizerRecruitmentRepository();
  });

  setUpAll(() {
    registerFallbackValue(const CreateRecruitmentParams(eventId: 1));
    registerFallbackValue(const UpdateRecruitmentParams());
    registerFallbackValue(const UpdateRecruitmentParamsWrapper(
        id: 1, params: UpdateRecruitmentParams()));
  });

  group('GetOrganizerRecruitmentsUsecase', () {
    late GetOrganizerRecruitmentsUsecase usecase;

    setUp(() {
      usecase = GetOrganizerRecruitmentsUsecase(mockRepository);
    });

    test('success', () async {
      when(() => mockRepository.getRecruitments(
            eventId: any(named: 'eventId'),
            keyword: any(named: 'keyword'),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer(
        (_) async => const Right(<CtvRecruitmentEntity>[]),
      );

      const params = GetOrganizerRecruitmentsParams(
        eventId: null,
        keyword: null,
        page: 0,
        size: 20,
      );
      final result = await usecase(params);

      expect(result.isRight(), true);
    });

    test('empty', () async {
      when(() => mockRepository.getRecruitments(
            eventId: any(named: 'eventId'),
            keyword: any(named: 'keyword'),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer(
        (_) async => const Right([]),
      );

      const params = GetOrganizerRecruitmentsParams(
        eventId: null,
        keyword: null,
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

    test('with eventId filter', () async {
      when(() => mockRepository.getRecruitments(
            eventId: any(named: 'eventId'),
            keyword: any(named: 'keyword'),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer(
        (_) async => const Right(<CtvRecruitmentEntity>[]),
      );

      const params = GetOrganizerRecruitmentsParams(
        eventId: 5,
        keyword: null,
        page: 0,
        size: 20,
      );
      await usecase(params);

      verify(() => mockRepository.getRecruitments(
            eventId: 5,
            keyword: null,
            page: 0,
            size: 20,
          )).called(1);
    });
  });

  group('GetOrganizerRecruitmentByIdUsecase', () {
    late GetOrganizerRecruitmentByIdUsecase usecase;

    setUp(() {
      usecase = GetOrganizerRecruitmentByIdUsecase(mockRepository);
    });

    test('success', () async {
      when(() => mockRepository.getRecruitmentById(any())).thenAnswer(
        (_) async => Right(CtvRecruitmentEntity()),
      );

      final result = await usecase(1);

      expect(result.isRight(), true);
    });

    test('404 returns Left', () async {
      when(() => mockRepository.getRecruitmentById(any())).thenAnswer(
        (_) async =>
            const Left(FailureEntity.serverFailure('404', 'Not found')),
      );

      final result = await usecase(999);

      expect(result.isLeft(), true);
    });
  });

  group('CreateOrganizerRecruitmentUsecase', () {
    late CreateOrganizerRecruitmentUsecase usecase;

    setUp(() {
      usecase = CreateOrganizerRecruitmentUsecase(mockRepository);
    });

    test('success', () async {
      when(() => mockRepository.createRecruitment(any())).thenAnswer(
        (_) async => Right(CtvRecruitmentEntity()),
      );

      const params = CreateRecruitmentParams(
        eventId: 1,
        title: 'Volunteer',
      );
      final result = await usecase(params);

      expect(result.isRight(), true);
    });

    test('400 returns Left', () async {
      when(() => mockRepository.createRecruitment(any())).thenAnswer(
        (_) async => const Left(FailureEntity.serverFailure('400', 'Invalid')),
      );

      const params = CreateRecruitmentParams(eventId: 1, title: '');
      final result = await usecase(params);

      expect(result.isLeft(), true);
    });
  });

  group('UpdateOrganizerRecruitmentUsecase', () {
    late UpdateOrganizerRecruitmentUsecase usecase;

    setUp(() {
      usecase = UpdateOrganizerRecruitmentUsecase(mockRepository);
    });

    test('success', () async {
      when(() => mockRepository.updateRecruitment(any(), any())).thenAnswer(
        (_) async => Right(CtvRecruitmentEntity()),
      );

      const params = UpdateRecruitmentParams(title: 'Updated');
      final wrapper = UpdateRecruitmentParamsWrapper(id: 1, params: params);
      final result = await usecase(wrapper);

      expect(result.isRight(), true);
    });
  });

  group('CloseOrganizerRecruitmentUsecase', () {
    late CloseOrganizerRecruitmentUsecase usecase;

    setUp(() {
      usecase = CloseOrganizerRecruitmentUsecase(mockRepository);
    });

    test('success returns Right(unit)', () async {
      when(() => mockRepository.closeRecruitment(any())).thenAnswer(
        (_) async => const Right(unit),
      );

      final result = await usecase(1);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not return Left'),
        (r) => expect(r, unit),
      );
    });

    test('404 returns Left', () async {
      when(() => mockRepository.closeRecruitment(any())).thenAnswer(
        (_) async =>
            const Left(FailureEntity.serverFailure('404', 'Not found')),
      );

      final result = await usecase(999);

      expect(result.isLeft(), true);
    });
  });

  group('DeleteOrganizerRecruitmentUsecase', () {
    late DeleteOrganizerRecruitmentUsecase usecase;

    setUp(() {
      usecase = DeleteOrganizerRecruitmentUsecase(mockRepository);
    });

    test('success returns Right(unit)', () async {
      when(() => mockRepository.deleteRecruitment(any())).thenAnswer(
        (_) async => const Right(unit),
      );

      final result = await usecase(1);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not return Left'),
        (r) => expect(r, unit),
      );
    });
  });
}
