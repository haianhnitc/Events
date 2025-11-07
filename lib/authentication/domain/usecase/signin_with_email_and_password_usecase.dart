import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/domain/entity/user_entity.dart';
import 'package:events_app/authentication/domain/repository/auth_repository.dart';
import 'package:events_app/authentication/data/model/auth_params.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class SigninWithEmailAndPasswordUsecase
    implements UseCase<UserEntity?, AuthParams> {
  final AuthRepository authRepository;

  SigninWithEmailAndPasswordUsecase(this.authRepository);

  @override
  Future<Either<FailureEntity, UserEntity?>> call(AuthParams params) async {
    return await authRepository.signInWithEmailAndPassword(
        params.email, params.password);
  }
}
