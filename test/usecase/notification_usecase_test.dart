import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/news/domain/entity/notification_entity.dart';
import 'package:events_app/feature/news/domain/repository/notification_repository.dart';
import 'package:events_app/feature/news/domain/usecase/notification_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationRepository extends Mock implements NotificationRepository {}

class FakeGetNotificationListParams extends Fake implements GetNotificationListParams {}

void main() {
  late MockNotificationRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeGetNotificationListParams());
    registerFallbackValue(0);
  });

  setUp(() {
    mockRepository = MockNotificationRepository();
  });

  group('GetNotificationListUsecase', () {
    late GetNotificationListUsecase usecase;

    setUp(() {
      usecase = GetNotificationListUsecase(mockRepository);
    });

    test('trả về list notification entity khi repository thành công', () async {
      final entities = [
        NotificationEntity(notificationId: 1, title: 'Notification 1'),
        NotificationEntity(notificationId: 2, title: 'Notification 2'),
      ];
      final params = const GetNotificationListParams(page: 0, size: 20);
      when(() => mockRepository.getNotificationList(
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => Right(entities));

      final result = await usecase(params);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (notifications) {
          expect(notifications.length, equals(2));
          expect(notifications.first.notificationId, equals(1));
        },
      );
    });

    test('trả về empty list khi repository trả rỗng', () async {
      final params = const GetNotificationListParams();
      when(() => mockRepository.getNotificationList(
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => const Right([]));

      final result = await usecase(params);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (notifications) => expect(notifications, isEmpty),
      );
    });

    test('trả về Left(FailureEntity) khi repository trả failure', () async {
      final params = const GetNotificationListParams();
      when(() => mockRepository.getNotificationList(
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer(
          (_) async => const Left(FailureEntity.serverFailure('500', 'Server error')));

      final result = await usecase(params);

      expect(result.isLeft(), isTrue);
    });

    test('truyền đúng params xuống repository', () async {
      final params = const GetNotificationListParams(page: 1, size: 10);
      when(() => mockRepository.getNotificationList(
            page: 1,
            size: 10,
          )).thenAnswer((_) async => const Right([]));

      await usecase(params);

      verify(() => mockRepository.getNotificationList(
            page: 1,
            size: 10,
          )).called(1);
    });
  });

  group('GetNotificationByIdUsecase', () {
    late GetNotificationByIdUsecase usecase;

    setUp(() {
      usecase = GetNotificationByIdUsecase(mockRepository);
    });

    test('trả về notification entity khi repository thành công', () async {
      final entity = NotificationEntity(
        notificationId: 5,
        title: 'Notification 5',
        body: 'Body 5',
      );
      when(() => mockRepository.getNotificationById(5))
          .thenAnswer((_) async => Right(entity));

      final result = await usecase(5);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (notification) {
          expect(notification, isNotNull);
          expect(notification.notificationId, equals(5));
          expect(notification.title, equals('Notification 5'));
        },
      );
    });

    test('trả về Left(FailureEntity) khi repository trả notFound', () async {
      when(() => mockRepository.getNotificationById(9999))
          .thenAnswer((_) async => const Left(FailureEntity.serverFailure('404', 'Not found')));

      final result = await usecase(9999);

      expect(result.isLeft(), isTrue);
    });

    test('trả về Left(FailureEntity) khi repository trả unauthorized', () async {
      when(() => mockRepository.getNotificationById(1))
          .thenAnswer((_) async => const Left(FailureEntity.serverFailure('401', 'Unauthorized')));

      final result = await usecase(1);

      expect(result.isLeft(), isTrue);
    });

    test('trả về Left(FailureEntity) khi repository trả serverFailure', () async {
      when(() => mockRepository.getNotificationById(1))
          .thenAnswer((_) async => const Left(FailureEntity.serverFailure('500', 'Server error')));

      final result = await usecase(1);

      expect(result.isLeft(), isTrue);
    });
  });

  group('MarkNotificationAsReadUsecase', () {
    late MarkNotificationAsReadUsecase usecase;

    setUp(() {
      usecase = MarkNotificationAsReadUsecase(mockRepository);
    });

    test('trả về Right(unit) khi repository thành công', () async {
      when(() => mockRepository.markAsRead(5))
          .thenAnswer((_) async => const Right(unit));

      final result = await usecase(5);

      expect(result.isRight(), isTrue);
    });

    test('trả về Left(FailureEntity) khi repository trả failure', () async {
      when(() => mockRepository.markAsRead(9999))
          .thenAnswer((_) async => const Left(FailureEntity.serverFailure('404', 'Not found')));

      final result = await usecase(9999);

      expect(result.isLeft(), isTrue);
    });

    test('trả về Left(FailureEntity) khi repository trả unauthorized', () async {
      when(() => mockRepository.markAsRead(1))
          .thenAnswer((_) async => const Left(FailureEntity.serverFailure('401', 'Unauthorized')));

      final result = await usecase(1);

      expect(result.isLeft(), isTrue);
    });
  });

  group('MarkAllNotificationsAsReadUsecase', () {
    late MarkAllNotificationsAsReadUsecase usecase;

    setUp(() {
      usecase = MarkAllNotificationsAsReadUsecase(mockRepository);
    });

    test('trả về Right(unit) khi repository thành công', () async {
      when(() => mockRepository.markAllAsRead())
          .thenAnswer((_) async => const Right(unit));

      final result = await usecase(null);

      expect(result.isRight(), isTrue);
    });

    test('trả về Left(FailureEntity) khi repository trả failure', () async {
      when(() => mockRepository.markAllAsRead())
          .thenAnswer((_) async => const Left(FailureEntity.serverFailure('401', 'Unauthorized')));

      final result = await usecase(null);

      expect(result.isLeft(), isTrue);
    });

    test('trả về Left(FailureEntity) khi repository trả serverFailure', () async {
      when(() => mockRepository.markAllAsRead())
          .thenAnswer((_) async => const Left(FailureEntity.serverFailure('500', 'Server error')));

      final result = await usecase(null);

      expect(result.isLeft(), isTrue);
    });
  });
}
