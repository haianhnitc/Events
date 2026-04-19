import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/domain/repository/auth_repository.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:injectable/injectable.dart';

class SendPasswordResetEmailParams {
  final String email;

  const SendPasswordResetEmailParams({required this.email});
}

@injectable
class SendPasswordResetEmailUsecase
    implements UseCase<Unit, SendPasswordResetEmailParams> {
  final AuthRepository authRepository;

  SendPasswordResetEmailUsecase(this.authRepository);

  @override
  Future<Either<FailureEntity, Unit>> call(
      SendPasswordResetEmailParams params) async {
    return authRepository.sendPasswordResetEmail(params.email);
  }
}
