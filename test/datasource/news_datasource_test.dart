import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/feature/news/data/datasource/news_datasource.dart';
import 'package:events_app/feature/news/data/model/news_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_data.dart';

class TestNewsDatasource extends NewsDatasourceImpl {
  ApiResponse<Map<String, dynamic>>? listStub;
  ApiResponse<Map<String, dynamic>>? detailStub;

  TestNewsDatasource({this.listStub, this.detailStub}) : super(client: null);

  @override
  Future<ApiResponse<List<NewsModel>>> getNewsList({
    int? page,
    int? size,
    String? keyword,
  }) async {
    final envelope = listStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': [fakeNewsJson()],
            'totalElements': 1,
          },
        });
    return forwardEnvelopeResponse<List<NewsModel>>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        final content = object['content'] as List<dynamic>? ?? [];
        return content
            .map((e) => NewsModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
      fallbackError: 'Lấy danh sách tin tức thất bại',
    );
  }

  @override
  Future<ApiResponse<NewsModel>> getNewsById(int id) async {
    final envelope = detailStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeNewsJson(id: id),
        });
    return forwardEnvelopeResponse<NewsModel>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return NewsModel.fromJson(object);
      },
      fallbackError: 'Lấy chi tiết tin tức thất bại',
    );
  }
}

void main() {
  group('getNewsList', () {
    test('trả về list tin tức khi thành công', () async {
      final datasource = TestNewsDatasource(
        listStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': [
              fakeNewsJson(id: 1),
              fakeNewsJson(id: 2),
              fakeNewsJson(id: 3),
            ],
            'totalElements': 3,
          },
        }),
      );

      final result = await datasource.getNewsList();

      result.when(
        success: (newsList) {
          expect(newsList.length, equals(3));
          expect(newsList.first.newsId, equals(1));
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
      final datasource = TestNewsDatasource(
        listStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {'content': [], 'totalElements': 0},
        }),
      );

      final result = await datasource.getNewsList();

      result.when(
        success: (newsList) => expect(newsList, isEmpty),
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

    test('trả về responseParsing khi object không phải Map', () async {
      final datasource = TestNewsDatasource(
        listStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': 'invalid',
        }),
      );

      final result = await datasource.getNewsList();

      expect(
        result.when(
          success: (_) => false,
          responseParsing: () => true,
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
          unexpected: (_) => false,
        ),
        isTrue,
      );
    });

    test('truyền keyword vào query params không gây lỗi', () async {
      final datasource = TestNewsDatasource(
        listStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {'content': [fakeNewsJson()], 'totalElements': 1},
        }),
      );

      final result = await datasource.getNewsList(keyword: 'concert', page: 1, size: 5);

      expect(
        result.when(
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
        ),
        isTrue,
      );
    });

    test('trả về internalServerError khi backend 500', () async {
      final datasource = TestNewsDatasource(
        listStub: const ApiResponse.internalServerError(),
      );

      final result = await datasource.getNewsList();

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

    test('trả về serviceUnavailable khi không có mạng', () async {
      final datasource = TestNewsDatasource(
        listStub: const ApiResponse.serviceUnavailable(),
      );

      final result = await datasource.getNewsList();

      expect(
        result.when(
          success: (_) => false,
          serviceUnavailable: () => true,
          badRequest: (_) => false,
          unauthorized: (_) => false,
          forbidden: (_) => false,
          notFound: (_) => false,
          conflict: (_) => false,
          internalServerError: () => false,
          badGateway: () => false,
          gatewayTimeout: () => false,
          canceled: () => false,
          responseParsing: () => false,
          unexpected: (_) => false,
        ),
        isTrue,
      );
    });
  });

  group('getNewsById', () {
    test('trả về NewsModel khi thành công', () async {
      final datasource = TestNewsDatasource(
        detailStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeNewsJson(id: 10),
        }),
      );

      final result = await datasource.getNewsById(10);

      result.when(
        success: (news) {
          expect(news.newsId, equals(10));
          expect(news.title, equals('News 10'));
          expect(news.content, equals('News content'));
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

    test('trả về notFound khi tin tức không tồn tại', () async {
      final datasource = TestNewsDatasource(
        detailStub: const ApiResponse.notFound(
          ApiResponseError(code: '404', message: 'Not found', errors: []),
        ),
      );

      final result = await datasource.getNewsById(9999);

      expect(
        result.when(
          success: (_) => false,
          notFound: (_) => true,
          unauthorized: (_) => false,
          forbidden: (_) => false,
          badRequest: (_) => false,
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

    test('trả về internalServerError khi backend lỗi', () async {
      final datasource = TestNewsDatasource(
        detailStub: const ApiResponse.internalServerError(),
      );

      final result = await datasource.getNewsById(1);

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

    test('trả về responseParsing khi object không phải Map', () async {
      final datasource = TestNewsDatasource(
        detailStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': 123,
        }),
      );

      final result = await datasource.getNewsById(1);

      expect(
        result.when(
          success: (_) => false,
          responseParsing: () => true,
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
          unexpected: (_) => false,
        ),
        isTrue,
      );
    });
  });
}
