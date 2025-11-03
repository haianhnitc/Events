import 'package:events_app/api_template/base_response/api_response.dart';

import 'base_request/api_request.dart';
import 'services/rest_clients.dart';

abstract class ApiProvider {
  final RestClient _client;

  ApiProvider({
    required RestClient client,
  }) : _client = client;

  Future<ApiResponse<Model>> _request<Model>(
      ApiRequest request, ResponseParser<Model> parser,
      {bool requireAuth = true}) async {
    return await _client.makeRequest(request, parser, requireAuth);
  }

  Future<ApiResponse<Model>> get<Model>(
    String path,
    ResponseParser<Model> parser, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    List<Map<String, String>>? queryParameterList,
    bool requireAuth = true,
  }) =>
      _request(
          ApiRequest(
            path: path,
            type: ApiRequestType.get,
            body: const ApiRequestBody.empty(),
            queryParameters: queryParameters,
            headers: headers,
            queryParameterList: queryParameterList,
          ),
          parser,
          requireAuth: requireAuth);

  Future<ApiResponse<Model>> post<Model>(
    String path,
    ResponseParser<Model> parser, {
    ApiRequestBody? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    List<Map<String, String>>? queryParametersList,
    bool requireAuth = true,
  }) =>
      _request(
          ApiRequest(
            path: path,
            type: ApiRequestType.post,
            body: body ?? const ApiRequestBody.empty(),
            queryParameters: queryParameters,
            headers: headers,
            queryParameterList: queryParametersList,
          ),
          parser,
          requireAuth: requireAuth);

  Future<ApiResponse<Model>> put<Model>(
    String path,
    ResponseParser<Model> parser, {
    ApiRequestBody? body,
    Map<String, String>? headers,
    bool requireAuth = true,
  }) =>
      _request(
          ApiRequest(
            path: path,
            type: ApiRequestType.put,
            body: body ?? const ApiRequestBody.empty(),
            headers: headers,
          ),
          parser,
          requireAuth: requireAuth);

  Future<ApiResponse<Model>> delete<Model>(
    String path,
    ResponseParser<Model> parser, {
    ApiRequestBody? body,
    Map<String, String>? headers,
    bool requireAuth = true,
  }) =>
      _request(
          ApiRequest(
            path: path,
            type: ApiRequestType.delete,
            body: body ?? const ApiRequestBody.empty(),
            headers: headers,
          ),
          parser,
          requireAuth: requireAuth);

  Future<ApiResponse<Model>> patch<Model>(
    String path,
    ResponseParser<Model> parser, {
    ApiRequestBody? body,
    Map<String, String>? headers,
    bool requireAuth = true,
  }) =>
      _request(
          ApiRequest(
            path: path,
            type: ApiRequestType.patch,
            body: body ?? const ApiRequestBody.empty(),
            headers: headers,
          ),
          parser,
          requireAuth: requireAuth);

  Future<ApiResponse<Model>> upload<Model>(
    String path,
    ResponseParser<Model> parser, {
    ApiRequestBody? body,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
    bool requireAuth = true,
  }) =>
      _request(
          ApiRequest(
            path: path,
            type: ApiRequestType.upload,
            body: body ?? const ApiRequestBody.empty(),
            queryParameters: queryParameters,
            headers: headers,
          ),
          parser,
          requireAuth: requireAuth);
}
