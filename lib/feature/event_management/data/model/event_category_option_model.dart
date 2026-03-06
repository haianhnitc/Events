import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/event_category_option_entity.dart';

part 'event_category_option_model.freezed.dart';
part 'event_category_option_model.g.dart';

@freezed
class EventCategoryOptionModel with _$EventCategoryOptionModel {
  const factory EventCategoryOptionModel({
    int? categoryOptionId,
    int? eventId,
  }) = _EventCategoryOptionModel;

  factory EventCategoryOptionModel.fromJson(Map<String, dynamic> json) =>
      _$EventCategoryOptionModelFromJson(json);

  factory EventCategoryOptionModel.fromEntity(
      EventCategoryOptionEntity entity) {
    return EventCategoryOptionModel(
      categoryOptionId: entity.categoryOptionId,
      eventId: entity.eventId,
    );
  }
}

extension EventCategoryOptionModelExtension on EventCategoryOptionModel {
  EventCategoryOptionEntity toEntity() {
    return EventCategoryOptionEntity(
      categoryOptionId: categoryOptionId,
      eventId: eventId,
    );
  }
}
