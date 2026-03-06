import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/user_management/domain/entity/user_entity.dart';

abstract class AuthRepository {
  Future<Either<FailureEntity, UserEntity?>> signInWithEmailAndPassword(
      String email, String password);
  Future<Either<FailureEntity, UserEntity?>> signUpWithEmailAndPassword(
      String email, String password);
  Future<Either<FailureEntity, UserEntity?>> signInWithGoogle();
  Future<Either<FailureEntity, Unit>> signOut();
  Future<Either<FailureEntity, UserEntity?>> getCurrentUser();
}
