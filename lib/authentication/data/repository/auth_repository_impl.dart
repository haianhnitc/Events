import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/data/datasource/auth_datasource.dart';
import 'package:events_app/authentication/domain/repository/auth_repository.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart'
    show UserRole, UserStatus;
import 'package:events_app/feature/user_management/domain/entity/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource authDatasource;

  AuthRepositoryImpl(this.authDatasource);

  UserEntity? _firebaseUserToEntity(firebase_auth.User? firebaseUser) {
    if (firebaseUser == null) return null;

    return UserEntity(
      userId: null,
      email: firebaseUser.email ?? '',
      firebaseUid: firebaseUser.uid,
      phoneNumber: firebaseUser.phoneNumber,
      role: UserRole.user,
      status: UserStatus.active,
      currentCoin: 0,
      remainingFreePortfolios: 0,
      createdTime: DateTime.now(),
    );
  }

  @override
  Future<Either<FailureEntity, UserEntity?>> signInWithEmailAndPassword(
      String email, String password) async {
    final response =
        await authDatasource.signInWithEmailAndPassword(email, password);

    return response.when(
      success: (firebaseUser) => Right(_firebaseUserToEntity(firebaseUser)),
      unexpected: (error) => Left(
        FailureEntity.serverFailure(error.code.toString(), error.message),
      ),
      badRequest: (error) => Left(
        FailureEntity.serverFailure(error.code.toString(), error.message),
      ),
      notFound: (error) => Left(
        FailureEntity.serverFailure(error.code.toString(), error.message),
      ),
      unauthorized: (error) => Left(
        FailureEntity.serverFailure(error.code.toString(), error.message),
      ),
      forbidden: (error) => Left(
        FailureEntity.serverFailure(error.code.toString(), error.message),
      ),
      internalServerError: () => const Left(
        FailureEntity.serverFailure('500', 'Internal server error'),
      ),
      badGateway: () => const Left(
        FailureEntity.serverFailure('502', 'Bad gateway'),
      ),
      serviceUnavailable: () => const Left(
        FailureEntity.serverFailure('503', 'Service unavailable'),
      ),
      gatewayTimeout: () => const Left(
        FailureEntity.serverFailure('504', 'Gateway timeout'),
      ),
      responseParsing: () => const Left(
        FailureEntity.dataParsingFailure(),
      ),
      canceled: () => const Right(null),
    );
  }

  @override
  Future<Either<FailureEntity, UserEntity?>> signUpWithEmailAndPassword(
      String email, String password) async {
    final response =
        await authDatasource.signUpWithEmailAndPassword(email, password);

    return response.when(
      success: (firebaseUser) => Right(_firebaseUserToEntity(firebaseUser)),
      unexpected: (error) => Left(
        FailureEntity.serverFailure(error.code.toString(), error.message),
      ),
      badRequest: (error) => Left(
        FailureEntity.serverFailure(error.code.toString(), error.message),
      ),
      notFound: (error) => Left(
        FailureEntity.serverFailure(error.code.toString(), error.message),
      ),
      unauthorized: (error) => Left(
        FailureEntity.serverFailure(error.code.toString(), error.message),
      ),
      forbidden: (error) => Left(
        FailureEntity.serverFailure(error.code.toString(), error.message),
      ),
      internalServerError: () => const Left(
        FailureEntity.serverFailure('500', 'Internal server error'),
      ),
      badGateway: () => const Left(
        FailureEntity.serverFailure('502', 'Bad gateway'),
      ),
      serviceUnavailable: () => const Left(
        FailureEntity.serverFailure('503', 'Service unavailable'),
      ),
      gatewayTimeout: () => const Left(
        FailureEntity.serverFailure('504', 'Gateway timeout'),
      ),
      responseParsing: () => const Left(
        FailureEntity.dataParsingFailure(),
      ),
      canceled: () => const Right(null),
    );
  }

  @override
  Future<Either<FailureEntity, UserEntity?>> signInWithGoogle() async {
    final response = await authDatasource.signInWithGoogle();

    return response.when(
      success: (firebaseUser) => Right(_firebaseUserToEntity(firebaseUser)),
      unexpected: (error) => Left(
        FailureEntity.serverFailure(error.code.toString(), error.message),
      ),
      badRequest: (error) => Left(
        FailureEntity.serverFailure(error.code.toString(), error.message),
      ),
      notFound: (error) => Left(
        FailureEntity.serverFailure(error.code.toString(), error.message),
      ),
      unauthorized: (error) => Left(
        FailureEntity.serverFailure(error.code.toString(), error.message),
      ),
      forbidden: (error) => Left(
        FailureEntity.serverFailure(error.code.toString(), error.message),
      ),
      internalServerError: () => const Left(
        FailureEntity.serverFailure('500', 'Internal server error'),
      ),
      badGateway: () => const Left(
        FailureEntity.serverFailure('502', 'Bad gateway'),
      ),
      serviceUnavailable: () => const Left(
        FailureEntity.serverFailure('503', 'Service unavailable'),
      ),
      gatewayTimeout: () => const Left(
        FailureEntity.serverFailure('504', 'Gateway timeout'),
      ),
      responseParsing: () => const Left(
        FailureEntity.dataParsingFailure(),
      ),
      canceled: () => const Right(null),
    );
  }

  @override
  Future<Either<FailureEntity, Unit>> signOut() async {
    final response = await authDatasource.signOut();

    return response.whenOrNull<Either<FailureEntity, Unit>>(
          success: (_) => Right(unit),
          unexpected: (error) => Left(
            FailureEntity.serverFailure(error.code.toString(), error.message),
          ),
          badRequest: (error) => Left(
            FailureEntity.serverFailure(error.code.toString(), error.message),
          ),
          notFound: (error) => Left(
            FailureEntity.serverFailure(error.code.toString(), error.message),
          ),
          unauthorized: (error) => Left(
            FailureEntity.serverFailure(error.code.toString(), error.message),
          ),
          forbidden: (error) => Left(
            FailureEntity.serverFailure(error.code.toString(), error.message),
          ),
        ) ??
        const Left(FailureEntity.dataParsingFailure());
  }

  @override
  Future<Either<FailureEntity, UserEntity?>> getCurrentUser() async {
    final response = await authDatasource.getCurrentUser();

    return response.when(
      success: (firebaseUser) => Right(_firebaseUserToEntity(firebaseUser)),
      unexpected: (error) => Left(
        FailureEntity.serverFailure(error.code.toString(), error.message),
      ),
      badRequest: (error) => Left(
        FailureEntity.serverFailure(error.code.toString(), error.message),
      ),
      notFound: (error) => Left(
        FailureEntity.serverFailure(error.code.toString(), error.message),
      ),
      unauthorized: (error) => Left(
        FailureEntity.serverFailure(error.code.toString(), error.message),
      ),
      forbidden: (error) => Left(
        FailureEntity.serverFailure(error.code.toString(), error.message),
      ),
      internalServerError: () => const Left(
        FailureEntity.serverFailure('500', 'Internal server error'),
      ),
      badGateway: () => const Left(
        FailureEntity.serverFailure('502', 'Bad gateway'),
      ),
      serviceUnavailable: () => const Left(
        FailureEntity.serverFailure('503', 'Service unavailable'),
      ),
      gatewayTimeout: () => const Left(
        FailureEntity.serverFailure('504', 'Gateway timeout'),
      ),
      responseParsing: () => const Left(
        FailureEntity.dataParsingFailure(),
      ),
      canceled: () => const Right(null),
    );
  }
}
