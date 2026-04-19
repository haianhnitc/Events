import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:events_app/feature/feedback/domain/entity/feedback_entity.dart';
import 'package:events_app/feature/organizer/feedback/domain/repository/organizer_feedback_repository.dart';
import 'package:events_app/feature/organizer/feedback/domain/usecase/organizer_feedback_params.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateOrganizerFeedbackQuestionUsecase
    implements UseCase<FeedbackQuestionEntity, CreateFeedbackQuestionParams> {
  final OrganizerFeedbackRepository _repository;
  CreateOrganizerFeedbackQuestionUsecase(this._repository);

  @override
  Future<Either<FailureEntity, FeedbackQuestionEntity>> call(
      CreateFeedbackQuestionParams params) async {
    return await _repository.createFeedbackQuestion(params);
  }
}

@injectable
class GetOrganizerFeedbackQuestionByIdUsecase
    implements UseCase<FeedbackQuestionEntity, int> {
  final OrganizerFeedbackRepository _repository;
  GetOrganizerFeedbackQuestionByIdUsecase(this._repository);

  @override
  Future<Either<FailureEntity, FeedbackQuestionEntity>> call(int id) async {
    return await _repository.getFeedbackQuestionById(id);
  }
}

@injectable
class GetOrganizerFeedbackQuestionsUsecase
    implements UseCase<List<FeedbackQuestionEntity>, int> {
  final OrganizerFeedbackRepository _repository;
  GetOrganizerFeedbackQuestionsUsecase(this._repository);

  @override
  Future<Either<FailureEntity, List<FeedbackQuestionEntity>>> call(int eventId) async {
    return await _repository.getFeedbackQuestions(eventId);
  }
}

@injectable
class DeleteFeedbackQuestionsUsecase
    implements UseCase<Unit, DeleteFeedbackQuestionsParams> {
  final OrganizerFeedbackRepository _repository;
  DeleteFeedbackQuestionsUsecase(this._repository);

  @override
  Future<Either<FailureEntity, Unit>> call(DeleteFeedbackQuestionsParams params) async {
    return await _repository.deleteFeedbackQuestions(params.questionIds);
  }
}

@injectable
class GetOrganizerFeedbacksUsecase
    implements UseCase<List<FeedbackEntity>, GetOrganizerFeedbacksParams> {
  final OrganizerFeedbackRepository _repository;
  GetOrganizerFeedbacksUsecase(this._repository);

  @override
  Future<Either<FailureEntity, List<FeedbackEntity>>> call(
      GetOrganizerFeedbacksParams params) async {
    return await _repository.getFeedbacks(params);
  }
}

@injectable
class GetOrganizerFeedbackByIdUsecase
    implements UseCase<FeedbackEntity, int> {
  final OrganizerFeedbackRepository _repository;
  GetOrganizerFeedbackByIdUsecase(this._repository);

  @override
  Future<Either<FailureEntity, FeedbackEntity>> call(int id) async {
    return await _repository.getFeedbackById(id);
  }
}
