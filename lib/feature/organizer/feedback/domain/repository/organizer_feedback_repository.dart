import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/feedback/domain/entity/feedback_entity.dart';
import 'package:events_app/feature/organizer/feedback/domain/usecase/organizer_feedback_params.dart';

abstract class OrganizerFeedbackRepository {
  Future<Either<FailureEntity, FeedbackQuestionEntity>> createFeedbackQuestion(
      CreateFeedbackQuestionParams params);
  Future<Either<FailureEntity, FeedbackQuestionEntity>> getFeedbackQuestionById(int id);
  Future<Either<FailureEntity, List<FeedbackQuestionEntity>>> getFeedbackQuestions(
      int eventId);
  Future<Either<FailureEntity, Unit>> deleteFeedbackQuestions(List<int> questionIds);
  Future<Either<FailureEntity, List<FeedbackEntity>>> getFeedbacks(
      GetOrganizerFeedbacksParams params);
  Future<Either<FailureEntity, FeedbackEntity>> getFeedbackById(int id);
}
