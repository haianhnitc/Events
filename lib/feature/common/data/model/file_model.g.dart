// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FileModelImpl _$$FileModelImplFromJson(Map<String, dynamic> json) =>
    _$FileModelImpl(
      fileId: (json['fileId'] as num?)?.toInt(),
      url: json['url'] as String?,
      fileType: json['fileType'] as String?,
      fileSize: (json['fileSize'] as num?)?.toInt(),
      createdTime: json['createdTime'] == null
          ? null
          : DateTime.parse(json['createdTime'] as String),
    );

Map<String, dynamic> _$$FileModelImplToJson(_$FileModelImpl instance) =>
    <String, dynamic>{
      'fileId': instance.fileId,
      'url': instance.url,
      'fileType': instance.fileType,
      'fileSize': instance.fileSize,
      'createdTime': instance.createdTime?.toIso8601String(),
    };
