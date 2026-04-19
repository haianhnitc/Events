import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/user_management/domain/entity/user_entity.dart';
import 'package:events_app/authentication/domain/repository/auth_repository.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:injectable/injectable.dart';

class SigninWithEmailAndPasswordParams {
  final String email;
  final String password;

  const SigninWithEmailAndPasswordParams({
    required this.email,
    required this.password,
  });
}

@injectable
class SigninWithEmailAndPasswordUsecase
    implements UseCase<UserEntity?, SigninWithEmailAndPasswordParams> {
  final AuthRepository authRepository;

  SigninWithEmailAndPasswordUsecase(this.authRepository);

  @override
  Future<Either<FailureEntity, UserEntity?>> call(
      SigninWithEmailAndPasswordParams params) async {
    return await authRepository.signInWithEmailAndPassword(
        params.email, params.password);
  }
}
