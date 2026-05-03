import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';
import 'package:events_app/feature/registration/domain/usecase/registration_usecase.dart';
import 'package:events_app/feature/registration/presentation/controller/registration_controller.dart';
import 'package:events_app/feature/user_management/domain/entity/user_summary_entity.dart';
import 'package:events_app/feature/user_management/domain/entity/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateRegistrationUsecase extends Mock implements CreateRegistrationUsecase {}
class MockCancelRegistrationUsecase extends Mock implements CancelRegistrationUsecase {}
class MockGetMyRegistrationsUsecase extends Mock implements GetMyRegistrationsUsecase {}
class MockGetRegistrationByIdUsecase extends Mock implements GetRegistrationByIdUsecase {}
class MockAuthController extends Mock implements AuthController {}

class FakeCreateRegistrationParams extends Fake implements CreateRegistrationParams {}
class FakeGetMyRegistrationsParams extends Fake implements GetMyRegistrationsParams {}

void main() {
  late MockCreateRegistrationUsecase mockCreateRegistrationUsecase;
  late MockCancelRegistrationUsecase mockCancelRegistrationUsecase;
  late MockGetMyRegistrationsUsecase mockGetMyRegistrationsUsecase;
  late MockGetRegistrationByIdUsecase mockGetRegistrationByIdUsecase;
  late MockAuthController mockAuthController;
  late RegistrationController controller;

  ParticipantEntity makeParticipant({
    int? id = 1,
    int? eventId = 10,
    ParticipantType type = ParticipantType.attendee,
    int? ticketId,
    ParticipantStatus status = ParticipantStatus.registered,
  }) {
    return ParticipantEntity(
      eventParticipantId: id,
      eventId: eventId,
      user: UserSummaryEntity(userId: 1, fullName: 'Test User'),
      participantType: type,
      ticketId: ticketId,
      status: status,
    );
  }

  setUpAll(() {
    registerFallbackValue(FakeCreateRegistrationParams());
    registerFallbackValue(FakeGetMyRegistrationsParams());
    registerFallbackValue(0);
  });

  setUp(() async {
    Get.testMode = true;
    await networkGetIt.reset();

    mockCreateRegistrationUsecase = MockCreateRegistrationUsecase();
    mockCancelRegistrationUsecase = MockCancelRegistrationUsecase();
    mockGetMyRegistrationsUsecase = MockGetMyRegistrationsUsecase();
    mockGetRegistrationByIdUsecase = MockGetRegistrationByIdUsecase();
    mockAuthController = MockAuthController();

    when(() => mockAuthController.currentUser).thenReturn(Rx(UserEntity(userId: 42, email: 'test@test.com', firebaseUid: 'uid', currentCoin: 0)));
    Get.put<AuthController>(mockAuthController);

    controller = RegistrationController.internal(
      createRegistrationUsecase: mockCreateRegistrationUsecase,
      getMyRegistrationsUsecase: mockGetMyRegistrationsUsecase,
      cancelRegistrationUsecase: mockCancelRegistrationUsecase,
      authControllerProvider: () => mockAuthController,
    );

    when(() => mockGetMyRegistrationsUsecase(any()))
        .thenAnswer((_) async => const Right([]));
  });

  tearDown(() async {
    Get.reset();
    await networkGetIt.reset();
  });

  group('initial state', () {
    test('registrations rỗng, isLoading = false khi khởi tạo', () {
      expect(controller.registrations, isEmpty);
      expect(controller.isLoading.value, isFalse);
    });

    test('isRegistering = false khi khởi tạo', () {
      expect(controller.isRegistering.value, isFalse);
    });
  });

  group('registerForEvent', () {
    test('thành công thì thêm vào registrations list', () async {
      final participant = makeParticipant(id: 5, eventId: 100);
      when(() => mockCreateRegistrationUsecase(any()))
          .thenAnswer((_) async => Right(participant));

      final result = await controller.registerForEvent(100);

      expect(result, equals(participant));
      expect(controller.registrations.length, equals(1));
      expect(controller.registrations.first.eventParticipantId, equals(5));
    });

    test('trả về 409 conflict thì xử lý lỗi', () async {
      when(() => mockCreateRegistrationUsecase(any()))
          .thenAnswer((_) async => const Left(FailureEntity.serverFailure('409', 'Conflict')));

      final result = await controller.registerForEvent(100);

      expect(result, isNull);
      expect(controller.registrations, isEmpty);
    });

    test('trả về 404 thì xử lý lỗi', () async {
      when(() => mockCreateRegistrationUsecase(any()))
          .thenAnswer((_) async => const Left(FailureEntity.serverFailure('404', 'Not found')));

      final result = await controller.registerForEvent(9999);

      expect(result, isNull);
    });

    test('sets isRegistering = true trong khi gọi', () async {
      when(() => mockCreateRegistrationUsecase(any())).thenAnswer(
        (_) async {
          await Future.delayed(const Duration(milliseconds: 10));
          return Right(makeParticipant());
        },
      );

      final future = controller.registerForEvent(1);
      expect(controller.isRegistering.value, isTrue);

      await future;
      expect(controller.isRegistering.value, isFalse);
    });
  });

  group('cancelRegistration', () {
    test('thành công thì xóa khỏi list', () async {
      controller.registrations.add(makeParticipant(id: 10));
      controller.registrations.add(makeParticipant(id: 20));
      when(() => mockCancelRegistrationUsecase(any()))
          .thenAnswer((_) async => const Right(unit));

      await controller.cancelRegistration(10);

      expect(controller.registrations.length, equals(1));
      expect(controller.registrations.first.eventParticipantId, equals(20));
    });

    test('404 thì xử lý lỗi', () async {
      controller.registrations.add(makeParticipant(id: 10));
      when(() => mockCancelRegistrationUsecase(any()))
          .thenAnswer((_) async => const Left(FailureEntity.serverFailure('404', 'Not found')));

      await controller.cancelRegistration(9999);

      expect(controller.registrations.length, equals(1));
    });
  });

  group('loadMyRegistrations', () {
    test('thành công thì populate list', () async {
      final registrations = [
        makeParticipant(id: 1),
        makeParticipant(id: 2),
      ];
      when(() => mockGetMyRegistrationsUsecase(any()))
          .thenAnswer((_) async => Right(registrations));

      await controller.loadMyRegistrations(refresh: true);

      expect(controller.registrations.length, equals(2));
    });

    test('sets isLoading = true khi bắt đầu load', () async {
      when(() => mockGetMyRegistrationsUsecase(any())).thenAnswer(
        (_) async {
          await Future.delayed(const Duration(milliseconds: 10));
          return const Right([]);
        },
      );

      final future = controller.loadMyRegistrations();
      expect(controller.isLoading.value, isTrue);

      await future;
      expect(controller.isLoading.value, isFalse);
    });

    test('propagates failure khi datasource lỗi', () async {
      when(() => mockGetMyRegistrationsUsecase(any()))
          .thenAnswer((_) async => const Left(FailureEntity.serverFailure('500', 'error')));

      await controller.loadMyRegistrations();

      expect(controller.registrations, isEmpty);
    });
  });
}
