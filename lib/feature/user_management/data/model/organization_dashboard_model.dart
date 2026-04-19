import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/organization_dashboard_entity.dart';

part 'organization_dashboard_model.freezed.dart';
part 'organization_dashboard_model.g.dart';

@freezed
class OrganizationDashboardModel with _$OrganizationDashboardModel {
  const factory OrganizationDashboardModel({
    @Default(0) int? totalEvents,
    double? totalEventsGrowth,
    @Default(0) int? totalRegistrations,
    double? totalRegistrationsGrowth,
    @Default(0) int? totalViews,
    double? totalViewsGrowth,
    double? averageAttendanceRate,
    double? averageAttendanceRateGrowth,
  }) = _OrganizationDashboardModel;

  factory OrganizationDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$OrganizationDashboardModelFromJson(json);

  factory OrganizationDashboardModel.fromEntity(OrganizationDashboardEntity entity) {
    return OrganizationDashboardModel(
      totalEvents: entity.totalEvents,
      totalEventsGrowth: entity.totalEventsGrowth,
      totalRegistrations: entity.totalRegistrations,
      totalRegistrationsGrowth: entity.totalRegistrationsGrowth,
      totalViews: entity.totalViews,
      totalViewsGrowth: entity.totalViewsGrowth,
      averageAttendanceRate: entity.averageAttendanceRate,
      averageAttendanceRateGrowth: entity.averageAttendanceRateGrowth,
    );
  }
}

extension OrganizationDashboardModelExtension on OrganizationDashboardModel {
  OrganizationDashboardEntity toEntity() {
    return OrganizationDashboardEntity(
      totalEvents: totalEvents,
      totalEventsGrowth: totalEventsGrowth,
      totalRegistrations: totalRegistrations,
      totalRegistrationsGrowth: totalRegistrationsGrowth,
      totalViews: totalViews,
      totalViewsGrowth: totalViewsGrowth,
      averageAttendanceRate: averageAttendanceRate,
      averageAttendanceRateGrowth: averageAttendanceRateGrowth,
    );
  }
}
