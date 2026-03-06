import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/event_statistic_entity.dart';

part 'event_statistic_model.freezed.dart';
part 'event_statistic_model.g.dart';

@freezed
class EventStatisticModel with _$EventStatisticModel {
  const factory EventStatisticModel({
    int? eventId,
    @Default(0) int? totalRegistered,
    @Default(0) int? totalAttended,
    @Default(0) int? totalNoShow,
    @Default(0) int? totalRevenue,
    double? avgRating,
    DateTime? updatedTime,
  }) = _EventStatisticModel;

  factory EventStatisticModel.fromJson(Map<String, dynamic> json) =>
      _$EventStatisticModelFromJson(json);

  factory EventStatisticModel.fromEntity(EventStatisticEntity entity) {
    return EventStatisticModel(
      eventId: entity.eventId,
      totalRegistered: entity.totalRegistered,
      totalAttended: entity.totalAttended,
      totalNoShow: entity.totalNoShow,
      totalRevenue: entity.totalRevenue,
      avgRating: entity.avgRating,
      updatedTime: entity.updatedTime,
    );
  }
}

extension EventStatisticModelExtension on EventStatisticModel {
  EventStatisticEntity toEntity() {
    return EventStatisticEntity(
      eventId: eventId,
      totalRegistered: totalRegistered,
      totalAttended: totalAttended,
      totalNoShow: totalNoShow,
      totalRevenue: totalRevenue,
      avgRating: avgRating,
      updatedTime: updatedTime,
    );
  }
}
