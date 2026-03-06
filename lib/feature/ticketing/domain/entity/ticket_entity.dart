import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class TicketEntity {
  final int? ticketId;
  final int? eventId;
  final String? qrCode;
  final TicketStatus? status;
  final int? price;
  final DateTime? issuedTime;

  TicketEntity({
    this.ticketId,
    this.eventId,
    this.qrCode,
    this.status,
    this.price,
    this.issuedTime,
  });
}
