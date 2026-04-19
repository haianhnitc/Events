import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class TicketUpdateParams {
  final TicketStatus status;

  const TicketUpdateParams({required this.status});

  Map<String, dynamic> toJson() => {'status': status.apiValue};
}

class TicketCreateParams {
  final int eventId;

  const TicketCreateParams({required this.eventId});

  Map<String, dynamic> toJson() => {'eventId': eventId};
}
