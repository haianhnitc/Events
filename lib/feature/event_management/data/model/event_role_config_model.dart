import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import '../../domain/entity/event_role_config_entity.dart';

part 'event_role_config_model.freezed.dart';
part 'event_role_config_model.g.dart';

@freezed
class EventRoleConfigModel with _$EventRoleConfigModel {
  const factory EventRoleConfigModel({
    int? eventRoleConfigId,
    int? eventId,
    EventRoleType? roleType,
    @Default(0) int? coinReward,
  }) = _EventRoleConfigModel;

  factory EventRoleConfigModel.fromJson(Map<String, dynamic> json) =>
      _$EventRoleConfigModelFromJson(json);

  factory EventRoleConfigModel.fromEntity(EventRoleConfigEntity entity) {
    return EventRoleConfigModel(
      eventRoleConfigId: entity.eventRoleConfigId,
      eventId: entity.eventId,
      roleType: entity.roleType,
      coinReward: entity.coinReward,
    );
  }
}

extension EventRoleConfigModelExtension on EventRoleConfigModel {
  EventRoleConfigEntity toEntity() {
    return EventRoleConfigEntity(
      eventRoleConfigId: eventRoleConfigId,
      eventId: eventId,
      roleType: roleType,
      coinReward: coinReward,
    );
  }
}
