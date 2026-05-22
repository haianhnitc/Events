// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiResponseErrorImpl _$$ApiResponseErrorImplFromJson(
        Map<String, dynamic> json) =>
    _$ApiResponseErrorImpl(
      code: json['code'] as String,
      message: json['message'] as String,
      errors: (json['errors'] as List<dynamic>?)
          ?.map(
              (e) => ApiResponseErrorDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ApiResponseErrorImplToJson(
        _$ApiResponseErrorImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'errors': instance.errors,
    };

_$ApiResponseErrorDetailImpl _$$ApiResponseErrorDetailImplFromJson(
        Map<String, dynamic> json) =>
    _$ApiResponseErrorDetailImpl(
      reason: json['reason'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$ApiResponseErrorDetailImplToJson(
        _$ApiResponseErrorDetailImpl instance) =>
    <String, dynamic>{
      'reason': instance.reason,
      'description': instance.description,
    };
