import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/authentication/domain/usecase/get_current_user_usecase.dart';
import 'package:events_app/authentication/domain/usecase/send_password_reset_email_usecase.dart';
import 'package:events_app/authentication/domain/usecase/signin_with_email_and_password_usecase.dart';
import 'package:events_app/authentication/domain/usecase/signin_with_google_usecase.dart';
import 'package:events_app/authentication/domain/usecase/signout_usecase.dart';
import 'package:events_app/authentication/domain/usecase/signup_with_email_and_password_usecase.dart';
import 'package:events_app/authentication/domain/usecase/signup_params.dart';
import 'package:events_app/authentication/domain/usecase/upload_verification_document_usecase.dart';
import 'package:events_app/feature/common/usecase/upload_file_usecase.dart';
import 'package:events_app/feature/common/usecase/upload_file_params.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/authentication/presentation/pages/organizer_pending_approval_screen.dart';
import 'package:events_app/authentication/domain/auth_constants.dart';
import 'package:events_app/authentication/domain/usecase/signin_with_google_usecase.dart';
import 'package:events_app/common/helpers/no_params.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/user_management/domain/entity/user_profile_entity.dart';
import 'package:events_app/feature/user_management/domain/entity/user_entity.dart';
import 'package:events_app/feature/user_management/domain/usecase/get_current_user_usecase.dart'
    as user_management;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

class MockSigninWithEmailAndPasswordUsecase extends Mock
    implements SigninWithEmailAndPasswordUsecase {}

class MockSignupWithEmailAndPasswordUsecase extends Mock
    implements SignupWithEmailAndPasswordUsecase {}

class MockSignoutUsecase extends Mock implements SignoutUsecase {}

class MockGetCurrentUserUsecase extends Mock implements GetCurrentUserUsecase {}

class MockSendPasswordResetEmailUsecase extends Mock
    implements SendPasswordResetEmailUsecase {}

class MockSigninWithGoogleUsecase extends Mock
    implements SigninWithGoogleUsecase {}

class MockSignInWithGoogleOnlyUsecase extends Mock
    implements SignInWithGoogleOnlyUsecase {}

class MockSignInWithGoogleExistingUserUsecase extends Mock
    implements SignInWithGoogleExistingUserUsecase {}

class MockUploadVerificationDocumentUsecase extends Mock
    implements UploadVerificationDocumentUsecase {}

class MockUploadFileUsecase extends Mock implements UploadFileUsecase {}

class MockRefreshCurrentUserUsecase extends Mock
    implements user_management.GetCurrentUserUsecase {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  late MockSigninWithEmailAndPasswordUsecase signinUsecase;
  late MockSignupWithEmailAndPasswordUsecase signupUsecase;
  late MockSignoutUsecase signoutUsecase;
  late MockGetCurrentUserUsecase getCurrentUserUsecase;
  late MockSendPasswordResetEmailUsecase sendPasswordResetEmailUsecase;
  late MockSigninWithGoogleUsecase signinWithGoogleUsecase;
  late MockSignInWithGoogleOnlyUsecase signInWithGoogleOnlyUsecase;
  late MockSignInWithGoogleExistingUserUsecase signInWithGoogleExistingUserUsecase;
  late MockUploadVerificationDocumentUsecase uploadVerificationDocumentUsecase;
  late MockUploadFileUsecase uploadFileUsecase;
  late MockRefreshCurrentUserUsecase refreshCurrentUserUsecase;
  late AuthController controller;

  Future<void> pumpShell(WidgetTester tester) async {
    await tester.pumpWidget(
      const GetMaterialApp(
        home: Scaffold(body: SizedBox.shrink()),
      ),
    );
  }

  Future<void> drainOverlay(WidgetTester tester) async {
    await tester.pump();
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
      await tester.pumpAndSettle();
    }
  }

  setUpAll(() {
    registerFallbackValue(
      const SigninWithEmailAndPasswordParams(
        email: 'fallback@email.com',
        password: '123456',
      ),
    );
    registerFallbackValue(
      SignupWithEmailAndPasswordParams(
        password: '123456',
        signupParams: SignupParams(
          idToken: 'fallback-token',
          email: 'fallback@email.com',
          isUser: true,
          userProfile: SignupUserProfileParams(fullName: 'Fallback User'),
        ),
      ),
    );
    registerFallbackValue(
      const SendPasswordResetEmailParams(email: 'fallback@email.com'),
    );
    registerFallbackValue(const NoParams());
    registerFallbackValue(
      const UploadFileParams(
        filePath: '/fallback/path',
        fileType: FileType.avatar,
      ),
    );
    registerFallbackValue('fallback-string');
  });

  setUp(() async {
    Get.testMode = true;
    await networkGetIt.reset();
    signinUsecase = MockSigninWithEmailAndPasswordUsecase();
    signupUsecase = MockSignupWithEmailAndPasswordUsecase();
    signoutUsecase = MockSignoutUsecase();
    getCurrentUserUsecase = MockGetCurrentUserUsecase();
    sendPasswordResetEmailUsecase = MockSendPasswordResetEmailUsecase();
    signinWithGoogleUsecase = MockSigninWithGoogleUsecase();
    signInWithGoogleOnlyUsecase = MockSignInWithGoogleOnlyUsecase();
    signInWithGoogleExistingUserUsecase = MockSignInWithGoogleExistingUserUsecase();
    uploadVerificationDocumentUsecase = MockUploadVerificationDocumentUsecase();
    uploadFileUsecase = MockUploadFileUsecase();
    refreshCurrentUserUsecase = MockRefreshCurrentUserUsecase();

    final mockFirebaseAuth = MockFirebaseAuth();
    AuthController.testFirebaseAuth = mockFirebaseAuth;
    networkGetIt.registerSingleton<FirebaseAuth>(mockFirebaseAuth);
    when(() => mockFirebaseAuth.authStateChanges()).thenAnswer(
      (_) => const Stream.empty(),
    );
    networkGetIt.registerSingleton<SigninWithEmailAndPasswordUsecase>(
      signinUsecase,
    );
    networkGetIt.registerSingleton<SignupWithEmailAndPasswordUsecase>(
      signupUsecase,
    );
    networkGetIt.registerSingleton<SignoutUsecase>(signoutUsecase);
    networkGetIt.registerSingleton<GetCurrentUserUsecase>(
      getCurrentUserUsecase,
    );
    networkGetIt.registerSingleton<SendPasswordResetEmailUsecase>(
      sendPasswordResetEmailUsecase,
    );
    networkGetIt.registerSingleton<SigninWithGoogleUsecase>(
      signinWithGoogleUsecase,
    );
    networkGetIt.registerSingleton<SignInWithGoogleOnlyUsecase>(
      signInWithGoogleOnlyUsecase,
    );
    networkGetIt.registerSingleton<SignInWithGoogleExistingUserUsecase>(
      signInWithGoogleExistingUserUsecase,
    );
    networkGetIt.registerSingleton<UploadVerificationDocumentUsecase>(
      uploadVerificationDocumentUsecase,
    );
    networkGetIt.registerSingleton<UploadFileUsecase>(uploadFileUsecase);
    networkGetIt.registerSingleton<user_management.GetCurrentUserUsecase>(
      refreshCurrentUserUsecase,
    );
    // Stub immediately because onInit() -> bootstrapSession() calls this.
    when(() => refreshCurrentUserUsecase(any()))
        .thenAnswer((_) async => const Right(null));

    controller = AuthController.internal();

    Get.put<AuthController>(controller, permanent: true);
  });

  tearDown(() async {
    Get.reset();
    await networkGetIt.reset();
    AuthController.testFirebaseAuth = null;
  });

  testWidgets(
      'login thành công: gọi usecase với email trim, clear password, tắt loading',
      (tester) async {
    await pumpShell(tester);

    when(() => signinUsecase(any())).thenAnswer(
      (_) async => Right(
        UserEntity(
          userId: 1,
          email: 'user@example.com',
          firebaseUid: 'uid-1',
          phoneNumber: null,
          role: UserRole.user,
          status: UserStatus.active,
          currentCoin: 0,
          createdTime: DateTime.now(),
        ),
      ),
    );

    controller.loginEmailController.text = '  user@example.com  ';
    controller.loginPasswordController.text = 'secret';

    await controller.login();
    await drainOverlay(tester);

    final captured = verify(() => signinUsecase(captureAny())).captured.single
        as SigninWithEmailAndPasswordParams;
    expect(captured.email, 'user@example.com');
    expect(captured.password, 'secret');
    expect(controller.loginPasswordController.text, '');
    expect(controller.isLoadingEmail.value, false);
  });

  testWidgets('register thất bại: giữ nguyên form, tắt loading',
      (tester) async {
    await pumpShell(tester);

    when(() => signupUsecase(any())).thenAnswer(
      (_) async => const Left(
        FailureEntity.serverFailure('400', 'register failed'),
      ),
    );

    controller.registerEmailController.text = 'user@example.com';
    controller.registerPasswordController.text = 'password123';
    controller.registerConfirmPasswordController.text = 'password123';

    await controller.register();
    await drainOverlay(tester);

    expect(controller.registerPasswordController.text, 'password123');
    expect(controller.registerConfirmPasswordController.text, 'password123');
    expect(controller.isLoadingEmail.value, false);
  });

  testWidgets(
      'sendResetPasswordEmail thành công: trim email, clear input, tắt loading',
      (tester) async {
    await pumpShell(tester);

    when(() => sendPasswordResetEmailUsecase(any())).thenAnswer(
      (_) async => const Right(unit),
    );

    controller.forgotPasswordEmailController.text = '  reset@example.com  ';

    await controller.sendResetPasswordEmail(
      email: controller.forgotPasswordEmailController.text,
    );
    await drainOverlay(tester);

    final captured = verify(() => sendPasswordResetEmailUsecase(captureAny()))
        .captured
        .single as SendPasswordResetEmailParams;
    expect(captured.email, 'reset@example.com');
    expect(controller.forgotPasswordEmailController.text, '');
    expect(controller.isLoadingEmail.value, false);
  });

  test('bootstrapSession trả true khi usecase trả user', () async {
    when(() => getCurrentUserUsecase(any())).thenAnswer(
      (_) async => Right(
        UserEntity(
          userId: 2,
          email: 'current@example.com',
          firebaseUid: 'uid-2',
          phoneNumber: null,
          role: UserRole.user,
          status: UserStatus.active,
          currentCoin: 10,
          createdTime: DateTime.now(),
        ),
      ),
    );

    controller.bootstrapSession();
    await Future.delayed(const Duration(milliseconds: 100));

    verify(() => refreshCurrentUserUsecase(any())).called(1);
  });

  test('bootstrapSession trả false khi usecase lỗi', () async {
    when(() => getCurrentUserUsecase(any())).thenAnswer(
      (_) async => const Left(
        FailureEntity.serverFailure('500', 'error'),
      ),
    );

    controller.bootstrapSession();
    await Future.delayed(const Duration(milliseconds: 100));

    verify(() => refreshCurrentUserUsecase(any())).called(1);
  });

  testWidgets('logout gọi signoutUsecase và tắt loading', (tester) async {
    await pumpShell(tester);

    when(() => signoutUsecase(any())).thenAnswer(
      (_) async => const Right(unit),
    );

    await controller.logout();
    await drainOverlay(tester);

    verify(() => signoutUsecase(any())).called(1);
    expect(controller.isLoadingEmail.value, false);
  });

  test('login organizer pending: emit AuthEvent.organizerPending', () async {
    when(() => signinUsecase(any())).thenAnswer(
      (_) async => const Left(
        FailureEntity.serverFailure('ORG_PENDING', 'pending'),
      ),
    );

    final events = <AuthEvent>[];
    final sub = controller.authEvents.listen(events.add);

    controller.loginEmailController.text = 'org_pending@example.com';
    controller.loginPasswordController.text = 'password123';
    await controller.login();
    await Future.delayed(const Duration(milliseconds: 100));
    await sub.cancel();

    expect(events.contains(AuthEvent.organizerPending), isTrue,
        reason: 'events: $events');
  });

  test('register organizer pending: emit AuthEvent.organizerPending', () async {
    when(() => signupUsecase(any())).thenAnswer(
      (_) async => const Left(
        FailureEntity.serverFailure('ORG_PENDING', 'pending'),
      ),
    );

    controller.registerAsOrganization.value = true;
    controller.registerEmailController.text = 'org_signup@example.com';
    controller.registerPasswordController.text = 'password123';
    controller.registerConfirmPasswordController.text = 'password123';
    controller.organizationNameController.text = 'My Org';
    controller.organizationType.value = OrganizationType.company;
    controller.uploadedVerificationDocs.add({'id': 123});

    final events = <AuthEvent>[];
    final sub = controller.authEvents.listen(events.add);

    await controller.register();
    await Future.delayed(const Duration(milliseconds: 100));
    await sub.cancel();

    expect(events.contains(AuthEvent.organizerPending), isTrue,
        reason: 'events: $events');
  });
}
