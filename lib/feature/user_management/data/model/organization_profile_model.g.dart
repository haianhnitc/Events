// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrganizationProfileModelImpl _$$OrganizationProfileModelImplFromJson(
        Map<String, dynamic> json) =>
    _$OrganizationProfileModelImpl(
      userId: (json['userId'] as num?)?.toInt(),
      organizationName: json['organizationName'] as String?,
      description: json['description'] as String?,
      organizationType: $enumDecodeNullable(
          _$OrganizationTypeEnumMap, json['organizationType']),
      logoUrl: json['logoUrl'] as String?,
      verificationStatus: $enumDecodeNullable(
          _$VerificationStatusEnumMap, json['verificationStatus']),
      verifiedTime: json['verifiedTime'] == null
          ? null
          : DateTime.parse(json['verifiedTime'] as String),
      address: json['address'] as String?,
    );

Map<String, dynamic> _$$OrganizationProfileModelImplToJson(
        _$OrganizationProfileModelImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'organizationName': instance.organizationName,
      'description': instance.description,
      'organizationType': _$OrganizationTypeEnumMap[instance.organizationType],
      'logoUrl': instance.logoUrl,
      'verificationStatus':
          _$VerificationStatusEnumMap[instance.verificationStatus],
      'verifiedTime': instance.verifiedTime?.toIso8601String(),
      'address': instance.address,
    };

const _$OrganizationTypeEnumMap = {
  OrganizationType.university: 'UNIVERSITY',
  OrganizationType.club: 'CLUB',
  OrganizationType.company: 'COMPANY',
};

const _$VerificationStatusEnumMap = {
  VerificationStatus.pending: 'PENDING',
  VerificationStatus.approved: 'APPROVED',
  VerificationStatus.rejected: 'REJECTED',
};
