import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/category_option_entity.dart';

part 'category_option_model.freezed.dart';
part 'category_option_model.g.dart';

@freezed
class CategoryOptionModel with _$CategoryOptionModel {
  const factory CategoryOptionModel({
    int? categoryOptionId,
    int? categoryId,
    String? label,
    String? value,
  }) = _CategoryOptionModel;

  factory CategoryOptionModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryOptionModelFromJson(json);

  factory CategoryOptionModel.fromEntity(CategoryOptionEntity entity) {
    return CategoryOptionModel(
      categoryOptionId: entity.categoryOptionId,
      categoryId: entity.categoryId,
      label: entity.label,
      value: entity.value,
    );
  }
}

extension CategoryOptionModelExtension on CategoryOptionModel {
  CategoryOptionEntity toEntity() {
    return CategoryOptionEntity(
      categoryOptionId: categoryOptionId,
      categoryId: categoryId,
      label: label,
      value: value,
    );
  }
}
