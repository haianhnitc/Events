import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class EventRoleConfigEntity {
  final int? eventRoleConfigId;
  final int? eventId;
  final EventRoleType? roleType;
  final int? coinReward;

  EventRoleConfigEntity({
    this.eventRoleConfigId,
    this.eventId,
    this.roleType,
    this.coinReward,
  });
}
