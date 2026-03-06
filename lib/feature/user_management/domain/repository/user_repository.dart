import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/user_management/domain/entity/user_entity.dart';

abstract class UserRepository {
  /// Get user by Firebase UID
  Future<Either<FailureEntity, UserEntity?>> getUserByFirebaseUid(
      String firebaseUid);

  /// Get user by user ID
  Future<Either<FailureEntity, UserEntity?>> getUserById(int userId);

  /// Create new user
  Future<Either<FailureEntity, UserEntity>> createUser(UserEntity user);

  /// Update user
  Future<Either<FailureEntity, UserEntity>> updateUser(UserEntity user);
}
