import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:events_app/feature/common/data/model/category_model.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/recruitment/domain/entity/ctv_recruitment_summary_entity.dart';

part 'ctv_recruitment_summary_model.freezed.dart';
part 'ctv_recruitment_summary_model.g.dart';

@freezed
class CtvRecruitmentSummaryModel with _$CtvRecruitmentSummaryModel {
  const factory CtvRecruitmentSummaryModel({
    int? ctvRecruitmentId,
    int? eventId,
    List<CategoryModel>? categories,
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
  }) = _CtvRecruitmentSummaryModel;

  factory CtvRecruitmentSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$CtvRecruitmentSummaryModelFromJson(json);

  factory CtvRecruitmentSummaryModel.fromEntity(
    CtvRecruitmentSummaryEntity entity,
  ) {
    return CtvRecruitmentSummaryModel(
      ctvRecruitmentId: entity.ctvRecruitmentId,
      eventId: entity.eventId,
      categories: entity.categories?.map(CategoryModel.fromEntity).toList(),
      title: entity.title,
      banner: entity.banner,
      startTime: entity.startTime,
      roleName: entity.roleName,
      description: entity.description,
      certificateName: entity.certificateName,
      cashRewardAmount: entity.cashRewardAmount,
      quantity: entity.quantity,
      isOpen: entity.isOpen,
      appliedCount: entity.appliedCount,
      userEventState: entity.userEventState,
      createdTime: entity.createdTime,
      youthUnionPoint: entity.youthUnionPoint,
    );
  }
}

extension CtvRecruitmentSummaryModelExtension on CtvRecruitmentSummaryModel {
  CtvRecruitmentSummaryEntity toEntity() {
    return CtvRecruitmentSummaryEntity(
      ctvRecruitmentId: ctvRecruitmentId,
      eventId: eventId,
      categories: categories?.map((category) => category.toEntity()).toList(),
      title: title,
      banner: banner,
      startTime: startTime,
      roleName: roleName,
      description: description,
      certificateName: certificateName,
      cashRewardAmount: cashRewardAmount,
      quantity: quantity,
      isOpen: isOpen,
      appliedCount: appliedCount,
      userEventState: userEventState,
      createdTime: createdTime,
      youthUnionPoint: youthUnionPoint,
    );
  }
}
