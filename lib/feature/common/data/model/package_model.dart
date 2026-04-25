import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/package_entity.dart';

part 'package_model.freezed.dart';
part 'package_model.g.dart';

@freezed
class PackageModel with _$PackageModel {
  const factory PackageModel({
    int? packageId,
    String? packageName,
    String? name,
    String? description,
    int? price,
    int? duration,
    int? durationDays,
    bool? isActive,
  }) = _PackageModel;

  factory PackageModel.fromJson(Map<String, dynamic> json) =>
      _$PackageModelFromJson(json);

  factory PackageModel.fromEntity(PackageEntity entity) {
    return PackageModel(
      packageId: entity.packageId,
      packageName: entity.packageName,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      duration: entity.duration,
      durationDays: entity.durationDays,
      isActive: entity.isActive,
    );
  }
}

extension PackageModelExtension on PackageModel {
  PackageEntity toEntity() {
    return PackageEntity(
      packageId: packageId,
      packageName: packageName,
      name: name,
      description: description,
      price: price,
      duration: duration,
      durationDays: durationDays,
      isActive: isActive,
    );
  }
}
