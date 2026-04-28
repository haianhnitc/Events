import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/organization_dashboard_entity.dart';

part 'organization_dashboard_model.freezed.dart';
part 'organization_dashboard_model.g.dart';

@freezed
class OrganizationDashboardModel with _$OrganizationDashboardModel {
  const factory OrganizationDashboardModel({
    @Default(0) int? totalEvents,
    double? totalEventsGrowth,
    @Default(0) int? currentPeriodEvents,
    @Default(0) int? previousPeriodEvents,
    @Default(0) int? totalRegistrations,
    double? totalRegistrationsGrowth,
    @Default(0) int? currentPeriodRegistrations,
    @Default(0) int? previousPeriodRegistrations,
    @Default(0) int? totalViews,
    double? totalViewsGrowth,
    @Default(0) int? currentPeriodViews,
    @Default(0) int? previousPeriodViews,
    double? averageAttendanceRate,
    double? averageAttendanceRateGrowth,
    double? currentPeriodAttendanceRate,
    double? previousPeriodAttendanceRate,
  }) = _OrganizationDashboardModel;

  factory OrganizationDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$OrganizationDashboardModelFromJson(json);

  factory OrganizationDashboardModel.fromEntity(OrganizationDashboardEntity entity) {
    return OrganizationDashboardModel(
      totalEvents: entity.totalEvents,
      totalEventsGrowth: entity.totalEventsGrowth,
      currentPeriodEvents: entity.currentPeriodEvents,
      previousPeriodEvents: entity.previousPeriodEvents,
      totalRegistrations: entity.totalRegistrations,
      totalRegistrationsGrowth: entity.totalRegistrationsGrowth,
      currentPeriodRegistrations: entity.currentPeriodRegistrations,
      previousPeriodRegistrations: entity.previousPeriodRegistrations,
      totalViews: entity.totalViews,
      totalViewsGrowth: entity.totalViewsGrowth,
      currentPeriodViews: entity.currentPeriodViews,
      previousPeriodViews: entity.previousPeriodViews,
      averageAttendanceRate: entity.averageAttendanceRate,
      averageAttendanceRateGrowth: entity.averageAttendanceRateGrowth,
      currentPeriodAttendanceRate: entity.currentPeriodAttendanceRate,
      previousPeriodAttendanceRate: entity.previousPeriodAttendanceRate,
    );
  }
}

extension OrganizationDashboardModelExtension on OrganizationDashboardModel {
  OrganizationDashboardEntity toEntity() {
    return OrganizationDashboardEntity(
      totalEvents: totalEvents,
      totalEventsGrowth: totalEventsGrowth,
      currentPeriodEvents: currentPeriodEvents,
      previousPeriodEvents: previousPeriodEvents,
      totalRegistrations: totalRegistrations,
      totalRegistrationsGrowth: totalRegistrationsGrowth,
      currentPeriodRegistrations: currentPeriodRegistrations,
      previousPeriodRegistrations: previousPeriodRegistrations,
      totalViews: totalViews,
      totalViewsGrowth: totalViewsGrowth,
      currentPeriodViews: currentPeriodViews,
      previousPeriodViews: previousPeriodViews,
      averageAttendanceRate: averageAttendanceRate,
      averageAttendanceRateGrowth: averageAttendanceRateGrowth,
      currentPeriodAttendanceRate: currentPeriodAttendanceRate,
      previousPeriodAttendanceRate: previousPeriodAttendanceRate,
    );
  }
}
