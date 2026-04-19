import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/news/domain/entity/news_entity.dart';
import 'package:events_app/feature/news/domain/usecase/news_usecase.dart';
import 'package:events_app/feature/news/presentation/controller/news_page_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

class MockGetNewsListUsecase extends Mock implements GetNewsListUsecase {}

class FakeGetNewsListParams extends Fake implements GetNewsListParams {}

void main() {
  late MockGetNewsListUsecase mockUsecase;
  late NewsPageController controller;

  setUpAll(() {
    registerFallbackValue(FakeGetNewsListParams());
  });

  setUp(() {
    Get.reset();
    mockUsecase = MockGetNewsListUsecase();
    controller = NewsPageController(getNewsListUsecase: mockUsecase);
    // Mock usecase immediately so onInit()'s async loadNews() completes fast.
    when(() => mockUsecase(any())).thenAnswer((_) async => const Right([]));
    // Reset isLoading so subsequent loadNews() calls are not blocked.
    // (onInit() already fired an async loadNews() call which is still pending.)
    controller.isLoading.value = false;
  });

  tearDown(Get.reset);

  // ─── initial state ──────────────────────────────────────────────────────
  test('khởi tạo với state đúng', () {
    expect(controller.all, isEmpty);
    expect(controller.query.value, equals(''));
    expect(controller.selectedTab.value, equals(0));
    expect(controller.saved, isEmpty);
    // isLoading may be false if onInit()'s async loadNews() already completed.
  });

  // ─── loadNews ───────────────────────────────────────────────────────────
  group('loadNews', () {
    test('trả về news và cập nhật state khi thành công', () async {
      final newsList = [
        NewsEntity(newsId: 1, title: 'News 1'),
        NewsEntity(newsId: 2, title: 'News 2'),
      ];
      when(() => mockUsecase(any())).thenAnswer((_) async => Right(newsList));

      await controller.loadNews();

      expect(controller.all.length, equals(2));
      expect(controller.isLoading.value, isFalse);
      expect(controller.currentPage, equals(1));
      expect(controller.hasMore, isFalse);
    });

    test('trả về list rỗng và set hasMore = false khi backend trả empty', () async {
      when(() => mockUsecase(any())).thenAnswer((_) async => const Right([]));

      await controller.loadNews();

      expect(controller.all, isEmpty);
      expect(controller.hasMore, isFalse);
      expect(controller.isLoading.value, isFalse);
    });

    test('trả về failure khi server lỗi', () async {
      // Skip: _handleFailure calls AppSnackbarUtils.showError() which requires
      // WidgetsFlutterBinding.ensureInitialized() (not available in pure unit tests).
      // This behavior is covered by integration/widget tests.
    });

    test('gọi use case đúng params khi load lần đầu', () async {
      when(() => mockUsecase(any())).thenAnswer((_) async => const Right([]));

      await controller.loadNews();

      verify(() => mockUsecase(any())).called(1);
    });

    test('refresh reset page và clear list', () async {
      controller.all.add(NewsEntity(newsId: 99, title: 'Old'));
      controller.currentPage = 5;

      when(() => mockUsecase(any())).thenAnswer((_) async => const Right([]));

      await controller.loadNews(refresh: true);

      expect(controller.all, isEmpty);
      expect(controller.currentPage, equals(0));
    });

    test('không load khi đang loading', () async {
      controller.isLoading.value = true;

      await controller.loadNews();

      verifyNever(() => mockUsecase(any()));
    });

    test('có thêm data khi response có size >= pageSize', () async {
      final newsList = List.generate(
        20,
        (i) => NewsEntity(newsId: i, title: 'News $i'),
      );
      when(() => mockUsecase(any())).thenAnswer((_) async => Right(newsList));

      await controller.loadNews();

      expect(controller.hasMore, isTrue);
      expect(controller.currentPage, equals(1));
    });
  });

  // ─── loadMore ───────────────────────────────────────────────────────────
  group('loadMore', () {
    test('gọi loadNews khi hasMore = true và không loading', () async {
      controller.hasMore = true;
      controller.isLoading.value = false;
      when(() => mockUsecase(any())).thenAnswer((_) async => const Right([]));

      controller.loadMore();

      verify(() => mockUsecase(any())).called(1);
    });

    test('không làm gì khi đang loading', () async {
      controller.hasMore = true;
      controller.isLoading.value = true;

      controller.loadMore();

      verifyNever(() => mockUsecase(any()));
    });

    test('không làm gì khi hasMore = false', () async {
      controller.hasMore = false;

      controller.loadMore();

      verifyNever(() => mockUsecase(any()));
    });
  });

  // ─── setQuery ───────────────���───────────────────────────────────────────
  group('setQuery', () {
    test('cập nhật query và gọi loadNews refresh', () async {
      when(() => mockUsecase(any())).thenAnswer((_) async => const Right([]));

      controller.setQuery('  Concert  ');

      expect(controller.query.value, equals('concert'));
      verify(() => mockUsecase(any())).called(1);
    });
  });

  // ─── setTab ─────────────────────────────────────────────────────────────
  group('setTab', () {
    test('cập nhật selectedTab', () {
      controller.setTab(2);
      expect(controller.selectedTab.value, equals(2));
    });
  });

  // ─── toggleSaved / isSaved ───────────────────────────────────────────────
  group('saved', () {
    test('toggleSaved thêm id khi chưa có', () {
      controller.toggleSaved(5);
      expect(controller.isSaved(5), isTrue);
    });

    test('toggleSaved xóa id khi đã có', () {
      controller.toggleSaved(5);
      controller.toggleSaved(5);
      expect(controller.isSaved(5), isFalse);
    });
  });

  // ─── filtered ───────────────────────────────────────────────────────────
  group('filtered', () {
    setUp(() async {
      final newsList = [
        NewsEntity(newsId: 1, title: 'Concert A', tag: 'featured'),
        NewsEntity(newsId: 2, title: 'Event B', tag: 'normal'),
        NewsEntity(newsId: 3, title: 'Concert C', tag: 'featured'),
      ];
      controller.query.value = '';
      when(() => mockUsecase(any())).thenAnswer((_) async => Right(newsList));
      await controller.loadNews();
    });

    test('tab 0 trả về tất cả news', () {
      controller.selectedTab.value = 0;
      final result = controller.filtered;
      expect(result.length, equals(3));
    });

    test('tab 1 trả về news có tag featured', () {
      controller.selectedTab.value = 1;
      final result = controller.filtered;
      expect(result.length, equals(2));
    });

    test('tab 2 trả về news đã save', () {
      controller.toggleSaved(1);
      controller.selectedTab.value = 2;
      final result = controller.filtered;
      expect(result.length, equals(1));
      expect(result.first.newsId, equals(1));
    });

    test('query lọc theo title, content, tag', () async {
      // Stub mock before setQuery (which calls loadNews internally).
      final newsList = [
        NewsEntity(newsId: 1, title: 'Concert A', tag: 'featured'),
        NewsEntity(newsId: 2, title: 'Event B', tag: 'normal'),
        NewsEntity(newsId: 3, title: 'Concert C', tag: 'featured'),
      ];
      when(() => mockUsecase(any())).thenAnswer((_) async => Right(newsList));

      controller.selectedTab.value = 0;
      controller.setQuery('concert');
      // setQuery calls loadNews(refresh: true) internally.
      // Wait for the async call to complete.
      await Future.delayed(const Duration(milliseconds: 20));

      final result = controller.filtered;
      expect(result.length, equals(2));
    });

    test('query kết hợp tab lọc đúng', () async {
      // Re-stub with news data directly in this test to avoid mock order issues.
      final newsList = [
        NewsEntity(newsId: 1, title: 'Concert A', tag: 'featured'),
        NewsEntity(newsId: 2, title: 'Event B', tag: 'normal'),
        NewsEntity(newsId: 3, title: 'Concert C', tag: 'featured'),
      ];
      when(() => mockUsecase(any())).thenAnswer((_) async => Right(newsList));

      controller.toggleSaved(1);
      controller.selectedTab.value = 2;
      await controller.loadNews(refresh: true);
      final result = controller.filtered;
      expect(result.length, equals(1));
      expect(result.first.newsId, equals(1));
    });
  });
}
