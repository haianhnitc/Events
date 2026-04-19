import 'package:flutter/material.dart';
import 'package:events_app/feature/news/domain/entity/news_entity.dart';

class NewsCard extends StatelessWidget {
  final NewsEntity news;
  final VoidCallback? onTap;
  final VoidCallback? onBookmark;
  final bool isSaved;
  final bool hideBookmark;

  const NewsCard({
    super.key,
    required this.news,
    this.onTap,
    this.onBookmark,
    this.isSaved = false,
    this.hideBookmark = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner image + overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: SizedBox(
                    height: 160,
                    width: double.infinity,
                    child: news.banner != null && news.banner!.isNotEmpty
                        ? Image.network(
                            news.banner!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _buildPlaceholder(),
                          )
                        : _buildPlaceholder(),
                  ),
                ),
                // Coin badge (top-left)
                if ((news.rewardPerMinute ?? 0) > 0)
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.monetization_on,
                              size: 12, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            '+${news.rewardPerMinute}/phút',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Exhausted badge
                if ((news.remainingRewardCoin ?? 0) <= 0)
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Hết coin',
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                  ),
                // Bookmark button (top-right)
                if (!hideBookmark)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Material(
                      color: Colors.white.withValues(alpha: 0.8),
                      shape: const CircleBorder(),
                      child: IconButton(
                        icon: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: isSaved ? const Color(0xFF1976D2) : Colors.grey.shade700,
                        ),
                        iconSize: 22,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 36, minHeight: 36),
                        onPressed: onBookmark,
                      ),
                    ),
                  ),
              ],
            ),

            // Card body
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tag chips
                  if (news.tag != null && news.tag!.isNotEmpty) ...[
                    Text(
                      news.tag!.split(',').first.trim(),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF1976D2),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                  ],

                  // Title
                  Text(
                    news.title ?? '',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Content excerpt
                  if (news.content != null && news.content!.isNotEmpty) ...[
                    Text(
                      _stripHtml(news.content!),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                  ],

                  // Footer row
                  Row(
                    children: [
                      if (news.createdTime != null) ...[
                        Icon(Icons.access_time, size: 13, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(
                          _formatTime(news.createdTime!),
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                        const SizedBox(width: 12),
                      ],
                      if (news.viewCount != null) ...[
                        Icon(Icons.remove_red_eye_outlined,
                            size: 13, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(
                          _formatNumber(news.viewCount!),
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                      const Spacer(),
                      Icon(Icons.share, size: 16, color: Colors.grey.shade400),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFE8F4FD),
      child: const Center(
        child: Icon(Icons.newspaper, size: 40, color: Color(0xFF90CAF9)),
      ),
    );
  }

  String _stripHtml(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
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
