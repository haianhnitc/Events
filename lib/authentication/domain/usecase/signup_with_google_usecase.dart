import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/domain/repository/auth_repository.dart';
import 'package:events_app/authentication/domain/usecase/signup_params.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:events_app/feature/user_management/domain/entity/user_entity.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignUpWithGoogleUsecase
    implements UseCase<UserEntity?, SignupParams> {
  final AuthRepository authRepository;

  SignUpWithGoogleUsecase(this.authRepository);

  @override
  Future<Either<FailureEntity, UserEntity?>> call(SignupParams params) async {
    return await authRepository.signUpWithGoogle(signupParams: params);
  }
}