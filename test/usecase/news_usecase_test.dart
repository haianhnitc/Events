import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/news/domain/entity/news_entity.dart';
import 'package:events_app/feature/news/domain/repository/news_repository.dart';
import 'package:events_app/feature/news/domain/usecase/news_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

class FakeGetNewsListParams extends Fake implements GetNewsListParams {}

void main() {
  late MockNewsRepository mockRepository;
  late GetNewsListUsecase getNewsListUsecase;
  late GetNewsByIdUsecase getNewsByIdUsecase;

  setUpAll(() {
    registerFallbackValue(FakeGetNewsListParams());
    registerFallbackValue(0);
  });

  setUp(() {
    mockRepository = MockNewsRepository();
    getNewsListUsecase = GetNewsListUsecase(mockRepository);
    getNewsByIdUsecase = GetNewsByIdUsecase(mockRepository);
  });

  // ─── GetNewsListUsecase ───────────────────────────────────────────────────
  group('GetNewsListUsecase', () {
    test('trả về list news entity khi repository thành công', () async {
      final entities = [
        NewsEntity(newsId: 1, title: 'News 1'),
        NewsEntity(newsId: 2, title: 'News 2'),
      ];
      when(() => mockRepository.getNewsList(
            page: any(named: 'page'),
            size: any(named: 'size'),
            keyword: any(named: 'keyword'),
          )).thenAnswer((_) async => Right(entities));

      final result = await getNewsListUsecase(const GetNewsListParams(
        page: 0,
        size: 20,
        keyword: 'test',
      ));

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (news) {
          expect(news.length, equals(2));
          expect(news.first.newsId, equals(1));
        },
      );
      verify(() => mockRepository.getNewsList(
            page: 0,
            size: 20,
            keyword: 'test',
          )).called(1);
    });

    test('trả về failure khi repository thất bại', () async {
      when(() => mockRepository.getNewsList(
            page: any(named: 'page'),
            size: any(named: 'size'),
            keyword: any(named: 'keyword'),
          )).thenAnswer((_) async =>
              const Left(FailureEntity.serverFailure('500', 'Server error')));

      final result = await getNewsListUsecase(const GetNewsListParams());

      expect(result.isLeft(), isTrue);
    });

    test('trả về empty list khi repository trả rỗng', () async {
      when(() => mockRepository.getNewsList(
            page: any(named: 'page'),
            size: any(named: 'size'),
            keyword: any(named: 'keyword'),
          )).thenAnswer((_) async => const Right([]));

      final result = await getNewsListUsecase(const GetNewsListParams());

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (news) => expect(news, isEmpty),
      );
    });
  });

  // ─── GetNewsByIdUsecase ───────────────────────────────────────────────────
  group('GetNewsByIdUsecase', () {
    test('trả về news entity khi repository thành công', () async {
      final entity = NewsEntity(newsId: 10, title: 'News 10');
      when(() => mockRepository.getNewsById(10))
          .thenAnswer((_) async => Right(entity));

      final result = await getNewsByIdUsecase(10);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (news) => expect(news.newsId, equals(10)),
      );
    });

    test('trả về failure khi repository trả notFound', () async {
      when(() => mockRepository.getNewsById(9999))
          .thenAnswer((_) async =>
              const Left(FailureEntity.serverFailure('404', 'Not found')));

      final result = await getNewsByIdUsecase(9999);

      expect(result.isLeft(), isTrue);
    });

    test('trả về failure khi repository trả dataParsingFailure', () async {
      when(() => mockRepository.getNewsById(1))
          .thenAnswer((_) async =>
              const Left(FailureEntity.dataParsingFailure()));

      final result = await getNewsByIdUsecase(1);

      expect(result.isLeft(), isTrue);
    });
  });
}
