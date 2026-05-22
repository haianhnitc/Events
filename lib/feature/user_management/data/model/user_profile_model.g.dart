// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileModelImpl _$$UserProfileModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserProfileModelImpl(
      userId: (json['userId'] as num?)?.toInt(),
      fullName: json['fullName'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      gender: json['gender'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      university: json['university'] as String?,
      faculty: json['faculty'] as String?,
      major: json['major'] as String?,
      studentCode: json['studentCode'] as String?,
      remainingFreePortfolios:
          (json['remainingFreePortfolios'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$UserProfileModelImplToJson(
        _$UserProfileModelImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'fullName': instance.fullName,
      'avatarUrl': instance.avatarUrl,
      'gender': instance.gender,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'university': instance.university,
      'faculty': instance.faculty,
      'major': instance.major,
      'studentCode': instance.studentCode,
      'remainingFreePortfolios': instance.remainingFreePortfolios,
    };
