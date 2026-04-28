import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/feedback/data/model/feedback_model.dart';
import 'package:events_app/feature/feedback/domain/entity/feedback_entity.dart';
import 'package:events_app/feature/organizer/feedback/data/datasource/organizer_feedback_datasource.dart';
import 'package:events_app/feature/organizer/feedback/domain/repository/organizer_feedback_repository.dart';
import 'package:events_app/feature/organizer/feedback/domain/usecase/organizer_feedback_params.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OrganizerFeedbackRepository)
class OrganizerFeedbackRepositoryImpl implements OrganizerFeedbackRepository {
  final OrganizerFeedbackDatasource _datasource;

  OrganizerFeedbackRepositoryImpl(this._datasource);

  @override
  Future<Either<FailureEntity, FeedbackQuestionEntity>> createFeedbackQuestion(
      CreateFeedbackQuestionParams params) async {
    final response = await _datasource.createFeedbackQuestion(params);
    return response.toEitherNullable().map((m) => m.toEntity());
  }

  @override
  Future<Either<FailureEntity, FeedbackQuestionEntity>> getFeedbackQuestionById(
      int id) async {
    final response = await _datasource.getFeedbackQuestionById(id);
    return response.toEitherNullable().map((m) => m.toEntity());
  }

  @override
  Future<Either<FailureEntity, List<FeedbackQuestionEntity>>>
      getFeedbackQuestions(int eventId) async {
    final response = await _datasource.getFeedbackQuestions(eventId);
    return response
        .toEither()
        .map((list) => list.map((m) => m.toEntity()).toList());
  }

  @override
  Future<Either<FailureEntity, Unit>> deleteFeedbackQuestions(
      List<int> questionIds) async {
    final response = await _datasource.deleteFeedbackQuestions(questionIds);
    return response.toEitherUnit();
  }

  @override
  Future<Either<FailureEntity, List<FeedbackEntity>>> getFeedbacks(
      GetOrganizerFeedbacksParams params) async {
    final response = await _datasource.getFeedbacks(
        eventId: params.eventId,
        participantId: params.participantId,
        page: params.page,
        size: params.size);
    return response.toEither().fold(
      (failure) => Left(failure),
      (data) {
        if (data is! Map<String, dynamic>) return const Right([]);
        final content = data['content'] as List<dynamic>? ?? [];
        return Right(content
            .map((e) =>
                FeedbackModel.fromJson(e as Map<String, dynamic>).toEntity())
            .toList());
      },
    );
  }

  @override
  Future<Either<FailureEntity, FeedbackEntity>> getFeedbackById(int id) async {
    final response = await _datasource.getFeedbackById(id);
    return response.toEitherNullable().map((m) => m.toEntity());
  }
}
