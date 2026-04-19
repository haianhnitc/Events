import 'package:events_app/feature/common/domain/entity/category_entity.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/venue/domain/entity/venue_entity.dart';
import 'package:events_app/feature/recruitment/domain/entity/requirement_question_entity.dart';

class CtvRecruitmentEntity {
  final int? ctvRecruitmentId;
  final int? eventId;
  final String? eventTitle;
  final String? organizerName;
  final VenueEntity? venue;
  final EventRecruitmentType? recruitmentType;
  final int? rewardCoin;
  final int? youthUnionPoint;
  final int? cashRewardAmount;
  final String? certificateName;
  final String? title;
  final String? banner;
  final String? roleName;
  final String? description;
  final DateTime? startTime;
  final DateTime? registerOpenTime;
  final int? quantity;
  final bool? isOpen;
  final int? appliedCount;
  final int? recruitedCtvCount;
  final UserEventState? userEventState;
  final DateTime? createdTime;
  final List<CategoryEntity>? categories;
  final List<RequirementQuestionEntity>? requirementQuestions;

  CtvRecruitmentEntity({
    this.ctvRecruitmentId,
    this.eventId,
    this.eventTitle,
    this.organizerName,
    this.venue,
    this.recruitmentType,
    this.rewardCoin,
    this.youthUnionPoint,
    this.cashRewardAmount,
    this.certificateName,
    this.title,
    this.banner,
    this.roleName,
    this.description,
    this.startTime,
    this.registerOpenTime,
    this.quantity,
    this.isOpen,
    this.appliedCount,
    this.recruitedCtvCount,
    this.userEventState,
    this.createdTime,
    this.categories,
    this.requirementQuestions,
  });

  CtvRecruitmentEntity copyWith({
    int? ctvRecruitmentId,
    int? eventId,
    String? eventTitle,
    String? organizerName,
    VenueEntity? venue,
    EventRecruitmentType? recruitmentType,
    int? rewardCoin,
    int? youthUnionPoint,
    int? cashRewardAmount,
    String? certificateName,
    String? title,
    String? banner,
    String? roleName,
    String? description,
    DateTime? startTime,
    DateTime? registerOpenTime,
    int? quantity,
    bool? isOpen,
    int? appliedCount,
    int? recruitedCtvCount,
    UserEventState? userEventState,
    DateTime? createdTime,
    List<CategoryEntity>? categories,
    List<RequirementQuestionEntity>? requirementQuestions,
  }) {
    return CtvRecruitmentEntity(
      ctvRecruitmentId: ctvRecruitmentId ?? this.ctvRecruitmentId,
      eventId: eventId ?? this.eventId,
      eventTitle: eventTitle ?? this.eventTitle,
      organizerName: organizerName ?? this.organizerName,
      venue: venue ?? this.venue,
      recruitmentType: recruitmentType ?? this.recruitmentType,
      rewardCoin: rewardCoin ?? this.rewardCoin,
      youthUnionPoint: youthUnionPoint ?? this.youthUnionPoint,
      cashRewardAmount: cashRewardAmount ?? this.cashRewardAmount,
      certificateName: certificateName ?? this.certificateName,
      title: title ?? this.title,
      banner: banner ?? this.banner,
      roleName: roleName ?? this.roleName,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      registerOpenTime: registerOpenTime ?? this.registerOpenTime,
      quantity: quantity ?? this.quantity,
      isOpen: isOpen ?? this.isOpen,
      appliedCount: appliedCount ?? this.appliedCount,
      recruitedCtvCount: recruitedCtvCount ?? this.recruitedCtvCount,
      userEventState: userEventState ?? this.userEventState,
      createdTime: createdTime ?? this.createdTime,
      categories: categories ?? this.categories,
      requirementQuestions: requirementQuestions ?? this.requirementQuestions,
    );
  }

  @override
  String toString() =>
      'CtvRecruitmentEntity(id: $ctvRecruitmentId, title: $title, isOpen: $isOpen)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CtvRecruitmentEntity &&
        other.ctvRecruitmentId == ctvRecruitmentId;
  }

  @override
  int get hashCode => Object.hash(ctvRecruitmentId, title);
}