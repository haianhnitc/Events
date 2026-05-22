// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      userId: (json['userId'] as num?)?.toInt(),
      firebaseUid: json['firebaseUid'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      role:
          $enumDecodeNullable(_$UserRoleEnumMap, json['role']) ?? UserRole.user,
      status: $enumDecodeNullable(_$UserStatusEnumMap, json['status']),
      currentCoin: (json['currentCoin'] as num?)?.toInt() ?? 0,
      createdTime: json['createdTime'] == null
          ? null
          : DateTime.parse(json['createdTime'] as String),
      userProfile: json['userProfile'] == null
          ? null
          : UserProfileModel.fromJson(
              json['userProfile'] as Map<String, dynamic>),
      organizationProfile: json['organizationProfile'] == null
          ? null
          : OrganizationProfileModel.fromJson(
              json['organizationProfile'] as Map<String, dynamic>),
      verificationDocuments: (json['verificationDocuments'] as List<dynamic>?)
          ?.map((e) =>
              VerificationDocumentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'firebaseUid': instance.firebaseUid,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'role': _$UserRoleEnumMap[instance.role],
      'status': _$UserStatusEnumMap[instance.status],
      'currentCoin': instance.currentCoin,
      'createdTime': instance.createdTime?.toIso8601String(),
      'userProfile': instance.userProfile,
      'organizationProfile': instance.organizationProfile,
      'verificationDocuments': instance.verificationDocuments,
    };

const _$UserRoleEnumMap = {
  UserRole.user: 'USER',
  UserRole.admin: 'ADMIN',
  UserRole.organization: 'ORGANIZATION',
};

const _$UserStatusEnumMap = {
  UserStatus.active: 'ACTIVE',
  UserStatus.disabled: 'DISABLED',
};
