import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/user_management/domain/entity/user_summary_entity.dart';

class StaffApplicationEntity {
  final int? applicationId;
  final UserSummaryEntity? applicant;
  final int? eventId;
  final String? eventTitle;
  final String? roleName;
  final String? cvUrl;
  final StaffApplicationStatus? status;
  final String? rejectionReason;
  final DateTime? appliedTime;
  final DateTime? reviewedTime;
  final List<ApplicationAnswerEntity>? applicationAnswers;

  StaffApplicationEntity({
    this.applicationId,
    this.applicant,
    this.eventId,
    this.eventTitle,
    this.roleName,
    this.cvUrl,
    this.status,
    this.rejectionReason,
    this.appliedTime,
    this.reviewedTime,
    this.applicationAnswers,
  });

  StaffApplicationEntity copyWith({
    int? applicationId,
    UserSummaryEntity? applicant,
    int? eventId,
    String? eventTitle,
    String? roleName,
    String? cvUrl,
    StaffApplicationStatus? status,
    String? rejectionReason,
    DateTime? appliedTime,
    DateTime? reviewedTime,
    List<ApplicationAnswerEntity>? applicationAnswers,
  }) {
    return StaffApplicationEntity(
      applicationId: applicationId ?? this.applicationId,
      applicant: applicant ?? this.applicant,
      eventId: eventId ?? this.eventId,
      eventTitle: eventTitle ?? this.eventTitle,
      roleName: roleName ?? this.roleName,
      cvUrl: cvUrl ?? this.cvUrl,
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      appliedTime: appliedTime ?? this.appliedTime,
      reviewedTime: reviewedTime ?? this.reviewedTime,
      applicationAnswers: applicationAnswers ?? this.applicationAnswers,
    );
  }

  int? get applicantUserId => applicant?.userId;
  String? get applicantFullName => applicant?.fullName;
  String? get applicantAvatar => applicant?.avatarUrl;

  @override
  String toString() =>
      'StaffApplicationEntity(id: $applicationId, status: $status)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StaffApplicationEntity &&
        other.applicationId == applicationId;
  }

  @override
  int get hashCode => Object.hash(applicationId, eventId);
}

class ApplicationAnswerEntity {
  final int? id;
  final int? eventStaffApplicationId;
  final int? questionId;
  final String? questionText;
  final RequirementQuestionType? questionType;
  final String? answerValue;
  final List<int>? selectedOptionIds;

  ApplicationAnswerEntity({
    this.id,
    this.eventStaffApplicationId,
    this.questionId,
    this.questionText,
    this.questionType,
    this.answerValue,
    this.selectedOptionIds,
  });

  ApplicationAnswerEntity copyWith({
    int? id,
    int? eventStaffApplicationId,
    int? questionId,
    String? questionText,
    RequirementQuestionType? questionType,
    String? answerValue,
    List<int>? selectedOptionIds,
  }) {
    return ApplicationAnswerEntity(
      id: id ?? this.id,
      eventStaffApplicationId: eventStaffApplicationId ?? this.eventStaffApplicationId,
      questionId: questionId ?? this.questionId,
      questionText: questionText ?? this.questionText,
      questionType: questionType ?? this.questionType,
      answerValue: answerValue ?? this.answerValue,
      selectedOptionIds: selectedOptionIds ?? this.selectedOptionIds,
    );
  }
}