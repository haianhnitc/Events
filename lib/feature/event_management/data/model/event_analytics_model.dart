import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/event_analytics_entity.dart';
import 'package:events_app/feature/common/data/model/gender_distribution_model.dart';
import 'package:events_app/feature/common/data/model/category_distribution_model.dart';
import 'package:events_app/feature/common/data/model/timeline_data_model.dart';

part 'event_analytics_model.freezed.dart';
part 'event_analytics_model.g.dart';

@freezed
class EventAnalyticsModel with _$EventAnalyticsModel {
  const factory EventAnalyticsModel({
    int? eventId,
    String? eventTitle,
    GenderDistributionModel? genderDistribution,
    List<CategoryDistributionModel>? majorDistribution,
    List<CategoryDistributionModel>? schoolDistribution,
    List<CategoryDistributionModel>? ageDistribution,
    List<TimelineDataModel>? checkInTimeline,
    DateTime? lastUpdateTime,
  }) = _EventAnalyticsModel;

  factory EventAnalyticsModel.fromJson(Map<String, dynamic> json) =>
      _$EventAnalyticsModelFromJson(json);

  factory EventAnalyticsModel.fromEntity(EventAnalyticsEntity entity) {
    return EventAnalyticsModel(
      eventId: entity.eventId,
      eventTitle: entity.eventTitle,
      genderDistribution: entity.genderDistribution != null
          ? GenderDistributionModel.fromEntity(entity.genderDistribution!)
          : null,
      majorDistribution: entity.majorDistribution
          ?.map((e) => CategoryDistributionModel.fromEntity(e))
          .toList(),
      schoolDistribution: entity.schoolDistribution
          ?.map((e) => CategoryDistributionModel.fromEntity(e))
          .toList(),
      ageDistribution: entity.ageDistribution
          ?.map((e) => CategoryDistributionModel.fromEntity(e))
          .toList(),
      checkInTimeline: entity.checkInTimeline
          ?.map((e) => TimelineDataModel.fromEntity(e))
          .toList(),
      lastUpdateTime: entity.lastUpdateTime,
    );
  }
}

extension EventAnalyticsModelExtension on EventAnalyticsModel {
  EventAnalyticsEntity toEntity() {
    return EventAnalyticsEntity(
      eventId: eventId,
      eventTitle: eventTitle,
      genderDistribution: genderDistribution?.toEntity(),
      majorDistribution:
          majorDistribution?.map((e) => e.toEntity()).toList(),
      schoolDistribution:
          schoolDistribution?.map((e) => e.toEntity()).toList(),
      ageDistribution:
          ageDistribution?.map((e) => e.toEntity()).toList(),
      checkInTimeline:
          checkInTimeline?.map((e) => e.toEntity()).toList(),
      lastUpdateTime: lastUpdateTime,
    );
  }
}
