import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/feature/news/data/datasource/notification_datasource.dart';
import 'package:events_app/feature/news/data/model/notification_model.dart';
import 'package:events_app/feature/news/data/repository/notification_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/fake_data.dart';
import '../helpers/mock_rest_client.dart';

class MockNotificationDatasource extends Mock implements NotificationDatasource {}

void main() {
  late MockNotificationDatasource mockDatasource;
  late NotificationRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockNotificationDatasource();
    repository = NotificationRepositoryImpl(mockDatasource);
  });

  group('getNotificationList', () {
    test('trả về list notification entity khi datasource trả success', () async {
      final models = [
        NotificationModel.fromJson(fakeNotificationJson(id: 1)),
        NotificationModel.fromJson(fakeNotificationJson(id: 2)),
      ];
      when(() => mockDatasource.getNotificationList(
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => successResponse(models));

      final result = await repository.getNotificationList();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entities) {
          expect(entities.length, equals(2));
          expect(entities.first.notificationId, equals(1));
          expect(entities.last.notificationId, equals(2));
        },
      );
    });

    test('trả về empty list khi datasource trả content rỗng', () async {
      when(() => mockDatasource.getNotificationList(
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer(
          (_) async => successResponse<List<NotificationModel>>([]));

      final result = await repository.getNotificationList();

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('Expected Right'), (entities) {
        expect(entities, isEmpty);
      });
    });

    test('trả về FailureEntity khi datasource trả unauthorized', () async {
      when(() => mockDatasource.getNotificationList(
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer(
          (_) async => errorResponse<List<NotificationModel>>(unauthorizedResponse()));

      final result = await repository.getNotificationList();

      expect(result.isLeft(), isTrue);
    });

    test('trả về FailureEntity khi datasource trả notFound', () async {
      when(() => mockDatasource.getNotificationList(
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer(
          (_) async => errorResponse<List<NotificationModel>>(notFoundResponse()));

      final result = await repository.getNotificationList();

      expect(result.isLeft(), isTrue);
    });

    test('trả về FailureEntity khi datasource trả internalServerError', () async {
      when(() => mockDatasource.getNotificationList(
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer(
          (_) async => errorResponse<List<NotificationModel>>(serverErrorResponse()));

      final result = await repository.getNotificationList();

      expect(result.isLeft(), isTrue);
    });

    test('truyền đúng params xuống datasource', () async {
      when(() => mockDatasource.getNotificationList(
            page: 1,
            size: 10,
          )).thenAnswer(
          (_) async => successResponse<List<NotificationModel>>([]));

      await repository.getNotificationList(page: 1, size: 10);

      verify(() => mockDatasource.getNotificationList(
            page: 1,
            size: 10,
          )).called(1);
    });
  });

  group('getNotificationById', () {
    test('trả về notification entity khi datasource trả success', () async {
      final model = NotificationModel.fromJson(fakeNotificationJson(id: 5));
      when(() => mockDatasource.getNotificationById(5))
          .thenAnswer((_) async => successResponse(model));

      final result = await repository.getNotificationById(5);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) => expect(entity.notificationId, equals(5)),
      );
    });

    test('trả về FailureEntity khi datasource trả notFound', () async {
      when(() => mockDatasource.getNotificationById(9999))
          .thenAnswer((_) async => errorResponse<NotificationModel>(notFoundResponse()));

      final result = await repository.getNotificationById(9999);

      expect(result.isLeft(), isTrue);
    });

    test('trả về FailureEntity khi datasource trả unauthorized', () async {
      when(() => mockDatasource.getNotificationById(1))
          .thenAnswer((_) async => errorResponse<NotificationModel>(unauthorizedResponse()));

      final result = await repository.getNotificationById(1);

      expect(result.isLeft(), isTrue);
    });
  });

  group('markAsRead', () {
    test('trả về Right(Unit) khi datasource trả success', () async {
      when(() => mockDatasource.markAsRead(5))
          .thenAnswer((_) async => const ApiResponse.success({'object': null}));

      final result = await repository.markAsRead(5);

      expect(result.isRight(), isTrue);
    });

    test('trả về FailureEntity khi datasource trả notFound', () async {
      when(() => mockDatasource.markAsRead(9999))
          .thenAnswer((_) async => errorResponse<void>(notFoundResponse()));

      final result = await repository.markAsRead(9999);

      expect(result.isLeft(), isTrue);
    });

    test('trả về FailureEntity khi datasource trả unauthorized', () async {
      when(() => mockDatasource.markAsRead(1))
          .thenAnswer((_) async => errorResponse<void>(unauthorizedResponse()));

      final result = await repository.markAsRead(1);

      expect(result.isLeft(), isTrue);
    });
  });

  group('markAllAsRead', () {
    test('trả về Right(Unit) khi datasource trả success', () async {
      when(() => mockDatasource.markAllAsRead())
          .thenAnswer((_) async => const ApiResponse.success({'object': null}));

      final result = await repository.markAllAsRead();

      expect(result.isRight(), isTrue);
    });

    test('trả về FailureEntity khi datasource trả unauthorized', () async {
      when(() => mockDatasource.markAllAsRead())
          .thenAnswer((_) async => errorResponse<void>(unauthorizedResponse()));

      final result = await repository.markAllAsRead();

      expect(result.isLeft(), isTrue);
    });
  });
}
