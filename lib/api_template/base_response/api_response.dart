import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response.freezed.dart';
part 'api_response.g.dart';

@freezed
class ApiResponse<Model> with _$ApiResponse<Model> {
  const factory ApiResponse.success(Model model) = _Success;
  const factory ApiResponse.badRequest(ApiResponseError error) = _BadRequest;
  const factory ApiResponse.unauthorized(ApiResponseError error) =
      _Unauthorized;
  const factory ApiResponse.forbidden(ApiResponseError error) = _Forbidden;
  const factory ApiResponse.notFound(ApiResponseError error) = _NotFound;
  const factory ApiResponse.internalServerError() = _InternalServerError;
  const factory ApiResponse.badGateway() = _BadGateway;
  const factory ApiResponse.serviceUnavailable() = _ServiceUnavailable;
  const factory ApiResponse.gatewayTimeout() = _GatewayTimeout;
  const factory ApiResponse.canceled() = _Canceled;
  const factory ApiResponse.responseParsing() = _ResponseParsing;
  const factory ApiResponse.unexpected(ApiResponseError error) = _Unexpected;
}

@freezed
class ApiResponseError with _$ApiResponseError {
  const factory ApiResponseError({
    required String code,
    required String message,
    required List<ApiResponseErrorDetail>? errors,
  }) = _ApiResponseError;

  factory ApiResponseError.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseErrorFromJson(json);
}

@freezed
class ApiResponseErrorDetail with _$ApiResponseErrorDetail {
  const factory ApiResponseErrorDetail({
    String? reason,
    String? description,
  }) = _ApiResponseErrorDetail;

  factory ApiResponseErrorDetail.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseErrorDetailFromJson(json);
}
