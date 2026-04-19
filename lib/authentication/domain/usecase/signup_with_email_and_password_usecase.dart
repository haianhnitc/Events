import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/domain/repository/auth_repository.dart';
import 'package:events_app/authentication/domain/usecase/signup_params.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:events_app/feature/user_management/domain/entity/user_entity.dart';
import 'package:injectable/injectable.dart';

class SignupWithEmailAndPasswordParams {
  final String password;
  final SignupParams signupParams;

  const SignupWithEmailAndPasswordParams({
    required this.password,
    required this.signupParams,
  });
}

@injectable
class SignupWithEmailAndPasswordUsecase
    implements UseCase<UserEntity?, SignupWithEmailAndPasswordParams> {
  final AuthRepository authRepository;

  SignupWithEmailAndPasswordUsecase(this.authRepository);

  @override
  Future<Either<FailureEntity, UserEntity?>> call(
      SignupWithEmailAndPasswordParams params) async {
    return await authRepository.signUpWithEmailAndPassword(
      params.password,
      params.signupParams,
    );
  }
}
