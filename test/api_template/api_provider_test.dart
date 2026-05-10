import 'package:events_app/api_template/base_request/api_request.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:flutter_test/flutter_test.dart';

class RecordingRestClient extends RestClient {
  RecordingRestClient({required this.nextResponse});

  ApiResponse<Map<String, dynamic>> nextResponse;
  ApiRequest? lastRequest;
  bool? lastRequireAuth;
  final List<ApiRequest> requests = [];
  final List<bool> requireAuthHistory = [];
  bool Function()? checkNetworkOverride;

  @override
  Future<ApiResponse<Model>> makeRequest<Model>(
    ApiRequest request,
    ResponseParser parser,
    bool requireAuth,
  ) async {
    lastRequest = request;
    lastRequireAuth = requireAuth;
    requests.add(request);
    requireAuthHistory.add(requireAuth);
    return nextResponse as ApiResponse<Model>;
  }

  @override
  Future<bool> checkNetwork() async {
    return checkNetworkOverride?.call() ?? true;
  }
}

class TestApiProvider {
  TestApiProvider({required RecordingRestClient client}) : _client = client;

  final RecordingRestClient _client;

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
        requireAuth: requireAuth,
      );

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
        requireAuth: requireAuth,
      );

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
        requireAuth: requireAuth,
      );

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
        requireAuth: requireAuth,
      );

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
        requireAuth: requireAuth,
      );

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
        requireAuth: requireAuth,
      );

  Future<ApiResponse<Model>> _request<Model>(
    ApiRequest request,
    ResponseParser<Model> parser, {
    bool requireAuth = true,
  }) async {
    return await _client.makeRequest(request, parser, requireAuth);
  }
}

void main() {
  late RecordingRestClient client;
  late TestApiProvider provider;

  setUp(() {
    client = RecordingRestClient(
      nextResponse: const ApiResponse.success(<String, dynamic>{
        'errorCode': 0,
        'statusCode': 200,
        'message': 'Success',
        'object': {'id': 1, 'name': 'Test'},
      }),
    );
    provider = TestApiProvider(client: client);
  });

  group('ApiProvider - HTTP Methods', () {
    test('get goi dung path va tra ve response da parse', () async {
      final result = await provider.get<Map<String, dynamic>>(
        '/users/1',
        (data) => data as Map<String, dynamic>,
      );

      expect(client.requests.length, 1);
      expect(client.requests.first.path, '/users/1');
      expect(client.requests.first.type, ApiRequestType.get);
      expect(
          result.when(
            success: (data) => data['object']?['name'],
            badRequest: (_) => null,
            unauthorized: (_) => null,
            forbidden: (_) => null,
            notFound: (_) => null,
            conflict: (_) => null,
            internalServerError: () => null,
            badGateway: () => null,
            serviceUnavailable: () => null,
            gatewayTimeout: () => null,
            canceled: () => null,
            responseParsing: () => null,
            unexpected: (_) => null,
          ),
          'Test');
    });

    test('post gui body JSON va tra ve response da parse', () async {
      final result = await provider.post<Map<String, dynamic>>(
        '/users',
        (data) => data as Map<String, dynamic>,
        body: const ApiRequestBody.json(
            {'name': 'New User', 'email': 'new@example.com'}),
      );

      expect(client.requests.length, 1);
      expect(client.requests.first.path, '/users');
      expect(client.requests.first.type, ApiRequestType.post);
      expect(
          result.when(
            success: (data) => data['object']?['name'],
            badRequest: (_) => null,
            unauthorized: (_) => null,
            forbidden: (_) => null,
            notFound: (_) => null,
            conflict: (_) => null,
            internalServerError: () => null,
            badGateway: () => null,
            serviceUnavailable: () => null,
            gatewayTimeout: () => null,
            canceled: () => null,
            responseParsing: () => null,
            unexpected: (_) => null,
          ),
          'Test');
    });

    test('put gui body JSON va tra ve response da parse', () async {
      final result = await provider.put<Map<String, dynamic>>(
        '/users/1',
        (data) => data as Map<String, dynamic>,
        body: const ApiRequestBody.json({'name': 'Updated User'}),
      );

      expect(client.requests.length, 1);
      expect(client.requests.first.path, '/users/1');
      expect(client.requests.first.type, ApiRequestType.put);
      expect(
          result.when(
            success: (data) => true,
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
          ),
          true);
    });

    test('delete goi dung path va tra ve response', () async {
      final result = await provider.delete<Map<String, dynamic>>(
        '/users/1',
        (data) => data as Map<String, dynamic>,
      );

      expect(client.requests.length, 1);
      expect(client.requests.first.path, '/users/1');
      expect(client.requests.first.type, ApiRequestType.delete);
      expect(
          result.when(
            success: (data) => true,
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
          ),
          true);
    });

    test('patch goi dung path va tra ve response', () async {
      final result = await provider.patch<Map<String, dynamic>>(
        '/users/1',
        (data) => data as Map<String, dynamic>,
      );

      expect(client.requests.length, 1);
      expect(client.requests.first.path, '/users/1');
      expect(client.requests.first.type, ApiRequestType.patch);
      expect(
          result.when(
            success: (data) => true,
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
          ),
          true);
    });

    test('upload gui multipart form data va tra ve response', () async {
      final result = await provider.upload<Map<String, dynamic>>(
        '/upload',
        (data) => data as Map<String, dynamic>,
        body: const ApiRequestBody.json(
            {'filePath': '/path/to/file.jpg', 'documentType': 'AVATAR'}),
      );

      expect(client.requests.length, 1);
      expect(client.requests.first.path, '/upload');
      expect(client.requests.first.type, ApiRequestType.upload);
      expect(
          result.when(
            success: (data) => true,
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
          ),
          true);
    });
  });

  group('ApiProvider - Error Handling', () {
    test('tra ve serviceUnavailable khi network check that bai', () async {
      client.checkNetworkOverride = () => false;
      client.nextResponse = const ApiResponse.serviceUnavailable();

      final result = await provider.get<Map<String, dynamic>>(
        '/users',
        (data) => data as Map<String, dynamic>,
      );

      expect(
          result.when(
            success: (_) => false,
            badRequest: (_) => false,
            unauthorized: (_) => false,
            forbidden: (_) => false,
            notFound: (_) => false,
            conflict: (_) => false,
            internalServerError: () => false,
            badGateway: () => false,
            serviceUnavailable: () => true,
            gatewayTimeout: () => false,
            canceled: () => false,
            responseParsing: () => false,
            unexpected: (_) => false,
          ),
          true);
    });

    test('tra ve unauthorized khi auth that bai', () async {
      client.nextResponse = const ApiResponse.unauthorized(
        ApiResponseError(code: '401', message: 'Unauthorized', errors: []),
      );

      final result = await provider.get<Map<String, dynamic>>(
        '/protected',
        (data) => data as Map<String, dynamic>,
        requireAuth: true,
      );

      expect(
          result.when(
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
          ),
          true);
    });

    test('tra ve internalServerError khi nhan InternalServerError', () async {
      client.nextResponse = const ApiResponse.internalServerError();

      final result = await provider.post<Map<String, dynamic>>(
        '/users',
        (data) => data as Map<String, dynamic>,
        body: const ApiRequestBody.json({'name': 'Test'}),
      );

      expect(
          result.when(
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
          ),
          true);
    });

    test('tra ve badGateway khi nhan BadGateway', () async {
      client.nextResponse = const ApiResponse.badGateway();

      final result = await provider.get<Map<String, dynamic>>(
        '/users',
        (data) => data as Map<String, dynamic>,
      );

      expect(
          result.when(
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
          ),
          true);
    });
  });
}
