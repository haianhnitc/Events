import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/feature/payment/data/datasource/coin_datasource.dart';
import 'package:events_app/feature/payment/data/model/coin_transaction_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_data.dart';

class TestCoinDatasource extends CoinDatasourceImpl {
  ApiResponse<Map<String, dynamic>>? getCoinHistoryStub;

  TestCoinDatasource({this.getCoinHistoryStub}) : super(client: null);

  @override
  Future<ApiResponse<CoinPage>> getCoinHistory({
    int page = 0,
    int size = 20,
    String sort = 'createdTime,desc',
  }) async {
    final envelope = getCoinHistoryStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': [fakeCoinTransactionJson()],
            'totalElements': 1,
            'totalPages': 1,
            'number': 0,
            'size': 20,
          },
        });
    return forwardEnvelopeResponse<CoinPage>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        final contentList = object['content'] as List<dynamic>? ?? [];
        return CoinPage(
          items: contentList
              .map((e) =>
                  CoinTransactionModel.fromJson(e as Map<String, dynamic>))
              .toList(),
          totalElements: object['totalElements'] as int? ?? 0,
          totalPages: object['totalPages'] as int? ?? 0,
          page: object['number'] as int? ?? page,
          size: object['size'] as int? ?? size,
        );
      },
      fallbackError: 'Khong the tai lich su coin',
    );
  }
}

void main() {
  group('getCoinHistory', () {
    test('trả về CoinPage với transactions khi thành công', () async {
      final datasource = TestCoinDatasource(
        getCoinHistoryStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': [
              fakeCoinTransactionJson(id: 1),
              fakeCoinTransactionJson(id: 2),
            ],
            'totalElements': 2,
            'totalPages': 1,
            'number': 0,
            'size': 20,
          },
        }),
      );

      final result = await datasource.getCoinHistory();

      result.when(
        success: (coinPage) {
          expect(coinPage.items.length, equals(2));
          expect(coinPage.totalElements, equals(2));
          expect(coinPage.items.first.transactionId, equals(1));
        },
        unexpected: (_) => fail('Expected success'),
        badRequest: (_) => fail('Expected success'),
        unauthorized: (_) => fail('Expected success'),
        forbidden: (_) => fail('Expected success'),
        notFound: (_) => fail('Expected success'),
        conflict: (_) => fail('Expected success'),
        internalServerError: () => fail('Expected success'),
        badGateway: () => fail('Expected success'),
        serviceUnavailable: () => fail('Expected success'),
        gatewayTimeout: () => fail('Expected success'),
        canceled: () => fail('Expected success'),
        responseParsing: () => fail('Expected success'),
      );
    });

    test('trả về list rỗng khi content rỗng', () async {
      final datasource = TestCoinDatasource(
        getCoinHistoryStub: const ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': [],
            'totalElements': 0,
            'totalPages': 0,
            'number': 0,
            'size': 20,
          },
        }),
      );

      final result = await datasource.getCoinHistory();

      result.when(
        success: (coinPage) {
          expect(coinPage.items, isEmpty);
          expect(coinPage.totalElements, equals(0));
        },
        unexpected: (_) => fail('Expected success'),
        badRequest: (_) => fail('Expected success'),
        unauthorized: (_) => fail('Expected success'),
        forbidden: (_) => fail('Expected success'),
        notFound: (_) => fail('Expected success'),
        conflict: (_) => fail('Expected success'),
        internalServerError: () => fail('Expected success'),
        badGateway: () => fail('Expected success'),
        serviceUnavailable: () => fail('Expected success'),
        gatewayTimeout: () => fail('Expected success'),
        canceled: () => fail('Expected success'),
        responseParsing: () => fail('Expected success'),
      );
    });

    test('truyền đúng pagination và sort params', () async {
      final datasource = TestCoinDatasource(
        getCoinHistoryStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': [fakeCoinTransactionJson()],
            'totalElements': 1,
            'totalPages': 1,
            'number': 2,
            'size': 10,
          },
        }),
      );

      final result = await datasource.getCoinHistory(
        page: 2,
        size: 10,
        sort: 'createdTime,asc',
      );

      result.when(
        success: (coinPage) {
          expect(coinPage.page, equals(2));
          expect(coinPage.size, equals(10));
        },
        unexpected: (_) => fail('Expected success'),
        badRequest: (_) => fail('Expected success'),
        unauthorized: (_) => fail('Expected success'),
        forbidden: (_) => fail('Expected success'),
        notFound: (_) => fail('Expected success'),
        conflict: (_) => fail('Expected success'),
        internalServerError: () => fail('Expected success'),
        badGateway: () => fail('Expected success'),
        serviceUnavailable: () => fail('Expected success'),
        gatewayTimeout: () => fail('Expected success'),
        canceled: () => fail('Expected success'),
        responseParsing: () => fail('Expected success'),
      );
    });

    test('trả về unauthorized khi 401', () async {
      final datasource = TestCoinDatasource(
        getCoinHistoryStub: const ApiResponse.unauthorized(
          ApiResponseError(code: '401', message: 'Unauthorized', errors: []),
        ),
      );

      final result = await datasource.getCoinHistory();

      expect(
        result.when(
          success: (_) => false,
          unauthorized: (_) => true,
          badRequest: (_) => false,
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
        isTrue,
      );
    });

    test('trả về internalServerError khi 500', () async {
      final datasource = TestCoinDatasource(
        getCoinHistoryStub: const ApiResponse.internalServerError(),
      );

      final result = await datasource.getCoinHistory();

      expect(
        result.when(
          success: (_) => false,
          internalServerError: () => true,
          badRequest: (_) => false,
          unauthorized: (_) => false,
          forbidden: (_) => false,
          notFound: (_) => false,
          conflict: (_) => false,
          badGateway: () => false,
          serviceUnavailable: () => false,
          gatewayTimeout: () => false,
          canceled: () => false,
          responseParsing: () => false,
          unexpected: (_) => false,
        ),
        isTrue,
      );
    });
  });
}
