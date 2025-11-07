import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/domain/entity/user_entity.dart';
import 'package:events_app/authentication/domain/repository/auth_repository.dart';
import 'package:events_app/common/helpers/no_params.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class SigninWithGoogleUsecase implements UseCase<UserEntity?, NoParams> {
  final AuthRepository authRepository;

  SigninWithGoogleUsecase(this.authRepository);

  @override
  Future<Either<FailureEntity, UserEntity?>> call(NoParams params) async {
    return await authRepository.signInWithGoogle();
  }
}
