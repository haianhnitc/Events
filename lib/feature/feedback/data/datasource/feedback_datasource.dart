import 'package:events_app/api_template/api_provider.dart';
import 'package:events_app/api_template/api_path.dart';
import 'package:events_app/api_template/base_request/api_request.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/feedback/data/model/feedback_model.dart';
import 'package:events_app/feature/feedback/domain/usecase/submit_feedback_params.dart';
import 'package:injectable/injectable.dart';

abstract class FeedbackDatasource {
  Future<ApiResponse<List<FeedbackQuestionModel>>> getFeedbackQuestions(int eventId, {int page = 0, int size = 20});
  Future<ApiResponse<FeedbackModel>> submitFeedback(SubmitFeedbackParams params);
}

@Injectable(as: FeedbackDatasource)
class FeedbackDatasourceImpl extends ApiProvider implements FeedbackDatasource {
  FeedbackDatasourceImpl({RestClient? client})
      : super(client: client ?? NRDRestClient());

  @override
  Future<ApiResponse<List<FeedbackQuestionModel>>> getFeedbackQuestions(
    int eventId, {
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.feedbackQuestions,
        (data) => Map<String, dynamic>.from(data as Map),
        queryParameters: {'eventId': eventId, 'page': page, 'size': size},
        requireAuth: true,
      );

      return forwardEnvelopeResponse<List<FeedbackQuestionModel>>(
        response,
        (object) {
          if (object == null) return <FeedbackQuestionModel>[];
          if (object is List<dynamic>) {
            return object
                .map((e) => FeedbackQuestionModel.fromJson(e as Map<String, dynamic>))
                .toList();
          }
          if (object is Map<String, dynamic>) {
            final content = object['content'] as List<dynamic>? ?? [];
            return content
                .map((e) => FeedbackQuestionModel.fromJson(e as Map<String, dynamic>))
                .toList();
          }
          throw const FormatException('Invalid object payload');
        },
        fallbackError: 'Lấy câu hỏi feedback thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<FeedbackModel>> submitFeedback(SubmitFeedbackParams params) async {
    try {
      final response = await post<Map<String, dynamic>>(
        ApiPath.feedbacks,
        (data) => Map<String, dynamic>.from(data as Map),
        body: ApiRequestBody.json(params.toJson()),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<FeedbackModel>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return FeedbackModel.fromJson(object);
        },
        fallbackError: 'Gửi feedback thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }
}
