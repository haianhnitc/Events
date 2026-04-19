import 'dart:convert';

import 'package:events_app/api_template/api_provider.dart';
import 'package:events_app/api_template/api_path.dart';
import 'package:events_app/api_template/base_request/api_request.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/feedback/data/model/feedback_model.dart';
import 'package:events_app/feature/organizer/feedback/domain/usecase/organizer_feedback_params.dart';
import 'package:injectable/injectable.dart';

abstract class OrganizerFeedbackDatasource {
  Future<ApiResponse<FeedbackQuestionModel>> createFeedbackQuestion(
      CreateFeedbackQuestionParams params);
  Future<ApiResponse<FeedbackQuestionModel>> getFeedbackQuestionById(int id);
  Future<ApiResponse<List<FeedbackQuestionModel>>> getFeedbackQuestions(int eventId);
  Future<ApiResponse<void>> deleteFeedbackQuestions(List<int> questionIds);
  Future<ApiResponse<Map<String, dynamic>>> getFeedbacks({
    int? eventId,
    int? participantId,
    int page = 0,
    int size = 20,
  });
  Future<ApiResponse<FeedbackModel>> getFeedbackById(int id);
}

@Injectable(as: OrganizerFeedbackDatasource)
class OrganizerFeedbackDatasourceImpl extends ApiProvider
    implements OrganizerFeedbackDatasource {
  OrganizerFeedbackDatasourceImpl({RestClient? client})
      : super(client: client ?? NRDRestClient());

  @override
  Future<ApiResponse<FeedbackQuestionModel>> createFeedbackQuestion(
    CreateFeedbackQuestionParams params,
  ) async {
    try {
      final response = await post<Map<String, dynamic>>(
        ApiPath.feedbackQuestions,
        (data) => Map<String, dynamic>.from(data as Map),
        body: ApiRequestBody.json(params.toJson()),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<FeedbackQuestionModel>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return FeedbackQuestionModel.fromJson(object);
        },
        fallbackError: 'Tạo câu hỏi feedback thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<FeedbackQuestionModel>> getFeedbackQuestionById(int id) async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.feedbackQuestionDetail(id),
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<FeedbackQuestionModel>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return FeedbackQuestionModel.fromJson(object);
        },
        fallbackError: 'Lấy câu hỏi feedback thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<List<FeedbackQuestionModel>>> getFeedbackQuestions(int eventId) async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.feedbackQuestions,
        (data) => Map<String, dynamic>.from(data as Map),
        queryParameters: {'eventId': eventId},
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
        fallbackError: 'Lấy danh sách câu hỏi thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<void>> deleteFeedbackQuestions(List<int> questionIds) async {
    try {
      final response = await delete<Map<String, dynamic>>(
        ApiPath.feedbackQuestions,
        (data) => data == null
            ? <String, dynamic>{}
            : Map<String, dynamic>.from(data as Map),
        body: ApiRequestBody.jsonString(jsonEncode(questionIds)),
        requireAuth: true,
      );
      return forwardEnvelopeResponse<void>(
        response,
        (Object? _) {},
        fallbackError: 'Xóa câu hỏi thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> getFeedbacks({
    int? eventId,
    int? participantId,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'size': size};
      if (eventId != null) queryParams['eventId'] = eventId;
      if (participantId != null) queryParams['participantId'] = participantId;

      final response = await get<Map<String, dynamic>>(
        ApiPath.feedbacks,
        (data) => Map<String, dynamic>.from(data as Map),
        queryParameters: queryParams,
        requireAuth: true,
      );

      return forwardEnvelopeResponse<Map<String, dynamic>>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return object;
        },
        fallbackError: 'Lấy danh sách feedback thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<FeedbackModel>> getFeedbackById(int id) async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.feedbackDetail(id),
        (data) => Map<String, dynamic>.from(data as Map),
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
        fallbackError: 'Lấy chi tiết feedback thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }
}
