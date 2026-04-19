import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class CreateFeedbackQuestionParams {
  final int eventId;
  final String questionContent;
  final FeedbackQuestionType questionType;
  final bool? isRequired;
  final int? maxRating;
  final List<String>? options;

  const CreateFeedbackQuestionParams({
    required this.eventId,
    required this.questionContent,
    required this.questionType,
    this.isRequired,
    this.maxRating,
    this.options,
  });

  Map<String, dynamic> toJson() => {
        'eventId': eventId,
        'questionContent': questionContent,
        'questionType': questionType.apiValue,
        'isRequired': isRequired ?? false,
        if (maxRating != null) 'maxRating': maxRating,
        if (options != null) 'options': options,
      };
}

class GetOrganizerFeedbacksParams {
  final int? eventId;
  final int? participantId;
  final int page;
  final int size;

  const GetOrganizerFeedbacksParams({
    this.eventId,
    this.participantId,
    this.page = 0,
    this.size = 20,
  });
}

class DeleteFeedbackQuestionsParams {
  final List<int> questionIds;

  const DeleteFeedbackQuestionsParams({required this.questionIds});

  List<int> toJson() => questionIds;
}