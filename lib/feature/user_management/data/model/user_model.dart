import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/user_management/data/model/user_profile_model.dart';
import 'package:events_app/feature/user_management/data/model/organization_profile_model.dart';
import 'package:events_app/feature/user_management/data/model/verification_document_model.dart';
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
    UserStatus? status,
    @Default(0) int currentCoin,
    DateTime? createdTime,
    UserProfileModel? userProfile,
    OrganizationProfileModel? organizationProfile,
    List<VerificationDocumentModel>? verificationDocuments,
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
      createdTime: entity.createdTime,
      userProfile: entity.userProfile != null
          ? UserProfileModel.fromEntity(entity.userProfile!)
          : null,
      organizationProfile: entity.organizationProfile != null
          ? OrganizationProfileModel.fromEntity(entity.organizationProfile!)
          : null,
      verificationDocuments: entity.verificationDocuments
          ?.map((e) => VerificationDocumentModel.fromEntity(e))
          .toList(),
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
      createdTime: createdTime,
      userProfile: userProfile?.toEntity(),
      organizationProfile: organizationProfile?.toEntity(),
      verificationDocuments:
          verificationDocuments?.map((e) => e.toEntity()).toList(),
    );
  }
}
