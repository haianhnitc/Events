import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/feature/news/data/datasource/news_datasource.dart';
import 'package:events_app/feature/news/data/model/news_model.dart';
import 'package:events_app/feature/news/data/repository/news_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/fake_data.dart';
import '../helpers/mock_rest_client.dart';

class MockNewsDatasource extends Mock implements NewsDatasource {}

void main() {
  late MockNewsDatasource mockDatasource;
  late NewsRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockNewsDatasource();
    repository = NewsRepositoryImpl(mockDatasource);
  });

  // ─── getNewsList ───────────────────────────────────────────────────────────
  group('getNewsList', () {
    test('trả về list news entity khi datasource trả success', () async {
      final models = [
        NewsModel.fromJson(fakeNewsJson(id: 1)),
        NewsModel.fromJson(fakeNewsJson(id: 2)),
      ];
      when(() => mockDatasource.getNewsList(
            page: any(named: 'page'),
            size: any(named: 'size'),
            keyword: any(named: 'keyword'),
          )).thenAnswer((_) async => successResponse(models));

      final result = await repository.getNewsList();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entities) {
          expect(entities.length, equals(2));
          expect(entities.first.newsId, equals(1));
          expect(entities.last.newsId, equals(2));
        },
      );
    });

    test('trả về empty list khi datasource trả success với content rỗng', () async {
      when(() => mockDatasource.getNewsList(
            page: any(named: 'page'),
            size: any(named: 'size'),
            keyword: any(named: 'keyword'),
          )).thenAnswer((_) async => successResponse<List<NewsModel>>([]));

      final result = await repository.getNewsList();

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('Expected Right'), (entities) {
        expect(entities, isEmpty);
      });
    });

    test('trả về FailureEntity khi datasource trả unauthorized', () async {
      when(() => mockDatasource.getNewsList(
            page: any(named: 'page'),
            size: any(named: 'size'),
            keyword: any(named: 'keyword'),
          )).thenAnswer(
          (_) async => errorResponse<List<NewsModel>>(unauthorizedResponse()));

      final result = await repository.getNewsList();

      expect(result.isLeft(), isTrue);
    });

    test('trả về FailureEntity khi datasource trả notFound', () async {
      when(() => mockDatasource.getNewsList(
            page: any(named: 'page'),
            size: any(named: 'size'),
            keyword: any(named: 'keyword'),
          )).thenAnswer(
          (_) async => errorResponse<List<NewsModel>>(notFoundResponse()));

      final result = await repository.getNewsList();

      expect(result.isLeft(), isTrue);
    });

    test('trả về FailureEntity khi datasource trả internalServerError', () async {
      when(() => mockDatasource.getNewsList(
            page: any(named: 'page'),
            size: any(named: 'size'),
            keyword: any(named: 'keyword'),
          )).thenAnswer(
          (_) async => errorResponse<List<NewsModel>>(serverErrorResponse()));

      final result = await repository.getNewsList();

      expect(result.isLeft(), isTrue);
    });

    test('truyền đúng params xuống datasource', () async {
      when(() => mockDatasource.getNewsList(
            page: 2,
            size: 10,
            keyword: 'concert',
          )).thenAnswer((_) async => successResponse<List<NewsModel>>([]));

      await repository.getNewsList(page: 2, size: 10, keyword: 'concert');

      verify(() => mockDatasource.getNewsList(
            page: 2,
            size: 10,
            keyword: 'concert',
          )).called(1);
    });
  });

  // ─── getNewsById ──────────────────────────────────────────────────────────
  group('getNewsById', () {
    test('trả về news entity khi datasource trả success', () async {
      final model = NewsModel.fromJson(fakeNewsJson(id: 99));
      when(() => mockDatasource.getNewsById(99))
          .thenAnswer((_) async => successResponse(model));

      final result = await repository.getNewsById(99);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) => expect(entity.newsId, equals(99)),
      );
    });

    test('trả về FailureEntity khi datasource trả notFound', () async {
      when(() => mockDatasource.getNewsById(9999)).thenAnswer(
          (_) async => errorResponse<NewsModel>(notFoundResponse()));

      final result = await repository.getNewsById(9999);

      expect(result.isLeft(), isTrue);
    });

    test('trả về FailureEntity khi datasource trả unauthorized', () async {
      when(() => mockDatasource.getNewsById(1)).thenAnswer(
          (_) async => errorResponse<NewsModel>(unauthorizedResponse()));

      final result = await repository.getNewsById(1);

      expect(result.isLeft(), isTrue);
    });

    test('trả về FailureEntity khi datasource trả responseParsing', () async {
      when(() => mockDatasource.getNewsById(1)).thenAnswer(
          (_) async => errorResponse<NewsModel>(const ApiResponse.responseParsing()));

      final result = await repository.getNewsById(1);

      expect(result.isLeft(), isTrue);
    });
  });
}
