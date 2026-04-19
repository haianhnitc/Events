class EventStatisticEntity {
  final int? eventId;
  final String? eventTitle;
  final String? recruitmentType;
  final int? totalRegistered;
  final int? totalCheckedIn;
  final int? totalCheckedOut;
  final int? totalAttendees;
  final int? totalCtv;
  final int? totalTicketsSold;
  final int? totalFeedbacks;
  final DateTime? lastUpdateTime;

  EventStatisticEntity({
    this.eventId,
    this.eventTitle,
    this.recruitmentType,
    this.totalRegistered,
    this.totalCheckedIn,
    this.totalCheckedOut,
    this.totalAttendees,
    this.totalCtv,
    this.totalTicketsSold,
    this.totalFeedbacks,
    this.lastUpdateTime,
  });

  EventStatisticEntity copyWith({
    int? eventId,
    String? eventTitle,
    String? recruitmentType,
    int? totalRegistered,
    int? totalCheckedIn,
    int? totalCheckedOut,
    int? totalAttendees,
    int? totalCtv,
    int? totalTicketsSold,
    int? totalFeedbacks,
    DateTime? lastUpdateTime,
  }) {
    return EventStatisticEntity(
      eventId: eventId ?? this.eventId,
      eventTitle: eventTitle ?? this.eventTitle,
      recruitmentType: recruitmentType ?? this.recruitmentType,
      totalRegistered: totalRegistered ?? this.totalRegistered,
      totalCheckedIn: totalCheckedIn ?? this.totalCheckedIn,
      totalCheckedOut: totalCheckedOut ?? this.totalCheckedOut,
      totalAttendees: totalAttendees ?? this.totalAttendees,
      totalCtv: totalCtv ?? this.totalCtv,
      totalTicketsSold: totalTicketsSold ?? this.totalTicketsSold,
      totalFeedbacks: totalFeedbacks ?? this.totalFeedbacks,
      lastUpdateTime: lastUpdateTime ?? this.lastUpdateTime,
    );
  }

  @override
  String toString() => 'EventStatisticEntity(eventId: $eventId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventStatisticEntity && other.eventId == eventId;
  }

  @override
  int get hashCode => Object.hash(eventId, eventTitle);
}
