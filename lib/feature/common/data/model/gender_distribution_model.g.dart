// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gender_distribution_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GenderDistributionModelImpl _$$GenderDistributionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$GenderDistributionModelImpl(
      male: (json['male'] as num?)?.toInt(),
      malePercentage: (json['malePercentage'] as num?)?.toDouble(),
      female: (json['female'] as num?)?.toInt(),
      femalePercentage: (json['femalePercentage'] as num?)?.toDouble(),
      other: (json['other'] as num?)?.toInt(),
      otherPercentage: (json['otherPercentage'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$GenderDistributionModelImplToJson(
        _$GenderDistributionModelImpl instance) =>
    <String, dynamic>{
      'male': instance.male,
      'malePercentage': instance.malePercentage,
      'female': instance.female,
      'femalePercentage': instance.femalePercentage,
      'other': instance.other,
      'otherPercentage': instance.otherPercentage,
    };
