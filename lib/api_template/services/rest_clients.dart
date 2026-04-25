import 'dart:io';

import 'package:dio/dio.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/event_network.dart';
import 'package:events_app/api_template/helpers/idempotency_helper.dart';
import 'package:events_app/api_template/services/firebase_token_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

typedef ResponseParser<T> = T Function(dynamic response);

abstract class RestClient {
  Future<ApiResponse<Model>> makeRequest<Model>(
    ApiRequest request,
    ResponseParser parser,
    bool requireAuth,
  );

  Future<bool> checkNetwork();
}

class ApiRequestModel {
  ApiRequestModel(this.request, this.parser);

  final ApiRequest request;
  final ResponseParser parser;
}

class NRDRestClient extends RestClient {
  final FirebaseTokenService _tokenService =
      FirebaseTokenService(FirebaseAuth.instance);
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 10),
    ),
  );
  static const int _maxRetries = 1;

  NRDRestClient() {
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final requireAuth = options.extra['requireAuth'] ?? true;

          if (requireAuth && options.headers['Authorization'] == null) {
            final accessToken = await _tokenService.getAccessToken();
            if (accessToken != null && accessToken.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $accessToken';
            }
          }

          return handler.next(options);
        },
        onError: (error, handler) async {
          final requireAuth = error.requestOptions.extra['requireAuth'] ?? true;

          if (requireAuth && error.response?.statusCode == 401) {
            final isRetrying = error.requestOptions.extra['retryCount'] ?? 0;

            if (isRetrying < _maxRetries) {
              final newToken = await _tokenService.getAccessToken();
              if (newToken != null && newToken.isNotEmpty) {
                error.requestOptions.headers['Authorization'] =
                    'Bearer $newToken';
                error.requestOptions.extra['retryCount'] = isRetrying + 1;
                try {
                  final response = await _dio.fetch(error.requestOptions);
                  return handler.resolve(response);
                } catch (e) {
                  return handler.next(error);
                }
              }
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

  @override
  Future<ApiResponse<Model>> makeRequest<Model>(
      ApiRequest request, ResponseParser parser, bool requireAuth) async {
    return _makeRequestInternal<Model>(request, parser, requireAuth);
  }

  Future<ApiResponse<Model>> _makeRequestInternal<Model>(
      ApiRequest request, ResponseParser parser, bool requireAuth) async {
    final hasNetwork = await checkNetwork();
    if (!hasNetwork) {
      return const ApiResponse.serviceUnavailable();
    }

    Map<String, String> headers = Map.of(request.headers ?? {});

    if (IdempotencyHelper.requiresIdempotencyKey(request.path)) {
      headers['Idempotency-Key'] =
          IdempotencyHelper.getOrGenerateIdempotencyKey(headers);
    }

    final requestBody = request.body.when<dynamic>(
      empty: () => null,
      json: (json) => json,
      text: (text) => text,
      file: (files) => files,
      jsonString: (jsonString) => jsonString,
    );

    if (!headers.containsKey('Content-Type') && requestBody != null) {
      if (request.body.maybeWhen(json: (_) => true, orElse: () => false)) {
        headers['Content-Type'] = 'application/json';
      } else if (request.body.maybeWhen(text: (_) => true, orElse: () => false)) {
        headers['Content-Type'] = 'text/plain';
      }
    }
    Map<String, String>? parameters = request.queryParameters
        ?.map((key, value) => MapEntry(key, value.toString()));

    Response response;

    try {
      if (request.type == ApiRequestType.get) {
        response = await _dio.get(EventNetwork.baseUrl + request.path,
            queryParameters: parameters,
            options: Options(
              headers: headers,
              extra: {'requireAuth': requireAuth},
            ));
      } else if (request.type == ApiRequestType.post) {
        response = await _dio.post(EventNetwork.baseUrl + request.path,
            data: requestBody,
            queryParameters: parameters,
            options: Options(
              headers: headers,
              extra: {'requireAuth': requireAuth},
            ));
      } else if (request.type == ApiRequestType.put) {
        response = await _dio.put(EventNetwork.baseUrl + request.path,
            data: requestBody,
            queryParameters: parameters,
            options: Options(
              headers: headers,
              extra: {'requireAuth': requireAuth},
            ));
      } else if (request.type == ApiRequestType.delete) {
        response = await _dio.delete(EventNetwork.baseUrl + request.path,
            data: requestBody,
            queryParameters: parameters,
            options: Options(
              headers: headers,
              extra: {'requireAuth': requireAuth},
            ));
      } else if (request.type == ApiRequestType.upload) {
        final formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(
            requestBody['filePath'] as String,
            filename: requestBody['fileName'] as String? ?? 'document',
          ),
          'documentType': requestBody['documentType'] ?? '',
          if (requestBody['originalFileName'] != null)
            'originalFileName': requestBody['originalFileName'] as String,
        });
        final uploadHeaders = Map<String, String>.from(headers)
          ..remove('Content-Type');
        response = await _dio.post(
          EventNetwork.baseUrl + request.path,
          data: formData,
          queryParameters: parameters,
          options: Options(
            headers: uploadHeaders,
            extra: {'requireAuth': requireAuth},
          ),
        );
      } else {
        return ApiResponse.unexpected(ApiResponseError(
            code: '503',
            message:
                'The EventNetwork has not implemented ${request.type.name} method yet.',
            errors: []));
      }
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.connectionError) {
        return const ApiResponse.serviceUnavailable();
      }
      response = error.response ??
          Response(
              data: null,
              statusCode: 500,
              statusMessage: 'Internal Server Error',
              requestOptions: RequestOptions(
                  baseUrl: EventNetwork.baseUrl, path: request.path));
    }

    final statusCode = response.statusCode;

    switch (statusCode) {
      case 200:
      case 201:
        {
          if (response.data is Map<String, dynamic>) {
            return ApiResponse.success(parser(response.data));
          } else {
            return ApiResponse.responseParsing();
          }
        }
      case 500:
        return ApiResponse.internalServerError();
      case 502:
        return ApiResponse.badGateway();
      case 503:
        return ApiResponse.unexpected(ApiResponseError(
            code: '503', message: response.data.toString(), errors: []));
      case 401:
        return const ApiResponse.unauthorized(
            ApiResponseError(code: '401', message: 'Unauthorized', errors: []));
      case 403:
        return const ApiResponse.forbidden(
            ApiResponseError(code: '403', message: 'Forbidden', errors: []));
      case 404:
        return ApiResponse.notFound(ApiResponseError(
            code: '404', message: response.data.toString(), errors: []));
      case 409:
        return ApiResponse.conflict(ApiResponseError(
            code: '409', message: response.data.toString(), errors: []));
      case 400:
        return ApiResponse.badRequest(const ApiResponseError(
            code: '400', message: 'Bad Request', errors: []));
      default:
        return const ApiResponse.responseParsing();
    }
  }

  Future<bool> checkNetwork() async {
    try {
      if (kIsWeb) return true;
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}

class StubRestClient extends RestClient {
  @override
  Future<ApiResponse<Model>> makeRequest<Model>(
    ApiRequest request,
    ResponseParser parser,
    bool requireAuth,
  ) async {
    return const ApiResponse.unexpected(ApiResponseError(
      code: 'STUB_CLIENT',
      message: 'StubRestClient is not configured for real requests',
      errors: null,
    ));
  }

  @override
  Future<bool> checkNetwork() async => true;
}
