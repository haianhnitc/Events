import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/portfolio_event_entity.dart';

part 'portfolio_event_model.freezed.dart';
part 'portfolio_event_model.g.dart';

@freezed
class PortfolioEventModel with _$PortfolioEventModel {
  const factory PortfolioEventModel({
    int? portfolioId,
    int? eventId,
  }) = _PortfolioEventModel;

  factory PortfolioEventModel.fromJson(Map<String, dynamic> json) =>
      _$PortfolioEventModelFromJson(json);

  factory PortfolioEventModel.fromEntity(PortfolioEventEntity entity) {
    return PortfolioEventModel(
      portfolioId: entity.portfolioId,
      eventId: entity.eventId,
    );
  }
}

extension PortfolioEventModelExtension on PortfolioEventModel {
  PortfolioEventEntity toEntity() {
    return PortfolioEventEntity(
      portfolioId: portfolioId,
      eventId: eventId,
    );
  }
}
