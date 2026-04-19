import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:events_app/feature/common/data/model/category_model.dart';
import 'package:events_app/feature/recruitment/data/model/question_option_model.dart';
import 'package:events_app/feature/recruitment/data/model/requirement_question_model.dart';
import 'package:events_app/feature/recruitment/domain/entity/ctv_recruitment_entity.dart';
import 'package:events_app/feature/venue/data/model/venue_model.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';

part 'ctv_recruitment_model.freezed.dart';
part 'ctv_recruitment_model.g.dart';

@freezed
class CtvRecruitmentModel with _$CtvRecruitmentModel {
  const factory CtvRecruitmentModel({
    int? ctvRecruitmentId,
    int? eventId,
    String? eventTitle,
    String? organizerName,
    VenueModel? venue,
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
    List<CategoryModel?>? categories,
    List<RequirementQuestionModel>? requirementQuestions,
  }) = _CtvRecruitmentModel;

  factory CtvRecruitmentModel.fromJson(Map<String, dynamic> json) =>
      _$CtvRecruitmentModelFromJson(json);

  factory CtvRecruitmentModel.fromEntity(CtvRecruitmentEntity entity) {
    return CtvRecruitmentModel(
      ctvRecruitmentId: entity.ctvRecruitmentId,
      eventId: entity.eventId,
      eventTitle: entity.eventTitle,
      organizerName: entity.organizerName,
      venue: entity.venue != null ? VenueModel.fromEntity(entity.venue!) : null,
      recruitmentType: entity.recruitmentType,
      rewardCoin: entity.rewardCoin,
      youthUnionPoint: entity.youthUnionPoint,
      cashRewardAmount: entity.cashRewardAmount,
      certificateName: entity.certificateName,
      title: entity.title,
      banner: entity.banner,
      roleName: entity.roleName,
      description: entity.description,
      startTime: entity.startTime,
      registerOpenTime: entity.registerOpenTime,
      quantity: entity.quantity,
      isOpen: entity.isOpen,
      appliedCount: entity.appliedCount,
      recruitedCtvCount: entity.recruitedCtvCount,
      userEventState: entity.userEventState,
      createdTime: entity.createdTime,
      categories: entity.categories?.map((c) => CategoryModel.fromEntity(c)).toList(),
      requirementQuestions: entity.requirementQuestions?.map((q) =>
        RequirementQuestionModel(
          questionId: q.questionId,
          ctvRecruitmentId: q.ctvRecruitmentId,
          questionText: q.questionText,
          questionType: q.questionType,
          isRequired: q.isRequired,
          options: q.options?.map((o) => QuestionOptionModel(
            optionId: o.optionId,
            questionId: o.questionId,
            optionValue: o.optionValue,
          )).toList(),
        )
      ).toList(),
    );
  }
}

extension CtvRecruitmentModelExtension on CtvRecruitmentModel {
  CtvRecruitmentEntity toEntity() {
    return CtvRecruitmentEntity(
      ctvRecruitmentId: ctvRecruitmentId,
      eventId: eventId,
      eventTitle: eventTitle,
      organizerName: organizerName,
      venue: venue?.toEntity(),
      recruitmentType: recruitmentType,
      rewardCoin: rewardCoin,
      youthUnionPoint: youthUnionPoint,
      cashRewardAmount: cashRewardAmount,
      certificateName: certificateName,
      title: title,
      banner: banner,
      roleName: roleName,
      description: description,
      startTime: startTime,
      registerOpenTime: registerOpenTime,
      quantity: quantity,
      isOpen: isOpen,
      appliedCount: appliedCount,
      recruitedCtvCount: recruitedCtvCount,
      userEventState: userEventState,
      createdTime: createdTime,
      categories: categories?.map((c) => c?.toEntity()).toList().cast(),
      requirementQuestions: requirementQuestions?.map((q) => q.toEntity()).toList(),
    );
  }
}
