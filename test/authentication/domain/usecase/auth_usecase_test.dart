import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/data/datasource/auth_datasource.dart';
import 'package:events_app/authentication/domain/repository/auth_repository.dart';
import 'package:events_app/authentication/domain/usecase/get_current_user_usecase.dart';
import 'package:events_app/authentication/domain/usecase/send_password_reset_email_usecase.dart';
import 'package:events_app/authentication/domain/usecase/signin_with_email_and_password_usecase.dart';
import 'package:events_app/authentication/domain/usecase/signin_with_google_usecase.dart';
import 'package:events_app/authentication/domain/usecase/signout_usecase.dart';
import 'package:events_app/authentication/domain/usecase/signup_params.dart';
import 'package:events_app/authentication/domain/usecase/signup_with_email_and_password_usecase.dart';
import 'package:events_app/authentication/domain/usecase/signup_with_google_usecase.dart';
import 'package:events_app/common/helpers/no_params.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/user_management/domain/entity/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class FakeSignupParams extends Fake implements SignupParams {}

void main() {
  late MockAuthRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeSignupParams());
    registerFallbackValue(const NoParams());
    registerFallbackValue(SigninWithEmailAndPasswordParams(
      email: 'test@example.com',
      password: 'password123',
    ));
    registerFallbackValue(SignupWithEmailAndPasswordParams(
      password: 'password123',
      signupParams: SignupParams(
        idToken: 'token',
        isUser: true,
        email: 'test@example.com',
      ),
    ));
    registerFallbackValue(const SendPasswordResetEmailParams(email: 'test@example.com'));
  });

  setUp(() {
    mockRepository = MockAuthRepository();
  });

  UserEntity createFakeUser({int userId = 1, UserRole role = UserRole.user}) {
    return UserEntity(
      userId: userId,
      email: 'test@example.com',
      firebaseUid: 'firebase-uid-$userId',
      phoneNumber: null,
      role: role,
      status: UserStatus.active,
      currentCoin: 0,
      createdTime: DateTime.now(),
    );
  }

  group('GetCurrentUserUsecase', () {
    late GetCurrentUserUsecase usecase;

    setUp(() {
      usecase = GetCurrentUserUsecase(mockRepository);
    });

    test('tra ve user khi thanh cong', () async {
      final fakeUser = createFakeUser();
      when(() => mockRepository.getCurrentUser())
          .thenAnswer((_) async => Right(fakeUser));

      final result = await usecase(const NoParams());

      expect(result.fold(
        (failure) => null,
        (user) => user,
      ), fakeUser);
      verify(() => mockRepository.getCurrentUser()).called(1);
    });

    test('tra ve failure khi co loi', () async {
      const failure = FailureEntity.serverFailure('500', 'Server error');
      when(() => mockRepository.getCurrentUser())
          .thenAnswer((_) async => const Left(failure));

      final result = await usecase(const NoParams());

      result.fold(
        (f) => expect(f, failure),
        (_) => fail('Expected failure'),
      );
      verify(() => mockRepository.getCurrentUser()).called(1);
    });
  });

  group('SigninWithEmailAndPasswordUsecase', () {
    late SigninWithEmailAndPasswordUsecase usecase;

    setUp(() {
      usecase = SigninWithEmailAndPasswordUsecase(mockRepository);
    });

    test('tra ve user khi dang nhap thanh cong', () async {
      final fakeUser = createFakeUser();
      final params = SigninWithEmailAndPasswordParams(
        email: 'user@example.com',
        password: 'password123',
      );
      when(() => mockRepository.signInWithEmailAndPassword(
            params.email,
            params.password,
          )).thenAnswer((_) async => Right(fakeUser));

      final result = await usecase(params);

      expect(result.fold(
        (failure) => null,
        (user) => user,
      ), fakeUser);
      verify(() => mockRepository.signInWithEmailAndPassword(
            params.email,
            params.password,
          )).called(1);
    });

    test('propagate failure khi dang nhap that bai', () async {
      const failure = FailureEntity.serverFailure('401', 'Invalid credentials');
      final params = SigninWithEmailAndPasswordParams(
        email: 'user@example.com',
        password: 'wrongpassword',
      );
      when(() => mockRepository.signInWithEmailAndPassword(
            params.email,
            params.password,
          )).thenAnswer((_) async => const Left(failure));

      final result = await usecase(params);

      result.fold(
        (f) => expect(f, failure),
        (_) => fail('Expected failure'),
      );
    });
  });

  group('SignupWithEmailAndPasswordUsecase', () {
    late SignupWithEmailAndPasswordUsecase usecase;

    setUp(() {
      usecase = SignupWithEmailAndPasswordUsecase(mockRepository);
    });

    test('tra ve user khi dang ky thanh cong', () async {
      final fakeUser = createFakeUser(userId: 2);
      final signupParams = SignupParams(
        idToken: 'id-token',
        isUser: true,
        email: 'newuser@example.com',
        userProfile: const SignupUserProfileParams(fullName: 'New User'),
      );
      final params = SignupWithEmailAndPasswordParams(
        password: 'password123',
        signupParams: signupParams,
      );
      when(() => mockRepository.signUpWithEmailAndPassword(
            params.password,
            signupParams,
          )).thenAnswer((_) async => Right(fakeUser));

      final result = await usecase(params);

      expect(result.fold(
        (failure) => null,
        (user) => user,
      ), fakeUser);
    });

    test('propagate failure khi dang ky that bai', () async {
      const failure = FailureEntity.serverFailure('409', 'Email already exists');
      final signupParams = SignupParams(
        idToken: 'id-token',
        isUser: true,
        email: 'existing@example.com',
      );
      final params = SignupWithEmailAndPasswordParams(
        password: 'password123',
        signupParams: signupParams,
      );
      when(() => mockRepository.signUpWithEmailAndPassword(
            params.password,
            signupParams,
          )).thenAnswer((_) async => const Left(failure));

      final result = await usecase(params);

      result.fold(
        (f) => expect(f, failure),
        (_) => fail('Expected failure'),
      );
    });
  });

  group('SignOutUsecase', () {
    late SignoutUsecase usecase;

    setUp(() {
      usecase = SignoutUsecase(mockRepository);
    });

    test('tra ve unit khi dang xuat thanh cong', () async {
      when(() => mockRepository.signOut())
          .thenAnswer((_) async => const Right(unit));

      final result = await usecase(const NoParams());

      expect(result.isRight(), true);
      verify(() => mockRepository.signOut()).called(1);
    });

    test('propagate failure khi dang xuat that bai', () async {
      const failure = FailureEntity.noConnectionFailure();
      when(() => mockRepository.signOut())
          .thenAnswer((_) async => const Left(failure));

      final result = await usecase(const NoParams());

      result.fold(
        (f) => expect(f, failure),
        (_) => fail('Expected failure'),
      );
    });
  });

  group('SendPasswordResetEmailUsecase', () {
    late SendPasswordResetEmailUsecase usecase;

    setUp(() {
      usecase = SendPasswordResetEmailUsecase(mockRepository);
    });

    test('tra ve unit khi gui email thanh cong', () async {
      const params = SendPasswordResetEmailParams(email: 'reset@example.com');
      when(() => mockRepository.sendPasswordResetEmail(params.email))
          .thenAnswer((_) async => const Right(unit));

      final result = await usecase(params);

      expect(result.isRight(), true);
      verify(() => mockRepository.sendPasswordResetEmail(params.email)).called(1);
    });

    test('propagate failure khi gui email that bai', () async {
      const params = SendPasswordResetEmailParams(email: 'invalid@example.com');
      const failure = FailureEntity.serverFailure('400', 'Invalid email');
      when(() => mockRepository.sendPasswordResetEmail(params.email))
          .thenAnswer((_) async => const Left(failure));

      final result = await usecase(params);

      result.fold(
        (f) => expect(f, failure),
        (_) => fail('Expected failure'),
      );
    });
  });

  group('SignInWithGoogleOnlyUsecase', () {
    late SignInWithGoogleOnlyUsecase usecase;

    setUp(() {
      usecase = SignInWithGoogleOnlyUsecase(mockRepository);
    });

    test('tra ve GoogleSignInResult khi dang nhap Google thanh cong', () async {
      final googleResult = GoogleSignInResult.success(
        firebaseUid: 'google-uid-123',
        idToken: 'google-id-token',
        accessToken: 'google-access-token',
        email: 'google@example.com',
        isNewUser: false,
      );
      when(() => mockRepository.signInWithGoogleOnly())
          .thenAnswer((_) async => Right(googleResult));

      final result = await usecase(const NoParams());

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected success'),
        (googleRes) {
          expect(googleRes.isSuccess, true);
          expect(googleRes.firebaseUid, 'google-uid-123');
        },
      );
    });

    test('tra ve failure khi dang nhap Google that bai', () async {
      const failure = FailureEntity.serverFailure('GOOGLE_ERROR', 'Google sign in failed');
      when(() => mockRepository.signInWithGoogleOnly())
          .thenAnswer((_) async => const Left(failure));

      final result = await usecase(const NoParams());

      result.fold(
        (f) => expect(f, failure),
        (_) => fail('Expected failure'),
      );
    });

    test('tra ve result bi huy khi nguoi dung huy dang nhap Google', () async {
      final googleResult = GoogleSignInResult.canceled();
      when(() => mockRepository.signInWithGoogleOnly())
          .thenAnswer((_) async => Right(googleResult));

      final result = await usecase(const NoParams());

      result.fold(
        (_) => fail('Expected success'),
        (googleRes) => expect(googleRes.isCanceled, true),
      );
    });
  });

  group('SignUpWithGoogleUsecase', () {
    late SignUpWithGoogleUsecase usecase;

    setUp(() {
      usecase = SignUpWithGoogleUsecase(mockRepository);
    });

    test('tra ve user khi dang ky Google thanh cong', () async {
      final fakeUser = createFakeUser(userId: 3);
      final signupParams = SignupParams(
        idToken: 'google-token',
        isUser: true,
        email: 'google-new@example.com',
      );
      when(() => mockRepository.signUpWithGoogle(signupParams: signupParams))
          .thenAnswer((_) async => Right(fakeUser));

      final result = await usecase(signupParams);

      expect(result.fold(
        (failure) => null,
        (user) => user,
      ), fakeUser);
    });

    test('propagate failure khi dang ky Google that bai', () async {
      const failure = FailureEntity.serverFailure('GOOGLE_SIGNUP_ERROR', 'Signup failed');
      final signupParams = SignupParams(
        idToken: 'google-token',
        isUser: true,
        email: 'google@example.com',
      );
      when(() => mockRepository.signUpWithGoogle(signupParams: signupParams))
          .thenAnswer((_) async => const Left(failure));

      final result = await usecase(signupParams);

      result.fold(
        (f) => expect(f, failure),
        (_) => fail('Expected failure'),
      );
    });
  });
}
