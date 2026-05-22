// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_distribution_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryDistributionModelImpl _$$CategoryDistributionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CategoryDistributionModelImpl(
      name: json['name'] as String?,
      count: (json['count'] as num?)?.toInt(),
      percentage: (json['percentage'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$CategoryDistributionModelImplToJson(
        _$CategoryDistributionModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'count': instance.count,
      'percentage': instance.percentage,
    };
