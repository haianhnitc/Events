import 'package:events_app/api_template/base_request/api_request.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StubRestClient', () {
    late StubRestClient client;

    setUp(() {
      client = StubRestClient();
    });

    test('makeRequest tra ve unexpected voi message mac dinh', () async {
      final result = await client.makeRequest<Map<String, dynamic>>(
        ApiRequest(
          path: '/test',
          type: ApiRequestType.get,
          body: const ApiRequestBody.empty(),
        ),
        (data) => data as Map<String, dynamic>,
        false,
      );

      final isUnexpected = result.when(
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
        unexpected: (error) => error.message.contains('StubRestClient'),
      );

      expect(isUnexpected, true);
    });

    test('checkNetwork tra ve true', () async {
      final result = await client.checkNetwork();
      expect(result, true);
    });
  });
}
