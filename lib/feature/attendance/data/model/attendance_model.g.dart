// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AttendanceQrModelImpl _$$AttendanceQrModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AttendanceQrModelImpl(
      qrContent: json['qrContent'] as String?,
      scanMethod: $enumDecodeNullable(_$ScanMethodEnumMap, json['scanMethod']),
      eventId: (json['eventId'] as num?)?.toInt(),
      eventParticipantId: (json['eventParticipantId'] as num?)?.toInt(),
      issuedTime: json['issuedTime'] == null
          ? null
          : DateTime.parse(json['issuedTime'] as String),
      expiryTime: json['expiryTime'] == null
          ? null
          : DateTime.parse(json['expiryTime'] as String),
    );

Map<String, dynamic> _$$AttendanceQrModelImplToJson(
        _$AttendanceQrModelImpl instance) =>
    <String, dynamic>{
      'qrContent': instance.qrContent,
      'scanMethod': _$ScanMethodEnumMap[instance.scanMethod],
      'eventId': instance.eventId,
      'eventParticipantId': instance.eventParticipantId,
      'issuedTime': instance.issuedTime?.toIso8601String(),
      'expiryTime': instance.expiryTime?.toIso8601String(),
    };

const _$ScanMethodEnumMap = {
  ScanMethod.eventQr: 'EVENT_QR',
  ScanMethod.staffQr: 'STAFF_QR',
  ScanMethod.manual: 'MANUAL',
};

_$AttendanceScanResultModelImpl _$$AttendanceScanResultModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AttendanceScanResultModelImpl(
      action: $enumDecodeNullable(_$AttendanceActionEnumMap, json['action']),
      eventParticipantId: (json['eventParticipantId'] as num?)?.toInt(),
      attendanceLogId: (json['attendanceLogId'] as num?)?.toInt(),
      checkInTime: json['checkInTime'] == null
          ? null
          : DateTime.parse(json['checkInTime'] as String),
      checkOutTime: json['checkOutTime'] == null
          ? null
          : DateTime.parse(json['checkOutTime'] as String),
      message: json['message'] as String?,
      participantName: json['participantName'] as String?,
      participantType: $enumDecodeNullable(
          _$ParticipantTypeEnumMap, json['participantType']),
      userId: (json['userId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$AttendanceScanResultModelImplToJson(
        _$AttendanceScanResultModelImpl instance) =>
    <String, dynamic>{
      'action': _$AttendanceActionEnumMap[instance.action],
      'eventParticipantId': instance.eventParticipantId,
      'attendanceLogId': instance.attendanceLogId,
      'checkInTime': instance.checkInTime?.toIso8601String(),
      'checkOutTime': instance.checkOutTime?.toIso8601String(),
      'message': instance.message,
      'participantName': instance.participantName,
      'participantType': _$ParticipantTypeEnumMap[instance.participantType],
      'userId': instance.userId,
    };

const _$AttendanceActionEnumMap = {
  AttendanceAction.checkIn: 'CHECKIN',
  AttendanceAction.checkOut: 'CHECKOUT',
};

const _$ParticipantTypeEnumMap = {
  ParticipantType.attendee: 'ATTENDEE',
  ParticipantType.ctv: 'CTV',
};
