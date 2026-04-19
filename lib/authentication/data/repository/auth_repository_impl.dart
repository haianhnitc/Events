import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/data/datasource/auth_datasource.dart';
import 'package:events_app/authentication/domain/repository/auth_repository.dart';
import 'package:events_app/authentication/domain/usecase/signup_params.dart';
import 'package:events_app/feature/user_management/data/model/user_model.dart';
import 'package:events_app/feature/user_management/data/model/verification_document_model.dart';
import 'package:events_app/feature/user_management/domain/entity/user_entity.dart';
import 'package:events_app/feature/user_management/domain/entity/verification_document_entity.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource authDatasource;

  AuthRepositoryImpl(this.authDatasource);

  @override
  Future<Either<FailureEntity, UserEntity?>> signInWithEmailAndPassword(
      String email, String password) async {
    final response =
        await authDatasource.signInWithEmailAndPassword(email, password);
    return response.toEitherNullable().map((m) => m?.toEntity());
  }

  @override
  Future<Either<FailureEntity, UserEntity?>> signUpWithEmailAndPassword(
    String password,
    SignupParams signupParams,
  ) async {
    final response = await authDatasource.signUpWithEmailAndPassword(
      password,
      signupParams,
    );
    return response.toEitherNullable().map((m) => m?.toEntity());
  }

  @override
  Future<Either<FailureEntity, UserEntity?>> signInWithGoogle(
      {required bool isUser}) async {
    throw UnimplementedError('Use signInWithGoogleOnly instead');
  }

  @override
  Future<Either<FailureEntity, GoogleSignInResult>>
      signInWithGoogleOnly() async {
    final response = await authDatasource.signInWithGoogleOnly();
    return Right(response);
  }

  @override
  Future<Either<FailureEntity, UserEntity?>> signInWithGoogleExistingUser(
      String firebaseUid) async {
    final response =
        await authDatasource.signInWithGoogleExistingUser(firebaseUid);
    return response.toEitherNullable().map((m) => m?.toEntity());
  }

  @override
  Future<Either<FailureEntity, UserEntity?>> signUpWithGoogle({
    required SignupParams signupParams,
  }) async {
    final response = await authDatasource.signUpWithGoogle(
      signupParams: signupParams,
    );
    return response.toEitherNullable().map((m) => m?.toEntity());
  }

  @override
  Future<Either<FailureEntity, Unit>> signOut() async {
    final response = await authDatasource.signOut();
    return response.toEitherUnit();
  }

  @override
  Future<Either<FailureEntity, UserEntity?>> getCurrentUser() async {
    final response = await authDatasource.getCurrentUser();
    return response.toEitherNullable().map((m) => m?.toEntity());
  }

  @override
  Future<Either<FailureEntity, Unit>> sendPasswordResetEmail(
      String email) async {
    final response = await authDatasource.sendPasswordResetEmail(email);
    return response.toEitherUnit();
  }

  @override
  Future<Either<FailureEntity, VerificationDocumentEntity>>
      uploadVerificationDocument({
    required int fileId,
    required String documentType,
  }) async {
    final response = await authDatasource.uploadVerificationDocument(
      fileId: fileId,
      documentType: documentType,
    );
    return response.toEither().map((model) => model.toEntity());
  }

  @override
  Future<Either<FailureEntity, List<VerificationDocumentEntity>>>
      getMyVerificationDocuments({
    int page = 0,
    int size = 20,
  }) async {
    final response = await authDatasource.getMyVerificationDocuments(
      page: page,
      size: size,
    );
    return response.toEither().map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }

}
