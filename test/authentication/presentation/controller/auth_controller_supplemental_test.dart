import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/data/datasource/auth_datasource.dart';
import 'package:events_app/authentication/domain/usecase/get_current_user_usecase.dart';
import 'package:events_app/authentication/domain/usecase/send_password_reset_email_usecase.dart';
import 'package:events_app/authentication/domain/usecase/signin_with_email_and_password_usecase.dart';
import 'package:events_app/authentication/domain/usecase/signin_with_google_usecase.dart';
import 'package:events_app/authentication/domain/usecase/signout_usecase.dart';
import 'package:events_app/authentication/domain/usecase/signup_params.dart';
import 'package:events_app/authentication/domain/usecase/signup_with_email_and_password_usecase.dart';
import 'package:events_app/authentication/domain/usecase/signup_with_google_usecase.dart';
import 'package:events_app/authentication/domain/usecase/upload_verification_document_usecase.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/common/helpers/no_params.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/user_management/domain/entity/user_entity.dart';
import 'package:events_app/feature/user_management/domain/usecase/get_current_user_usecase.dart'
    as user_management;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

class MockSigninWithEmailAndPasswordUsecase extends Mock
    implements SigninWithEmailAndPasswordUsecase {}

class MockSignupWithEmailAndPasswordUsecase extends Mock
    implements SignupWithEmailAndPasswordUsecase {}

class MockSignoutUsecase extends Mock implements SignoutUsecase {}

class MockSignInWithGoogleOnlyUsecase extends Mock
    implements SignInWithGoogleOnlyUsecase {}

class MockSignUpWithGoogleUsecase extends Mock
    implements SignUpWithGoogleUsecase {}

class MockSendPasswordResetEmailUsecase extends Mock
    implements SendPasswordResetEmailUsecase {}

class MockGetCurrentUserUsecase extends Mock
    implements user_management.GetCurrentUserUsecase {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class FakeNoParams extends Fake implements NoParams {}

class FakeSignupParams extends Fake implements SignupParams {}

void main() {
  late MockSigninWithEmailAndPasswordUsecase signinUsecase;
  late MockSignupWithEmailAndPasswordUsecase signupUsecase;
  late MockSignoutUsecase signoutUsecase;
  late MockSigninWithGoogleOnlyUsecase signinWithGoogleUsecase;
  late MockSignUpWithGoogleUsecase signupWithGoogleUsecase;
  late MockSendPasswordResetEmailUsecase sendResetEmailUsecase;
  late MockGetCurrentUserUsecase getCurrentUserUsecase;
  late MockFirebaseAuth mockFirebaseAuth;
  late AuthController controller;

  setUpAll(() {
    registerFallbackValue(FakeNoParams());
    registerFallbackValue(FakeSignupParams());
    registerFallbackValue(const NoParams());
    registerFallbackValue(const SigninWithEmailAndPasswordParams(
      email: 'test@example.com',
      password: 'password123',
    ));
    registerFallbackValue(const SignupWithEmailAndPasswordParams(
      password: 'password123',
      signupParams: SignupParams(
        idToken: 'token',
        isUser: true,
        email: 'test@example.com',
      ),
    ));
    registerFallbackValue(
        const SendPasswordResetEmailParams(email: 'test@example.com'));
    registerFallbackValue(FirebaseAuth.instance);
  });

  setUp(() {
    Get.testMode = true;
    networkGetIt.reset();

    signinUsecase = MockSigninWithEmailAndPasswordUsecase();
    signupUsecase = MockSignupWithEmailAndPasswordUsecase();
    signoutUsecase = MockSignoutUsecase();
    signinWithGoogleUsecase = MockSigninWithGoogleOnlyUsecase();
    signupWithGoogleUsecase = MockSignUpWithGoogleUsecase();
    sendResetEmailUsecase = MockSendPasswordResetEmailUsecase();
    getCurrentUserUsecase = MockGetCurrentUserUsecase();
    mockFirebaseAuth = MockFirebaseAuth();
    AuthController.testFirebaseAuth = mockFirebaseAuth;

    when(() => mockFirebaseAuth.authStateChanges())
        .thenAnswer((_) => const Stream.empty());

    networkGetIt
        .registerSingleton<SigninWithEmailAndPasswordUsecase>(signinUsecase);
    networkGetIt
        .registerSingleton<SignupWithEmailAndPasswordUsecase>(signupUsecase);
    networkGetIt.registerSingleton<SignoutUsecase>(signoutUsecase);
    networkGetIt.registerSingleton<SigninWithGoogleOnlyUsecase>(
        signinWithGoogleUsecase);
    networkGetIt
        .registerSingleton<SignUpWithGoogleUsecase>(signupWithGoogleUsecase);
    networkGetIt.registerSingleton<SendPasswordResetEmailUsecase>(
        sendResetEmailUsecase);
    networkGetIt.registerSingleton<user_management.GetCurrentUserUsecase>(
        getCurrentUserUsecase);

    controller = AuthController.internal();
  });

  tearDown(() {
    Get.reset();
    networkGetIt.reset();
    AuthController.testFirebaseAuth = null;
  });

  group('AuthController - Validation Methods', () {
    test('validateEmail - chuoi rong tra ve error', () {
      final result = controller.validateEmail('');
      expect(result, 'Vui lòng nhập email');
    });

    test('validateEmail - dinh dang sai tra ve error', () {
      final result = controller.validateEmail('not-an-email');
      expect(result, 'Email không hợp lệ');
    });

    test('validateEmail - gia tri hop le tra ve null', () {
      final result = controller.validateEmail('test@example.com');
      expect(result, isNull);
    });

    test('validatePassword - chuoi rong tra ve error', () {
      final result = controller.validatePassword('');
      expect(result, 'Vui lòng nhập mật khẩu');
    });

    test('validatePassword - it hon 6 ky tu tra ve error', () {
      final result = controller.validatePassword('12345');
      expect(result, 'Mật khẩu phải có ít nhất 6 ký tự');
    });

    test('validatePassword - gia tri hop le tra ve null', () {
      final result = controller.validatePassword('password123');
      expect(result, isNull);
    });

    test('validateRegisterConfirmPassword - mat khau khong khop tra ve error',
        () {
      controller.registerPasswordController.text = 'password123';
      final result =
          controller.validateRegisterConfirmPassword('differentpassword');
      expect(result, 'Mật khẩu không khớp');
    });

    test('validateRegisterConfirmPassword - mat khau khop tra ve null', () {
      controller.registerPasswordController.text = 'password123';
      final result = controller.validateRegisterConfirmPassword('password123');
      expect(result, isNull);
    });

    test('validateFullName - chuoi rong tra ve error', () {
      final result = controller.validateFullName('');
      expect(result, 'Vui lòng nhập họ tên');
    });

    test('validateFullName - it hon 2 ky tu tra ve error', () {
      final result = controller.validateFullName('A');
      expect(result, 'Họ tên tối thiểu 2 ký tự');
    });

    test('validateFullName - gia tri hop le tra ve null', () {
      final result = controller.validateFullName('Nguyen Van');
      expect(result, isNull);
    });

    test('validateOrganizationName - khi khong phai org tra ve null', () {
      controller.registerAsOrganization.value = false;
      final result = controller.validateOrganizationName('');
      expect(result, isNull);
    });

    test('validateOrganizationName - khi la org nhung rong tra ve error', () {
      controller.registerAsOrganization.value = true;
      final result = controller.validateOrganizationName('');
      expect(result, 'Vui lòng nhập tên tổ chức');
    });
  });

  group('AuthController - Toggle Visibility Methods', () {
    test('toggleLoginPasswordVisibility toggles loginObscurePassword', () {
      expect(controller.loginObscurePassword.value, true);
      controller.toggleLoginPasswordVisibility();
      expect(controller.loginObscurePassword.value, false);
      controller.toggleLoginPasswordVisibility();
      expect(controller.loginObscurePassword.value, true);
    });

    test('toggleRegisterPasswordVisibility toggles registerObscurePassword',
        () {
      expect(controller.registerObscurePassword.value, true);
      controller.toggleRegisterPasswordVisibility();
      expect(controller.registerObscurePassword.value, false);
      controller.toggleRegisterPasswordVisibility();
      expect(controller.registerObscurePassword.value, true);
    });

    test(
        'toggleRegisterConfirmPasswordVisibility toggles registerObscureConfirmPassword',
        () {
      expect(controller.registerObscureConfirmPassword.value, true);
      controller.toggleRegisterConfirmPasswordVisibility();
      expect(controller.registerObscureConfirmPassword.value, false);
      controller.toggleRegisterConfirmPasswordVisibility();
      expect(controller.registerObscureConfirmPassword.value, true);
    });
  });

  group('AuthController - Setter Methods', () {
    test('setRegisterAsOrganization sets registerAsOrganization', () {
      expect(controller.registerAsOrganization.value, false);
      controller.setRegisterAsOrganization(true);
      expect(controller.registerAsOrganization.value, true);
      controller.setRegisterAsOrganization(false);
      expect(controller.registerAsOrganization.value, false);
    });

    test('setOrganizationType sets organizationType', () {
      expect(controller.organizationType.value, OrganizationType.club);
      controller.setOrganizationType(OrganizationType.university);
      expect(controller.organizationType.value, OrganizationType.university);
      controller.setOrganizationType(OrganizationType.company);
      expect(controller.organizationType.value, OrganizationType.company);
    });

    test('setSelectedGender sets selectedGender', () {
      expect(controller.selectedGender.value, isNull);
      controller.setSelectedGender('NAM');
      expect(controller.selectedGender.value, 'NAM');
      controller.setSelectedGender('NU');
      expect(controller.selectedGender.value, 'NU');
      controller.setSelectedGender(null);
      expect(controller.selectedGender.value, isNull);
    });

    test('setSelectedBirthDate sets selectedBirthDate', () {
      final testDate = DateTime(2000, 1, 1);
      expect(controller.selectedBirthDate.value, isNull);
      controller.setSelectedBirthDate(testDate);
      expect(controller.selectedBirthDate.value, testDate);
    });
  });

  group('AuthController - Reset/Clear Methods', () {
    test('resetAllRegisterFields clears all form fields', () {
      controller.registerFullNameController.text = 'Test User';
      controller.registerEmailController.text = 'test@example.com';
      controller.registerPhoneController.text = '0912345678';
      controller.registerPasswordController.text = 'password123';
      controller.registerConfirmPasswordController.text = 'password123';
      controller.selectedGender.value = 'NAM';
      controller.selectedBirthDate.value = DateTime(2000, 1, 1);

      controller.resetAllRegisterFields();

      expect(controller.registerFullNameController.text, '');
      expect(controller.registerEmailController.text, '');
      expect(controller.registerPhoneController.text, '');
      expect(controller.registerPasswordController.text, '');
      expect(controller.registerConfirmPasswordController.text, '');
      expect(controller.selectedGender.value, isNull);
      expect(controller.selectedBirthDate.value, isNull);
    });

    test('clearRegisterForm resets all fields and googleAuthResult', () {
      controller.registerFullNameController.text = 'Test User';
      controller.registerEmailController.text = 'test@example.com';
      controller.googleAuthResult.value = const GoogleAuthSession(
        firebaseUid: 'test-uid',
        idToken: 'test-token',
        email: 'test@example.com',
        isNewUser: true,
        state: GoogleAuthState.success,
      );

      controller.clearRegisterForm();

      expect(controller.registerFullNameController.text, '');
      expect(controller.registerEmailController.text, '');
      expect(controller.googleAuthResult.value.state, GoogleAuthState.none);
    });
  });

  group('AuthController - Avatar Upload Callback', () {
    test('onAvatarUploadedInRegister sets avatar file id and preview URL', () {
      expect(controller.registerAvatarFileId.value, isNull);
      expect(controller.registerAvatarPreviewUrl.value, isNull);

      controller.onAvatarUploadedInRegister(
          123, 'https://example.com/avatar.jpg');

      expect(controller.registerAvatarFileId.value, 123);
      expect(controller.registerAvatarPreviewUrl.value,
          'https://example.com/avatar.jpg');
    });
  });

  group('AuthController - Google Sign In', () {
    test('signInWithGoogleOnly goi usecase va tra ve GoogleAuthSession.success',
        () async {
      final googleResult = GoogleSignInResult.success(
        firebaseUid: 'google-uid-123',
        idToken: 'google-token',
        accessToken: 'google-access-token',
        email: 'google@example.com',
        isNewUser: false,
      );
      when(() => signinWithGoogleUsecase(any()))
          .thenAnswer((_) async => Right(googleResult));

      final result = await controller.signInWithGoogleOnly();

      expect(result.state, GoogleAuthState.success);
      expect(result.firebaseUid, 'google-uid-123');
      expect(result.idToken, 'google-token');
      expect(result.email, 'google@example.com');
      verify(() => signinWithGoogleUsecase(any())).called(1);
    });

    test('signInWithGoogleOnly tra ve error session khi that bai', () async {
      const failure =
          FailureEntity.serverFailure('GOOGLE_ERROR', 'Google failed');
      when(() => signinWithGoogleUsecase(any()))
          .thenAnswer((_) async => const Left(failure));

      final result = await controller.signInWithGoogleOnly();

      expect(result.state, GoogleAuthState.error);
    });

    test('signInWithGoogleOnly tra ve error session khi isLoadingEmail true',
        () async {
      controller.isLoadingEmail.value = true;

      final result = await controller.signInWithGoogleOnly();

      expect(result.state, GoogleAuthState.error);
      expect(result.errorMessage, 'Đang xử lý...');
    });
  });

  group('AuthController - Early Return Conditions', () {
    test('submitLogin return early khi isLoadingEmail la true', () async {
      controller.isLoadingEmail.value = true;
      controller.loginEmailController.text = 'test@example.com';
      controller.loginPasswordController.text = 'password123';

      await controller.submitLogin();

      verifyNever(() => signinUsecase(any()));
    });

    test('submitRegister return early khi isLoadingEmail la true', () async {
      controller.isLoadingEmail.value = true;
      controller.registerEmailController.text = 'test@example.com';
      controller.registerPasswordController.text = 'password123';
      controller.registerConfirmPasswordController.text = 'password123';
      controller.registerAsOrganization.value = false;
      controller.registerFullNameController.text = 'Test User';

      await controller.submitRegister(isStudent: true);

      verifyNever(() => signupUsecase(any()));
    });
  });
}
