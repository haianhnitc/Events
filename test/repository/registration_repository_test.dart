import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/participant/data/model/participant_model.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';
import 'package:events_app/feature/registration/data/datasource/registration_datasource.dart';
import 'package:events_app/feature/registration/data/repository/registration_repository_impl.dart';
import 'package:events_app/feature/registration/domain/usecase/registration_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/fake_data.dart';
import '../helpers/mock_rest_client.dart';

class MockRegistrationDatasource extends Mock
    implements RegistrationDatasource {}

class FakeCreateRegistrationParams extends Fake
    implements CreateRegistrationParams {}

void main() {
  late MockRegistrationDatasource mockDatasource;
  late RegistrationRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(FakeCreateRegistrationParams());
  });

  setUp(() {
    mockDatasource = MockRegistrationDatasource();
    repository = RegistrationRepositoryImpl(mockDatasource);
  });

  group('createRegistration', () {
    test('trả về ParticipantEntity khi datasource trả success', () async {
      final model = ParticipantModel.fromJson(fakeParticipantJson(id: 100));
      const params = CreateRegistrationParams(eventId: 1);
      when(() => mockDatasource.createRegistration(any()))
          .thenAnswer((_) async => successResponse(model));

      final result = await repository.createRegistration(params);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) {
          expect(entity, isA<ParticipantEntity>());
          expect(entity.eventParticipantId, equals(100));
        },
      );
    });

    test('trả về Left khi datasource trả conflict', () async {
      const params = CreateRegistrationParams(eventId: 1);
      when(() => mockDatasource.createRegistration(any())).thenAnswer(
          (_) async => errorResponse<ParticipantModel>(conflictResponse()));

      final result = await repository.createRegistration(params);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<FailureEntity>());
        },
        (_) => fail('Expected Left'),
      );
    });

    test('trả về Left khi datasource trả notFound', () async {
      const params = CreateRegistrationParams(eventId: 9999);
      when(() => mockDatasource.createRegistration(any())).thenAnswer(
          (_) async => errorResponse<ParticipantModel>(notFoundResponse()));

      final result = await repository.createRegistration(params);

      expect(result.isLeft(), isTrue);
    });
  });

  group('getMyRegistrations', () {
    test('trả về list ParticipantEntity khi datasource trả success', () async {
      final models = [
        ParticipantModel.fromJson(fakeParticipantJson(id: 1)),
        ParticipantModel.fromJson(fakeParticipantJson(id: 2)),
      ];
      when(() => mockDatasource.getMyRegistrations(
            any(),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => successResponse(models));

      final result = await repository.getMyRegistrations(42);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entities) {
          expect(entities.length, equals(2));
          expect(entities.first.eventParticipantId, equals(1));
        },
      );
    });

    test('trả về empty list khi datasource trả success với content rỗng',
        () async {
      when(() => mockDatasource.getMyRegistrations(
                any(),
                page: any(named: 'page'),
                size: any(named: 'size'),
              ))
          .thenAnswer((_) async => successResponse<List<ParticipantModel>>([]));

      final result = await repository.getMyRegistrations(42);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entities) => expect(entities, isEmpty),
      );
    });
  });

  group('getRegistrationById', () {
    test('trả về ParticipantEntity khi datasource trả success', () async {
      final model = ParticipantModel.fromJson(fakeParticipantJson(id: 50));
      when(() => mockDatasource.getRegistrationById(50))
          .thenAnswer((_) async => successResponse(model));

      final result = await repository.getRegistrationById(50);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) => expect(entity.eventParticipantId, equals(50)),
      );
    });

    test('trả về Left khi datasource trả notFound', () async {
      when(() => mockDatasource.getRegistrationById(9999)).thenAnswer(
          (_) async => errorResponse<ParticipantModel>(notFoundResponse()));

      final result = await repository.getRegistrationById(9999);

      expect(result.isLeft(), isTrue);
    });
  });

  group('cancelRegistration', () {
    test('trả về Right(unit) khi datasource trả success', () async {
      when(() => mockDatasource.cancelRegistration(50))
          .thenAnswer((_) async => successResponse<void>(null));

      final result = await repository.cancelRegistration(50);

      expect(result.isRight(), isTrue);
    });

    test('trả về Left khi datasource trả notFound', () async {
      when(() => mockDatasource.cancelRegistration(9999))
          .thenAnswer((_) async => errorResponse<void>(notFoundResponse()));

      final result = await repository.cancelRegistration(9999);

      expect(result.isLeft(), isTrue);
    });
  });
}
