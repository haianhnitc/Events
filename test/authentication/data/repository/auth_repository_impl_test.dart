import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/data/datasource/auth_datasource.dart';
import 'package:events_app/authentication/data/repository/auth_repository_impl.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/user_management/data/model/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthDatasource extends Mock implements AuthDatasource {}

void main() {
  late MockAuthDatasource authDatasource;
  late AuthRepositoryImpl repository;

  setUp(() {
    authDatasource = MockAuthDatasource();
    repository = AuthRepositoryImpl(authDatasource);
  });

  test('signInWithEmailAndPassword map UserModel sang UserEntity', () async {
    when(() => authDatasource.signInWithEmailAndPassword(
          'user@example.com',
          'password123',
        )).thenAnswer(
      (_) async => ApiResponse.success(
        UserModel(
          userId: 10,
          firebaseUid: 'firebase-uid-10',
          email: 'user@example.com',
          phoneNumber: '0912345678',
          role: UserRole.user,
          status: UserStatus.active,
          currentCoin: 55,
          createdTime: DateTime.parse('2024-01-15T10:30:00'),
        ),
      ),
    );

    final result = await repository.signInWithEmailAndPassword(
      'user@example.com',
      'password123',
    );

    expect(result.isRight(), true);
    result.fold(
      (_) => fail('Expected Right'),
      (user) {
        expect(user?.email, 'user@example.com');
        expect(user?.firebaseUid, 'firebase-uid-10');
        expect(user?.currentCoin, 55);
      },
    );
  });

  test('sendPasswordResetEmail trả về Unit thành công', () async {
    when(() => authDatasource.sendPasswordResetEmail('reset@example.com'))
        .thenAnswer(
      (_) async => const ApiResponse.success(null),
    );

    final result = await repository.sendPasswordResetEmail('reset@example.com');

    expect(result.isRight(), true);
    result.fold(
      (_) => fail('Expected Right'),
      (unit) => expect(unit, isNotNull),
    );
  });

  test('signOut trả về lỗi khi datasource báo unauthorized', () async {
    when(() => authDatasource.signOut()).thenAnswer(
      (_) async => const ApiResponse.unauthorized(
        ApiResponseError(
          code: '401',
          message: 'Invalid firebase token',
          errors: null,
        ),
      ),
    );

    final result = await repository.signOut();

    expect(result.isLeft(), true);
    result.fold(
      (failure) {
        expect(failure, isA<FailureEntity>());
        expect(failure.errorCode(), '401');
      },
      (_) => fail('Expected Left'),
    );
  });
}
