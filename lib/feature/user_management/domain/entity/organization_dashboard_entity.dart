class OrganizationDashboardEntity {
  final int? totalEvents;
  final double? totalEventsGrowth;
  final int? totalRegistrations;
  final double? totalRegistrationsGrowth;
  final int? totalViews;
  final double? totalViewsGrowth;
  final double? averageAttendanceRate;
  final double? averageAttendanceRateGrowth;

  OrganizationDashboardEntity({
    this.totalEvents,
    this.totalEventsGrowth,
    this.totalRegistrations,
    this.totalRegistrationsGrowth,
    this.totalViews,
    this.totalViewsGrowth,
    this.averageAttendanceRate,
    this.averageAttendanceRateGrowth,
  });

  OrganizationDashboardEntity copyWith({
    int? totalEvents,
    double? totalEventsGrowth,
    int? totalRegistrations,
    double? totalRegistrationsGrowth,
    int? totalViews,
    double? totalViewsGrowth,
    double? averageAttendanceRate,
    double? averageAttendanceRateGrowth,
  }) {
    return OrganizationDashboardEntity(
      totalEvents: totalEvents ?? this.totalEvents,
      totalEventsGrowth: totalEventsGrowth ?? this.totalEventsGrowth,
      totalRegistrations: totalRegistrations ?? this.totalRegistrations,
      totalRegistrationsGrowth: totalRegistrationsGrowth ?? this.totalRegistrationsGrowth,
      totalViews: totalViews ?? this.totalViews,
      totalViewsGrowth: totalViewsGrowth ?? this.totalViewsGrowth,
      averageAttendanceRate: averageAttendanceRate ?? this.averageAttendanceRate,
      averageAttendanceRateGrowth: averageAttendanceRateGrowth ?? this.averageAttendanceRateGrowth,
    );
  }

  @override
  String toString() =>
      'OrganizationDashboardEntity(totalEvents: $totalEvents, totalRegistrations: $totalRegistrations)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrganizationDashboardEntity &&
        other.totalEvents == totalEvents &&
        other.totalRegistrations == totalRegistrations;
  }

  @override
  int get hashCode => Object.hash(totalEvents, totalRegistrations);
}
