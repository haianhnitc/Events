// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_category_option_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventCategoryOptionModelImpl _$$EventCategoryOptionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$EventCategoryOptionModelImpl(
      categoryOptionId: (json['categoryOptionId'] as num?)?.toInt(),
      categoryId: (json['categoryId'] as num?)?.toInt(),
      categoryName: json['categoryName'] as String?,
      value: json['value'] as String?,
      eventId: (json['eventId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$EventCategoryOptionModelImplToJson(
        _$EventCategoryOptionModelImpl instance) =>
    <String, dynamic>{
      'categoryOptionId': instance.categoryOptionId,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'value': instance.value,
      'eventId': instance.eventId,
    };
