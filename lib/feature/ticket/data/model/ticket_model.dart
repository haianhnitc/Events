import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:events_app/feature/ticket/domain/entity/ticket_entity.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/event_management/data/model/event_summary_model.dart';

part 'ticket_model.freezed.dart';
part 'ticket_model.g.dart';

@freezed
class TicketModel with _$TicketModel {
  const factory TicketModel({
    int? ticketId,
    EventSummaryModel? event,
    TicketStatus? status,
    DateTime? issuedTime,
  }) = _TicketModel;

  factory TicketModel.fromJson(Map<String, dynamic> json) =>
      _$TicketModelFromJson(json);

  factory TicketModel.fromEntity(TicketEntity entity) {
    return TicketModel(
      ticketId: entity.ticketId,
      event: entity.event != null
          ? EventSummaryModel.fromEntity(entity.event!)
          : null,
      status: entity.status,
      issuedTime: entity.issuedTime,
    );
  }
}

extension TicketModelExtension on TicketModel {
  TicketEntity toEntity() {
    return TicketEntity(
      ticketId: ticketId,
      event: event?.toEntity(),
      status: status,
      issuedTime: issuedTime,
    );
  }
}
