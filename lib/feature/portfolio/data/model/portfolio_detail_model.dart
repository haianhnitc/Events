export 'portfolio_event_model.dart' show PortfolioItemModel;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:events_app/feature/user_management/data/model/user_summary_model.dart';
import 'portfolio_event_model.dart';
import '../../domain/entity/portfolio_detail_entity.dart';

part 'portfolio_detail_model.freezed.dart';
part 'portfolio_detail_model.g.dart';

@freezed
class PortfolioDetailModel with _$PortfolioDetailModel {
  const factory PortfolioDetailModel({
    int? portfolioId,
    UserSummaryModel? user,
    int? userId,
    int? price,
    String? title,
    String? description,
    String? portfolioCode,
    bool? isPublished,
    int? viewCount,
    int? downloadCount,
    String? thumbnail,
    int? itemCount,
    DateTime? createdTime,
    DateTime? publishTime,
    List<PortfolioItemModel>? items,
  }) = _PortfolioDetailModel;

  factory PortfolioDetailModel.fromJson(Map<String, dynamic> json) =>
      _$PortfolioDetailModelFromJson(json);

  factory PortfolioDetailModel.fromEntity(PortfolioDetailEntity entity) {
    return PortfolioDetailModel(
      portfolioId: entity.portfolioId,
      user: entity.user != null
          ? UserSummaryModel.fromEntity(entity.user!)
          : null,
      userId: entity.userId,
      portfolioCode: entity.portfolioCode,
      price: entity.price,
      title: entity.title,
      description: entity.description,
      isPublished: entity.isPublished,
      createdTime: entity.createdTime,
      publishTime: entity.publishTime,
      viewCount: entity.viewCount,
      downloadCount: entity.downloadCount,
      thumbnail: entity.thumbnail,
      itemCount: entity.itemCount,
      items: entity.items
          ?.map((e) => PortfolioItemModel.fromEntity(e))
          .toList(),
    );
  }
}

extension PortfolioDetailModelExtension on PortfolioDetailModel {
  PortfolioDetailEntity toEntity() {
    return PortfolioDetailEntity(
      portfolioId: portfolioId,
      user: user?.toEntity(),
      userId: userId,
      portfolioCode: portfolioCode,
      title: title,
      description: description,
      isPublished: isPublished,
      createdTime: createdTime,
      publishTime: publishTime,
      viewCount: viewCount,
      downloadCount: downloadCount,
      price: price,
      thumbnail: thumbnail,
      itemCount: itemCount,
      items: items?.map((e) => e.toEntity()).toList(),
    );
  }
}
