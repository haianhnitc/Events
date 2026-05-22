// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_staff_application_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventStaffApplicationModelImpl _$$EventStaffApplicationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$EventStaffApplicationModelImpl(
      eventStaffApplicationId:
          (json['eventStaffApplicationId'] as num?)?.toInt(),
      eventId: (json['eventId'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      position: json['position'] as String?,
      status: $enumDecodeNullable(
              _$StaffApplicationStatusEnumMap, json['status']) ??
          StaffApplicationStatus.pending,
      cvUrl: json['cvUrl'] as String?,
      rejectReason: json['rejectReason'] as String?,
      appliedTime: json['appliedTime'] == null
          ? null
          : DateTime.parse(json['appliedTime'] as String),
      reviewedTime: json['reviewedTime'] == null
          ? null
          : DateTime.parse(json['reviewedTime'] as String),
    );

Map<String, dynamic> _$$EventStaffApplicationModelImplToJson(
        _$EventStaffApplicationModelImpl instance) =>
    <String, dynamic>{
      'eventStaffApplicationId': instance.eventStaffApplicationId,
      'eventId': instance.eventId,
      'userId': instance.userId,
      'position': instance.position,
      'status': _$StaffApplicationStatusEnumMap[instance.status],
      'cvUrl': instance.cvUrl,
      'rejectReason': instance.rejectReason,
      'appliedTime': instance.appliedTime?.toIso8601String(),
      'reviewedTime': instance.reviewedTime?.toIso8601String(),
    };

const _$StaffApplicationStatusEnumMap = {
  StaffApplicationStatus.pending: 'PENDING',
  StaffApplicationStatus.approved: 'APPROVED',
  StaffApplicationStatus.rejected: 'REJECTED',
};
