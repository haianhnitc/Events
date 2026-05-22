// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrganizationDashboardModelImpl _$$OrganizationDashboardModelImplFromJson(
        Map<String, dynamic> json) =>
    _$OrganizationDashboardModelImpl(
      totalEvents: (json['totalEvents'] as num?)?.toInt() ?? 0,
      totalEventsGrowth: (json['totalEventsGrowth'] as num?)?.toDouble(),
      currentPeriodEvents: (json['currentPeriodEvents'] as num?)?.toInt() ?? 0,
      previousPeriodEvents:
          (json['previousPeriodEvents'] as num?)?.toInt() ?? 0,
      totalRegistrations: (json['totalRegistrations'] as num?)?.toInt() ?? 0,
      totalRegistrationsGrowth:
          (json['totalRegistrationsGrowth'] as num?)?.toDouble(),
      currentPeriodRegistrations:
          (json['currentPeriodRegistrations'] as num?)?.toInt() ?? 0,
      previousPeriodRegistrations:
          (json['previousPeriodRegistrations'] as num?)?.toInt() ?? 0,
      totalViews: (json['totalViews'] as num?)?.toInt() ?? 0,
      totalViewsGrowth: (json['totalViewsGrowth'] as num?)?.toDouble(),
      currentPeriodViews: (json['currentPeriodViews'] as num?)?.toInt() ?? 0,
      previousPeriodViews: (json['previousPeriodViews'] as num?)?.toInt() ?? 0,
      averageAttendanceRate:
          (json['averageAttendanceRate'] as num?)?.toDouble(),
      averageAttendanceRateGrowth:
          (json['averageAttendanceRateGrowth'] as num?)?.toDouble(),
      currentPeriodAttendanceRate:
          (json['currentPeriodAttendanceRate'] as num?)?.toDouble(),
      previousPeriodAttendanceRate:
          (json['previousPeriodAttendanceRate'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$OrganizationDashboardModelImplToJson(
        _$OrganizationDashboardModelImpl instance) =>
    <String, dynamic>{
      'totalEvents': instance.totalEvents,
      'totalEventsGrowth': instance.totalEventsGrowth,
      'currentPeriodEvents': instance.currentPeriodEvents,
      'previousPeriodEvents': instance.previousPeriodEvents,
      'totalRegistrations': instance.totalRegistrations,
      'totalRegistrationsGrowth': instance.totalRegistrationsGrowth,
      'currentPeriodRegistrations': instance.currentPeriodRegistrations,
      'previousPeriodRegistrations': instance.previousPeriodRegistrations,
      'totalViews': instance.totalViews,
      'totalViewsGrowth': instance.totalViewsGrowth,
      'currentPeriodViews': instance.currentPeriodViews,
      'previousPeriodViews': instance.previousPeriodViews,
      'averageAttendanceRate': instance.averageAttendanceRate,
      'averageAttendanceRateGrowth': instance.averageAttendanceRateGrowth,
      'currentPeriodAttendanceRate': instance.currentPeriodAttendanceRate,
      'previousPeriodAttendanceRate': instance.previousPeriodAttendanceRate,
    };
