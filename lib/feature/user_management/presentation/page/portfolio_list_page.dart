import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:events_app/feature/user_management/presentation/controller/portfolio_list_controller.dart';
import 'package:events_app/feature/user_management/presentation/page/portfolio_detail_page.dart';

class PortfolioListPage extends StatefulWidget {
  const PortfolioListPage({super.key});

  @override
  State<PortfolioListPage> createState() => _PortfolioListPageState();
}

class _PortfolioListPageState extends State<PortfolioListPage>
    with SingleTickerProviderStateMixin {
  late final PortfolioListController ctrl;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    ctrl = Get.put(PortfolioListController());
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      ctrl.onTabChanged(_tabController.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff64748B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Hồ sơ hoạt động',
          style: TextStyle(
            color: Color(0xff273143),
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF06B6D4),
          unselectedLabelColor: Colors.grey.shade600,
          indicatorColor: const Color(0xFF06B6D4),
          labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          tabs: [
            Obx(() => Tab(text: 'Đã xuất bản (${ctrl.publishedPortfolios.length})')),
            Obx(() => Tab(text: 'Nháp (${ctrl.draftPortfolios.length})')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPublishedTab(),
          _buildDraftsTab(),
        ],
      ),
    );
  }

  Widget _buildPublishedTab() {
    return Obx(() {
      if (ctrl.isLoadingPublished.value && ctrl.publishedPortfolios.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF06B6D4)),
        );
      }

      if (ctrl.publishedPortfolios.isEmpty) {
        return _buildEmptyState(
          'Chưa có hồ sơ nào',
          'Các hồ sơ đã xuất bản sẽ hiển thị ở đây.',
          Icons.folder_off_outlined,
        );
      }

      return RefreshIndicator(
        onRefresh: () => ctrl.loadPublished(refresh: true),
        notificationPredicate: (notification) => notification.depth == 1,
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollEndNotification &&
                notification.metrics.extentAfter < 80 &&
                ctrl.publishedPortfolios.isNotEmpty &&
                !ctrl.isLoadingPublished.value &&
                ctrl.hasMorePublished.value) {
              ctrl.loadPublished();
            }
            return false;
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ctrl.publishedPortfolios.length +
                (ctrl.hasMorePublished.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= ctrl.publishedPortfolios.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(color: Color(0xFF06B6D4)),
                  ),
                );
              }
              return _buildPortfolioItem(ctrl.publishedPortfolios[index], published: true);
            },
          ),
        ),
      );
    });
  }

  Widget _buildDraftsTab() {
    return Obx(() {
      if (ctrl.isLoadingDrafts.value && ctrl.draftPortfolios.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF06B6D4)),
        );
      }

      if (ctrl.draftPortfolios.isEmpty) {
        return _buildEmptyState(
          'Không có bản nháp',
          'Các hồ sơ chưa xuất bản sẽ hiển thị ở đây.',
          Icons.edit_note_outlined,
        );
      }

      return RefreshIndicator(
        onRefresh: () => ctrl.loadDrafts(refresh: true),
        notificationPredicate: (notification) => notification.depth == 1,
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollEndNotification &&
                notification.metrics.extentAfter < 80 &&
                ctrl.draftPortfolios.isNotEmpty &&
                !ctrl.isLoadingDrafts.value &&
                ctrl.hasMoreDrafts.value) {
              ctrl.loadDrafts();
            }
            return false;
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ctrl.draftPortfolios.length +
                (ctrl.hasMoreDrafts.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= ctrl.draftPortfolios.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(color: Color(0xFF06B6D4)),
                  ),
                );
              }
              return _buildPortfolioItem(ctrl.draftPortfolios[index], published: false);
            },
          ),
        ),
      );
    });
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioItem(portfolio, {required bool published}) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PortfolioDetailPage(portfolioId: portfolio.portfolioId!),
        ),
      ).then((_) => ctrl.loadAll()),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF06B6D4).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: portfolio.thumbnail != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            portfolio.thumbnail!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.folder_rounded,
                              color: Color(0xFF06B6D4),
                              size: 24,
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.folder_rounded,
                          color: Color(0xFF06B6D4),
                          size: 24,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        portfolio.title ?? 'Không có tiêu đề',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff273143),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _buildStatChip(
                            Icons.visibility_outlined,
                            '${portfolio.viewCount ?? 0}',
                          ),
                          const SizedBox(width: 8),
                          _buildStatChip(
                            Icons.download_outlined,
                            '${portfolio.downloadCount ?? 0}',
                          ),
                          if (portfolio.itemCount != null) ...[
                            const SizedBox(width: 8),
                            _buildStatChip(
                              Icons.event_rounded,
                              '${portfolio.itemCount}',
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: published
                        ? Colors.green.shade50
                        : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    published ? 'Công khai' : 'Nháp',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: published
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
                    ),
                  ),
                ),
              ],
            ),
            if (portfolio.description != null &&
                portfolio.description!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                portfolio.description!,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 8),
            Text(
              _formatTimeAgo(portfolio.createdTime),
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xff67688C)),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xff67688C),
          ),
        ),
      ],
    );
  }

  String _formatTimeAgo(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 30) return '${(diff.inDays / 30).floor()} tháng trước';
    if (diff.inDays > 0) return '${diff.inDays} ngày trước';
    if (diff.inHours > 0) return '${diff.inHours} giờ trước';
    if (diff.inMinutes > 0) return '${diff.inMinutes} phút trước';
    return 'Vừa xong';
  }
}
