import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_request.freezed.dart';

enum ApiRequestType { get, post, put, delete, patch, upload }

@freezed
class ApiRequestBody with _$ApiRequestBody {
  const factory ApiRequestBody.empty() = _ApiRequestBodyEmpty;

  const factory ApiRequestBody.json(Map<String, dynamic> data) =
      _ApiRequestBodyJson;

  const factory ApiRequestBody.text(String text) = _ApiRequestBodyText;

  const factory ApiRequestBody.file(Map<String, String> files) =
      _ApiRequestBodyFile;

  const factory ApiRequestBody.jsonString(String data) =
      _ApiRequestBodyJsonString;
}

@freezed
class ApiRequest with _$ApiRequest {
  factory ApiRequest(
      {required String path,
      required ApiRequestType type,
      required ApiRequestBody body,
      Map<String, dynamic>? queryParameters,
      List<Map<String, dynamic>>? queryParameterList,
      Map<String, String>? headers}) = _ApiRequest;
}
