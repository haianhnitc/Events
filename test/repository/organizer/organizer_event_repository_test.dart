import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/organizer/event/domain/repository/organizer_event_repository.dart';
import 'package:events_app/feature/organizer/event/domain/usecase/event_params.dart';
import 'package:events_app/feature/event_management/data/model/event_model.dart';
import 'package:events_app/feature/event_management/data/model/event_summary_model.dart';
import 'package:events_app/feature/event_management/data/model/event_analytics_model.dart';
import 'package:events_app/feature/event_management/domain/entity/event_entity.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class MockOrganizerEventDatasource extends Mock
    implements OrganizerEventDatasource {}

void main() {
  late OrganizerEventRepositoryImpl repository;
  late MockOrganizerEventDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockOrganizerEventDatasource();
    repository = OrganizerEventRepositoryImpl(mockDatasource);
  });

  setUpAll(() {
    registerFallbackValue(OrganizerEventListParams(
      organizerId: 1,
      page: 0,
      size: 20,
    ));
    registerFallbackValue(EventCreateParams(title: 'Test'));
    registerFallbackValue(EventUpdateParams());
    registerFallbackValue(EventCategoryOptionCreateParams(
      eventId: 1,
      categoryOptionId: 1,
    ));
    registerFallbackValue(EventCategoryOptionUpdateParams(categoryOptionId: 1));
  });

  group('getOrganizerEventList', () {
    test('success returns items and pagination', () async {
      final eventModel = EventSummaryModel.fromJson(fakeEventSummaryJson());
      final page = EventSummaryPage(
        content: [eventModel],
        totalElements: 1,
        totalPages: 1,
        page: 0,
        size: 20,
      );
      when(() => mockDatasource.getOrganizerEvents(any()))
          .thenAnswer((_) async => ApiResponse.success(page));

      final params = OrganizerEventListParams(
        organizerId: 1,
        page: 0,
        size: 20,
      );
      final result = await repository.getOrganizerEventList(params);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not return Left'),
        (r) {
          expect(r.items.length, 1);
          expect(r.totalElements, 1);
          expect(r.totalPages, 1);
        },
      );
    });

    test('empty list', () async {
      final page = EventSummaryPage(
        content: [],
        totalElements: 0,
        totalPages: 0,
        page: 0,
        size: 20,
      );
      when(() => mockDatasource.getOrganizerEvents(any()))
          .thenAnswer((_) async => ApiResponse.success(page));

      final params = OrganizerEventListParams(
        organizerId: 1,
        page: 0,
        size: 20,
      );
      final result = await repository.getOrganizerEventList(params);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not return Left'),
        (r) {
          expect(r.items, isEmpty);
          expect(r.totalElements, 0);
        },
      );
    });

    test('propagates failure', () async {
      when(() => mockDatasource.getOrganizerEvents(any()))
          .thenAnswer((_) async => errorResponse<Map<String, dynamic>>());

      final params = OrganizerEventListParams(
        organizerId: 1,
        page: 0,
        size: 20,
      );
      final result = await repository.getOrganizerEventList(params);

      expect(result.isLeft(), true);
    });
  });

  group('createEvent', () {
    test('success', () async {
      final eventModel = EventModel.fromJson(fakeEventJson());
      when(() => mockDatasource.createEvent(any()))
          .thenAnswer((_) async => ApiResponse.success(eventModel));

      final params = EventCreateParams(title: 'New Event');
      final result = await repository.createEvent(params);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not return Left'),
        (r) => expect(r, isA<EventEntity>()),
      );
    });
  });

  group('updateEvent', () {
    test('success', () async {
      final eventModel = EventModel.fromJson(fakeEventJson());
      when(() => mockDatasource.updateEvent(any(), any()))
          .thenAnswer((_) async => ApiResponse.success(eventModel));

      final params = EventUpdateParams(title: 'Updated');
      final result = await repository.updateEvent(1, params);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not return Left'),
        (r) => expect(r, isA<EventEntity>()),
      );
    });
  });

  group('deleteEvent', () {
    test('success returns Right(unit)', () async {
      when(() => mockDatasource.deleteEvent(any()))
          .thenAnswer((_) async => ApiResponse.success(null));

      final result = await repository.deleteEvent(1);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not return Left'),
        (r) => expect(r, unit),
      );
    });

    test('404 returns Left', () async {
      when(() => mockDatasource.deleteEvent(any()))
          .thenAnswer((_) async => errorResponse<Map<String, dynamic>>());

      final result = await repository.deleteEvent(999);

      expect(result.isLeft(), true);
    });
  });

  group('publishEvent', () {
    test('success', () async {
      final eventModel = EventModel.fromJson(fakeEventJson());
      when(() => mockDatasource.publishEvent(any()))
          .thenAnswer((_) async => ApiResponse.success(eventModel));

      final result = await repository.publishEvent(1);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not return Left'),
        (r) => expect(r, isA<EventEntity>()),
      );
    });
  });

  group('getEventById', () {
    test('success', () async {
      final eventModel = EventModel.fromJson(fakeEventJson());
      when(() => mockDatasource.getEventById(any()))
          .thenAnswer((_) async => ApiResponse.success(eventModel));

      final result = await repository.getEventById(1);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not return Left'),
        (r) => expect(r, isA<EventEntity>()),
      );
    });
  });

  group('getEventStatistics', () {
    test('success', () async {
      final response = {
        'eventId': 1,
        'eventTitle': 'Test',
        'totalRegistered': 100,
        'totalCheckedIn': 80,
      };
      when(() => mockDatasource.getEventStatistics(any()))
          .thenAnswer((_) async => ApiResponse.success(response));

      final result = await repository.getEventStatistics(1);

      expect(result.isRight(), true);
    });
  });

  group('getEventAnalytics', () {
    test('success', () async {
      final analyticsJson = {
        'eventId': 1,
        'eventTitle': 'Test Event',
      };
      final analyticsModel = EventAnalyticsModel.fromJson(analyticsJson);
      when(() => mockDatasource.getEventAnalytics(any()))
          .thenAnswer((_) async => ApiResponse.success(analyticsModel));

      final result = await repository.getEventAnalytics(1);

      expect(result.isRight(), true);
    });
  });

  group('createEventCategoryOption', () {
    test('success returns Right(unit)', () async {
      when(() => mockDatasource.createEventCategoryOption(any()))
          .thenAnswer((_) async => ApiResponse.success({'success': true}));

      final params = EventCategoryOptionCreateParams(
        eventId: 1,
        categoryOptionId: 5,
      );
      final result = await repository.createEventCategoryOption(params);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not return Left'),
        (r) => expect(r, unit),
      );
    });
  });

  group('updateEventCategoryOption', () {
    test('success returns Right(unit)', () async {
      when(() => mockDatasource.updateEventCategoryOption(any(), any(), any()))
          .thenAnswer((_) async => ApiResponse.success({'success': true}));

      final params = EventCategoryOptionUpdateParams(categoryOptionId: 5);
      final result = await repository.updateEventCategoryOption(1, 5, params);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not return Left'),
        (r) => expect(r, unit),
      );
    });
  });

  group('deleteEventCategoryOption', () {
    test('success returns Right(unit)', () async {
      when(() => mockDatasource.deleteEventCategoryOption(any(), any()))
          .thenAnswer((_) async => ApiResponse.success(null));

      final result = await repository.deleteEventCategoryOption(1, 5);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not return Left'),
        (r) => expect(r, unit),
      );
    });
  });
}
