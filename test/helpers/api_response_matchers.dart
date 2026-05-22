import 'package:events_app/api_template/base_response/api_response.dart';

// file này tạo dùng cho các file test , hỗ trợ viết test nhanh hơn

bool isSuccess<T>(ApiResponse<T> result) {
  return result.when(
    success: (_) => true,
    badRequest: (_) => false,
    unauthorized: (_) => false,
    forbidden: (_) => false,
    notFound: (_) => false,
    conflict: (_) => false,
    internalServerError: () => false,
    badGateway: () => false,
    serviceUnavailable: () => false,
    gatewayTimeout: () => false,
    canceled: () => false,
    responseParsing: () => false,
    unexpected: (_) => false,
  );
}

bool isUnauthorized<T>(ApiResponse<T> result) {
  return result.when(
    success: (_) => false,
    badRequest: (_) => false,
    unauthorized: (_) => true,
    forbidden: (_) => false,
    notFound: (_) => false,
    conflict: (_) => false,
    internalServerError: () => false,
    badGateway: () => false,
    serviceUnavailable: () => false,
    gatewayTimeout: () => false,
    canceled: () => false,
    responseParsing: () => false,
    unexpected: (_) => false,
  );
}

bool isNotFound<T>(ApiResponse<T> result) {
  return result.when(
    success: (_) => false,
    badRequest: (_) => false,
    unauthorized: (_) => false,
    forbidden: (_) => false,
    notFound: (_) => true,
    conflict: (_) => false,
    internalServerError: () => false,
    badGateway: () => false,
    serviceUnavailable: () => false,
    gatewayTimeout: () => false,
    canceled: () => false,
    responseParsing: () => false,
    unexpected: (_) => false,
  );
}

bool isBadRequest<T>(ApiResponse<T> result) {
  return result.when(
    success: (_) => false,
    badRequest: (_) => true,
    unauthorized: (_) => false,
    forbidden: (_) => false,
    notFound: (_) => false,
    conflict: (_) => false,
    internalServerError: () => false,
    badGateway: () => false,
    serviceUnavailable: () => false,
    gatewayTimeout: () => false,
    canceled: () => false,
    responseParsing: () => false,
    unexpected: (_) => false,
  );
}

bool isForbidden<T>(ApiResponse<T> result) {
  return result.when(
    success: (_) => false,
    badRequest: (_) => false,
    unauthorized: (_) => false,
    forbidden: (_) => true,
    notFound: (_) => false,
    conflict: (_) => false,
    internalServerError: () => false,
    badGateway: () => false,
    serviceUnavailable: () => false,
    gatewayTimeout: () => false,
    canceled: () => false,
    responseParsing: () => false,
    unexpected: (_) => false,
  );
}

bool isInternalServerError<T>(ApiResponse<T> result) {
  return result.when(
    success: (_) => false,
    badRequest: (_) => false,
    unauthorized: (_) => false,
    forbidden: (_) => false,
    notFound: (_) => false,
    conflict: (_) => false,
    internalServerError: () => true,
    badGateway: () => false,
    serviceUnavailable: () => false,
    gatewayTimeout: () => false,
    canceled: () => false,
    responseParsing: () => false,
    unexpected: (_) => false,
  );
}

bool isBadGateway<T>(ApiResponse<T> result) {
  return result.when(
    success: (_) => false,
    badRequest: (_) => false,
    unauthorized: (_) => false,
    forbidden: (_) => false,
    notFound: (_) => false,
    conflict: (_) => false,
    internalServerError: () => false,
    badGateway: () => true,
    serviceUnavailable: () => false,
    gatewayTimeout: () => false,
    canceled: () => false,
    responseParsing: () => false,
    unexpected: (_) => false,
  );
}

bool isResponseParsing<T>(ApiResponse<T> result) {
  return result.when(
    success: (_) => false,
    badRequest: (_) => false,
    unauthorized: (_) => false,
    forbidden: (_) => false,
    notFound: (_) => false,
    conflict: (_) => false,
    internalServerError: () => false,
    badGateway: () => false,
    serviceUnavailable: () => false,
    gatewayTimeout: () => false,
    canceled: () => false,
    responseParsing: () => true,
    unexpected: (_) => false,
  );
}

bool isUnexpected<T>(ApiResponse<T> result) {
  return result.when(
    success: (_) => false,
    badRequest: (_) => false,
    unauthorized: (_) => false,
    forbidden: (_) => false,
    notFound: (_) => false,
    conflict: (_) => false,
    internalServerError: () => false,
    badGateway: () => false,
    serviceUnavailable: () => false,
    gatewayTimeout: () => false,
    canceled: () => false,
    responseParsing: () => false,
    unexpected: (_) => true,
  );
}

bool isCanceled<T>(ApiResponse<T> result) {
  return result.when(
    success: (_) => false,
    badRequest: (_) => false,
    unauthorized: (_) => false,
    forbidden: (_) => false,
    notFound: (_) => false,
    conflict: (_) => false,
    internalServerError: () => false,
    badGateway: () => false,
    serviceUnavailable: () => false,
    gatewayTimeout: () => false,
    canceled: () => true,
    responseParsing: () => false,
    unexpected: (_) => false,
  );
}

// Helper builders cho responses
ApiResponse<Map<String, dynamic>> successEnvelope(Map<String, dynamic> data) {
  // Wrap the data in an API envelope structure
  return ApiResponse<Map<String, dynamic>>.success({
    'errorCode': 0,
    'statusCode': 200,
    'message': 'Success',
    'object': data,
  });
}

ApiResponse<Map<String, dynamic>> unauthorizedResponse() {
  return const ApiResponse<Map<String, dynamic>>.unauthorized(
    ApiResponseError(
      code: '401',
      message: 'Unauthorized',
      errors: null,
    ),
  );
}

ApiResponse<T> errorResponse<T extends Object>() {
  return const ApiResponse<dynamic>.unexpected(
    ApiResponseError(
      code: 'ERROR',
      message: 'Error',
      errors: null,
    ),
  ) as ApiResponse<T>;
}