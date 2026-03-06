class EventStatisticEntity {
  final int? eventId;
  final int? totalRegistered;
  final int? totalAttended;
  final int? totalNoShow;
  final int? totalRevenue;
  final double? avgRating;
  final DateTime? updatedTime;

  EventStatisticEntity({
    this.eventId,
    this.totalRegistered,
    this.totalAttended,
    this.totalNoShow,
    this.totalRevenue,
    this.avgRating,
    this.updatedTime,
  });
}
