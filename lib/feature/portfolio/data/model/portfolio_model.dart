import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/portfolio_entity.dart';

part 'portfolio_model.freezed.dart';
part 'portfolio_model.g.dart';

@freezed
class PortfolioModel with _$PortfolioModel {
  const factory PortfolioModel({
    int? portfolioId,
    int? userId,
    int? price,
    String? title,
    String? description,
    String? portfolioCode,
    bool? isPublished,
    int? viewCount,
    int? downloadCount,
    DateTime? createdTime,
    DateTime? publishTime,
  }) = _PortfolioModel;

  factory PortfolioModel.fromJson(Map<String, dynamic> json) =>
      _$PortfolioModelFromJson(json);

  factory PortfolioModel.fromEntity(PortfolioEntity entity) {
    return PortfolioModel(
      portfolioId: entity.portfolioId,
      userId: entity.userId,
      price: entity.price,
      title: entity.title,
      description: entity.description,
      portfolioCode: entity.portfolioCode,
      isPublished: entity.isPublished,
      viewCount: entity.viewCount,
      downloadCount: entity.downloadCount,
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
      createdTime: createdTime,
      publishTime: publishTime,
    );
  }
}
