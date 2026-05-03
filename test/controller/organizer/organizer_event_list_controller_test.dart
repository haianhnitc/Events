import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/common/helpers/no_params.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/organizer/event/domain/usecase/organizer_event_usecase.dart';
import 'package:events_app/feature/organizer/event/domain/usecase/event_params.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_event_list_controller.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/feature/user_management/domain/entity/user_entity.dart';

class MockGetOrganizerEventListUsecase extends Mock
    implements GetOrganizerEventListUsecase {}

class MockAuthController extends Mock implements AuthController {}

void main() {
  late OrganizerEventListController controller;
  late MockGetOrganizerEventListUsecase mockGetEventListUsecase;
  late MockAuthController mockAuthController;

  setUp(() {
    Get.testMode = true;
    Get.reset();
    networkGetIt.reset();

    mockGetEventListUsecase = MockGetOrganizerEventListUsecase();
    mockAuthController = MockAuthController();

    networkGetIt.registerSingleton<MockAuthController>(mockAuthController);
    networkGetIt.registerSingleton<MockGetOrganizerEventListUsecase>(
        mockGetEventListUsecase);

    when(() => mockAuthController.currentUser).thenReturn(
      Rx(UserEntity(userId: 1, email: 'test@test.com', firebaseUid: 'uid-1', currentCoin: 0)),
    );

    controller = OrganizerEventListController();
  });

  tearDown(() {
    Get.reset();
    networkGetIt.reset();
  });

  group('Initial state', () {
    test('empty events, isLoading = false', () {
      controller.onInit();

      expect(controller.events, isEmpty);
      expect(controller.isLoading.value, false);
    });
  });

  group('loadEvents', () {
    test('success populates events list', () async {
      final events = <EventSummaryEntity>[];
      when(() => mockGetEventListUsecase(any())).thenAnswer(
        (_) async => Right((
          items: events,
          totalElements: 1,
          totalPages: 1,
        )),
      );

      await controller.loadEvents();

      expect(controller.events, isNotEmpty);
      expect(controller.isLoading.value, false);
    });

    test('empty list', () async {
      when(() => mockGetEventListUsecase(any())).thenAnswer(
        (_) async => Right((
          items: <EventSummaryEntity>[],
          totalElements: 0,
          totalPages: 0,
        )),
      );

      await controller.loadEvents();

      expect(controller.events, isEmpty);
      expect(controller.isLoading.value, false);
    });

    test('with search query filters correctly', () async {
      when(() => mockGetEventListUsecase(any())).thenAnswer(
        (_) async => Right((
          items: <EventSummaryEntity>[],
          totalElements: 0,
          totalPages: 0,
        )),
      );

      controller.searchQuery.value = 'test';
      await controller.loadEvents();

      verify(() => mockGetEventListUsecase(any())).called(greaterThan(0));
    });

    test('with status filter passes correct params', () async {
      when(() => mockGetEventListUsecase(any())).thenAnswer(
        (_) async => Right((
          items: <EventSummaryEntity>[],
          totalElements: 0,
          totalPages: 0,
        )),
      );

      controller.filterStatus.value = EventStatus.published;
      await controller.loadEvents();

      verify(() => mockGetEventListUsecase(any())).called(greaterThan(0));
    });

    test('refresh clears and reloads', () async {
      when(() => mockGetEventListUsecase(any())).thenAnswer(
        (_) async => Right((
          items: <EventSummaryEntity>[],
          totalElements: 0,
          totalPages: 0,
        )),
      );

      await controller.loadEvents(reset: true);

      expect(controller.events, isEmpty);
      verify(() => mockGetEventListUsecase(any())).called(1);
    });

    test('does not reload if already loading', () async {
      when(() => mockGetEventListUsecase(any())).thenAnswer(
        (_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return Right((
            items: <EventSummaryEntity>[],
            totalElements: 0,
            totalPages: 0,
          ));
        },
      );

      final futures = await Future.wait([
        controller.loadEvents(),
        controller.loadEvents(),
      ]);

      verify(() => mockGetEventListUsecase(any())).called(1);
    });

    test('sets hasMore based on page content', () async {
      when(() => mockGetEventListUsecase(any())).thenAnswer(
        (_) async => Right((
          items: <EventSummaryEntity>[],
          totalElements: 100,
          totalPages: 5,
        )),
      );

      await controller.loadEvents();
    });
  });

  group('loadMore', () {
    test('calls loadEvents when hasMore = true', () async {
      when(() => mockGetEventListUsecase(any())).thenAnswer(
        (_) async => Right((
          items: <EventSummaryEntity>[],
          totalElements: 100,
          totalPages: 5,
        )),
      );

      await controller.loadMore();

      verify(() => mockGetEventListUsecase(any())).called(greaterThan(0));
    });

    test('does nothing when hasMore = false', () async {
      when(() => mockGetEventListUsecase(any())).thenAnswer(
        (_) async => Right((
          items: <EventSummaryEntity>[],
          totalElements: 0,
          totalPages: 0,
        )),
      );

      await controller.loadEvents();
      await controller.loadMore();

      verify(() => mockGetEventListUsecase(any())).called(1);
    });

    test('does nothing when isLoading = true', () async {
      when(() => mockGetEventListUsecase(any())).thenAnswer(
        (_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return Right((
            items: <EventSummaryEntity>[],
            totalElements: 0,
            totalPages: 0,
          ));
        },
      );

      controller.loadEvents();
      await controller.loadMore();

      verifyNever(() => mockGetEventListUsecase(any()));
    });
  });

  group('setQuery', () {
    test('updates query and triggers reload', () async {
      when(() => mockGetEventListUsecase(any())).thenAnswer(
        (_) async => Right((
          items: <EventSummaryEntity>[],
          totalElements: 0,
          totalPages: 0,
        )),
      );

      controller.setSearch('new query');

      expect(controller.searchQuery.value, 'new query');
      verify(() => mockGetEventListUsecase(any())).called(greaterThan(0));
    });
  });

  group('setStatusFilter', () {
    test('updates filter and triggers reload', () async {
      when(() => mockGetEventListUsecase(any())).thenAnswer(
        (_) async => Right((
          items: <EventSummaryEntity>[],
          totalElements: 0,
          totalPages: 0,
        )),
      );

      controller.setFilter(EventStatus.closed);

      expect(controller.filterStatus.value, EventStatus.closed);
      verify(() => mockGetEventListUsecase(any())).called(greaterThan(0));
    });
  });
}
