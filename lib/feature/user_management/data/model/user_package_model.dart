import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import '../../domain/entity/user_package_entity.dart';

part 'user_package_model.freezed.dart';
part 'user_package_model.g.dart';

@freezed
class UserPackageModel with _$UserPackageModel {
  const factory UserPackageModel({
    int? id,
    int? userId,
    int? packageId,
    String? packageName,
    UserPackageStatus? status,
    DateTime? startDate,
    DateTime? expiryDate,
    num? price,
    DateTime? createdAt,
    @Default(false) bool? autoRenew,
  }) = _UserPackageModel;

  factory UserPackageModel.fromJson(Map<String, dynamic> json) =>
      _$UserPackageModelFromJson(json);

  factory UserPackageModel.fromEntity(UserPackageEntity entity) {
    return UserPackageModel(
      id: entity.userPackageId,
      userId: entity.userId,
      packageId: entity.packageId,
      packageName: entity.packageName,
      status: entity.status,
      startDate: entity.startTime,
      expiryDate: entity.endTime,
      price: entity.price,
      createdAt: entity.createdTime,
      autoRenew: entity.autoRenew,
    );
  }
}

extension UserPackageModelExtension on UserPackageModel {
  UserPackageEntity toEntity() {
    return UserPackageEntity(
      userPackageId: id,
      userId: userId,
      packageId: packageId,
      packageName: packageName,
      status: status,
      startTime: startDate,
      endTime: expiryDate,
      price: price,
      createdTime: createdAt,
      autoRenew: autoRenew,
    );
  }
}
