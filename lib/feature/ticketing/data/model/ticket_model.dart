import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import '../../domain/entity/ticket_entity.dart';

part 'ticket_model.freezed.dart';
part 'ticket_model.g.dart';

@freezed
class TicketModel with _$TicketModel {
  const factory TicketModel({
    int? ticketId,
    int? eventId,
    String? qrCode,
    @Default(TicketStatus.issued) TicketStatus? status,
    @Default(0) int? price,
    DateTime? issuedTime,
  }) = _TicketModel;

  factory TicketModel.fromJson(Map<String, dynamic> json) =>
      _$TicketModelFromJson(json);

  factory TicketModel.fromEntity(TicketEntity entity) {
    return TicketModel(
      ticketId: entity.ticketId,
      eventId: entity.eventId,
      qrCode: entity.qrCode,
      status: entity.status,
      price: entity.price,
      issuedTime: entity.issuedTime,
    );
  }
}

extension TicketModelExtension on TicketModel {
  TicketEntity toEntity() {
    return TicketEntity(
      ticketId: ticketId,
      eventId: eventId,
      qrCode: qrCode,
      status: status,
      price: price,
      issuedTime: issuedTime,
    );
  }
}
