import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/package_entity.dart';

part 'package_model.freezed.dart';
part 'package_model.g.dart';

@freezed
class PackageModel with _$PackageModel {
  const factory PackageModel({
    int? packageId,
    String? name,
    String? description,
    int? price,
    int? durationDays,
    bool? isActive,
    DateTime? createdTime,
  }) = _PackageModel;

  factory PackageModel.fromJson(Map<String, dynamic> json) =>
      _$PackageModelFromJson(json);

  factory PackageModel.fromEntity(PackageEntity entity) {
    return PackageModel(
      packageId: entity.packageId,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      durationDays: entity.durationDays,
      isActive: entity.isActive,
      createdTime: entity.createdTime,
    );
  }
}

extension PackageModelExtension on PackageModel {
  PackageEntity toEntity() {
    return PackageEntity(
      packageId: packageId,
      name: name,
      description: description,
      price: price,
      durationDays: durationDays,
      isActive: isActive,
      createdTime: createdTime,
    );
  }
}
