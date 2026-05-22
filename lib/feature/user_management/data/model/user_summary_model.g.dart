// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserSummaryModelImpl _$$UserSummaryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserSummaryModelImpl(
      userId: (json['userId'] as num?)?.toInt(),
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      role: $enumDecodeNullable(_$UserRoleEnumMap, json['role']),
      status: $enumDecodeNullable(_$UserStatusEnumMap, json['status']),
      joinedAt: json['joinedAt'] == null
          ? null
          : DateTime.parse(json['joinedAt'] as String),
    );

Map<String, dynamic> _$$UserSummaryModelImplToJson(
        _$UserSummaryModelImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'fullName': instance.fullName,
      'email': instance.email,
      'avatarUrl': instance.avatarUrl,
      'role': _$UserRoleEnumMap[instance.role],
      'status': _$UserStatusEnumMap[instance.status],
      'joinedAt': instance.joinedAt?.toIso8601String(),
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
