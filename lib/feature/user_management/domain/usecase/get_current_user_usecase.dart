import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/common/helpers/no_params.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:events_app/feature/user_management/domain/entity/user_entity.dart';
import 'package:events_app/feature/user_management/domain/repository/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCurrentUserUsecase implements UseCase<UserEntity?, NoParams> {
  final UserRepository _repository;

  GetCurrentUserUsecase(this._repository);

  @override
  Future<Either<FailureEntity, UserEntity?>> call(NoParams params) async {
    return await _repository.getCurrentUser();
  }
}
