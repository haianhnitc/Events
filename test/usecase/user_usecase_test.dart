import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/common/helpers/no_params.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/user_management/data/model/user_package_model.dart';
import 'package:events_app/feature/user_management/domain/entity/user_package_entity.dart';
import 'package:events_app/feature/user_management/domain/entity/rank_entity.dart';
import 'package:events_app/feature/user_management/domain/entity/user_entity.dart';
import 'package:events_app/feature/user_management/domain/repository/user_repository.dart';
import 'package:events_app/feature/user_management/domain/usecase/get_current_user_usecase.dart';
import 'package:events_app/feature/user_management/domain/usecase/get_user_participated_events_usecase.dart';
import 'package:events_app/feature/user_management/domain/usecase/update_current_user_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

class FakeUpdateCurrentUserParams extends Fake implements UpdateCurrentUserParams {}

class FakeGetUserParticipatedEventsParams extends Fake implements GetUserParticipatedEventsParams {}

void main() {
  late MockUserRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeUpdateCurrentUserParams());
    registerFallbackValue(FakeGetUserParticipatedEventsParams());
    registerFallbackValue(const NoParams());
    registerFallbackValue(0);
  });

  setUp(() {
    mockRepository = MockUserRepository();
  });

  group('GetCurrentUserUsecase', () {
    late GetCurrentUserUsecase usecase;

    setUp(() {
      usecase = GetCurrentUserUsecase(mockRepository);
    });

    test('trả về UserEntity khi repository thành công', () async {
      final entity = UserEntity(
        userId: 1,
        email: 'test@example.com',
        firebaseUid: 'firebase-uid',
        currentCoin: 0,
      );
      when(() => mockRepository.getCurrentUser())
          .thenAnswer((_) async => Right(entity));

      final result = await usecase(const NoParams());

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (user) {
          expect(user, isNotNull);
          expect(user!.userId, equals(1));
          expect(user.email, equals('test@example.com'));
        },
      );
    });

    test('trả về Right(null) khi user chưa đăng nhập', () async {
      when(() => mockRepository.getCurrentUser())
          .thenAnswer((_) async => const Right(null));

      final result = await usecase(const NoParams());

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (user) => expect(user, isNull),
      );
    });

    test('trả về Left(FailureEntity) khi repository trả unauthorized', () async {
      when(() => mockRepository.getCurrentUser())
          .thenAnswer((_) async => const Left(FailureEntity.serverFailure('401', 'Unauthorized')));

      final result = await usecase(const NoParams());

      expect(result.isLeft(), isTrue);
    });

    test('trả về Left(FailureEntity) khi repository trả serverFailure', () async {
      when(() => mockRepository.getCurrentUser())
          .thenAnswer((_) async => const Left(FailureEntity.serverFailure('500', 'Server error')));

      final result = await usecase(const NoParams());

      expect(result.isLeft(), isTrue);
    });
  });

  group('GetUserByIdUsecase', () {
    test('trả về UserEntity khi repository thành công', () async {
      final usecase = GetUserByIdUsecase(mockRepository);
      final entity = UserEntity(
        userId: 5,
        email: 'user5@example.com',
        firebaseUid: 'firebase-uid-5',
        currentCoin: 100,
      );
      when(() => mockRepository.getUserById(5))
          .thenAnswer((_) async => Right(entity));

      final result = await usecase(5);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (user) {
          expect(user, isNotNull);
          expect(user!.userId, equals(5));
        },
      );
    });

    test('trả về Left(FailureEntity) khi repository trả notFound', () async {
      final usecase = GetUserByIdUsecase(mockRepository);
      when(() => mockRepository.getUserById(9999))
          .thenAnswer((_) async => const Left(FailureEntity.serverFailure('404', 'Not found')));

      final result = await usecase(9999);

      expect(result.isLeft(), isTrue);
    });

    test('trả về Left(FailureEntity) khi repository trả unauthorized', () async {
      final usecase = GetUserByIdUsecase(mockRepository);
      when(() => mockRepository.getUserById(1))
          .thenAnswer((_) async => const Left(FailureEntity.serverFailure('401', 'Unauthorized')));

      final result = await usecase(1);

      expect(result.isLeft(), isTrue);
    });
  });

  group('UpdateCurrentUserUsecase', () {
    late UpdateCurrentUserUsecase usecase;

    setUp(() {
      usecase = UpdateCurrentUserUsecase(mockRepository);
    });

    test('trả về UserEntity khi repository thành công', () async {
      final entity = UserEntity(
        userId: 1,
        email: 'test@example.com',
        firebaseUid: 'firebase-uid',
        currentCoin: 0,
      );
      final params = UpdateCurrentUserParams(fullName: 'New Name');
      when(() => mockRepository.updateCurrentUser(params))
          .thenAnswer((_) async => Right(entity));

      final result = await usecase(params);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (user) => expect(user, isNotNull),
      );
    });

    test('trả về Left(FailureEntity) khi repository trả badRequest', () async {
      final params = UpdateCurrentUserParams(fullName: '');
      when(() => mockRepository.updateCurrentUser(params))
          .thenAnswer((_) async => const Left(FailureEntity.serverFailure('400', 'Bad request')));

      final result = await usecase(params);

      expect(result.isLeft(), isTrue);
    });

    test('trả về Left(FailureEntity) khi repository trả unauthorized', () async {
      final params = UpdateCurrentUserParams(fullName: 'Name');
      when(() => mockRepository.updateCurrentUser(params))
          .thenAnswer((_) async => const Left(FailureEntity.serverFailure('401', 'Unauthorized')));

      final result = await usecase(params);

      expect(result.isLeft(), isTrue);
    });
  });

  group('GetUserParticipatedEventsUsecase', () {
    late GetUserParticipatedEventsUsecase usecase;

    setUp(() {
      usecase = GetUserParticipatedEventsUsecase(mockRepository);
    });

    test('trả về list EventSummaryEntity khi repository thành công', () async {
      final entities = [
        EventSummaryEntity(eventId: 1, title: 'Event 1'),
        EventSummaryEntity(eventId: 2, title: 'Event 2'),
      ];
      final params = GetUserParticipatedEventsParams(userId: 1);
      when(() => mockRepository.getUserParticipatedEvents(
            userId: any(named: 'userId'),
            participantType: any(named: 'participantType'),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => Right(entities));

      final result = await usecase(params);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (events) {
          expect(events.length, equals(2));
          expect(events.first.eventId, equals(1));
        },
      );
    });

    test('trả về empty list khi repository trả rỗng', () async {
      final params = GetUserParticipatedEventsParams(userId: 1);
      when(() => mockRepository.getUserParticipatedEvents(
            userId: any(named: 'userId'),
            participantType: any(named: 'participantType'),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => const Right([]));

      final result = await usecase(params);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (events) => expect(events, isEmpty),
      );
    });

    test('truyền đúng params xuống repository', () async {
      final params = const GetUserParticipatedEventsParams(
        userId: 1,
        participantType: 'ATTENDEE',
        page: 2,
        size: 10,
      );
      when(() => mockRepository.getUserParticipatedEvents(
            userId: 1,
            participantType: 'ATTENDEE',
            page: 2,
            size: 10,
          )).thenAnswer((_) async => const Right([]));

      await usecase(params);

      verify(() => mockRepository.getUserParticipatedEvents(
            userId: 1,
            participantType: 'ATTENDEE',
            page: 2,
            size: 10,
          )).called(1);
    });

    test('trả về Left(FailureEntity) khi repository trả failure', () async {
      final params = GetUserParticipatedEventsParams(userId: 1);
      when(() => mockRepository.getUserParticipatedEvents(
            userId: any(named: 'userId'),
            participantType: any(named: 'participantType'),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer(
          (_) async => const Left(FailureEntity.serverFailure('500', 'Server error')));

      final result = await usecase(params);

      expect(result.isLeft(), isTrue);
    });
  });

  group('GetUserPackagesUsecase', () {
    test('trả về list UserPackageEntity khi repository thành công', () async {
      final usecase = GetUserPackagesUsecase(mockRepository);
      final entities = [
        UserPackageEntity(
          userPackageId: 1,
          userId: 1,
          packageId: 1,
          packageName: 'Premium',
        ),
      ];
      when(() => mockRepository.getUserPackages(
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => Right(entities));

      final result = await usecase(const GetUserPackagesParams());

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (packages) {
          expect(packages.length, equals(1));
          expect(packages.first.packageName, equals('Premium'));
        },
      );
    });

    test('trả về empty list khi repository trả rỗng', () async {
      final usecase = GetUserPackagesUsecase(mockRepository);
      when(() => mockRepository.getUserPackages(
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => const Right([]));

      final result = await usecase(const GetUserPackagesParams());

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (packages) => expect(packages, isEmpty),
      );
    });

    test('trả về Left(FailureEntity) khi repository trả failure', () async {
      final usecase = GetUserPackagesUsecase(mockRepository);
      when(() => mockRepository.getUserPackages(
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer(
          (_) async => const Left(FailureEntity.serverFailure('500', 'Server error')));

      final result = await usecase(const GetUserPackagesParams());

      expect(result.isLeft(), isTrue);
    });
  });

  group('GetUserRankUsecase', () {
    test('trả về RankEntity khi repository thành công', () async {
      final usecase = GetUserRankUsecase(mockRepository);
      final entity = RankEntity(
        userId: 1,
        totalCoin: 100,
        ranking: 5,
        level: 1,
        levelName: 'Bronze',
      );
      when(() => mockRepository.getUserRank(1))
          .thenAnswer((_) async => Right(entity));

      final result = await usecase(1);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (rank) {
          expect(rank, isNotNull);
          expect(rank!.totalCoin, equals(100));
          expect(rank.ranking, equals(5));
        },
      );
    });

    test('trả về Left(FailureEntity) khi repository trả failure', () async {
      final usecase = GetUserRankUsecase(mockRepository);
      when(() => mockRepository.getUserRank(1))
          .thenAnswer((_) async => const Left(FailureEntity.serverFailure('500', 'Server error')));

      final result = await usecase(1);

      expect(result.isLeft(), isTrue);
    });
  });
}

class GetUserByIdUsecase {
  final UserRepository _repository;

  GetUserByIdUsecase(this._repository);

  Future<Either<FailureEntity, UserEntity?>> call(int userId) async {
    return await _repository.getUserById(userId);
  }
}

class GetUserPackagesParams {
  final int page;
  final int size;

  const GetUserPackagesParams({this.page = 0, this.size = 20});
}

class GetUserPackagesUsecase {
  final UserRepository _repository;

  GetUserPackagesUsecase(this._repository);

  Future<Either<FailureEntity, List<UserPackageEntity>>> call(GetUserPackagesParams params) async {
    return await _repository.getUserPackages(page: params.page, size: params.size);
  }
}

class GetUserRankUsecase {
  final UserRepository _repository;

  GetUserRankUsecase(this._repository);

  Future<Either<FailureEntity, RankEntity?>> call(int userId) async {
    return await _repository.getUserRank(userId);
  }
}
