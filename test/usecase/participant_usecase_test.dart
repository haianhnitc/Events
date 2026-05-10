import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';
import 'package:events_app/feature/participant/domain/repository/participant_repository.dart';
import 'package:events_app/feature/participant/domain/usecase/participant_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockParticipantRepository extends Mock implements ParticipantRepository {}

class FakeGetMyParticipantsParams extends Fake
    implements GetMyParticipantsParams {}

void main() {
  late MockParticipantRepository mockRepository;
  late GetMyParticipantsUsecase getMyParticipantsUsecase;
  late GetParticipantByIdUsecase getParticipantByIdUsecase;

  setUpAll(() {
    registerFallbackValue(FakeGetMyParticipantsParams());
    registerFallbackValue(0);
  });

  setUp(() {
    mockRepository = MockParticipantRepository();
    getMyParticipantsUsecase = GetMyParticipantsUsecase(mockRepository);
    getParticipantByIdUsecase = GetParticipantByIdUsecase(mockRepository);
  });

  // ─── GetMyParticipantsUsecase ────────────────────────────────────────
  group('GetMyParticipantsUsecase', () {
    test('trả về list ParticipantEntity khi repository thành công', () async {
      final entities = [
        ParticipantEntity(eventParticipantId: 1, eventId: 10),
        ParticipantEntity(eventParticipantId: 2, eventId: 20),
      ];
      when(() => mockRepository.getMyParticipants(any()))
          .thenAnswer((_) async => Right(entities));

      const params = GetMyParticipantsParams(userId: 1, page: 0, size: 20);
      final result = await getMyParticipantsUsecase(params);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (participants) {
          expect(participants.length, equals(2));
          expect(participants.first.eventParticipantId, equals(1));
        },
      );
      verify(() => mockRepository.getMyParticipants(params)).called(1);
    });

    test('trả về empty list khi repository trả rỗng', () async {
      when(() => mockRepository.getMyParticipants(any()))
          .thenAnswer((_) async => const Right([]));

      const params = GetMyParticipantsParams(userId: 1);
      final result = await getMyParticipantsUsecase(params);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (participants) => expect(participants, isEmpty),
      );
    });

    test('trả về failure khi repository thất bại', () async {
      when(() => mockRepository.getMyParticipants(any())).thenAnswer(
          (_) async =>
              const Left(FailureEntity.serverFailure('500', 'Server error')));

      const params = GetMyParticipantsParams(userId: 1);
      final result = await getMyParticipantsUsecase(params);

      expect(result.isLeft(), isTrue);
    });
  });

  // ─── GetParticipantByIdUsecase ─────────────────────────────────────
  group('GetParticipantByIdUsecase', () {
    test('trả về ParticipantEntity khi repository thành công', () async {
      final entity = ParticipantEntity(eventParticipantId: 42, eventId: 10);
      when(() => mockRepository.getParticipantById(42))
          .thenAnswer((_) async => Right(entity));

      final result = await getParticipantByIdUsecase(42);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (participant) {
          expect(participant.eventParticipantId, equals(42));
          expect(participant.eventId, equals(10));
        },
      );
    });

    test('trả về failure khi repository trả notFound', () async {
      when(() => mockRepository.getParticipantById(9999)).thenAnswer(
          (_) async =>
              const Left(FailureEntity.serverFailure('404', 'Not found')));

      final result = await getParticipantByIdUsecase(9999);

      expect(result.isLeft(), isTrue);
    });
  });
}
