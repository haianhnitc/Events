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
    DateTime? registerOpenTime,
    EventStatus? status,
    int? price,
    String? certificateName,
    List<CategoryModel>? categories,
    int? capacity,
    int? totalParticipants,
    UserEventState? userEventState,
    int? youthUnionPoint,
    EventRecruitmentType? recruitmentType,
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
      registerOpenTime: entity.registerOpenTime,
      status: entity.status,
      price: entity.price,
      certificateName: entity.certificateName,
      categories: entity.categories?.map(CategoryModel.fromEntity).toList(),
      capacity: entity.capacity,
      totalParticipants: entity.totalParticipants,
      userEventState: entity.userEventState,
      youthUnionPoint: entity.youthUnionPoint,
      recruitmentType: entity.recruitmentType,
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
      registerOpenTime: registerOpenTime,
      status: status,
      price: price,
      certificateName: certificateName,
      categories: categories?.map((category) => category.toEntity()).toList(),
      capacity: capacity,
      totalParticipants: totalParticipants,
      userEventState: userEventState,
      youthUnionPoint: youthUnionPoint,
      recruitmentType: recruitmentType,
    );
  }
}
