import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:events_app/feature/news/presentation/controller/news_page_controller.dart';
import 'package:events_app/feature/news/presentation/widget/news_card.dart';
import 'package:events_app/feature/news/presentation/page/news_detail_page.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late final NewsPageController _c;
  late final TextEditingController _searchCtrl;

  @override
  void initState() {
    super.initState();
    _c = Get.put(NewsPageController());
    _searchCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: SafeArea(
        child: Column(
          children: [
            // Header gradient
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF5BC0FF), Color(0xFF4A90E2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  const Text(
                    'Tin tức',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Search field
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchCtrl,
                          onChanged: (v) => _c.setQuery(v),
                          style: const TextStyle(color: Colors.black87),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Tìm kiếm tin tức...',
                            hintStyle: TextStyle(color: Colors.grey.shade500),
                            prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: Obx(() {
                              final q = _c.query.value;
                              if (q.isEmpty) return const SizedBox.shrink();
                              return IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchCtrl.clear();
                                  _c.setQuery('');
                                },
                              );
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Tab chips
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Obx(() {
                final idx = _c.selectedTab.value;
                return Row(
                  children: [
                    _tabChip('Tất cả', idx == 0, () => _c.setTab(0)),
                    const SizedBox(width: 8),
                    _tabChip('Nổi bật', idx == 1, () => _c.setTab(1)),
                    const SizedBox(width: 8),
                    _tabChip('Đã lưu', idx == 2, () => _c.setTab(2)),
                  ],
                );
              }),
            ),

            // News list
            Expanded(
              child: Obx(() {
                final isLoading = _c.isLoading.value;
                final list = _c.filtered;

                if (isLoading && list.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (list.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.newspaper, size: 60, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text(
                          'Không có tin tức',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => _c.loadNews(refresh: true),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollEndNotification &&
                          notification.metrics.extentAfter < 200) {
                        _c.loadMore();
                      }
                      return false;
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemBuilder: (context, index) {
                        if (index >= list.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        final item = list[index];
                        return NewsCard(
                          news: item,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => NewsDetailPage(news: item),
                            ),
                          ),
                          onBookmark: () => _c.toggleSaved(item.newsId ?? 0),
                          isSaved: _c.isSaved(item.newsId ?? 0),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemCount: list.length + (_c.hasMore ? 1 : 0),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabChip(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? Colors.transparent : Colors.grey.shade300,
          ),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.black : Colors.grey.shade600,
            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
