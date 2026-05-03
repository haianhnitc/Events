import 'package:events_app/api_template/base_request/api_request.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/authentication/data/datasource/auth_datasource.dart';
import 'package:events_app/authentication/domain/auth_constants.dart';
import 'package:events_app/authentication/domain/usecase/signup_params.dart';
import 'package:events_app/feature/user_management/data/model/user_model.dart';
import 'package:events_app/feature/user_management/data/model/verification_document_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/fake_data.dart';
import '../helpers/api_response_matchers.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockFirebaseUser extends Mock implements User {}

class MockAdditionalUserInfo extends Mock implements AdditionalUserInfo {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

class MockFirebaseAuthException implements FirebaseAuthException {
  const MockFirebaseAuthException({required this.code, this.message});

  @override
  final String code;

  @override
  final String? message;

  @override
  String? get email => null;

  @override
  User? get user => null;

  @override
  AuthCredential? get credential => null;
}

/// Test RestClient that records requests and returns configured responses.
class TestRestClient extends Fake implements RestClient {
  ApiResponse<Map<String, dynamic>>? nextResponse;
  final List<ApiRequest> requests = [];

  void reset() {
    nextResponse = null;
    requests.clear();
  }

  @override
  Future<ApiResponse<Model>> makeRequest<Model>(
    ApiRequest request,
    ResponseParser parser,
    bool requireAuth,
  ) async {
    requests.add(request);
    if (nextResponse != null) {
      // Clone the response to avoid freezed issues on reuse
      return _cloneResponse(nextResponse!);
    }
    return successEnvelope(null);
  }

  ApiResponse<Model> _cloneResponse<Model>(ApiResponse<Map<String, dynamic>> from) {
    return from.when(
      success: (_) => ApiResponse.success(parser(from.whenOrNull(success: (_) => _) ?? {})),
      badRequest: (e) => ApiResponse.badRequest(e),
      unauthorized: (e) => ApiResponse.unauthorized(e),
      forbidden: (e) => ApiResponse.forbidden(e),
      notFound: (e) => ApiResponse.notFound(e),
      conflict: (e) => ApiResponse.conflict(e),
      internalServerError: () => const ApiResponse.internalServerError(),
      badGateway: () => const ApiResponse.badGateway(),
      serviceUnavailable: () => const ApiResponse.serviceUnavailable(),
      gatewayTimeout: () => const ApiResponse.gatewayTimeout(),
      canceled: () => const ApiResponse.canceled(),
      responseParsing: () => const ApiResponse.responseParsing(),
      unexpected: (e) => ApiResponse.unexpected(e),
    );
  }

  @override
  Future<bool> checkNetwork() async => true;
}

/// Test datasource that lets us control REST responses via TestRestClient.
class TestAuthDatasource extends AuthDatasourceImpl {
  TestAuthDatasource({
    required TestRestClient testClient,
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  })  : _testClient = testClient,
        super(
          client: testClient,
          firebaseAuth: firebaseAuth,
          googleSignIn: googleSignIn,
        );

  final TestRestClient _testClient;

  void stubResponse(ApiResponse<Map<String, dynamic>> response) {
    _testClient.nextResponse = response;
  }

  void reset() {
    _testClient.reset();
  }
}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockGoogleSignIn mockGoogleSignIn;
  late TestRestClient testRestClient;
  late TestAuthDatasource datasource;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    testRestClient = TestRestClient();
    datasource = TestAuthDatasource(
      testClient: testRestClient,
      firebaseAuth: mockFirebaseAuth,
      googleSignIn: mockGoogleSignIn,
    );
  });

  setUpAll(() {
    registerFallbackValue(
      ApiRequest(
        path: '/fallback',
        type: ApiRequestType.get,
        body: const ApiRequestBody.empty(),
      ),
    );
    registerFallbackValue(Uri.parse('https://fallback'));
  });

  // ─── signInWithEmailAndPassword ──────────────────────────────────────────────
  group('signInWithEmailAndPassword', () {
    test('trả về success khi Firebase + backend thành công', () async {
      final mockUser = MockFirebaseUser();
      final mockCred = MockUserCredential();

      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => mockCred);
      when(() => mockCred.user).thenReturn(mockUser);
      when(() => mockUser.getIdToken(any())).thenAnswer((_) async => 'fake-token');

      datasource.stubResponse(successEnvelope(fakeUserJson()));

      final result = await datasource.signInWithEmailAndPassword(
          'test@example.com', 'password123');

      expect(isSuccess(result), isTrue);
    });

    test('trả về unexpected khi Firebase ném FirebaseAuthException', () async {
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(const MockFirebaseAuthException(
        code: 'wrong-password',
        message: 'Wrong password',
      ));

      final result = await datasource.signInWithEmailAndPassword(
          'test@example.com', 'wrong-pass');

      expect(isUnexpected(result), isTrue);
    });

    test('trả về forbidden với organizerPendingCode khi tổ chức chờ duyệt', () async {
      final mockUser = MockFirebaseUser();
      final mockCred = MockUserCredential();

      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => mockCred);
      when(() => mockCred.user).thenReturn(mockUser);
      when(() => mockUser.getIdToken(any())).thenAnswer((_) async => 'fake-token');

      datasource.stubResponse(successEnvelope(fakeUserJson(
        role: 'ORGANIZATION',
        verificationStatus: 'PENDING',
      )));

      final result = await datasource.signInWithEmailAndPassword(
          'org@example.com', 'password');

      result.when(
        forbidden: (error) =>
            expect(error.code, equals(AuthConstants.organizerPendingCode)),
        success: (_) => fail('Expected forbidden'),
        badRequest: (_) => fail('Expected forbidden'),
        unauthorized: (_) => fail('Expected forbidden'),
        notFound: (_) => fail('Expected forbidden'),
        conflict: (_) => fail('Expected forbidden'),
        internalServerError: () => fail('Expected forbidden'),
        badGateway: () => fail('Expected forbidden'),
        serviceUnavailable: () => fail('Expected forbidden'),
        gatewayTimeout: () => fail('Expected forbidden'),
        canceled: () => fail('Expected forbidden'),
        responseParsing: () => fail('Expected forbidden'),
        unexpected: (_) => fail('Expected forbidden'),
      );
    });

    test('trả về forbidden với organizerRejectedCode khi tổ chức bị từ chối', () async {
      final mockUser = MockFirebaseUser();
      final mockCred = MockUserCredential();

      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => mockCred);
      when(() => mockCred.user).thenReturn(mockUser);
      when(() => mockUser.getIdToken(any())).thenAnswer((_) async => 'fake-token');

      datasource.stubResponse(successEnvelope(fakeUserJson(
        role: 'ORGANIZATION',
        verificationStatus: 'REJECTED',
      )));

      final result = await datasource.signInWithEmailAndPassword(
          'org@example.com', 'password');

      result.when(
        forbidden: (error) =>
            expect(error.code, equals(AuthConstants.organizerRejectedCode)),
        success: (_) => fail('Expected forbidden'),
        badRequest: (_) => fail('Expected forbidden'),
        unauthorized: (_) => fail('Expected forbidden'),
        notFound: (_) => fail('Expected forbidden'),
        conflict: (_) => fail('Expected forbidden'),
        internalServerError: () => fail('Expected forbidden'),
        badGateway: () => fail('Expected forbidden'),
        serviceUnavailable: () => fail('Expected forbidden'),
        gatewayTimeout: () => fail('Expected forbidden'),
        canceled: () => fail('Expected forbidden'),
        responseParsing: () => fail('Expected forbidden'),
        unexpected: (_) => fail('Expected forbidden'),
      );
    });

    test('trả về forbidden với userDisabledCode khi tài khoản bị khóa', () async {
      final mockUser = MockFirebaseUser();
      final mockCred = MockUserCredential();

      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => mockCred);
      when(() => mockCred.user).thenReturn(mockUser);
      when(() => mockUser.getIdToken(any())).thenAnswer((_) async => 'fake-token');

      datasource.stubResponse(successEnvelope(fakeUserJson(status: 'DISABLED')));

      final result = await datasource.signInWithEmailAndPassword(
          'test@example.com', 'password');

      result.when(
        forbidden: (error) =>
            expect(error.code, equals(AuthConstants.userDisabledCode)),
        success: (_) => fail('Expected forbidden'),
        badRequest: (_) => fail('Expected forbidden'),
        unauthorized: (_) => fail('Expected forbidden'),
        notFound: (_) => fail('Expected forbidden'),
        conflict: (_) => fail('Expected forbidden'),
        internalServerError: () => fail('Expected forbidden'),
        badGateway: () => fail('Expected forbidden'),
        serviceUnavailable: () => fail('Expected forbidden'),
        gatewayTimeout: () => fail('Expected forbidden'),
        canceled: () => fail('Expected forbidden'),
        responseParsing: () => fail('Expected forbidden'),
        unexpected: (_) => fail('Expected forbidden'),
      );
    });

    test('trả về unexpected khi Firebase user null (không lấy được token)', () async {
      final mockCred = MockUserCredential();

      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => mockCred);
      when(() => mockCred.user).thenReturn(null);

      final result = await datasource.signInWithEmailAndPassword(
          'test@example.com', 'password');

      expect(isUnexpected(result), isTrue);
    });

    test('trả về unauthorized khi backend trả 401', () async {
      final mockUser = MockFirebaseUser();
      final mockCred = MockUserCredential();

      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => mockCred);
      when(() => mockCred.user).thenReturn(mockUser);
      when(() => mockUser.getIdToken(any())).thenAnswer((_) async => 'fake-token');

      datasource.stubResponse(unauthorizedResponse());

      final result = await datasource.signInWithEmailAndPassword(
          'test@example.com', 'password');

      expect(isUnauthorized(result), isTrue);
    });
  });

  // ─── signUpWithEmailAndPassword ──────────────────────────────────────────────
  group('signUpWithEmailAndPassword', () {
    test('trả về success sau khi Firebase tạo user và backend signup', () async {
      final mockUser = MockFirebaseUser();
      final mockCred = MockUserCredential();

      when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => mockCred);
      when(() => mockCred.user).thenReturn(mockUser);
      when(() => mockUser.getIdToken(any())).thenAnswer((_) async => 'fake-token');

      datasource.stubResponse(successEnvelope(fakeUserJson()));

      final result = await datasource.signUpWithEmailAndPassword(
        'password123',
        SignupParams(idToken: 'token', email: 'new@example.com', isUser: true),
      );

      expect(isSuccess(result), isTrue);
    });

    test('trả về unexpected khi Firebase ném exception khi tạo user', () async {
      when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(const MockFirebaseAuthException(
        code: 'email-already-in-use',
        message: 'Email already in use',
      ));

      final result = await datasource.signUpWithEmailAndPassword(
        'password',
        SignupParams(idToken: 'token', email: 'existing@example.com', isUser: true),
      );

      expect(isUnexpected(result), isTrue);
    });

    test('trả về unexpected khi Firebase user null sau create', () async {
      final mockCred = MockUserCredential();

      when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => mockCred);
      when(() => mockCred.user).thenReturn(null);

      final result = await datasource.signUpWithEmailAndPassword(
        'password',
        SignupParams(idToken: 'token', email: 'test@example.com', isUser: true),
      );

      expect(isUnexpected(result), isTrue);
    });
  });

  // ─── signInWithGoogleOnly ────────────────────────────────────────────────────
  group('signInWithGoogleOnly', () {
    test('trả về canceled khi user hủy Google sign-in', () async {
      when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async => null);

      final result = await datasource.signInWithGoogleOnly();

      expect(result.errorCode, equals('CANCELED'));
    });

    test('trả về error khi Google ném exception', () async {
      when(() => mockGoogleSignIn.signIn()).thenThrow(Exception('Network error'));

      final result = await datasource.signInWithGoogleOnly();

      expect(result.errorCode, equals('EXCEPTION'));
    });
  });

  // ─── signOut ─────────────────────────────────────────────────────────────────
  group('signOut', () {
    test('trả về success khi backend và Firebase signout thành công', () async {
      datasource.stubResponse(successEnvelope(null));
      when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});
      when(() => mockGoogleSignIn.signOut()).thenAnswer((_) async => null);

      final result = await datasource.signOut();

      expect(isSuccess(result), isTrue);
      verify(() => mockFirebaseAuth.signOut()).called(1);
      verify(() => mockGoogleSignIn.signOut()).called(1);
    });

    test('trả về unexpected khi Firebase ném exception khi signOut', () async {
      datasource.stubResponse(successEnvelope(null));
      when(() => mockFirebaseAuth.signOut()).thenThrow(Exception('Firebase error'));
      when(() => mockGoogleSignIn.signOut()).thenAnswer((_) async => null);

      final result = await datasource.signOut();

      expect(isUnexpected(result), isTrue);
    });
  });

  // ─── getCurrentUser ──────────────────────────────────────────────────────────
  group('getCurrentUser', () {
    test('trả về success(null) khi không có user đang login', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(null);

      final result = await datasource.getCurrentUser();

      result.when(
        success: (user) => expect(user, isNull),
        unexpected: (_) => fail('Expected success'),
        badRequest: (_) => fail('Expected success'),
        unauthorized: (_) => fail('Expected success'),
        forbidden: (_) => fail('Expected success'),
        notFound: (_) => fail('Expected success'),
        conflict: (_) => fail('Expected success'),
        internalServerError: () => fail('Expected success'),
        badGateway: () => fail('Expected success'),
        serviceUnavailable: () => fail('Expected success'),
        gatewayTimeout: () => fail('Expected success'),
        canceled: () => fail('Expected success'),
        responseParsing: () => fail('Expected success'),
      );
    });

    test('trả về success(user) khi user đang login và backend verify thành công', () async {
      final mockUser = MockFirebaseUser();

      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.getIdToken(any())).thenAnswer((_) async => 'token');

      datasource.stubResponse(successEnvelope(fakeUserJson()));

      final result = await datasource.getCurrentUser();

      expect(isSuccess(result), isTrue);
    });
  });

  // ─── sendPasswordResetEmail ──────────────────────────────────────────────────
  group('sendPasswordResetEmail', () {
    test('trả về success khi Firebase gửi email thành công', () async {
      when(() => mockFirebaseAuth.sendPasswordResetEmail(
            email: any(named: 'email'),
          )).thenAnswer((_) async {});

      final result = await datasource.sendPasswordResetEmail('test@example.com');

      expect(isSuccess(result), isTrue);
    });

    test('trả về unexpected khi Firebase ném exception', () async {
      when(() => mockFirebaseAuth.sendPasswordResetEmail(
            email: any(named: 'email'),
          )).thenThrow(const MockFirebaseAuthException(
        code: 'user-not-found',
        message: 'User not found',
      ));

      final result = await datasource.sendPasswordResetEmail('notfound@example.com');

      expect(isUnexpected(result), isTrue);
    });
  });

  // ─── getMyVerificationDocuments ──────────────────────────────────────────────
  group('getMyVerificationDocuments', () {
    test('trả về list document khi thành công', () async {
      datasource.stubResponse(successEnvelope({
        'content': [fakeVerificationDocumentJson(), fakeVerificationDocumentJson(id: 2)],
        'totalElements': 2,
      }));

      final result = await datasource.getMyVerificationDocuments();

      result.when(
        success: (docs) => expect(docs.length, equals(2)),
        unexpected: (_) => fail('Expected success'),
        badRequest: (_) => fail('Expected success'),
        unauthorized: (_) => fail('Expected success'),
        forbidden: (_) => fail('Expected success'),
        notFound: (_) => fail('Expected success'),
        conflict: (_) => fail('Expected success'),
        internalServerError: () => fail('Expected success'),
        badGateway: () => fail('Expected success'),
        serviceUnavailable: () => fail('Expected success'),
        gatewayTimeout: () => fail('Expected success'),
        canceled: () => fail('Expected success'),
        responseParsing: () => fail('Expected success'),
      );
    });

    test('trả về unauthorized khi backend 401', () async {
      datasource.stubResponse(unauthorizedResponse());

      final result = await datasource.getMyVerificationDocuments();

      expect(isUnauthorized(result), isTrue);
    });
  });
}
