// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_package_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserPackageModelImpl _$$UserPackageModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserPackageModelImpl(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      packageId: (json['packageId'] as num?)?.toInt(),
      packageName: json['packageName'] as String?,
      status: $enumDecodeNullable(_$UserPackageStatusEnumMap, json['status']),
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      expiryDate: json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String),
      price: json['price'] as num?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      autoRenew: json['autoRenew'] as bool? ?? false,
    );

Map<String, dynamic> _$$UserPackageModelImplToJson(
        _$UserPackageModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'packageId': instance.packageId,
      'packageName': instance.packageName,
      'status': _$UserPackageStatusEnumMap[instance.status],
      'startDate': instance.startDate?.toIso8601String(),
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'price': instance.price,
      'createdAt': instance.createdAt?.toIso8601String(),
      'autoRenew': instance.autoRenew,
    };

const _$UserPackageStatusEnumMap = {
  UserPackageStatus.active: 'ACTIVE',
  UserPackageStatus.expired: 'EXPIRED',
};
