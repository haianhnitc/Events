import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/organizer/event/domain/repository/organizer_event_repository.dart';
import 'package:events_app/feature/organizer/event/domain/usecase/organizer_event_usecase.dart';
import 'package:events_app/feature/organizer/event/domain/usecase/event_params.dart';
import 'package:events_app/feature/event_management/domain/entity/event_entity.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/event_management/domain/entity/event_statistic_entity.dart';
import 'package:events_app/feature/event_management/domain/entity/event_analytics_entity.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class MockOrganizerEventRepository extends Mock
    implements OrganizerEventRepository {}

void main() {
  late MockOrganizerEventRepository mockRepository;

  setUp(() {
    mockRepository = MockOrganizerEventRepository();
  });

  setUpAll(() {
    registerFallbackValue(const OrganizerEventListParams(
      organizerId: 1,
      page: 0,
      size: 20,
    ));
    registerFallbackValue(const EventCreateParams(title: 'Test'));
    registerFallbackValue(const EventUpdateParams());
    registerFallbackValue(const EventCategoryOptionCreateParams(
      eventId: 1,
      categoryOptionId: 1,
    ));
    registerFallbackValue(
        const EventCategoryOptionUpdateParams(categoryOptionId: 1));
  });

  group('GetOrganizerEventListUsecase', () {
    late GetOrganizerEventListUsecase usecase;

    setUp(() {
      usecase = GetOrganizerEventListUsecase(mockRepository);
    });

    test('success', () async {
      final items = <EventSummaryEntity>[];
      when(() => mockRepository.getOrganizerEventList(any())).thenAnswer(
        (_) async => Right((
          items: items,
          totalElements: 1,
          totalPages: 1,
        )),
      );

      const params = OrganizerEventListParams(
        organizerId: 1,
        page: 0,
        size: 20,
      );
      final result = await usecase(params);

      expect(result.isRight(), true);
    });

    test('empty', () async {
      when(() => mockRepository.getOrganizerEventList(any())).thenAnswer(
        (_) async => const Right((
          items: <EventSummaryEntity>[],
          totalElements: 0,
          totalPages: 0,
        )),
      );

      const params = OrganizerEventListParams(
        organizerId: 1,
        page: 0,
        size: 20,
      );
      final result = await usecase(params);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not return Left'),
        (r) => expect(r.items, isEmpty),
      );
    });

    test('failure', () async {
      when(() => mockRepository.getOrganizerEventList(any())).thenAnswer(
        (_) async =>
            const Left(FailureEntity.serverFailure('500', 'Server error')),
      );

      const params = OrganizerEventListParams(
        organizerId: 1,
        page: 0,
        size: 20,
      );
      final result = await usecase(params);

      expect(result.isLeft(), true);
    });
  });

  group('CreateOrganizerEventUsecase', () {
    late CreateOrganizerEventUsecase usecase;

    setUp(() {
      usecase = CreateOrganizerEventUsecase(mockRepository);
    });

    test('success', () async {
      when(() => mockRepository.createEvent(any())).thenAnswer(
        (_) async => Right(EventEntity()),
      );

      const params = EventCreateParams(title: 'New Event');
      final result = await usecase(params);

      expect(result.isRight(), true);
    });

    test('400 returns Left', () async {
      when(() => mockRepository.createEvent(any())).thenAnswer(
        (_) async =>
            const Left(FailureEntity.serverFailure('400', 'Invalid data')),
      );

      const params = EventCreateParams(title: '');
      final result = await usecase(params);

      expect(result.isLeft(), true);
    });
  });

  group('UpdateOrganizerEventUsecase', () {
    late UpdateOrganizerEventUsecase usecase;

    setUp(() {
      usecase = UpdateOrganizerEventUsecase(mockRepository);
    });

    test('success', () async {
      when(() => mockRepository.updateEvent(any(), any())).thenAnswer(
        (_) async => Right(EventEntity()),
      );

      final result = await usecase(const UpdateOrganizerEventParams(
          eventId: 1, params: EventUpdateParams(title: 'Updated')));

      expect(result.isRight(), true);
    });
  });

  group('DeleteOrganizerEventUsecase', () {
    late DeleteOrganizerEventUsecase usecase;

    setUp(() {
      usecase = DeleteOrganizerEventUsecase(mockRepository);
    });

    test('success returns Right(unit)', () async {
      when(() => mockRepository.deleteEvent(any())).thenAnswer(
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
      when(() => mockRepository.deleteEvent(any())).thenAnswer(
        (_) async =>
            const Left(FailureEntity.serverFailure('404', 'Not found')),
      );

      final result = await usecase(999);

      expect(result.isLeft(), true);
    });
  });

  group('PublishOrganizerEventUsecase', () {
    late PublishOrganizerEventUsecase usecase;

    setUp(() {
      usecase = PublishOrganizerEventUsecase(mockRepository);
    });

    test('success', () async {
      when(() => mockRepository.publishEvent(any())).thenAnswer(
        (_) async => Right(EventEntity()),
      );

      final result = await usecase(1);

      expect(result.isRight(), true);
    });
  });

  group('GetOrganizerEventByIdUsecase', () {
    late GetOrganizerEventByIdUsecase usecase;

    setUp(() {
      usecase = GetOrganizerEventByIdUsecase(mockRepository);
    });

    test('success', () async {
      when(() => mockRepository.getEventById(any())).thenAnswer(
        (_) async => Right(EventEntity()),
      );

      final result = await usecase(1);

      expect(result.isRight(), true);
    });
  });

  group('GetOrganizerEventStatisticsUsecase', () {
    late GetOrganizerEventStatisticsUsecase usecase;

    setUp(() {
      usecase = GetOrganizerEventStatisticsUsecase(mockRepository);
    });

    test('success', () async {
      when(() => mockRepository.getEventStatistics(any())).thenAnswer(
        (_) async => Right(EventStatisticEntity()),
      );

      final result = await usecase(1);

      expect(result.isRight(), true);
    });
  });

  group('GetOrganizerEventAnalyticsUsecase', () {
    late GetOrganizerEventAnalyticsUsecase usecase;

    setUp(() {
      usecase = GetOrganizerEventAnalyticsUsecase(mockRepository);
    });

    test('success', () async {
      when(() => mockRepository.getEventAnalytics(any())).thenAnswer(
        (_) async => Right(EventAnalyticsEntity()),
      );

      final result = await usecase(1);

      expect(result.isRight(), true);
    });
  });

  group('CreateOrganizerEventCategoryOptionUsecase', () {
    late CreateOrganizerEventCategoryOptionUsecase usecase;

    setUp(() {
      usecase = CreateOrganizerEventCategoryOptionUsecase(mockRepository);
    });

    test('success', () async {
      when(() => mockRepository.createEventCategoryOption(any())).thenAnswer(
        (_) async => const Right(unit),
      );

      const params = EventCategoryOptionCreateParams(
        eventId: 1,
        categoryOptionId: 5,
      );
      final result = await usecase(params);

      expect(result.isRight(), true);
    });
  });

  group('UpdateOrganizerEventCategoryOptionUsecase', () {
    late UpdateOrganizerEventCategoryOptionUsecase usecase;

    setUp(() {
      usecase = UpdateOrganizerEventCategoryOptionUsecase(mockRepository);
    });

    test('success', () async {
      when(() => mockRepository.updateEventCategoryOption(
            any(),
            any(),
            any(),
          )).thenAnswer((_) async => const Right(unit));

      const params = EventCategoryOptionUpdateParams(categoryOptionId: 5);
      final result = await usecase(UpdateOrganizerEventCategoryOptionParams(
        eventId: 1,
        categoryOptionId: 5,
        params: params,
      ));

      expect(result.isRight(), true);
    });
  });

  group('DeleteOrganizerEventCategoryOptionUsecase', () {
    late DeleteOrganizerEventCategoryOptionUsecase usecase;

    setUp(() {
      usecase = DeleteOrganizerEventCategoryOptionUsecase(mockRepository);
    });

    test('success', () async {
      when(() => mockRepository.deleteEventCategoryOption(
            any(),
            any(),
          )).thenAnswer((_) async => const Right(unit));

      final result = await usecase(
          const DeleteOrganizerEventCategoryOptionParams(
              eventId: 1, categoryOptionId: 5));

      expect(result.isRight(), true);
    });
  });
}
