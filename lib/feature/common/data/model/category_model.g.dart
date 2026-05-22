// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryModelImpl _$$CategoryModelImplFromJson(Map<String, dynamic> json) =>
    _$CategoryModelImpl(
      categoryId: (json['categoryId'] as num?)?.toInt(),
      name: json['name'] as String?,
      type: $enumDecodeNullable(_$CategoryTypeEnumMap, json['type']),
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => CategoryOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CategoryModelImplToJson(_$CategoryModelImpl instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'name': instance.name,
      'type': _$CategoryTypeEnumMap[instance.type],
      'options': instance.options,
    };

const _$CategoryTypeEnumMap = {
  CategoryType.school: 'SCHOOL',
  CategoryType.field: 'FIELD',
  CategoryType.location: 'LOCATION',
  CategoryType.style: 'STYLE',
  CategoryType.price: 'PRICE',
  CategoryType.attendee: 'ATTENDEE',
  CategoryType.criterion: 'CRITERION',
};
