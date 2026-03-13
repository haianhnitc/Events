import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:events_app/feature/common/data/model/category_model.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import '../../domain/entity/event_summary_entity.dart';

part 'event_summary_model.freezed.dart';
part 'event_summary_model.g.dart';

@freezed
class EventSummaryModel with _$EventSummaryModel {
  const factory EventSummaryModel({
    int? eventId,
    String? title,
    String? banner,
    DateTime? startTime,
    DateTime? endTime,
    EventStatus? status,
    int? price,
    List<CategoryModel>? categories,
    int? capacity,
    int? totalParticipants,
  }) = _EventSummaryModel;

  factory EventSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$EventSummaryModelFromJson(json);

  factory EventSummaryModel.fromEntity(EventSummaryEntity entity) {
    return EventSummaryModel(
      eventId: entity.eventId,
      title: entity.title,
      banner: entity.banner,
      startTime: entity.startTime,
      endTime: entity.endTime,
      status: entity.status,
      price: entity.price,
      categories: entity.categories?.map(CategoryModel.fromEntity).toList(),
      capacity: entity.capacity,
      totalParticipants: entity.totalParticipants,
    );
  }
}

extension EventSummaryModelExtension on EventSummaryModel {
  EventSummaryEntity toEntity() {
    return EventSummaryEntity(
      eventId: eventId,
      title: title,
      banner: banner,
      startTime: startTime,
      endTime: endTime,
      status: status,
      price: price,
      categories: categories?.map((category) => category.toEntity()).toList(),
      capacity: capacity,
      totalParticipants: totalParticipants,
    );
  }
}
