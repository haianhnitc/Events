import 'package:freezed_annotation/freezed_annotation.dart';

part 'portfolio_create_model.freezed.dart';
part 'portfolio_create_model.g.dart';

@freezed
class PortfolioItemCreateModel with _$PortfolioItemCreateModel {
  const factory PortfolioItemCreateModel({
    required int eventParticipantId,
    String? displayTitle,
    String? displayRole,
    String? displayNote,
    int? displayOrder,
  }) = _PortfolioItemCreateModel;

  factory PortfolioItemCreateModel.fromJson(Map<String, dynamic> json) =>
      _$PortfolioItemCreateModelFromJson(json);
}

@freezed
class PortfolioCreateModel with _$PortfolioCreateModel {
  const factory PortfolioCreateModel({
    required String title,
    String? description,
    @Default(0) int price,
    @Default(0) int coinUsed,
    List<PortfolioItemCreateModel>? items,
  }) = _PortfolioCreateModel;

  factory PortfolioCreateModel.fromJson(Map<String, dynamic> json) =>
      _$PortfolioCreateModelFromJson(json);
}
