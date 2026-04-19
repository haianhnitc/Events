import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class RequirementQuestionCreateParams {
  final String questionText;
  final RequirementQuestionType questionType;
  final bool isRequired;
  final List<QuestionOptionCreateParams>? options;

  const RequirementQuestionCreateParams({
    required this.questionText,
    required this.questionType,
    this.isRequired = false,
    this.options,
  });

  Map<String, dynamic> toJson() => {
        'questionText': questionText,
        'questionType': questionType.apiValue,
        'isRequired': isRequired,
        if (options != null && options!.isNotEmpty)
          'options': options!.map((e) => e.toJson()).toList(),
      };
}

class QuestionOptionCreateParams {
  final String optionValue;

  const QuestionOptionCreateParams({required this.optionValue});

  Map<String, dynamic> toJson() => {'optionValue': optionValue};
}

class CreateRecruitmentParams {
  final int eventId;
  final String? title;
  final int? bannerFileId;
  final String? roleName;
  final String? description;
  final DateTime? startTime;
  final int? quantity;
  final int? rewardCoin;
  final int? youthUnionPoint;
  final int? cashRewardAmount;
  final String? certificateName;
  final bool? isOpen;
  final List<int>? categoryOptionIds;
  final List<RequirementQuestionCreateParams>? requirementQuestions;

  const CreateRecruitmentParams({
    required this.eventId,
    this.title,
    this.bannerFileId,
    this.roleName,
    this.description,
    this.startTime,
    this.quantity,
    this.rewardCoin,
    this.youthUnionPoint,
    this.cashRewardAmount,
    this.certificateName,
    this.isOpen,
    this.categoryOptionIds,
    this.requirementQuestions,
  });

  Map<String, dynamic> toJson() => {
        'eventId': eventId,
        if (title != null) 'title': title,
        if (bannerFileId != null) 'bannerFileId': bannerFileId,
        if (roleName != null) 'roleName': roleName,
        if (description != null) 'description': description,
        if (startTime != null) 'startTime': startTime!.toIso8601String(),
        if (quantity != null) 'quantity': quantity,
        if (rewardCoin != null) 'rewardCoin': rewardCoin,
        if (youthUnionPoint != null) 'youthUnionPoint': youthUnionPoint,
        if (cashRewardAmount != null) 'cashRewardAmount': cashRewardAmount,
        if (certificateName != null) 'certificateName': certificateName,
        if (isOpen != null) 'isOpen': isOpen,
        if (categoryOptionIds != null && categoryOptionIds!.isNotEmpty)
          'categoryOptionIds': categoryOptionIds,
        if (requirementQuestions != null && requirementQuestions!.isNotEmpty)
          'requirementQuestions': requirementQuestions!.map((e) => e.toJson()).toList(),
      };
}

class GetOrganizerRecruitmentsParams {
  final int? eventId;
  final String? keyword;
  final int page;
  final int size;
  const GetOrganizerRecruitmentsParams({this.eventId, this.keyword, this.page = 0, this.size = 20});
}

class UpdateRecruitmentParams {
  final String? title;
  final int? bannerFileId;
  final String? roleName;
  final String? description;
  final DateTime? startTime;
  final int? quantity;
  final int? rewardCoin;
  final int? youthUnionPoint;
  final int? cashRewardAmount;
  final String? certificateName;
  final bool? isOpen;
  final List<int>? categoryOptionIds;
  final List<RequirementQuestionCreateParams>? requirementQuestions;

  const UpdateRecruitmentParams({
    this.title,
    this.bannerFileId,
    this.roleName,
    this.description,
    this.startTime,
    this.quantity,
    this.rewardCoin,
    this.youthUnionPoint,
    this.cashRewardAmount,
    this.certificateName,
    this.isOpen,
    this.categoryOptionIds,
    this.requirementQuestions,
  });

  Map<String, dynamic> toJson() => {
        if (title != null) 'title': title,
        if (bannerFileId != null) 'bannerFileId': bannerFileId,
        if (roleName != null) 'roleName': roleName,
        if (description != null) 'description': description,
        if (startTime != null) 'startTime': startTime!.toIso8601String(),
        if (quantity != null) 'quantity': quantity,
        if (rewardCoin != null) 'rewardCoin': rewardCoin,
        if (youthUnionPoint != null) 'youthUnionPoint': youthUnionPoint,
        if (cashRewardAmount != null) 'cashRewardAmount': cashRewardAmount,
        if (certificateName != null) 'certificateName': certificateName,
        if (isOpen != null) 'isOpen': isOpen,
        if (categoryOptionIds != null && categoryOptionIds!.isNotEmpty)
          'categoryOptionIds': categoryOptionIds,
        if (requirementQuestions != null && requirementQuestions!.isNotEmpty)
          'requirementQuestions': requirementQuestions!.map((e) => e.toJson()).toList(),
      };
}