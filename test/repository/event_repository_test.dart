import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/feature/event_management/data/datasource/event_datasource.dart';
import 'package:events_app/feature/event_management/data/model/event_model.dart';
import 'package:events_app/feature/event_management/data/model/event_summary_model.dart';
import 'package:events_app/feature/event_management/data/repository/event_repository_impl.dart';
import 'package:events_app/feature/event_management/domain/entity/event_entity.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/fake_data.dart';
import '../helpers/mock_rest_client.dart';

class MockEventDatasource extends Mock implements EventDatasource {}

void main() {
  late MockEventDatasource mockDatasource;
  late EventRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockEventDatasource();
    repository = EventRepositoryImpl(mockDatasource);
  });

  // ─── getEvents ───────────────────────────────────────────────────────────
  group('getEvents', () {
    test('trả về list EventSummaryEntity khi datasource thành công', () async {
      final models = [
        EventSummaryModel.fromJson(fakeEventSummaryJson(id: 1)),
        EventSummaryModel.fromJson(fakeEventSummaryJson(id: 2)),
      ];
      when(() => mockDatasource.getEvents(
            categoryId: any(named: 'categoryId'),
            status: any(named: 'status'),
            page: any(named: 'page'),
            size: any(named: 'size'),
            keyword: any(named: 'keyword'),
          )).thenAnswer((_) async => successResponse(models));

      final result = await repository.getEvents(page: 0, size: 20);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entities) {
          expect(entities.length, equals(2));
          expect(entities.first.eventId, equals(1));
          expect(entities.last.eventId, equals(2));
        },
      );
    });

    test('trả về empty list khi datasource trả content rỗng', () async {
      when(() => mockDatasource.getEvents(
            categoryId: any(named: 'categoryId'),
            status: any(named: 'status'),
            page: any(named: 'page'),
            size: any(named: 'size'),
            keyword: any(named: 'keyword'),
          )).thenAnswer((_) async => successResponse<List<EventSummaryModel>>([]));

      final result = await repository.getEvents(page: 0, size: 20);

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('Expected Right'), (entities) {
        expect(entities, isEmpty);
      });
    });

    test('trả về FailureEntity khi datasource trả failure', () async {
      when(() => mockDatasource.getEvents(
            categoryId: any(named: 'categoryId'),
            status: any(named: 'status'),
            page: any(named: 'page'),
            size: any(named: 'size'),
            keyword: any(named: 'keyword'),
          )).thenAnswer(
          (_) async => errorResponse<List<EventSummaryModel>>(serverErrorResponse()));

      final result = await repository.getEvents(page: 0, size: 20);

      expect(result.isLeft(), isTrue);
    });

    test('map models sang entities đúng', () async {
      final models = [
        EventSummaryModel.fromJson(fakeEventSummaryJson(id: 10)),
      ];
      when(() => mockDatasource.getEvents(
            categoryId: any(named: 'categoryId'),
            status: any(named: 'status'),
            page: any(named: 'page'),
            size: any(named: 'size'),
            keyword: any(named: 'keyword'),
          )).thenAnswer((_) async => successResponse(models));

      final result = await repository.getEvents(page: 0, size: 20);

      result.fold(
        (_) => fail('Expected Right'),
        (entities) {
          expect(entities.length, equals(1));
          expect(entities.first.eventId, equals(10));
          expect(entities.first.title, equals('Event 10'));
        },
      );
    });
  });

  // ─── getFeaturedEvents ─────────────────────────────────────────────────
  group('getFeaturedEvents', () {
    test('trả về list EventSummaryEntity khi datasource thành công', () async {
      final models = [
        EventSummaryModel.fromJson(fakeEventSummaryJson(id: 1)),
      ];
      when(() => mockDatasource.getFeaturedEvents())
          .thenAnswer((_) async => successResponse(models));

      final result = await repository.getFeaturedEvents();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entities) {
          expect(entities.length, equals(1));
          expect(entities.first.eventId, equals(1));
        },
      );
    });

    test('trả về FailureEntity khi datasource trả failure', () async {
      when(() => mockDatasource.getFeaturedEvents())
          .thenAnswer((_) async => errorResponse<List<EventSummaryModel>>(notFoundResponse()));

      final result = await repository.getFeaturedEvents();

      expect(result.isLeft(), isTrue);
    });
  });

  // ─── getEventById ──────────────────────────────────────────────────────
  group('getEventById', () {
    test('trả về EventEntity khi datasource thành công', () async {
      final model = EventModel.fromJson(fakeEventJson(id: 99));
      when(() => mockDatasource.getEventById(99))
          .thenAnswer((_) async => successResponse(model));

      final result = await repository.getEventById(99);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) {
          expect(entity.eventId, equals(99));
          expect(entity.title, equals('Event 99'));
        },
      );
    });

    test('trả về FailureEntity khi datasource trả notFound', () async {
      when(() => mockDatasource.getEventById(9999))
          .thenAnswer((_) async => errorResponse<EventModel>(notFoundResponse()));

      final result = await repository.getEventById(9999);

      expect(result.isLeft(), isTrue);
    });

    test('trả về FailureEntity dataParsingFailure khi datasource trả responseParsing', () async {
      when(() => mockDatasource.getEventById(1))
          .thenAnswer((_) async => const ApiResponse.responseParsing());

      final result = await repository.getEventById(1);

      expect(result.isLeft(), isTrue);
    });
  });
}
