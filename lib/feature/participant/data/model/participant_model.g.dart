// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ParticipantModelImpl _$$ParticipantModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ParticipantModelImpl(
      eventParticipantId: (json['eventParticipantId'] as num?)?.toInt(),
      eventId: (json['eventId'] as num?)?.toInt(),
      user: json['user'] == null
          ? null
          : UserSummaryModel.fromJson(json['user'] as Map<String, dynamic>),
      participantQrContent: json['participantQrContent'] as String?,
      participantQrIssuedAt: json['participantQrIssuedAt'] == null
          ? null
          : DateTime.parse(json['participantQrIssuedAt'] as String),
      participantType: $enumDecodeNullable(
          _$ParticipantTypeEnumMap, json['participantType']),
      ticketId: (json['ticketId'] as num?)?.toInt(),
      status: $enumDecodeNullable(_$ParticipantStatusEnumMap, json['status']),
      hasCheckedIn: json['hasCheckedIn'] as bool?,
      registeredTime: json['registeredTime'] == null
          ? null
          : DateTime.parse(json['registeredTime'] as String),
      checkInTime: json['checkInTime'] == null
          ? null
          : DateTime.parse(json['checkInTime'] as String),
      checkOutTime: json['checkOutTime'] == null
          ? null
          : DateTime.parse(json['checkOutTime'] as String),
      isCheckOut: json['isCheckOut'] as bool?,
      hasFeedback: json['hasFeedback'] as bool?,
      feedbackSubmittedTime: json['feedbackSubmittedTime'] == null
          ? null
          : DateTime.parse(json['feedbackSubmittedTime'] as String),
      applicationId: (json['applicationId'] as num?)?.toInt(),
      recruitmentId: (json['recruitmentId'] as num?)?.toInt(),
      eventTitle: json['eventTitle'] as String?,
    );

Map<String, dynamic> _$$ParticipantModelImplToJson(
        _$ParticipantModelImpl instance) =>
    <String, dynamic>{
      'eventParticipantId': instance.eventParticipantId,
      'eventId': instance.eventId,
      'user': instance.user,
      'participantQrContent': instance.participantQrContent,
      'participantQrIssuedAt':
          instance.participantQrIssuedAt?.toIso8601String(),
      'participantType': _$ParticipantTypeEnumMap[instance.participantType],
      'ticketId': instance.ticketId,
      'status': _$ParticipantStatusEnumMap[instance.status],
      'hasCheckedIn': instance.hasCheckedIn,
      'registeredTime': instance.registeredTime?.toIso8601String(),
      'checkInTime': instance.checkInTime?.toIso8601String(),
      'checkOutTime': instance.checkOutTime?.toIso8601String(),
      'isCheckOut': instance.isCheckOut,
      'hasFeedback': instance.hasFeedback,
      'feedbackSubmittedTime':
          instance.feedbackSubmittedTime?.toIso8601String(),
      'applicationId': instance.applicationId,
      'recruitmentId': instance.recruitmentId,
      'eventTitle': instance.eventTitle,
    };

const _$ParticipantTypeEnumMap = {
  ParticipantType.attendee: 'ATTENDEE',
  ParticipantType.ctv: 'CTV',
};

const _$ParticipantStatusEnumMap = {
  ParticipantStatus.registered: 'REGISTERED',
  ParticipantStatus.attended: 'ATTENDED',
  ParticipantStatus.noShow: 'NOSHOW',
};
