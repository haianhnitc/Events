import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:mocktail/mocktail.dart';

export 'api_response_matchers.dart';
export 'api_request_matchers.dart';

/// Mock dùng chung cho tất cả datasource test.
/// Thay vì mock Dio (phức tạp), chúng ta mock trực tiếp [RestClient] —
/// đây là boundary duy nhất mà [ApiProvider] giao tiếp ra ngoài.
class MockRestClient extends Mock implements RestClient {
  MockRestClient() {
    // Default: network is available so tests are not blocked by connectivity checks.
    when(() => checkNetwork()).thenAnswer((_) async => true);
  }
}

/// Tạo một [ApiResponse.success] bọc [Map<String, dynamic>] theo format
/// backend trả về: { errorCode: 0, statusCode: 200, message: "...", object: ... }
ApiResponse<Map<String, dynamic>> successEnvelope(Object? object) {
  return ApiResponse.success({
    'errorCode': 0,
    'statusCode': 200,
    'message': 'Success',
    'object': object,
  });
}

/// Tạo envelope thành công với paginated content: { ..., object: { content: [...] } }
ApiResponse<Map<String, dynamic>> successPageEnvelope(List<dynamic> content) {
  return successEnvelope({'content': content, 'totalElements': content.length});
}

/// Tạo response lỗi 401 Unauthorized
ApiResponse<Map<String, dynamic>> unauthorizedResponse() {
  return const ApiResponse.unauthorized(
    ApiResponseError(code: '401', message: 'Unauthorized', errors: []),
  );
}

/// Tạo response lỗi 404 Not Found
ApiResponse<Map<String, dynamic>> notFoundResponse() {
  return const ApiResponse.notFound(
    ApiResponseError(code: '404', message: 'Not found', errors: []),
  );
}

/// Tạo response lỗi 500 Internal Server Error
ApiResponse<Map<String, dynamic>> serverErrorResponse() {
  return const ApiResponse.internalServerError();
}

/// Tạo response lỗi 400 Bad Request
ApiResponse<Map<String, dynamic>> badRequestResponse() {
  return const ApiResponse.badRequest(
    ApiResponseError(code: '400', message: 'Bad request', errors: []),
  );
}

/// Tạo response lỗi 403 Forbidden với custom error code
ApiResponse<Map<String, dynamic>> forbiddenResponse({
  String code = '403',
  String message = 'Forbidden',
}) {
  return ApiResponse.forbidden(
    ApiResponseError(code: code, message: message, errors: null),
  );
}

/// Tạo response lỗi 409 Conflict
ApiResponse<Map<String, dynamic>> conflictResponse({
  String code = '409',
  String message = 'Conflict',
}) {
  return ApiResponse.conflict(
    ApiResponseError(code: code, message: message, errors: null),
  );
}

/// Tạo envelope lỗi backend: errorCode != 0
ApiResponse<Map<String, dynamic>> backendErrorEnvelope({
  int errorCode = -1,
  String message = 'Backend error',
}) {
  return ApiResponse.success({
    'errorCode': errorCode,
    'statusCode': 400,
    'message': message,
    'object': null,
  });
}

/// Chuyển đổi error variant của ApiResponse<Map<String, dynamic>> sang ApiResponse<T>
/// Freezed không cho gán ApiResponse<X> sang ApiResponse<Y>, nhưng error variant
/// không có generic data nên có thể dùng chung.
ApiResponse<T> errorResponse<T>(ApiResponse<Map<String, dynamic>> from) {
  return from.when(
    success: (_) => throw StateError('Dùng successResponse<T>() cho success case'),
    badRequest: (e) => ApiResponse.badRequest(e),
    unauthorized: (e) => ApiResponse.unauthorized(e),
    forbidden: (e) => ApiResponse.forbidden(e),
    notFound: (e) => ApiResponse.notFound(e),
    conflict: (e) => ApiResponse.conflict(e),
    internalServerError: () => ApiResponse.internalServerError(),
    badGateway: () => ApiResponse.badGateway(),
    serviceUnavailable: () => ApiResponse.serviceUnavailable(),
    gatewayTimeout: () => ApiResponse.gatewayTimeout(),
    canceled: () => ApiResponse.canceled(),
    responseParsing: () => ApiResponse.responseParsing(),
    unexpected: (e) => ApiResponse.unexpected(e),
  );
}

/// Tạo ApiResponse.success với type T (dùng cho repository test mock)
ApiResponse<T> successResponse<T>(T data) => ApiResponse.success(data);
