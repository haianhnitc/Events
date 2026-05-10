import 'package:events_app/api_template/base_request/api_request.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_rest_client.dart';

void registerFallbacks() {
  registerFallbackValue(
    ApiRequest(
      path: '/fallback',
      type: ApiRequestType.get,
      body: const ApiRequestBody.empty(),
    ),
  );
  registerFallbackValue((dynamic data) => data as Map<String, dynamic>);
}

void stubRestClient(
  MockRestClient client,
  ApiResponse<Map<String, dynamic>> response,
) {
  when(() => client.makeRequest(any(), any(), any()))
      .thenAnswer((_) async => response);
}
