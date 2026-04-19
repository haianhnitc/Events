import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/feedback/data/datasource/feedback_datasource.dart';
import 'package:events_app/feature/feedback/data/model/feedback_model.dart';
import 'package:events_app/feature/feedback/domain/entity/feedback_entity.dart';
import 'package:events_app/feature/feedback/domain/repository/feedback_repository.dart';
import 'package:events_app/feature/feedback/domain/usecase/feedback_usecase_params.dart';
import 'package:events_app/feature/feedback/domain/usecase/submit_feedback_params.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: FeedbackRepository)
class FeedbackRepositoryImpl implements FeedbackRepository {
  final FeedbackDatasource _datasource;

  FeedbackRepositoryImpl(this._datasource);

  @override
  Future<Either<FailureEntity, List<FeedbackQuestionEntity>>> getFeedbackQuestions(
      GetFeedbackQuestionsParams params, {int page = 0, int size = 20}) async {
    final response = await _datasource.getFeedbackQuestions(params.eventId, page: page, size: size);
    return response.toEither().map(
      (models) => models.map((m) => m.toEntity()).toList(),
    );
  }

  @override
  Future<Either<FailureEntity, FeedbackEntity>> submitFeedback(SubmitFeedbackParams params) async {
    final response = await _datasource.submitFeedback(params);
    return response.toEither().map((m) => m.toEntity());
  }
}