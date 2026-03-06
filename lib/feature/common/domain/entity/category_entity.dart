import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class CategoryEntity {
  final int? categoryId;
  final String? name;
  final CategoryType? type;

  CategoryEntity({
    this.categoryId,
    this.name,
    this.type,
  });
}
