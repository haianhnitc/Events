import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/event_network.dart';
import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef ResponseParser<T> = T Function(dynamic response);

abstract class RestClient {
  Future<ApiResponse<Model>> makeRequest<Model>(
    ApiRequest request,
    ResponseParser parser,
    bool requireAuth,
  );
}

class ApiRequestModel {
  ApiRequestModel(this.request, this.parser);

  final ApiRequest request;
  final ResponseParser parser;
}

class NRDRestClient extends RestClient {
  @override
  Future<ApiResponse<Model>> makeRequest<Model>(
      ApiRequest request, ResponseParser parser, bool requireAuth) async {
    final dio = Dio();

    final hasNetwork = await checkNetwork();
    if (!hasNetwork) {
      return const ApiResponse.serviceUnavailable();
    }

    Map<String, String> headers = Map.of(request.headers ?? {});
    if (requireAuth) await addAuthorizationHeader(headers);

    headers['Content-Type'] = 'application/json';

    final body = request.body.whenOrNull(json: (json) => json) ?? {};
    Map<String, String>? parameters = request.queryParameters
        ?.map((key, value) => MapEntry(key, value.toString()));

    Response response;

    try {
      if (request.type == ApiRequestType.get) {
        response = await dio.get(EvnetNetwork.baseUrl + request.path,
            queryParameters: parameters,
            options: Options(
                headers: headers,
                sendTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10)));
        print('REALLY GET ??');
      } else if (request.type == ApiRequestType.post) {
        response = await dio.post(EvnetNetwork.baseUrl + request.path,
            data: jsonEncode(body),
            queryParameters: parameters,
            options: Options(headers: headers));
        print(response);
      } else if (request.type == ApiRequestType.put) {
        response = await dio.put(EvnetNetwork.baseUrl + request.path,
            data: jsonEncode(body),
            queryParameters: parameters,
            options: Options(headers: headers));
      } else if (request.type == ApiRequestType.delete) {
        response = await dio.delete(EvnetNetwork.baseUrl + request.path,
            data: jsonEncode(body),
            queryParameters: parameters,
            options: Options(headers: headers));
      } else {
        return ApiResponse.unexpected(ApiResponseError(
            code: '503',
            message:
                'The EvnetNetwork has not implemented ${request.type.name} method yet.',
            errors: []));
      }
    } on DioException catch (error) {
      response = error.response ??
          Response(
              data: null,
              statusCode: 500,
              statusMessage: 'Internal Server Error',
              requestOptions: RequestOptions(
                  baseUrl: EvnetNetwork.baseUrl, path: request.path));
    }

    // final timestamp = DateTime.now();
    // EvnetNetwork.logEntries.insert(
    //   0,
    //   RequestLogEntry(
    //     id: "${timestamp.millisecondsSinceEpoch}",
    //     requestOptions: response.requestOptions,
    //     response: response,
    //     timestamp: timestamp,
    //   ),
    // );

    final statusCode = response.statusCode;
    switch (statusCode) {
      case 200:
        {
          if (response.data is Map<String, dynamic>) {
            return ApiResponse.success(
                parser(jsonDecode(jsonEncode(response.data))));
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
      case 403:
        return const ApiResponse.unauthorized(
            ApiResponseError(code: '403', message: 'Unauthorized', errors: []));
      case 404:
        return ApiResponse.notFound(ApiResponseError(
            code: '404', message: response.data.toString(), errors: []));
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

  Future<bool> addAuthorizationHeader(
    Map<String, dynamic> headers,
  ) async {
    final sharedPrefs = await await SharedPreferences.getInstance();

    String? accessToken = sharedPrefs.getString('access_token');

    if (accessToken == null) {
      return false;
    }

    final isAccessTokenExpired = JwtDecoder.isExpired(accessToken);
    if (!isAccessTokenExpired) {
      headers["Authorization"] = "Bearer $accessToken";
      return true;
    }

    return false;
  }
}
