import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/feature/common/data/datasource/category_datasource.dart';
import 'package:events_app/feature/common/data/model/category_model.dart';
import 'package:events_app/feature/common/data/repository/category_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/fake_data.dart';
import '../helpers/mock_rest_client.dart';

class MockCategoryDatasource extends Mock implements CategoryDatasource {}

void main() {
  late MockCategoryDatasource mockDatasource;
  late CategoryRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockCategoryDatasource();
    repository = CategoryRepositoryImpl(mockDatasource);
  });

  group('getCategories', () {
    test('trả về list category entity khi datasource trả success', () async {
      final models = [
        CategoryModel.fromJson(fakeCategoryJson(id: 1)),
        CategoryModel.fromJson(fakeCategoryJson(id: 2)),
      ];
      when(() => mockDatasource.getCategories())
          .thenAnswer((_) async => successResponse(models));

      final result = await repository.getCategories();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entities) {
          expect(entities.length, equals(2));
          expect(entities.first.categoryId, equals(1));
          expect(entities.last.categoryId, equals(2));
        },
      );
    });

    test('trả về empty list khi datasource trả content rỗng', () async {
      when(() => mockDatasource.getCategories())
          .thenAnswer((_) async => successResponse<List<CategoryModel>>([]));

      final result = await repository.getCategories();

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('Expected Right'), (entities) {
        expect(entities, isEmpty);
      });
    });

    test('trả về FailureEntity khi datasource trả unauthorized', () async {
      when(() => mockDatasource.getCategories())
          .thenAnswer((_) async => errorResponse<List<CategoryModel>>(unauthorizedResponse()));

      final result = await repository.getCategories();

      expect(result.isLeft(), isTrue);
    });

    test('trả về FailureEntity khi datasource trả notFound', () async {
      when(() => mockDatasource.getCategories())
          .thenAnswer((_) async => errorResponse<List<CategoryModel>>(notFoundResponse()));

      final result = await repository.getCategories();

      expect(result.isLeft(), isTrue);
    });

    test('trả về FailureEntity khi datasource trả internalServerError', () async {
      when(() => mockDatasource.getCategories())
          .thenAnswer((_) async => errorResponse<List<CategoryModel>>(serverErrorResponse()));

      final result = await repository.getCategories();

      expect(result.isLeft(), isTrue);
    });

    test('trả về FailureEntity khi datasource trả responseParsing', () async {
      when(() => mockDatasource.getCategories())
          .thenAnswer((_) async => const ApiResponse.responseParsing());

      final result = await repository.getCategories();

      expect(result.isLeft(), isTrue);
    });
  });
}
