// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_option_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryOptionModelImpl _$$CategoryOptionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CategoryOptionModelImpl(
      categoryOptionId: (json['categoryOptionId'] as num?)?.toInt(),
      categoryId: (json['categoryId'] as num?)?.toInt(),
      value: json['value'] as String?,
    );

Map<String, dynamic> _$$CategoryOptionModelImplToJson(
        _$CategoryOptionModelImpl instance) =>
    <String, dynamic>{
      'categoryOptionId': instance.categoryOptionId,
      'categoryId': instance.categoryId,
      'value': instance.value,
    };
