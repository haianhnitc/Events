import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/feature/common/data/datasource/category_datasource.dart';
import 'package:events_app/feature/common/data/model/category_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_data.dart';

class TestCategoryDatasource extends CategoryDatasourceImpl {
  ApiResponse<Map<String, dynamic>>? categoriesStub;

  TestCategoryDatasource({this.categoriesStub}) : super(client: null);

  @override
  Future<ApiResponse<List<CategoryModel>>> getCategories() async {
    final envelope = categoriesStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': [fakeCategoryJson()],
          },
        });
    return forwardEnvelopeResponse<List<CategoryModel>>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        final content = object['content'] as List<dynamic>? ?? [];
        return content
            .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
      fallbackError: 'Lấy danh sách danh mục thất bại',
    );
  }
}

void main() {
  group('getCategories', () {
    test('trả về list categories khi thành công', () async {
      final datasource = TestCategoryDatasource(
        categoriesStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': [
              fakeCategoryJson(id: 1),
              fakeCategoryJson(id: 2),
              fakeCategoryJson(id: 3),
            ],
          },
        }),
      );

      final result = await datasource.getCategories();

      result.when(
        success: (categories) {
          expect(categories.length, equals(3));
          expect(categories.first.categoryId, equals(1));
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

    test('trả về list rỗng khi không có category', () async {
      final datasource = TestCategoryDatasource(
        categoriesStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {'content': []},
        }),
      );

      final result = await datasource.getCategories();

      result.when(
        success: (categories) => expect(categories, isEmpty),
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

    test('trả về unauthorized khi chưa đăng nhập', () async {
      final datasource = TestCategoryDatasource(
        categoriesStub: const ApiResponse.unauthorized(
          ApiResponseError(code: '401', message: 'Unauthorized', errors: []),
        ),
      );

      final result = await datasource.getCategories();

      expect(
        result.when(
          success: (_) => false,
          unauthorized: (_) => true,
          forbidden: (_) => false,
          notFound: (_) => false,
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

    test('trả về internalServerError khi backend 500', () async {
      final datasource = TestCategoryDatasource(
        categoriesStub: const ApiResponse.internalServerError(),
      );

      final result = await datasource.getCategories();

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
      final datasource = TestCategoryDatasource(
        categoriesStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': 'invalid',
        }),
      );

      final result = await datasource.getCategories();

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
