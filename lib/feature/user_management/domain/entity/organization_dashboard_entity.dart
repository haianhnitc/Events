class OrganizationDashboardEntity {
  final int? totalEvents;
  final double? totalEventsGrowth;
  final int? currentPeriodEvents;
  final int? previousPeriodEvents;
  final int? totalRegistrations;
  final double? totalRegistrationsGrowth;
  final int? currentPeriodRegistrations;
  final int? previousPeriodRegistrations;
  final int? totalViews;
  final double? totalViewsGrowth;
  final int? currentPeriodViews;
  final int? previousPeriodViews;
  final double? averageAttendanceRate;
  final double? averageAttendanceRateGrowth;
  final double? currentPeriodAttendanceRate;
  final double? previousPeriodAttendanceRate;

  OrganizationDashboardEntity({
    this.totalEvents,
    this.totalEventsGrowth,
    this.currentPeriodEvents,
    this.previousPeriodEvents,
    this.totalRegistrations,
    this.totalRegistrationsGrowth,
    this.currentPeriodRegistrations,
    this.previousPeriodRegistrations,
    this.totalViews,
    this.totalViewsGrowth,
    this.currentPeriodViews,
    this.previousPeriodViews,
    this.averageAttendanceRate,
    this.averageAttendanceRateGrowth,
    this.currentPeriodAttendanceRate,
    this.previousPeriodAttendanceRate,
  });

  OrganizationDashboardEntity copyWith({
    int? totalEvents,
    double? totalEventsGrowth,
    int? currentPeriodEvents,
    int? previousPeriodEvents,
    int? totalRegistrations,
    double? totalRegistrationsGrowth,
    int? currentPeriodRegistrations,
    int? previousPeriodRegistrations,
    int? totalViews,
    double? totalViewsGrowth,
    int? currentPeriodViews,
    int? previousPeriodViews,
    double? averageAttendanceRate,
    double? averageAttendanceRateGrowth,
    double? currentPeriodAttendanceRate,
    double? previousPeriodAttendanceRate,
  }) {
    return OrganizationDashboardEntity(
      totalEvents: totalEvents ?? this.totalEvents,
      totalEventsGrowth: totalEventsGrowth ?? this.totalEventsGrowth,
      currentPeriodEvents: currentPeriodEvents ?? this.currentPeriodEvents,
      previousPeriodEvents: previousPeriodEvents ?? this.previousPeriodEvents,
      totalRegistrations: totalRegistrations ?? this.totalRegistrations,
      totalRegistrationsGrowth:
          totalRegistrationsGrowth ?? this.totalRegistrationsGrowth,
      currentPeriodRegistrations:
          currentPeriodRegistrations ?? this.currentPeriodRegistrations,
      previousPeriodRegistrations:
          previousPeriodRegistrations ?? this.previousPeriodRegistrations,
      totalViews: totalViews ?? this.totalViews,
      totalViewsGrowth: totalViewsGrowth ?? this.totalViewsGrowth,
      currentPeriodViews: currentPeriodViews ?? this.currentPeriodViews,
      previousPeriodViews: previousPeriodViews ?? this.previousPeriodViews,
      averageAttendanceRate:
          averageAttendanceRate ?? this.averageAttendanceRate,
      averageAttendanceRateGrowth:
          averageAttendanceRateGrowth ?? this.averageAttendanceRateGrowth,
      currentPeriodAttendanceRate:
          currentPeriodAttendanceRate ?? this.currentPeriodAttendanceRate,
      previousPeriodAttendanceRate:
          previousPeriodAttendanceRate ?? this.previousPeriodAttendanceRate,
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
