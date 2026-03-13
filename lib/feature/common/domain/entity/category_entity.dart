import 'package:events_app/feature/common/domain/entity/category_option_entity.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class CategoryEntity {
  final int? categoryId;
  final String? name;
  final CategoryType? type;
  final List<CategoryOptionEntity>? options;

  CategoryEntity({this.categoryId, this.name, this.type, this.options});
}
