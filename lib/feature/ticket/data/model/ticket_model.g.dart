// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TicketModelImpl _$$TicketModelImplFromJson(Map<String, dynamic> json) =>
    _$TicketModelImpl(
      ticketId: (json['ticketId'] as num?)?.toInt(),
      event: json['event'] == null
          ? null
          : EventSummaryModel.fromJson(json['event'] as Map<String, dynamic>),
      status: $enumDecodeNullable(_$TicketStatusEnumMap, json['status']),
      issuedTime: json['issuedTime'] == null
          ? null
          : DateTime.parse(json['issuedTime'] as String),
    );

Map<String, dynamic> _$$TicketModelImplToJson(_$TicketModelImpl instance) =>
    <String, dynamic>{
      'ticketId': instance.ticketId,
      'event': instance.event,
      'status': _$TicketStatusEnumMap[instance.status],
      'issuedTime': instance.issuedTime?.toIso8601String(),
    };

const _$TicketStatusEnumMap = {
  TicketStatus.unpaid: 'UNPAID',
  TicketStatus.issued: 'ISSUED',
  TicketStatus.used: 'USED',
  TicketStatus.expired: 'EXPIRED',
};
