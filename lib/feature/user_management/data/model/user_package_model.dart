import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import '../../domain/entity/user_package_entity.dart';

part 'user_package_model.freezed.dart';
part 'user_package_model.g.dart';

@freezed
class UserPackageModel with _$UserPackageModel {
  const factory UserPackageModel({
    int? userPackageId,
    int? userId,
    int? packageId,
    @Default(UserPackageStatus.active) UserPackageStatus? status,
    DateTime? startTime,
    DateTime? endTime,
    @Default(false) bool? autoRenew,
    DateTime? createdTime,
  }) = _UserPackageModel;

  factory UserPackageModel.fromJson(Map<String, dynamic> json) =>
      _$UserPackageModelFromJson(json);

  factory UserPackageModel.fromEntity(UserPackageEntity entity) {
    return UserPackageModel(
      userPackageId: entity.userPackageId,
      userId: entity.userId,
      packageId: entity.packageId,
      status: entity.status,
      startTime: entity.startTime,
      endTime: entity.endTime,
      autoRenew: entity.autoRenew,
      createdTime: entity.createdTime,
    );
  }
}

extension UserPackageModelExtension on UserPackageModel {
  UserPackageEntity toEntity() {
    return UserPackageEntity(
      userPackageId: userPackageId,
      userId: userId,
      packageId: packageId,
      status: status,
      startTime: startTime,
      endTime: endTime,
      autoRenew: autoRenew,
      createdTime: createdTime,
    );
  }
}
