import 'package:events_app/feature/common/domain/entity/category_entity.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class CtvRecruitmentSummaryEntity {
  final int? ctvRecruitmentId;
  final int? eventId;
  final List<CategoryEntity>? categories;
  final String? title;
  final String? banner;
  final DateTime? startTime;
  final String? roleName;
  final String? description;
  final String? certificateName;
  final int? cashRewardAmount;
  final int? quantity;
  final bool? isOpen;
  final int? appliedCount;
  final UserEventState? userEventState;
  final DateTime? createdTime;
  final int? youthUnionPoint;

  CtvRecruitmentSummaryEntity({
    this.ctvRecruitmentId,
    this.eventId,
    this.categories,
    this.title,
    this.banner,
    this.startTime,
    this.roleName,
    this.description,
    this.certificateName,
    this.cashRewardAmount,
    this.quantity,
    this.isOpen,
    this.appliedCount,
    this.userEventState,
    this.createdTime,
    this.youthUnionPoint,
  });

  CtvRecruitmentSummaryEntity copyWith({
    int? ctvRecruitmentId,
    int? eventId,
    List<CategoryEntity>? categories,
    String? title,
    String? banner,
    DateTime? startTime,
    String? roleName,
    String? description,
    String? certificateName,
    int? cashRewardAmount,
    int? quantity,
    bool? isOpen,
    int? appliedCount,
    UserEventState? userEventState,
    DateTime? createdTime,
    int? youthUnionPoint,
  }) {
    return CtvRecruitmentSummaryEntity(
      ctvRecruitmentId: ctvRecruitmentId ?? this.ctvRecruitmentId,
      eventId: eventId ?? this.eventId,
      categories: categories ?? this.categories,
      title: title ?? this.title,
      banner: banner ?? this.banner,
      startTime: startTime ?? this.startTime,
      roleName: roleName ?? this.roleName,
      description: description ?? this.description,
      certificateName: certificateName ?? this.certificateName,
      cashRewardAmount: cashRewardAmount ?? this.cashRewardAmount,
      quantity: quantity ?? this.quantity,
      isOpen: isOpen ?? this.isOpen,
      appliedCount: appliedCount ?? this.appliedCount,
      userEventState: userEventState ?? this.userEventState,
      createdTime: createdTime ?? this.createdTime,
      youthUnionPoint: youthUnionPoint ?? this.youthUnionPoint,
    );
  }

  @override
  String toString() =>
      'CtvRecruitmentSummaryEntity(id: $ctvRecruitmentId, title: $title)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CtvRecruitmentSummaryEntity &&
        other.ctvRecruitmentId == ctvRecruitmentId;
  }

  @override
  int get hashCode => Object.hash(ctvRecruitmentId, eventId);
}
