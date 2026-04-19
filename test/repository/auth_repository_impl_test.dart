import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/data/datasource/auth_datasource.dart';
import 'package:events_app/authentication/data/repository/auth_repository_impl.dart';
import 'package:events_app/authentication/domain/usecase/signup_params.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/user_management/data/model/user_model.dart';
import 'package:events_app/feature/user_management/data/model/verification_document_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthDatasource extends Mock implements AuthDatasource {}

// ─── Helpers tạo model stub ──────────────────────────────────────────────────
UserModel _fakeUserModel() {
  return const UserModel(
    userId: 1,
    firebaseUid: 'firebase-uid-001',
    email: 'test@example.com',
    role: UserRole.user,
    status: UserStatus.active,
  );
}

VerificationDocumentModel _fakeDocModel({int id = 1}) {
  return VerificationDocumentModel(
    verificationDocumentId: id,
    documentType: DocumentType.businessLicense,
    fileUrl: 'https://example.com/doc.pdf',
  );
}

void main() {
  late MockAuthDatasource mockDatasource;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockAuthDatasource();
    repository = AuthRepositoryImpl(mockDatasource);
  });

  // ─── signInWithEmailAndPassword ──────────────────────────────────────────────
  group('signInWithEmailAndPassword', () {
    test('trả về Right(UserEntity) khi datasource thành công', () async {
      when(() => mockDatasource.signInWithEmailAndPassword(any(), any()))
          .thenAnswer((_) async => ApiResponse.success(_fakeUserModel()));

      final result = await repository.signInWithEmailAndPassword(
          'test@example.com', 'password');

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Expected Right'),
        (user) {
          expect(user, isNotNull);
          expect(user!.email, equals('test@example.com'));
        },
      );
    });

    test('trả về Right(null) khi datasource trả success(null)', () async {
      when(() => mockDatasource.signInWithEmailAndPassword(any(), any()))
          .thenAnswer((_) async => const ApiResponse.success(null));

      final result = await repository.signInWithEmailAndPassword(
          'test@example.com', 'password');

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Expected Right'),
        (user) => expect(user, isNull),
      );
    });

    test('trả về Left(FailureEntity) khi datasource trả unauthorized',
        () async {
      when(() => mockDatasource.signInWithEmailAndPassword(any(), any()))
          .thenAnswer((_) async => const ApiResponse.unauthorized(
                ApiResponseError(
                    code: '401', message: 'Unauthorized', errors: []),
              ));

      final result = await repository.signInWithEmailAndPassword(
          'test@example.com', 'wrong-password');

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          failure.when(
            serverFailure: (code, message) {
              expect(code, equals('401'));
              expect(message, equals('Unauthorized'));
            },
            dataParsingFailure: () => fail('Expected serverFailure'),
            noConnectionFailure: () => fail('Expected serverFailure'),
            systemFailure: (_, __) => fail('Expected serverFailure'),
          );
        },
        (r) => fail('Expected Left'),
      );
    });

    test('trả về Left(FailureEntity) khi datasource trả forbidden', () async {
      when(() => mockDatasource.signInWithEmailAndPassword(any(), any()))
          .thenAnswer((_) async => const ApiResponse.forbidden(
                ApiResponseError(
                    code: 'ORGANIZER_PENDING',
                    message: 'Pending',
                    errors: null),
              ));

      final result = await repository.signInWithEmailAndPassword(
          'org@example.com', 'password');

      expect(result.isLeft(), isTrue);
    });

    test('trả về Left khi datasource trả internalServerError', () async {
      when(() => mockDatasource.signInWithEmailAndPassword(any(), any()))
          .thenAnswer((_) async => const ApiResponse.internalServerError());

      final result = await repository.signInWithEmailAndPassword(
          'test@example.com', 'password');

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => failure.when(
          serverFailure: (code, message) => expect(code, equals('500')),
          dataParsingFailure: () => fail('Expected serverFailure'),
          noConnectionFailure: () => fail('Expected serverFailure'),
          systemFailure: (_, __) => fail('Expected serverFailure'),
        ),
        (r) => fail('Expected Left'),
      );
    });

    test('trả về Left khi datasource trả unexpected', () async {
      when(() => mockDatasource.signInWithEmailAndPassword(any(), any()))
          .thenAnswer((_) async => const ApiResponse.unexpected(
                ApiResponseError(
                    code: 'wrong-password',
                    message: 'Wrong password',
                    errors: null),
              ));

      final result = await repository.signInWithEmailAndPassword(
          'test@example.com', 'wrong');

      expect(result.isLeft(), isTrue);
    });
  });

  // ─── signUpWithEmailAndPassword ──────────────────────────────────────────────
  group('signUpWithEmailAndPassword', () {
    test('trả về Right(UserEntity) khi datasource thành công', () async {
      when(() => mockDatasource.signUpWithEmailAndPassword(any(), any()))
          .thenAnswer((_) async => ApiResponse.success(_fakeUserModel()));

      final result = await repository.signUpWithEmailAndPassword(
        'password123',
        SignupParams(
          idToken: 'token',
          email: 'new@example.com',
          isUser: true,
          userProfile: const SignupUserProfileParams(fullName: 'Test User'),
        ),
      );

      expect(result.isRight(), isTrue);
    });

    test('trả về Left khi datasource trả badRequest', () async {
      when(() => mockDatasource.signUpWithEmailAndPassword(any(), any()))
          .thenAnswer((_) async => const ApiResponse.badRequest(
            ApiResponseError(
                code: '400', message: 'Email đã tồn tại', errors: []),
          ));

      final result = await repository.signUpWithEmailAndPassword(
        'password',
        SignupParams(
          idToken: 'token',
          email: 'existing@example.com',
          isUser: true,
        ),
      );

      expect(result.isLeft(), isTrue);
    });
  });

  // ─── signOut ─────────────────────────────────────────────────────────────────
  group('signOut', () {
    test('trả về Right(Unit) khi signOut thành công', () async {
      when(() => mockDatasource.signOut())
          .thenAnswer((_) async => const ApiResponse.success(null));

      final result = await repository.signOut();

      expect(result, equals(const Right<FailureEntity, Unit>(unit)));
    });

    test('trả về Left khi signOut thất bại', () async {
      when(() => mockDatasource.signOut())
          .thenAnswer((_) async => const ApiResponse.internalServerError());

      final result = await repository.signOut();

      expect(result.isLeft(), isTrue);
    });
  });

  // ─── getCurrentUser ──────────────────────────────────────────────────────────
  group('getCurrentUser', () {
    test('trả về Right(null) khi không có user đăng nhập', () async {
      when(() => mockDatasource.getCurrentUser())
          .thenAnswer((_) async => const ApiResponse.success(null));

      final result = await repository.getCurrentUser();

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Expected Right'),
        (user) => expect(user, isNull),
      );
    });

    test('trả về Right(UserEntity) khi user đang đăng nhập', () async {
      when(() => mockDatasource.getCurrentUser())
          .thenAnswer((_) async => ApiResponse.success(_fakeUserModel()));

      final result = await repository.getCurrentUser();

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Expected Right'),
        (user) => expect(user, isNotNull),
      );
    });

    test('trả về Left khi datasource trả unexpected', () async {
      when(() => mockDatasource.getCurrentUser())
          .thenAnswer((_) async => const ApiResponse.unexpected(
                ApiResponseError(
                    code: 'unknown', message: 'Error', errors: null),
              ));

      final result = await repository.getCurrentUser();

      expect(result.isLeft(), isTrue);
    });
  });

  // ─── sendPasswordResetEmail ──────────────────────────────────────────────────
  group('sendPasswordResetEmail', () {
    test('trả về Right(Unit) khi gửi email thành công', () async {
      when(() => mockDatasource.sendPasswordResetEmail(any()))
          .thenAnswer((_) async => const ApiResponse.success(null));

      final result =
          await repository.sendPasswordResetEmail('test@example.com');

      expect(result, equals(const Right<FailureEntity, Unit>(unit)));
    });

    test('trả về Left khi datasource trả unexpected (email không tồn tại)',
        () async {
      when(() => mockDatasource.sendPasswordResetEmail(any()))
          .thenAnswer((_) async => const ApiResponse.unexpected(
                ApiResponseError(
                    code: 'user-not-found',
                    message: 'User not found',
                    errors: null),
              ));

      final result =
          await repository.sendPasswordResetEmail('notfound@example.com');

      expect(result.isLeft(), isTrue);
    });
  });

  // ─── uploadVerificationDocument ──────────────────────────────────────────────
  group('uploadVerificationDocument', () {
    test('trả về Right(VerificationDocumentEntity) khi upload thành công',
        () async {
      when(() => mockDatasource.uploadVerificationDocument(
            fileId: any(named: 'fileId'),
            documentType: any(named: 'documentType'),
          )).thenAnswer((_) async => ApiResponse.success(_fakeDocModel(id: 1)));

      final result = await repository.uploadVerificationDocument(
        fileId: 1,
        documentType: 'BUSINESS_LICENSE',
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Expected Right'),
        (doc) => expect(doc.verificationDocumentId, equals(1)),
      );
    });

    test('trả về Left khi upload thất bại (unauthorized)', () async {
      when(() => mockDatasource.uploadVerificationDocument(
            fileId: any(named: 'fileId'),
            documentType: any(named: 'documentType'),
          )).thenAnswer((_) async => const ApiResponse.unauthorized(
            ApiResponseError(code: '401', message: 'Unauthorized', errors: []),
          ));

      final result = await repository.uploadVerificationDocument(
        fileId: 1,
        documentType: 'BUSINESS_LICENSE',
      );

      expect(result.isLeft(), isTrue);
    });
  });

  // ─── getMyVerificationDocuments ──────────────────────────────────────────────
  group('getMyVerificationDocuments', () {
    test('trả về Right(list) khi thành công', () async {
      when(() => mockDatasource.getMyVerificationDocuments(
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => ApiResponse.success([
            _fakeDocModel(),
            _fakeDocModel(id: 2),
          ]));

      final result = await repository.getMyVerificationDocuments();

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Expected Right'),
        (docs) => expect(docs.length, equals(2)),
      );
    });

    test('trả về Left khi datasource trả responseParsing', () async {
      when(() => mockDatasource.getMyVerificationDocuments(
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => const ApiResponse.responseParsing());

      final result = await repository.getMyVerificationDocuments();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => failure.when(
          serverFailure: (code, message) => fail('Expected dataParsingFailure'),
          dataParsingFailure: () => expect(true, isTrue),
          noConnectionFailure: () => fail('Expected dataParsingFailure'),
          systemFailure: (_, __) => fail('Expected dataParsingFailure'),
        ),
        (r) => fail('Expected Left'),
      );
    });
  });
}
