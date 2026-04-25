import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:events_app/feature/common/domain/entity/category_entity.dart';
import 'package:events_app/feature/common/data/repository/category_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCategoriesUsecase implements UseCase<List<CategoryEntity>, void> {
  final CategoryRepository _repository;

  GetCategoriesUsecase(this._repository);

  @override
  Future<Either<FailureEntity, List<CategoryEntity>>> call(void _) async {
    return await _repository.getCategories();
  }
}
