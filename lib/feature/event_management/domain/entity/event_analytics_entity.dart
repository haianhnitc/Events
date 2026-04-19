import 'package:events_app/feature/common/domain/entity/category_distribution_entity.dart';
import 'package:events_app/feature/common/domain/entity/gender_distribution_entity.dart';
import 'package:events_app/feature/common/domain/entity/timeline_data_entity.dart';

class EventAnalyticsEntity {
  final int? eventId;
  final String? eventTitle;
  final GenderDistributionEntity? genderDistribution;
  final List<CategoryDistributionEntity>? majorDistribution;
  final List<CategoryDistributionEntity>? schoolDistribution;
  final List<CategoryDistributionEntity>? ageDistribution;
  final List<TimelineDataEntity>? checkInTimeline;
  final DateTime? lastUpdateTime;

  EventAnalyticsEntity({
    this.eventId,
    this.eventTitle,
    this.genderDistribution,
    this.majorDistribution,
    this.schoolDistribution,
    this.ageDistribution,
    this.checkInTimeline,
    this.lastUpdateTime,
  });

  EventAnalyticsEntity copyWith({
    int? eventId,
    String? eventTitle,
    GenderDistributionEntity? genderDistribution,
    List<CategoryDistributionEntity>? majorDistribution,
    List<CategoryDistributionEntity>? schoolDistribution,
    List<CategoryDistributionEntity>? ageDistribution,
    List<TimelineDataEntity>? checkInTimeline,
    DateTime? lastUpdateTime,
  }) {
    return EventAnalyticsEntity(
      eventId: eventId ?? this.eventId,
      eventTitle: eventTitle ?? this.eventTitle,
      genderDistribution: genderDistribution ?? this.genderDistribution,
      majorDistribution: majorDistribution ?? this.majorDistribution,
      schoolDistribution: schoolDistribution ?? this.schoolDistribution,
      ageDistribution: ageDistribution ?? this.ageDistribution,
      checkInTimeline: checkInTimeline ?? this.checkInTimeline,
      lastUpdateTime: lastUpdateTime ?? this.lastUpdateTime,
    );
  }

  @override
  String toString() =>
      'EventAnalyticsEntity(eventId: $eventId, eventTitle: $eventTitle)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventAnalyticsEntity && other.eventId == eventId;
  }

  @override
  int get hashCode => Object.hash(eventId, eventTitle);
}
