import 'package:flutter/material.dart';
import 'package:events_app/feature/news/data/models/news_model.dart';

class NewsDetailPage extends StatelessWidget {
  final NewsModel news;

  const NewsDetailPage({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Image header
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(14)),
                    child: Image.asset(
                      news.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                Positioned(
                  left: 8,
                  top: 8,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),

            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Metadata: left chip, right two-row info
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Chip(label: Text(news.category)),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                        child: Text(news.timeAgo,
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                                    color: Colors.black54),
                                            overflow: TextOverflow.ellipsis)),
                                    const SizedBox(width: 8),
                                    if (news.author.isNotEmpty)
                                      Flexible(
                                          child: Text('• ${news.author}',
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                      color: Colors.black54),
                                              overflow: TextOverflow.ellipsis)),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.remove_red_eye_outlined,
                                        size: 16, color: Colors.black45),
                                    const SizedBox(width: 6),
                                    Flexible(
                                        child: Text('${news.views}',
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                                    color: Colors.black54),
                                            overflow: TextOverflow.ellipsis)),
                                    const SizedBox(width: 12),
                                    if (news.readingTime > 0)
                                      Flexible(
                                          child: Text(
                                              '${news.readingTime} min đọc',
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                      color: Colors.black54),
                                              overflow: TextOverflow.ellipsis)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Text(news.title,
                          style: theme.textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 12),

                      // Body content
                      if (news.excerpt.isNotEmpty) ...[
                        Text(news.excerpt, style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 12),
                      ],
                      if (news.content.isNotEmpty)
                        Text(news.content,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(height: 1.6)),
                      const SizedBox(height: 18),
                      if (news.tags.isNotEmpty) ...[
                        Wrap(
                            spacing: 8,
                            children: news.tags
                                .map((t) => Chip(label: Text(t)))
                                .toList()),
                        const SizedBox(height: 12),
                      ],

                      const SizedBox(height: 22),
                      Row(
                        children: [
                          OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.bookmark_border),
                              label: const Text('Lưu')),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.share),
                              label: const Text('Chia sẻ')),
                          const Spacer(),
                          if (news.publishedAt.isNotEmpty)
                            Text(news.publishedAt,
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(color: Colors.black26)),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
