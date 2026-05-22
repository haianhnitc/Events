// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_role_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventRoleConfigModelImpl _$$EventRoleConfigModelImplFromJson(
        Map<String, dynamic> json) =>
    _$EventRoleConfigModelImpl(
      eventRoleConfigId: (json['eventRoleConfigId'] as num?)?.toInt(),
      eventId: (json['eventId'] as num?)?.toInt(),
      roleType: $enumDecodeNullable(_$EventRoleTypeEnumMap, json['roleType']),
      coinReward: (json['coinReward'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$EventRoleConfigModelImplToJson(
        _$EventRoleConfigModelImpl instance) =>
    <String, dynamic>{
      'eventRoleConfigId': instance.eventRoleConfigId,
      'eventId': instance.eventId,
      'roleType': _$EventRoleTypeEnumMap[instance.roleType],
      'coinReward': instance.coinReward,
    };

const _$EventRoleTypeEnumMap = {
  EventRoleType.attendee: 'ATTENDEE',
  EventRoleType.ctv: 'CTV',
};
