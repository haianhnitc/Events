import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/data/datasource/auth_datasource.dart';
import 'package:events_app/authentication/data/model/user_model.dart';
import 'package:events_app/authentication/domain/entity/user_entity.dart';
import 'package:events_app/authentication/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource authDatasource;

  AuthRepositoryImpl(this.authDatasource);

  @override
  Future<Either<FailureEntity, UserEntity?>> signInWithEmailAndPassword(
      String email, String password) async {
    final response =
        await authDatasource.signInWithEmailAndPassword(email, password);

    final result = response.whenOrNull<Either<FailureEntity, UserEntity?>>(
      success: (model) => Right(model?.toEntity()),
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
    );

    if (result == null) {
      return const Left(FailureEntity.dataParsingFailure());
    }

    return result;
  }

  @override
  Future<Either<FailureEntity, UserEntity?>> signUpWithEmailAndPassword(
      String email, String password) async {
    final response =
        await authDatasource.signUpWithEmailAndPassword(email, password);

    final result = response.whenOrNull<Either<FailureEntity, UserEntity?>>(
      success: (model) => Right(model?.toEntity()),
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
    );

    if (result == null) {
      return const Left(FailureEntity.dataParsingFailure());
    }

    return result;
  }

  @override
  Future<Either<FailureEntity, UserEntity?>> signInWithGoogle() async {
    final response = await authDatasource.signInWithGoogle();

    final result = response.whenOrNull<Either<FailureEntity, UserEntity?>>(
      success: (model) => Right(model?.toEntity()),
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
    );

    if (result == null) {
      return const Left(FailureEntity.dataParsingFailure());
    }

    return result;
  }

  @override
  Future<Either<FailureEntity, Unit>> signOut() async {
    final response = await authDatasource.signOut();

    final result = response.whenOrNull<Either<FailureEntity, Unit>>(
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
    );

    if (result == null) {
      return const Left(FailureEntity.dataParsingFailure());
    }

    return result;
  }

  @override
  Future<Either<FailureEntity, UserEntity?>> getCurrentUser() async {
    final response = await authDatasource.getCurrentUser();

    final result = response.whenOrNull<Either<FailureEntity, UserEntity?>>(
      success: (model) => Right(model?.toEntity()),
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
    );

    if (result == null) {
      return const Left(FailureEntity.dataParsingFailure());
    }

    return result;
  }
}
