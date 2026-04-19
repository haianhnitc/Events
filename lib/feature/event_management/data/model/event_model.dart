import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/data/model/category_model.dart';
import 'package:events_app/feature/venue/data/model/venue_model.dart';
import '../../domain/entity/event_entity.dart';

part 'event_model.freezed.dart';
part 'event_model.g.dart';

@freezed
class EventModel with _$EventModel {
  const factory EventModel({
    int? eventId,
    String? organizerName,
    VenueModel? venue,
    String? title,
    String? description,
    String? banner,
    @Default(EventStatus.draft) EventStatus? status,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? registerOpenTime,
    int? price,
    List<CategoryModel>? categories,
    int? rewardCoin,
    int? youthUnionPoint,
    String? certificateName,
    DateTime? createdTime,
    int? totalParticipants,
    UserEventState? userEventState,
    EventRecruitmentType? recruitmentType,
  }) = _EventModel;

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  factory EventModel.fromEntity(EventEntity entity) {
    return EventModel(
      eventId: entity.eventId,
      organizerName: entity.organizerName,
      venue: entity.venue != null ? VenueModel.fromEntity(entity.venue!) : null,
      title: entity.title,
      description: entity.description,
      banner: entity.banner,
      status: entity.status,
      startTime: entity.startTime,
      endTime: entity.endTime,
      registerOpenTime: entity.registerOpenTime,
      price: entity.price,
      categories: entity.categories?.map(CategoryModel.fromEntity).toList(),
      rewardCoin: entity.rewardCoin,
      youthUnionPoint: entity.youthUnionPoint,
      certificateName: entity.certificateName,
      createdTime: entity.createdTime,
      totalParticipants: entity.totalParticipants,
      userEventState: entity.userEventState,
      recruitmentType: entity.recruitmentType,
    );
  }
}

extension EventModelExtension on EventModel {
  EventEntity toEntity() {
    return EventEntity(
      eventId: eventId,
      organizerName: organizerName,
      venue: venue?.toEntity(),
      title: title,
      description: description,
      banner: banner,
      status: status,
      startTime: startTime,
      endTime: endTime,
      registerOpenTime: registerOpenTime,
      price: price,
      categories: categories?.map((category) => category.toEntity()).toList(),
      rewardCoin: rewardCoin,
      youthUnionPoint: youthUnionPoint,
      certificateName: certificateName,
      createdTime: createdTime,
      totalParticipants: totalParticipants,
      userEventState: userEventState,
      recruitmentType: recruitmentType,
    );
  }
}
