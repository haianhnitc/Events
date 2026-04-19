import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:events_app/feature/feedback/domain/entity/feedback_entity.dart';
import 'package:events_app/feature/feedback/domain/repository/feedback_repository.dart';
import 'package:events_app/feature/feedback/domain/usecase/feedback_usecase_params.dart';
import 'package:events_app/feature/feedback/domain/usecase/submit_feedback_params.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetFeedbackQuestionsUsecase
    implements UseCase<List<FeedbackQuestionEntity>, GetFeedbackQuestionsParams> {
  final FeedbackRepository _repository;
  GetFeedbackQuestionsUsecase(this._repository);

  @override
  Future<Either<FailureEntity, List<FeedbackQuestionEntity>>> call(
      GetFeedbackQuestionsParams params) async {
    return await _repository.getFeedbackQuestions(params, page: 0, size: 20);
  }
}

@injectable
class SubmitFeedbackUsecase implements UseCase<FeedbackEntity, SubmitFeedbackParams> {
  final FeedbackRepository _repository;
  SubmitFeedbackUsecase(this._repository);

  @override
  Future<Either<FailureEntity, FeedbackEntity>> call(SubmitFeedbackParams params) async {
    return await _repository.submitFeedback(params);
  }
}