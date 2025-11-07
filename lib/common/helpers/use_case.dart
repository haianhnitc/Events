import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';

abstract class UseCase<T, P> {
  Future<Either<FailureEntity, T>> call(P param);
}
