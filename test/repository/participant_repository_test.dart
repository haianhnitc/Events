import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/feature/participant/data/datasource/participant_datasource.dart';
import 'package:events_app/feature/participant/data/model/participant_model.dart';
import 'package:events_app/feature/participant/data/repository/participant_repository_impl.dart';
import 'package:events_app/feature/participant/domain/usecase/participant_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/fake_data.dart';
import '../helpers/mock_rest_client.dart';

class MockParticipantDatasource extends Mock implements ParticipantDatasource {}

void main() {
  late MockParticipantDatasource mockDatasource;
  late ParticipantRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockParticipantDatasource();
    repository = ParticipantRepositoryImpl(mockDatasource);
  });

  // ─── getMyParticipants ─────────────────────────────────────────────────
  group('getMyParticipants', () {
    test('trả về list ParticipantEntity khi datasource thành công', () async {
      final models = [
        ParticipantModel.fromJson(fakeParticipantJson(id: 1)),
        ParticipantModel.fromJson(fakeParticipantJson(id: 2)),
      ];
      when(() => mockDatasource.getMyParticipants(
            any(),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => successResponse(models));

      final params = GetMyParticipantsParams(userId: 1, page: 0, size: 20);
      final result = await repository.getMyParticipants(params);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entities) {
          expect(entities.length, equals(2));
          expect(entities.first.eventParticipantId, equals(1));
          expect(entities.last.eventParticipantId, equals(2));
        },
      );
    });

    test('trả về FailureEntity khi datasource trả failure', () async {
      when(() => mockDatasource.getMyParticipants(
            any(),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer(
          (_) async => errorResponse<List<ParticipantModel>>(unauthorizedResponse()));

      final params = GetMyParticipantsParams(userId: 1);
      final result = await repository.getMyParticipants(params);

      expect(result.isLeft(), isTrue);
    });

    test('map ParticipantModel sang ParticipantEntity đúng', () async {
      final models = [
        ParticipantModel.fromJson(fakeParticipantJson(id: 10)),
      ];
      when(() => mockDatasource.getMyParticipants(
            any(),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => successResponse(models));

      final params = GetMyParticipantsParams(userId: 1);
      final result = await repository.getMyParticipants(params);

      result.fold(
        (_) => fail('Expected Right'),
        (entities) {
          expect(entities.length, equals(1));
          expect(entities.first.eventParticipantId, equals(10));
          expect(entities.first.eventId, equals(1));
        },
      );
    });
  });

  // ─── getParticipantById ───────────────────────────────────────────────
  group('getParticipantById', () {
    test('trả về ParticipantEntity khi datasource thành công', () async {
      final model = ParticipantModel.fromJson(fakeParticipantJson(id: 42));
      when(() => mockDatasource.getParticipantById(42))
          .thenAnswer((_) async => successResponse(model));

      final result = await repository.getParticipantById(42);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) {
          expect(entity.eventParticipantId, equals(42));
          expect(entity.eventId, equals(1));
        },
      );
    });

    test('trả về FailureEntity khi datasource trả notFound', () async {
      when(() => mockDatasource.getParticipantById(9999))
          .thenAnswer((_) async => errorResponse<ParticipantModel>(notFoundResponse()));

      final result = await repository.getParticipantById(9999);

      expect(result.isLeft(), isTrue);
    });

    test('trả về FailureEntity khi datasource trả responseParsing', () async {
      when(() => mockDatasource.getParticipantById(1))
          .thenAnswer((_) async => const ApiResponse.responseParsing());

      final result = await repository.getParticipantById(1);

      expect(result.isLeft(), isTrue);
    });
  });
}
