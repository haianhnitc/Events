import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/event_management/domain/entity/event_entity.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/event_management/domain/repository/event_repository.dart';
import 'package:events_app/feature/event_management/domain/usecase/get_event_by_id_usecase.dart';
import 'package:events_app/feature/event_management/domain/usecase/get_events_usecase.dart';
import 'package:events_app/feature/event_management/domain/usecase/get_featured_events_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEventRepository extends Mock implements EventRepository {}

class FakeGetEventsParams extends Fake implements GetEventsParams {}

void main() {
  late MockEventRepository mockRepository;
  late GetEventsUsecase getEventsUsecase;
  late GetFeaturedEventsUsecase getFeaturedEventsUsecase;
  late GetEventByIdUsecase getEventByIdUsecase;

  setUpAll(() {
    registerFallbackValue(FakeGetEventsParams());
    registerFallbackValue(0);
  });

  setUp(() {
    mockRepository = MockEventRepository();
    getEventsUsecase = GetEventsUsecase(mockRepository);
    getFeaturedEventsUsecase = GetFeaturedEventsUsecase(mockRepository);
    getEventByIdUsecase = GetEventByIdUsecase(mockRepository);
  });

  // ─── GetEventsUsecase ─────────────────────────────────────────────────
  group('GetEventsUsecase', () {
    test('trả về list EventSummaryEntity khi repository thành công', () async {
      final entities = [
        EventSummaryEntity(eventId: 1, title: 'Event 1'),
        EventSummaryEntity(eventId: 2, title: 'Event 2'),
      ];
      when(() => mockRepository.getEvents(
            categoryId: any(named: 'categoryId'),
            status: any(named: 'status'),
            page: any(named: 'page'),
            size: any(named: 'size'),
            keyword: any(named: 'keyword'),
          )).thenAnswer((_) async => Right(entities));

      final result = await getEventsUsecase(const GetEventsParams(
        categoryId: 1,
        status: 2,
        page: 0,
        size: 20,
        keyword: 'test',
      ));

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (events) {
          expect(events.length, equals(2));
          expect(events.first.eventId, equals(1));
        },
      );
      verify(() => mockRepository.getEvents(
            categoryId: 1,
            status: 2,
            page: 0,
            size: 20,
            keyword: 'test',
          )).called(1);
    });

    test('trả về empty list khi repository trả rỗng', () async {
      when(() => mockRepository.getEvents(
            categoryId: any(named: 'categoryId'),
            status: any(named: 'status'),
            page: any(named: 'page'),
            size: any(named: 'size'),
            keyword: any(named: 'keyword'),
          )).thenAnswer((_) async => const Right([]));

      final result = await getEventsUsecase(const GetEventsParams());

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (events) => expect(events, isEmpty),
      );
    });

    test('trả về failure khi repository thất bại', () async {
      when(() => mockRepository.getEvents(
            categoryId: any(named: 'categoryId'),
            status: any(named: 'status'),
            page: any(named: 'page'),
            size: any(named: 'size'),
            keyword: any(named: 'keyword'),
          )).thenAnswer((_) async =>
              const Left(FailureEntity.serverFailure('500', 'Server error')));

      final result = await getEventsUsecase(const GetEventsParams());

      expect(result.isLeft(), isTrue);
    });
  });

  // ─── GetFeaturedEventsUsecase ─────────────────────────────────────────
  group('GetFeaturedEventsUsecase', () {
    test('trả về list EventSummaryEntity khi repository thành công', () async {
      final entities = [
        EventSummaryEntity(eventId: 1, title: 'Featured Event'),
      ];
      when(() => mockRepository.getFeaturedEvents())
          .thenAnswer((_) async => Right(entities));

      final result = await getFeaturedEventsUsecase();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (events) {
          expect(events.length, equals(1));
          expect(events.first.eventId, equals(1));
        },
      );
    });

    test('trả về failure khi repository thất bại', () async {
      when(() => mockRepository.getFeaturedEvents())
          .thenAnswer((_) async =>
              const Left(FailureEntity.serverFailure('500', 'Server error')));

      final result = await getFeaturedEventsUsecase();

      expect(result.isLeft(), isTrue);
    });
  });

  // ─── GetEventByIdUsecase ─────────────────────────────────────────────
  group('GetEventByIdUsecase', () {
    test('trả về EventEntity khi repository thành công', () async {
      final entity = EventEntity(eventId: 99, title: 'Event 99');
      when(() => mockRepository.getEventById(99))
          .thenAnswer((_) async => Right(entity));

      final result = await getEventByIdUsecase(99);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (event) {
          expect(event.eventId, equals(99));
          expect(event.title, equals('Event 99'));
        },
      );
    });

    test('trả về failure khi repository trả notFound', () async {
      when(() => mockRepository.getEventById(9999))
          .thenAnswer((_) async =>
              const Left(FailureEntity.serverFailure('404', 'Not found')));

      final result = await getEventByIdUsecase(9999);

      expect(result.isLeft(), isTrue);
    });

    test('trả về failure khi repository trả dataParsingFailure', () async {
      when(() => mockRepository.getEventById(1))
          .thenAnswer((_) async => const Left(FailureEntity.dataParsingFailure()));

      final result = await getEventByIdUsecase(1);

      expect(result.isLeft(), isTrue);
    });
  });
}
