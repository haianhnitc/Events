import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/common/data/datasource/category_datasource.dart';
import 'package:events_app/feature/common/data/model/category_model.dart';
import 'package:events_app/feature/common/domain/entity/category_entity.dart';
import 'package:injectable/injectable.dart';

abstract class CategoryRepository {
  Future<Either<FailureEntity, List<CategoryEntity>>> getCategories();
}

@Injectable(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDatasource _datasource;

  CategoryRepositoryImpl(this._datasource);

  @override
  Future<Either<FailureEntity, List<CategoryEntity>>> getCategories() async {
    final response = await _datasource.getCategories();
    return response.toEither().map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }
}
