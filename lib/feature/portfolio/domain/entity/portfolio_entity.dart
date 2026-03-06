class PortfolioEntity {
  final int? portfolioId;
  final int? userId;
  final String? portfolioCode;
  final String? title;
  final String? description;
  final bool? isPublished;
  final int? viewCount;
  final int? downloadCount;
  final int? price;
  final DateTime? createdTime;
  final DateTime? publishTime;

  PortfolioEntity({
    this.portfolioId,
    this.userId,
    this.portfolioCode,
    this.title,
    this.description,
    this.isPublished,
    this.viewCount,
    this.downloadCount,
    this.price,
    this.createdTime,
    this.publishTime,
  });
}
