import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import '../../domain/entity/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    int? userId,
    required String firebaseUid,
    required String email,
    String? phoneNumber,
    @Default(UserRole.user) UserRole? role,
    @Default(UserStatus.active) UserStatus? status,
    @Default(0) int? currentCoin,
    @Default(0) int remainingFreePortfolios,
    DateTime? createdTime,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      userId: entity.userId,
      firebaseUid: entity.firebaseUid,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      role: entity.role,
      status: entity.status,
      currentCoin: entity.currentCoin,
      remainingFreePortfolios: entity.remainingFreePortfolios,
      createdTime: entity.createdTime,
    );
  }
}

extension UserModelExtension on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      email: email,
      firebaseUid: firebaseUid,
      phoneNumber: phoneNumber,
      role: role,
      status: status,
      currentCoin: currentCoin,
      remainingFreePortfolios: remainingFreePortfolios,
      createdTime: createdTime,
    );
  }
}
