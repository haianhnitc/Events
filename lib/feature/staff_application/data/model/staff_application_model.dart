import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:events_app/feature/staff_application/domain/entity/staff_application_entity.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/user_management/data/model/user_summary_model.dart';

part 'staff_application_model.freezed.dart';
part 'staff_application_model.g.dart';

@freezed
class StaffApplicationModel with _$StaffApplicationModel {
  const factory StaffApplicationModel({
    int? applicationId,
    UserSummaryModel? applicant,
    int? eventId,
    String? eventTitle,
    String? roleName,
    String? cvUrl,
    StaffApplicationStatus? status,
    String? rejectionReason,
    DateTime? appliedTime,
    DateTime? reviewedTime,
    List<ApplicationAnswerModel>? applicationAnswers,
  }) = _StaffApplicationModel;

  factory StaffApplicationModel.fromJson(Map<String, dynamic> json) =>
      _$StaffApplicationModelFromJson(json);

  factory StaffApplicationModel.fromEntity(StaffApplicationEntity entity) {
    return StaffApplicationModel(
      applicationId: entity.applicationId,
      applicant: entity.applicant != null
          ? UserSummaryModel.fromEntity(entity.applicant!)
          : null,
      eventId: entity.eventId,
      eventTitle: entity.eventTitle,
      roleName: entity.roleName,
      cvUrl: entity.cvUrl,
      status: entity.status,
      rejectionReason: entity.rejectionReason,
      appliedTime: entity.appliedTime,
      reviewedTime: entity.reviewedTime,
      applicationAnswers: entity.applicationAnswers
          ?.map((e) => ApplicationAnswerModel.fromEntity(e))
          .toList(),
    );
  }
}

@freezed
class ApplicationAnswerModel with _$ApplicationAnswerModel {
  const factory ApplicationAnswerModel({
    int? id,
    int? eventStaffApplicationId,
    int? questionId,
    String? questionText,
    RequirementQuestionType? questionType,
    String? answerValue,
    List<int>? selectedOptionIds,
  }) = _ApplicationAnswerModel;

  factory ApplicationAnswerModel.fromJson(Map<String, dynamic> json) =>
      _$ApplicationAnswerModelFromJson(json);

  factory ApplicationAnswerModel.fromEntity(ApplicationAnswerEntity entity) {
    return ApplicationAnswerModel(
      id: entity.id,
      eventStaffApplicationId: entity.eventStaffApplicationId,
      questionId: entity.questionId,
      questionText: entity.questionText,
      questionType: entity.questionType,
      answerValue: entity.answerValue,
      selectedOptionIds: entity.selectedOptionIds,
    );
  }
}

extension StaffApplicationModelExtension on StaffApplicationModel {
  StaffApplicationEntity toEntity() {
    return StaffApplicationEntity(
      applicationId: applicationId,
      applicant: applicant?.toEntity(),
      eventId: eventId,
      eventTitle: eventTitle,
      roleName: roleName,
      cvUrl: cvUrl,
      status: status,
      rejectionReason: rejectionReason,
      appliedTime: appliedTime,
      reviewedTime: reviewedTime,
      applicationAnswers:
          applicationAnswers?.map((e) => e.toEntity()).toList(),
    );
  }
}

extension ApplicationAnswerModelExtension on ApplicationAnswerModel {
  ApplicationAnswerEntity toEntity() {
    return ApplicationAnswerEntity(
      id: id,
      eventStaffApplicationId: eventStaffApplicationId,
      questionId: questionId,
      questionText: questionText,
      questionType: questionType,
      answerValue: answerValue,
      selectedOptionIds: selectedOptionIds,
    );
  }
}