// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TimelineDataModelImpl _$$TimelineDataModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TimelineDataModelImpl(
      time: json['time'] as String?,
      count: (json['count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$TimelineDataModelImplToJson(
        _$TimelineDataModelImpl instance) =>
    <String, dynamic>{
      'time': instance.time,
      'count': instance.count,
    };
