import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/event_management/data/model/event_summary_model.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/news/data/model/notification_model.dart';
import 'package:events_app/feature/participant/data/model/participant_model.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';
import 'package:events_app/feature/user_management/data/datasource/user_datasource.dart';
import 'package:events_app/feature/user_management/data/model/rank_model.dart';
import 'package:events_app/feature/user_management/data/model/user_model.dart';
import 'package:events_app/feature/user_management/data/model/user_package_model.dart';
import 'package:events_app/feature/user_management/data/repository/user_repository_impl.dart';
import 'package:events_app/feature/user_management/domain/entity/rank_entity.dart';
import 'package:events_app/feature/user_management/domain/entity/user_entity.dart';
import 'package:events_app/feature/user_management/domain/entity/user_package_entity.dart';
import 'package:events_app/feature/user_management/domain/usecase/update_current_user_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/fake_data.dart';
import '../helpers/mock_rest_client.dart';

class MockUserDatasource extends Mock implements UserDatasource {}

class FakeUpdateCurrentUserParams extends Fake
    implements UpdateCurrentUserParams {}

void main() {
  late MockUserDatasource mockDatasource;
  late UserRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(FakeUpdateCurrentUserParams());
    registerFallbackValue(0);
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    mockDatasource = MockUserDatasource();
    repository = UserRepositoryImpl(mockDatasource);
  });

  group('getCurrentUser', () {
    test('trả về UserEntity khi datasource trả success', () async {
      final model = UserModel.fromJson(fakeUserJson(id: 1));
      when(() => mockDatasource.getCurrentUser())
          .thenAnswer((_) async => successResponse<UserModel?>(model));

      final result = await repository.getCurrentUser();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) {
          expect(entity, isNotNull);
          expect(entity!.userId, equals(1));
          expect(entity.email, equals('test@example.com'));
        },
      );
    });

    test('trả về Right(null) khi datasource trả null', () async {
      when(() => mockDatasource.getCurrentUser())
          .thenAnswer((_) async => successResponse<UserModel?>(null));

      final result = await repository.getCurrentUser();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) => expect(entity, isNull),
      );
    });

    test('trả về Left(FailureEntity) khi datasource trả unauthorized',
        () async {
      when(() => mockDatasource.getCurrentUser()).thenAnswer(
          (_) async => errorResponse<UserModel?>(unauthorizedResponse()));

      final result = await repository.getCurrentUser();

      expect(result.isLeft(), isTrue);
    });

    test('trả về Left(FailureEntity) khi datasource trả notFound', () async {
      when(() => mockDatasource.getCurrentUser()).thenAnswer(
          (_) async => errorResponse<UserModel?>(notFoundResponse()));

      final result = await repository.getCurrentUser();

      expect(result.isLeft(), isTrue);
    });

    test('trả về Left(FailureEntity) khi datasource trả internalServerError',
        () async {
      when(() => mockDatasource.getCurrentUser()).thenAnswer(
          (_) async => errorResponse<UserModel?>(serverErrorResponse()));

      final result = await repository.getCurrentUser();

      expect(result.isLeft(), isTrue);
    });
  });

  group('getUserById', () {
    test('trả về UserEntity khi datasource trả success', () async {
      final model = UserModel.fromJson(fakeUserJson(id: 5));
      when(() => mockDatasource.getUserById(5))
          .thenAnswer((_) async => successResponse<UserModel?>(model));

      final result = await repository.getUserById(5);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) => expect(entity!.userId, equals(5)),
      );
    });

    test('trả về Left(FailureEntity) khi datasource trả notFound', () async {
      when(() => mockDatasource.getUserById(9999)).thenAnswer(
          (_) async => errorResponse<UserModel?>(notFoundResponse()));

      final result = await repository.getUserById(9999);

      expect(result.isLeft(), isTrue);
    });

    test('trả về Left(FailureEntity) khi datasource trả unauthorized',
        () async {
      when(() => mockDatasource.getUserById(1)).thenAnswer(
          (_) async => errorResponse<UserModel?>(unauthorizedResponse()));

      final result = await repository.getUserById(1);

      expect(result.isLeft(), isTrue);
    });
  });

  group('updateCurrentUser', () {
    test('trả về UserEntity khi datasource trả success', () async {
      final model = UserModel.fromJson(fakeUserJson(id: 1));
      const params = UpdateCurrentUserParams(fullName: 'New Name');
      when(() => mockDatasource.updateCurrentUser(params))
          .thenAnswer((_) async => successResponse<UserModel?>(model));

      final result = await repository.updateCurrentUser(params);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) => expect(entity, isNotNull),
      );
    });

    test('truyền đúng params xuống datasource', () async {
      final model = UserModel.fromJson(fakeUserJson(id: 1));
      const params = UpdateCurrentUserParams(fullName: 'Updated Name');
      when(() => mockDatasource.updateCurrentUser(params))
          .thenAnswer((_) async => successResponse<UserModel?>(model));

      await repository.updateCurrentUser(params);

      verify(() => mockDatasource.updateCurrentUser(params)).called(1);
    });

    test('trả về Left(FailureEntity) khi datasource trả badRequest', () async {
      const params = UpdateCurrentUserParams(fullName: '');
      when(() => mockDatasource.updateCurrentUser(params)).thenAnswer(
          (_) async => errorResponse<UserModel?>(badRequestResponse()));

      final result = await repository.updateCurrentUser(params);

      expect(result.isLeft(), isTrue);
    });

    test('trả về Left(FailureEntity) khi datasource trả unauthorized',
        () async {
      const params = UpdateCurrentUserParams(fullName: 'Name');
      when(() => mockDatasource.updateCurrentUser(params)).thenAnswer(
          (_) async => errorResponse<UserModel?>(unauthorizedResponse()));

      final result = await repository.updateCurrentUser(params);

      expect(result.isLeft(), isTrue);
    });
  });

  group('getUserParticipatedEvents', () {
    test('trả về list EventSummaryEntity khi datasource trả success', () async {
      when(() => mockDatasource.getUserParticipatedEvents(
            userId: 1,
            participantType: any(named: 'participantType'),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => successResponse<Map<String, dynamic>>({
            'content': [
              fakeEventSummaryJson(id: 1),
              fakeEventSummaryJson(id: 2)
            ],
            'totalElements': 2,
          }));

      final result = await repository.getUserParticipatedEvents(userId: 1);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entities) {
          expect(entities.length, equals(2));
          expect(entities.first.eventId, equals(1));
        },
      );
    });

    test('trả về empty list khi datasource trả content rỗng', () async {
      when(() => mockDatasource.getUserParticipatedEvents(
            userId: 1,
            participantType: any(named: 'participantType'),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => successResponse<Map<String, dynamic>>({
            'content': [],
            'totalElements': 0,
          }));

      final result = await repository.getUserParticipatedEvents(userId: 1);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entities) => expect(entities, isEmpty),
      );
    });

    test('truyền đúng params xuống datasource', () async {
      when(() => mockDatasource.getUserParticipatedEvents(
            userId: 1,
            participantType: 'ATTENDEE',
            page: 2,
            size: 10,
          )).thenAnswer((_) async => successResponse<Map<String, dynamic>>({
            'content': [],
            'totalElements': 0,
          }));

      await repository.getUserParticipatedEvents(
        userId: 1,
        participantType: 'ATTENDEE',
        page: 2,
        size: 10,
      );

      verify(() => mockDatasource.getUserParticipatedEvents(
            userId: 1,
            participantType: 'ATTENDEE',
            page: 2,
            size: 10,
          )).called(1);
    });
  });

  group('getRegistrations', () {
    test('trả về list ParticipantEntity khi datasource trả success', () async {
      when(() => mockDatasource.getRegistrations(
            eventId: 1,
            userId: 10,
          )).thenAnswer((_) async => successResponse<Map<String, dynamic>>({
            'content': [fakeParticipantJson(id: 1)],
            'totalElements': 1,
          }));

      final result = await repository.getRegistrations(eventId: 1, userId: 10);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entities) {
          expect(entities.length, equals(1));
          expect(entities.first.eventParticipantId, equals(1));
        },
      );
    });

    test('trả về empty list khi datasource trả content rỗng', () async {
      when(() => mockDatasource.getRegistrations(
            eventId: 1,
            userId: 10,
          )).thenAnswer((_) async => successResponse<Map<String, dynamic>>({
            'content': [],
            'totalElements': 0,
          }));

      final result = await repository.getRegistrations(eventId: 1, userId: 10);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entities) => expect(entities, isEmpty),
      );
    });
  });

  group('getUserPackages', () {
    test('trả về list UserPackageEntity khi datasource trả success', () async {
      when(() => mockDatasource.getUserPackages(
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => successResponse<Map<String, dynamic>>({
            'content': [fakeUserPackageJson(id: 1), fakeUserPackageJson(id: 2)],
            'totalElements': 2,
          }));

      final result = await repository.getUserPackages();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entities) {
          expect(entities.length, equals(2));
          expect(entities.first.userPackageId, equals(1));
        },
      );
    });

    test('trả về empty list khi datasource trả content rỗng', () async {
      when(() => mockDatasource.getUserPackages(
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => successResponse<Map<String, dynamic>>({
            'content': [],
            'totalElements': 0,
          }));

      final result = await repository.getUserPackages();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entities) => expect(entities, isEmpty),
      );
    });
  });

  group('getUserRank', () {
    test('trả về RankEntity khi datasource trả success', () async {
      when(() => mockDatasource.getUserRank(1)).thenAnswer((_) async =>
          successResponse<RankModel?>(RankModel.fromJson(fakeRankJson(id: 1))));

      final result = await repository.getUserRank(1);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) {
          expect(entity, isNotNull);
          expect(entity!.userId, equals(1));
        },
      );
    });

    test('trả về Right(null) khi datasource trả null', () async {
      when(() => mockDatasource.getUserRank(1))
          .thenAnswer((_) async => successResponse<RankModel?>(null));

      final result = await repository.getUserRank(1);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) => expect(entity, isNull),
      );
    });
  });

  group('getRanks', () {
    test('trả về list RankEntity khi datasource trả success', () async {
      when(() => mockDatasource.getRanks(
            levelName: any(named: 'levelName'),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => successResponse<Map<String, dynamic>>({
            'content': [fakeRankJson(id: 1), fakeRankJson(id: 2)],
            'totalElements': 2,
          }));

      final result = await repository.getRanks();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entities) {
          expect(entities.length, equals(2));
        },
      );
    });

    test('trả về empty list khi datasource trả content rỗng', () async {
      when(() => mockDatasource.getRanks(
            levelName: any(named: 'levelName'),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => successResponse<Map<String, dynamic>>({
            'content': [],
            'totalElements': 0,
          }));

      final result = await repository.getRanks();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entities) => expect(entities, isEmpty),
      );
    });
  });
}
