import 'package:events_app/feature/common/data/model/category_option_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import '../../domain/entity/category_entity.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    int? categoryId,
    String? name,
    CategoryType? type,
    List<CategoryOptionModel>? options,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      categoryId: entity.categoryId,
      name: entity.name,
      type: entity.type,
      options: entity.options?.map(CategoryOptionModel.fromEntity).toList(),
    );
  }
}

extension CategoryModelExtension on CategoryModel {
  CategoryEntity toEntity() {
    return CategoryEntity(
      categoryId: categoryId,
      name: name,
      type: type,
      options: options?.map((option) => option.toEntity()).toList(),
    );
  }
}
