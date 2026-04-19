import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/data/datasource/auth_datasource.dart';
import 'package:events_app/authentication/domain/usecase/signup_params.dart';
import 'package:events_app/feature/user_management/domain/entity/user_entity.dart';
import 'package:events_app/feature/user_management/domain/entity/verification_document_entity.dart';

abstract class AuthRepository {
  Future<Either<FailureEntity, UserEntity?>> signInWithEmailAndPassword(
      String email, String password);
  Future<Either<FailureEntity, UserEntity?>> signUpWithEmailAndPassword(
    String password,
    SignupParams signupParams,
  );

  Future<Either<FailureEntity, GoogleSignInResult>> signInWithGoogleOnly();
  Future<Either<FailureEntity, UserEntity?>> signInWithGoogleExistingUser(String firebaseUid);
  Future<Either<FailureEntity, UserEntity?>> signUpWithGoogle({
    required SignupParams signupParams,
  });

  Future<Either<FailureEntity, Unit>> signOut();
  Future<Either<FailureEntity, UserEntity?>> getCurrentUser();
  Future<Either<FailureEntity, Unit>> sendPasswordResetEmail(String email);
  Future<Either<FailureEntity, VerificationDocumentEntity>> uploadVerificationDocument({
    required int fileId,
    required String documentType,
  });
  Future<Either<FailureEntity, List<VerificationDocumentEntity>>> getMyVerificationDocuments({
    int page = 0,
    int size = 20,
  });
}
