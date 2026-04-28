import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:events_app/feature/news/domain/entity/news_entity.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/news/domain/usecase/news_usecase.dart';
import 'package:events_app/feature/news/presentation/controller/news_detail_controller.dart';

class NewsDetailPage extends StatefulWidget {
  final NewsEntity news;

  const NewsDetailPage({super.key, required this.news});

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  late final NewsDetailController _ctrl;
  final ScrollController _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _ctrl = Get.put(NewsDetailController(
      claimNewsUsecase: networkGetIt<ClaimNewsUsecase>(),
      news: widget.news,
    ));
    _scrollCtrl.addListener(_onScroll);
    _ctrl.startReading();
  }

  void _onScroll() {
    _ctrl.onUserActivity();
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_onScroll);
    _scrollCtrl.dispose();
    Get.delete<NewsDetailController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          _ctrl.onUserActivity();
          return false;
        },
        child: Stack(
          children: [
            CustomScrollView(
              controller: _scrollCtrl,
              slivers: [
                _buildAppBar(),
                SliverToBoxAdapter(child: _buildContent()),
              ],
            ),
            if (_ctrl.canEarnCoin)
              Positioned(
                bottom: 24,
                right: 24,
                child: _buildCoinWidget(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.bookmark_border,
                color: Colors.white, size: 20),
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.share, color: Colors.white, size: 20),
          ),
          onPressed: () {},
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: widget.news.banner != null && widget.news.banner!.isNotEmpty
            ? Image.network(
                widget.news.banner!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildPlaceholderBanner(),
              )
            : _buildPlaceholderBanner(),
      ),
    );
  }

  Widget _buildPlaceholderBanner() {
    return Container(
      color: const Color(0xFFE8F4FD),
      child: const Center(
        child: Icon(Icons.newspaper, size: 60, color: Color(0xFF90CAF9)),
      ),
    );
  }

  Widget _buildContent() {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => _ctrl.onUserActivity(),
      onPanDown: (_) => _ctrl.onUserActivity(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tags row
            if (widget.news.tag != null && widget.news.tag!.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: widget.news.tag!
                    .split(',')
                    .where((t) => t.trim().isNotEmpty)
                    .map((t) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F2FD),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            t.trim(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF1976D2),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 12),
            ],

            // Title
            Text(
              widget.news.title ?? '',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A1A2E),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),

            // Metadata row
            Row(
              children: [
                if (widget.news.createdTime != null) ...[
                  Icon(Icons.access_time,
                      size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(
                    _formatTime(widget.news.createdTime!),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(width: 16),
                ],
                if (widget.news.viewCount != null) ...[
                  Icon(Icons.remove_red_eye_outlined,
                      size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(
                    '${_formatNumber(widget.news.viewCount!)} lượt xem',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // Body content
            Text(
              widget.news.content ?? '',
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.8,
                fontSize: 15,
                color: const Color(0xFF374151),
              ),
            ),

            // Target action
            if (widget.news.targetType != null && widget.news.targetId != null)
              _buildTargetAction() ?? const SizedBox.shrink(),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget? _buildTargetAction() {
    final targetType = widget.news.targetType;
    final targetId = widget.news.targetId;
    if (targetType == null || targetId == null) return null;

    IconData icon;
    String label;
    VoidCallback? onTap;

    switch (targetType) {
      case NewsTargetType.event:
        icon = Icons.event;
        label = 'Xem sự kiện';
        onTap = () {};
        break;
      case NewsTargetType.user:
        icon = Icons.person;
        label = 'Xem hồ sơ';
        onTap = () {};
        break;
      case NewsTargetType.externalUrl:
        icon = Icons.link;
        label = 'Truy cập liên kết';
        onTap = () {};
        break;
      case NewsTargetType.package:
        icon = Icons.inventory_2_outlined;
        label = 'Xem gói dịch vụ';
        onTap = () {};
        break;
      default:
        return null;
    }

    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildCoinWidget() {
    return Obx(() {
      final progress = _ctrl.progress.value;
      final secondsRemaining = _ctrl.secondsRemaining.value;
      final isIdle = _ctrl.isIdle.value;
      final isClaiming = _ctrl.isClaiming.value;
      final isExhausted = _ctrl.isExhausted.value;
      final sessionCoins = _ctrl.sessionCoins.value;
      final cooldownSec = _ctrl.cooldownSeconds.value;

      if (isExhausted) {
        return _buildExhaustedBadge();
      }

      return GestureDetector(
        onTap: () => _ctrl.claimManually(),
        onPanDown: (_) => _ctrl.onUserActivity(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (sessionCoins > 0)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9C4),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFFC107)),
                ),
                child: Text(
                  '+$sessionCoins E',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFE65100),
                  ),
                ),
              ),
            SizedBox(
              width: 68,
              height: 68,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background ring
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: 4,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation(Colors.grey.shade200),
                    ),
                  ),
                  // Progress ring
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 4,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation(
                        isIdle ? Colors.orange : const Color(0xFF10B981),
                      ),
                    ),
                  ),
                  // Center content
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'E',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color:
                              isIdle ? Colors.orange : const Color(0xFF10B981),
                        ),
                      ),
                      if (isIdle)
                        Icon(Icons.pause,
                            size: 10, color: Colors.orange.shade400)
                      else if (isClaiming)
                        const SizedBox(
                          width: 10,
                          height: 10,
                          child: CircularProgressIndicator(strokeWidth: 1.5),
                        )
                      else
                        Text(
                          '${secondsRemaining}s',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (cooldownSec > 0)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'CD: ${cooldownSec}s',
                  style: TextStyle(fontSize: 10, color: Colors.red.shade700),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildExhaustedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 16, color: Colors.grey.shade500),
          const SizedBox(width: 6),
          Text(
            'Hết coin',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  String _formatNumber(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }
}
