import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';

class TicketEntity {
  final int? ticketId;
  final EventSummaryEntity? event;
  final TicketStatus? status;
  final DateTime? issuedTime;

  TicketEntity({
    this.ticketId,
    this.event,
    this.status,
    this.issuedTime,
  });

  int? get eventId => event?.eventId;
  String? get eventTitle => event?.title;
  String? get eventBanner => event?.banner;

  TicketEntity copyWith({
    int? ticketId,
    EventSummaryEntity? event,
    TicketStatus? status,
    DateTime? issuedTime,
  }) {
    return TicketEntity(
      ticketId: ticketId ?? this.ticketId,
      event: event ?? this.event,
      status: status ?? this.status,
      issuedTime: issuedTime ?? this.issuedTime,
    );
  }

  bool get isUnpaid => status == TicketStatus.unpaid;
  bool get isUsable => status == TicketStatus.issued;
  bool get isUsed => status == TicketStatus.used;
  bool get isExpired => status == TicketStatus.expired;

  @override
  String toString() =>
      'TicketEntity(id: $ticketId, event: ${event?.title}, status: $status)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TicketEntity && other.ticketId == ticketId;
  }

  @override
  int get hashCode => Object.hash(ticketId, ticketId);
}
