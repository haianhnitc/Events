import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:events_app/feature/user_management/data/model/user_summary_model.dart';
import '../../domain/entity/portfolio_entity.dart';
import 'portfolio_event_model.dart';

part 'portfolio_model.freezed.dart';
part 'portfolio_model.g.dart';

@freezed
class PortfolioModel with _$PortfolioModel {
  const factory PortfolioModel({
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
    List<PortfolioItemModel>? items,
    DateTime? createdTime,
    DateTime? publishTime,
  }) = _PortfolioModel;

  factory PortfolioModel.fromJson(Map<String, dynamic> json) =>
      _$PortfolioModelFromJson(json);

  factory PortfolioModel.fromEntity(PortfolioEntity entity) {
    return PortfolioModel(
      portfolioId: entity.portfolioId,
      user: entity.user != null
          ? UserSummaryModel.fromEntity(entity.user!)
          : null,
      userId: entity.userId,
      price: entity.price,
      title: entity.title,
      description: entity.description,
      portfolioCode: entity.portfolioCode,
      isPublished: entity.isPublished,
      viewCount: entity.viewCount,
      downloadCount: entity.downloadCount,
      thumbnail: entity.thumbnail,
      itemCount: entity.itemCount,
      items: entity.items?.map((e) => PortfolioItemModel.fromEntity(e)).toList(),
      createdTime: entity.createdTime,
      publishTime: entity.publishTime,
    );
  }
}

extension PortfolioModelExtension on PortfolioModel {
  PortfolioEntity toEntity() {
    return PortfolioEntity(
      portfolioId: portfolioId,
      userId: userId,
      price: price,
      title: title,
      description: description,
      portfolioCode: portfolioCode,
      isPublished: isPublished,
      viewCount: viewCount,
      downloadCount: downloadCount,
      thumbnail: thumbnail,
      itemCount: itemCount,
      items: items?.map((e) => e.toEntity()).toList(),
      createdTime: createdTime,
      publishTime: publishTime,
    );
  }
}
