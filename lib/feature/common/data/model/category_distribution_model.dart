import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/category_distribution_entity.dart';

part 'category_distribution_model.freezed.dart';
part 'category_distribution_model.g.dart';

@freezed
class CategoryDistributionModel with _$CategoryDistributionModel {
  const factory CategoryDistributionModel({
    String? name,
    int? count,
    double? percentage,
  }) = _CategoryDistributionModel;

  factory CategoryDistributionModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryDistributionModelFromJson(json);

  factory CategoryDistributionModel.fromEntity(CategoryDistributionEntity entity) {
    return CategoryDistributionModel(
      name: entity.name,
      count: entity.count,
      percentage: entity.percentage,
    );
  }
}

extension CategoryDistributionModelExtension on CategoryDistributionModel {
  CategoryDistributionEntity toEntity() {
    return CategoryDistributionEntity(
      name: name,
      count: count,
      percentage: percentage,
    );
  }
}
