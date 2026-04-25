import 'package:events_app/feature/user_management/domain/entity/user_summary_entity.dart';
import 'portfolio_event_entity.dart';

class PortfolioEntity {
  final int? portfolioId;
  final int? userId;
  final UserSummaryEntity? user;
  final String? portfolioCode;
  final int? price;
  final String? title;
  final String? description;
  final bool? isPublished;
  final int? viewCount;
  final int? downloadCount;
  final String? thumbnail;
  final int? itemCount;
  final List<PortfolioEventEntity>? items;
  final DateTime? createdTime;
  final DateTime? publishTime;

  PortfolioEntity({
    this.portfolioId,
    this.userId,
    this.user,
    this.portfolioCode,
    this.price,
    this.title,
    this.description,
    this.isPublished,
    this.viewCount,
    this.downloadCount,
    this.thumbnail,
    this.itemCount,
    this.items,
    this.createdTime,
    this.publishTime,
  });
}
