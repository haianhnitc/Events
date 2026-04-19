import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/feedback/domain/entity/feedback_entity.dart';
import 'package:events_app/feature/feedback/domain/usecase/feedback_usecase_params.dart';
import 'package:events_app/feature/feedback/domain/usecase/submit_feedback_params.dart';

abstract class FeedbackRepository {
  Future<Either<FailureEntity, List<FeedbackQuestionEntity>>> getFeedbackQuestions(
      GetFeedbackQuestionsParams params, {int page = 0, int size = 20});
  Future<Either<FailureEntity, FeedbackEntity>> submitFeedback(SubmitFeedbackParams params);
}