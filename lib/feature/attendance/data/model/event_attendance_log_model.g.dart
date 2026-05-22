// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_attendance_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventAttendanceLogModelImpl _$$EventAttendanceLogModelImplFromJson(
        Map<String, dynamic> json) =>
    _$EventAttendanceLogModelImpl(
      eventAttendanceLogId: (json['eventAttendanceLogId'] as num?)?.toInt(),
      type: $enumDecodeNullable(_$AttendanceLogTypeEnumMap, json['type']),
      scanMethod: $enumDecodeNullable(_$ScanMethodEnumMap, json['scanMethod']),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      isValid: json['isValid'] as bool?,
      createdTime: json['createdTime'] == null
          ? null
          : DateTime.parse(json['createdTime'] as String),
      eventParticipant: json['eventParticipant'] == null
          ? null
          : ParticipantModel.fromJson(
              json['eventParticipant'] as Map<String, dynamic>),
      scannedByUser: json['scannedByUser'] == null
          ? null
          : UserSummaryModel.fromJson(
              json['scannedByUser'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$EventAttendanceLogModelImplToJson(
        _$EventAttendanceLogModelImpl instance) =>
    <String, dynamic>{
      'eventAttendanceLogId': instance.eventAttendanceLogId,
      'type': _$AttendanceLogTypeEnumMap[instance.type],
      'scanMethod': _$ScanMethodEnumMap[instance.scanMethod],
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'isValid': instance.isValid,
      'createdTime': instance.createdTime?.toIso8601String(),
      'eventParticipant': instance.eventParticipant,
      'scannedByUser': instance.scannedByUser,
    };

const _$AttendanceLogTypeEnumMap = {
  AttendanceLogType.checkIn: 'CHECKIN',
  AttendanceLogType.checkOut: 'CHECKOUT',
};

const _$ScanMethodEnumMap = {
  ScanMethod.eventQr: 'EVENT_QR',
  ScanMethod.staffQr: 'STAFF_QR',
  ScanMethod.manual: 'MANUAL',
};
