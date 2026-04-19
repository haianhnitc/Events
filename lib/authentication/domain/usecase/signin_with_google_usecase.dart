import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/data/datasource/auth_datasource.dart';
import 'package:events_app/feature/user_management/domain/entity/user_entity.dart';
import 'package:events_app/authentication/domain/repository/auth_repository.dart';
import 'package:events_app/common/helpers/no_params.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:injectable/injectable.dart';

class SignInWithGoogleParams {
  final bool isUser;

  const SignInWithGoogleParams({required this.isUser});
}

@injectable
class SignInWithGoogleOnlyUsecase implements UseCase<GoogleSignInResult, NoParams> {
  final AuthRepository authRepository;

  SignInWithGoogleOnlyUsecase(this.authRepository);

  @override
  Future<Either<FailureEntity, GoogleSignInResult>> call(NoParams params) async {
    return await authRepository.signInWithGoogleOnly();
  }
}

@injectable
class SignInWithGoogleExistingUserUsecase
    implements UseCase<UserEntity?, String> {
  final AuthRepository authRepository;

  SignInWithGoogleExistingUserUsecase(this.authRepository);

  @override
  Future<Either<FailureEntity, UserEntity?>> call(String firebaseUid) async {
    return await authRepository.signInWithGoogleExistingUser(firebaseUid);
  }
}

@injectable
class SigninWithGoogleUsecase implements UseCase<UserEntity?, SignInWithGoogleParams> {
  final AuthRepository authRepository;

  SigninWithGoogleUsecase(this.authRepository);

  @override
  Future<Either<FailureEntity, UserEntity?>> call(SignInWithGoogleParams params) async {
    throw UnimplementedError('Use SignInWithGoogleOnlyUsecase instead');
  }
}
