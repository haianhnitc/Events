import 'package:events_app/api_template/base_request/api_request.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/authentication/data/datasource/auth_datasource.dart';
import 'package:events_app/authentication/domain/auth_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

class RecordingRestClient extends RestClient {
  RecordingRestClient({required this.nextResponse});

  final ApiResponse<Map<String, dynamic>> nextResponse;
  ApiRequest? lastRequest;
  bool? lastRequireAuth;
  final List<ApiRequest> requests = [];
  final List<bool> requireAuthHistory = [];

  @override
  Future<ApiResponse<Model>> makeRequest<Model>(
    ApiRequest request,
    ResponseParser parser,
    bool requireAuth,
  ) async {
    lastRequest = request;
    lastRequireAuth = requireAuth;
    requests.add(request);
    requireAuthHistory.add(requireAuth);
    return nextResponse as ApiResponse<Model>;
  }

  @override
  Future<bool> checkNetwork() async => true;
}

void main() {
  late MockFirebaseAuth firebaseAuth;
  late MockUser mockUser;
  late MockUserCredential mockUserCredential;
  late MockGoogleSignIn googleSignIn;
  setUp(() {
    firebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();
    mockUserCredential = MockUserCredential();
    googleSignIn = MockGoogleSignIn();
  });

  AuthDatasourceImpl createDatasource(RecordingRestClient client) {
    return AuthDatasourceImpl(
      client: client,
    );
  }

  test('signInWithEmailAndPassword gọi /auth/verify và trả user từ verify',
      () async {
    final provider = RecordingRestClient(
      nextResponse: const ApiResponse.success(<String, dynamic>{
        'errorCode': 0,
        'statusCode': 200,
        'message': null,
        'object': <String, dynamic>{
          'userId': 5,
          'firebaseUid': 'firebase-uid-abc123',
          'email': 'user@example.com',
          'phoneNumber': '0912345678',
          'role': 'USER',
          'status': 'ACTIVE',
          'currentCoin': 1000,
          'remainingFreePortfolios': 3,
          'createdTime': '2024-01-15T10:30:00',
        },
      }),
    );

    when(() => firebaseAuth.signInWithEmailAndPassword(
          email: 'user@example.com',
          password: 'password123',
        )).thenAnswer((_) async => mockUserCredential);
    when(() => mockUserCredential.user).thenReturn(mockUser);
    when(() => mockUser.getIdToken()).thenAnswer((_) async => 'id-token-123');

    final datasource = createDatasource(provider);
    final response = await datasource.signInWithEmailAndPassword(
      'user@example.com',
      'password123',
    );

    final parsedUser = response.when(
      success: (userModel) {
        expect(userModel, isNotNull);
        expect(userModel!.email, 'user@example.com');
        expect(userModel.firebaseUid, 'firebase-uid-abc123');
        return userModel;
      },
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
      unexpected: (_) => fail('Expected success'),
    );

    expect(parsedUser, isNotNull);

    expect(provider.requests.length, 1);
    expect(provider.requests.first.path, '/auth/verify');
    expect(provider.requireAuthHistory, [false]);
    expect(provider.requests.first.headers?['Content-Type'], 'text/plain');
    final body = provider.requests.first.body;
    expect(
      body.when(
        empty: () => null,
        json: (_) => null,
        text: (text) => text,
        file: (_) => null,
        jsonString: (_) => null,
      ),
      'id-token-123',
    );
  });

  test('signOut gọi /auth/logout và signOut Firebase local', () async {
    final provider = RecordingRestClient(
      nextResponse: const ApiResponse.success(<String, dynamic>{
        'errorCode': 0,
        'statusCode': 200,
        'message': null,
        'object': null,
      }),
    );

    when(() => firebaseAuth.signOut()).thenAnswer((_) async {});
    when(() => googleSignIn.signOut()).thenAnswer((_) async => null);

    final datasource = createDatasource(provider);
    final response = await datasource.signOut();

    final logoutResult = response.when(
      success: (_) => true,
      badRequest: (_) => false,
      unauthorized: (_) => false,
      forbidden: (_) => false,
      notFound: (_) => false,
      conflict: (_) => false,
      internalServerError: () => false,
      badGateway: () => false,
      serviceUnavailable: () => false,
      gatewayTimeout: () => false,
      canceled: () => false,
      responseParsing: () => false,
      unexpected: (_) => false,
    );

    expect(logoutResult, true);
    expect(provider.lastRequest?.path, '/auth/logout');
    expect(provider.lastRequest?.path.contains('/refresh'), false);
    expect(provider.lastRequireAuth, true);
    verify(() => firebaseAuth.signOut()).called(1);
    verify(() => googleSignIn.signOut()).called(1);
  });

  test('sendPasswordResetEmail gọi Firebase SDK trực tiếp', () async {
    when(() => firebaseAuth.sendPasswordResetEmail(email: 'reset@example.com'))
        .thenAnswer((_) async {});

    final provider = RecordingRestClient(
      nextResponse: const ApiResponse.success(<String, dynamic>{
        'errorCode': 0,
        'statusCode': 200,
        'message': null,
        'object': null,
      }),
    );

    final datasource = createDatasource(
      provider,
    );

    final response =
        await datasource.sendPasswordResetEmail('reset@example.com');

    final resetResult = response.when(
      success: (_) => true,
      badRequest: (_) => false,
      unauthorized: (_) => false,
      forbidden: (_) => false,
      notFound: (_) => false,
      conflict: (_) => false,
      internalServerError: () => false,
      badGateway: () => false,
      serviceUnavailable: () => false,
      gatewayTimeout: () => false,
      canceled: () => false,
      responseParsing: () => false,
      unexpected: (_) => false,
    );

    expect(resetResult, true);
    expect(provider.lastRequest, isNull,
        reason:
            'Password reset must use Firebase SDK directly, not backend API.');
    verify(() =>
            firebaseAuth.sendPasswordResetEmail(email: 'reset@example.com'))
        .called(1);
  });

  test('getCurrentUser gọi /auth/verify khi có user hiện tại', () async {
    final provider = RecordingRestClient(
      nextResponse: const ApiResponse.success(<String, dynamic>{
        'errorCode': 0,
        'statusCode': 200,
        'message': null,
        'object': <String, dynamic>{
          'userId': 8,
          'firebaseUid': 'firebase-uid-xyz',
          'email': 'current@example.com',
          'phoneNumber': null,
          'role': 'USER',
          'status': 'ACTIVE',
          'currentCoin': 0,
          'remainingFreePortfolios': 0,
          'createdTime': '2024-01-15T10:30:00',
        },
      }),
    );

    when(() => firebaseAuth.currentUser).thenReturn(mockUser);
    when(() => mockUser.getIdToken())
        .thenAnswer((_) async => 'cached-id-token');

    final datasource = createDatasource(provider);
    final response = await datasource.getCurrentUser();

    final currentUserResult = response.when(
      success: (_) => true,
      badRequest: (_) => false,
      unauthorized: (_) => false,
      forbidden: (_) => false,
      notFound: (_) => false,
      conflict: (_) => false,
      internalServerError: () => false,
      badGateway: () => false,
      serviceUnavailable: () => false,
      gatewayTimeout: () => false,
      canceled: () => false,
      responseParsing: () => false,
      unexpected: (_) => false,
    );

    expect(currentUserResult, true);
    expect(provider.requests.length, 1);
    expect(provider.requests.first.path, '/auth/verify');
    expect(provider.requireAuthHistory, [false]);
  });

  test('organizer pending: login bị chặn với mã ORG_PENDING', () async {
    final provider = RecordingRestClient(
      nextResponse: const ApiResponse.success(<String, dynamic>{
        'errorCode': 0,
        'statusCode': 200,
        'message': null,
        'object': <String, dynamic>{
          'userId': 9,
          'firebaseUid': 'org-uid-pending',
          'email': 'org_pending@example.com',
          'role': 'ORGANIZATION',
          'status': 'ACTIVE',
          'organizationProfile': <String, dynamic>{
            'organizationName': 'Pending Org',
            'verificationStatus': 'PENDING',
          },
        },
      }),
    );

    when(() => firebaseAuth.signInWithEmailAndPassword(
          email: 'org_pending@example.com',
          password: 'password123',
        )).thenAnswer((_) async => mockUserCredential);
    when(() => mockUserCredential.user).thenReturn(mockUser);
    when(() => mockUser.getIdToken())
        .thenAnswer((_) async => 'id-token-pending');

    final datasource = createDatasource(provider);
    final response = await datasource.signInWithEmailAndPassword(
      'org_pending@example.com',
      'password123',
    );

    final code = response.when(
      success: (_) => null,
      badRequest: (_) => null,
      unauthorized: (_) => null,
      forbidden: (error) => error.code,
      notFound: (_) => null,
      conflict: (_) => null,
      internalServerError: () => null,
      badGateway: () => null,
      serviceUnavailable: () => null,
      gatewayTimeout: () => null,
      canceled: () => null,
      responseParsing: () => null,
      unexpected: (_) => null,
    );

    expect(code, AuthConstants.organizerPendingCode);
    expect(provider.requests.length, 1);
    expect(provider.requests.first.path, '/auth/verify');
  });

  test('organizer approved: login thành công', () async {
    final provider = RecordingRestClient(
      nextResponse: const ApiResponse.success(<String, dynamic>{
        'errorCode': 0,
        'statusCode': 200,
        'message': null,
        'object': <String, dynamic>{
          'userId': 10,
          'firebaseUid': 'org-uid-approved',
          'email': 'org_approved@example.com',
          'role': 'ORGANIZATION',
          'status': 'ACTIVE',
          'organizationProfile': <String, dynamic>{
            'organizationName': 'Approved Org',
            'verificationStatus': 'APPROVED',
          },
        },
      }),
    );

    when(() => firebaseAuth.signInWithEmailAndPassword(
          email: 'org_approved@example.com',
          password: 'password123',
        )).thenAnswer((_) async => mockUserCredential);
    when(() => mockUserCredential.user).thenReturn(mockUser);
    when(() => mockUser.getIdToken())
        .thenAnswer((_) async => 'id-token-approved');

    final datasource = createDatasource(provider);
    final response = await datasource.signInWithEmailAndPassword(
      'org_approved@example.com',
      'password123',
    );

    final isSuccess = response.when(
      success: (_) => true,
      badRequest: (_) => false,
      unauthorized: (_) => false,
      forbidden: (_) => false,
      notFound: (_) => false,
      conflict: (_) => false,
      internalServerError: () => false,
      badGateway: () => false,
      serviceUnavailable: () => false,
      gatewayTimeout: () => false,
      canceled: () => false,
      responseParsing: () => false,
      unexpected: (_) => false,
    );

    expect(isSuccess, true);
    expect(provider.requests.length, 1);
    expect(provider.requests.first.path, '/auth/verify');
  });
}
