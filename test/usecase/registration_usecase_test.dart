import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';
import 'package:events_app/feature/registration/domain/repository/registration_repository.dart';
import 'package:events_app/feature/registration/domain/usecase/registration_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRegistrationRepository extends Mock
    implements RegistrationRepository {}

class FakeCreateRegistrationParams extends Fake
    implements CreateRegistrationParams {}

class FakeGetMyRegistrationsParams extends Fake
    implements GetMyRegistrationsParams {}

void main() {
  late MockRegistrationRepository mockRepository;
  late CreateRegistrationUsecase createRegistrationUsecase;
  late GetMyRegistrationsUsecase getMyRegistrationsUsecase;
  late GetRegistrationByIdUsecase getRegistrationByIdUsecase;
  late CancelRegistrationUsecase cancelRegistrationUsecase;

  setUpAll(() {
    registerFallbackValue(FakeCreateRegistrationParams());
    registerFallbackValue(FakeGetMyRegistrationsParams());
  });

  setUp(() {
    mockRepository = MockRegistrationRepository();
    createRegistrationUsecase = CreateRegistrationUsecase(mockRepository);
    getMyRegistrationsUsecase = GetMyRegistrationsUsecase(mockRepository);
    getRegistrationByIdUsecase = GetRegistrationByIdUsecase(mockRepository);
    cancelRegistrationUsecase = CancelRegistrationUsecase(mockRepository);
  });

  group('CreateRegistrationUsecase', () {
    test('trả về ParticipantEntity khi repository thành công', () async {
      final entity = ParticipantEntity(eventParticipantId: 100);
      when(() => mockRepository.createRegistration(any()))
          .thenAnswer((_) async => Right(entity));

      final result = await createRegistrationUsecase(
        const CreateRegistrationParams(eventId: 1),
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (participant) => expect(participant.eventParticipantId, equals(100)),
      );
    });

    test('trả về failure khi repository trả conflict', () async {
      when(() => mockRepository.createRegistration(any())).thenAnswer(
          (_) async => const Left(FailureEntity.serverFailure('409', 'Already registered')));

      final result = await createRegistrationUsecase(
        const CreateRegistrationParams(eventId: 1),
      );

      expect(result.isLeft(), isTrue);
    });

    test('trả về failure khi repository trả notFound', () async {
      when(() => mockRepository.createRegistration(any())).thenAnswer(
          (_) async => const Left(FailureEntity.serverFailure('404', 'Event not found')));

      final result = await createRegistrationUsecase(
        const CreateRegistrationParams(eventId: 9999),
      );

      expect(result.isLeft(), isTrue);
    });
  });

  group('GetMyRegistrationsUsecase', () {
    test('trả về list ParticipantEntity khi repository thành công', () async {
      final entities = [
        ParticipantEntity(eventParticipantId: 1),
        ParticipantEntity(eventParticipantId: 2),
      ];
      when(() => mockRepository.getMyRegistrations(
            any(),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => Right(entities));

      final result = await getMyRegistrationsUsecase(
        const GetMyRegistrationsParams(userId: 42),
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (participants) {
          expect(participants.length, equals(2));
        },
      );
    });

    test('trả về empty list khi repository trả rỗng', () async {
      when(() => mockRepository.getMyRegistrations(
            any(),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => const Right([]));

      final result = await getMyRegistrationsUsecase(
        const GetMyRegistrationsParams(userId: 42),
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (participants) => expect(participants, isEmpty),
      );
    });

    test('trả về failure khi repository thất bại', () async {
      when(() => mockRepository.getMyRegistrations(
            any(),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async =>
              const Left(FailureEntity.serverFailure('500', 'Server error')));

      final result = await getMyRegistrationsUsecase(
        const GetMyRegistrationsParams(userId: 42),
      );

      expect(result.isLeft(), isTrue);
    });
  });

  group('CancelRegistrationUsecase', () {
    test('trả về Right(unit) khi repository thành công', () async {
      when(() => mockRepository.cancelRegistration(any()))
          .thenAnswer((_) async => const Right(unit));

      final result = await cancelRegistrationUsecase(50);

      expect(result.isRight(), isTrue);
    });

    test('trả về failure khi repository trả notFound', () async {
      when(() => mockRepository.cancelRegistration(any())).thenAnswer(
          (_) async => const Left(FailureEntity.serverFailure('404', 'Not found')));

      final result = await cancelRegistrationUsecase(9999);

      expect(result.isLeft(), isTrue);
    });
  });
}
