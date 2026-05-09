import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/feature/news/domain/entity/news_entity.dart';
import 'package:events_app/feature/news/domain/usecase/news_usecase.dart';
import 'package:get/get.dart';

class NewsPageController extends GetxController {
  NewsPageController({GetNewsListUsecase? getNewsListUsecase})
      : _getNewsListUsecase = getNewsListUsecase ?? networkGetIt<GetNewsListUsecase>();

  final GetNewsListUsecase _getNewsListUsecase;

  final RxList<NewsEntity> all = <NewsEntity>[].obs;
  final RxString query = ''.obs;
  final RxInt selectedTab = 0.obs;
  final RxSet<int> saved = <int>{}.obs;
  final RxBool isLoading = false.obs;

  final int _pageSize = 20;
  int currentPage = 0;
  bool hasMore = true;

  @override
  void onInit() {
    super.onInit();
    loadNews();
  }

  Future<void> loadNews({bool refresh = false}) async {
    if (isLoading.value) return;

    if (refresh) {
      currentPage = 0;
      hasMore = true;
      all.clear();
    }

    if (!hasMore && !refresh) return;

    isLoading.value = true;

    final result = await _getNewsListUsecase(
      GetNewsListParams(
        page: currentPage,
        size: _pageSize,
        keyword: query.value.isEmpty ? null : query.value,
      ),
    );

    result.fold(
      (failure) {
        _handleFailure(failure);
        isLoading.value = false;
      },
      (data) {
        if (data.isEmpty) {
          hasMore = false;
        } else {
          if (refresh) {
            all.clear();
          }
          all.addAll(data);
          currentPage++;
          hasMore = data.length >= _pageSize;
        }
        isLoading.value = false;
      },
    );
  }

  void loadMore() {
    if (isLoading.value || !hasMore) return;
    loadNews();
  }

  void setQuery(String q) {
    query.value = q.trim().toLowerCase();
    loadNews(refresh: true);
  }

  void setTab(int i) {
    selectedTab.value = i;
  }

  void toggleSaved(int? id) {
    if (id == null) return;
    if (saved.contains(id)) {
      saved.remove(id);
    } else {
      saved.add(id);
    }
    saved.refresh();
  }

  bool isSaved(int? id) => id != null && saved.contains(id);

  List<NewsEntity> get filtered {
    final q = query.value.trim().toLowerCase();
    Iterable<NewsEntity> it = all;

    if (selectedTab.value == 1) {
      it = it.where((n) {
        try {
          return (n.tag ?? '').trim().toLowerCase().contains('featured') ||
              (n.tag ?? '').contains('nổi bật');
        } catch (_) {
          return false;
        }
      });
    } else if (selectedTab.value == 2) {
      it = it.where((n) => saved.contains(n.newsId ?? -1));
    }

    if (q.isNotEmpty) {
      it = it.where((n) =>
          (n.title ?? '').toLowerCase().contains(q) ||
          (n.content ?? '').toLowerCase().contains(q) ||
          (n.tag ?? '').toLowerCase().contains(q));
    }

    return it.toList();
  }

  void _handleFailure(FailureEntity failure) {
    AuthController.handleFailure(failure);
  }
}
