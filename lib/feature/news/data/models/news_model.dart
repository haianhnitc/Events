class NewsModel {
  final int id;
  final String title;
  final String excerpt;
  final String image; // asset path
  final String category;
  final String timeAgo; // e.g. '2 giờ trước'
  final int views;
  final bool featured;
  // richer fields
  final String author;
  final String publishedAt; // ISO or readable
  final String content;
  final int readingTime; // minutes
  final List<String> tags;

  NewsModel({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.image,
    required this.category,
    required this.timeAgo,
    required this.views,
    this.featured = false,
    this.author = '',
    this.publishedAt = '',
    this.content = '',
    this.readingTime = 0,
    this.tags = const [],
  });

  factory NewsModel.fromMap(Map<String, dynamic> m) => NewsModel(
        id: m['id'] as int,
        title: m['title'] as String,
        excerpt: m['excerpt'] as String,
        image: m['image'] as String,
        category: m['category'] as String,
        timeAgo: m['timeAgo'] as String,
        views: (m['views'] as num).toInt(),
        featured: (m['featured'] is bool) ? m['featured'] as bool : false,
        author: m['author']?.toString() ?? '',
        publishedAt: m['publishedAt']?.toString() ?? '',
        content: m['content']?.toString() ?? '',
        readingTime:
            (m['readingTime'] is num) ? (m['readingTime'] as num).toInt() : 0,
        tags: (m['tags'] is List)
            ? (m['tags'] as List).map((e) => e.toString()).toList()
            : const [],
      );
}
