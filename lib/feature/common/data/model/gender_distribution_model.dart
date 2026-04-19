import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/gender_distribution_entity.dart';

part 'gender_distribution_model.freezed.dart';
part 'gender_distribution_model.g.dart';

@freezed
class GenderDistributionModel with _$GenderDistributionModel {
  const factory GenderDistributionModel({
    int? male,
    double? malePercentage,
    int? female,
    double? femalePercentage,
    int? other,
    double? otherPercentage,
  }) = _GenderDistributionModel;

  factory GenderDistributionModel.fromJson(Map<String, dynamic> json) =>
      _$GenderDistributionModelFromJson(json);

  factory GenderDistributionModel.fromEntity(GenderDistributionEntity entity) {
    return GenderDistributionModel(
      male: entity.male,
      malePercentage: entity.malePercentage,
      female: entity.female,
      femalePercentage: entity.femalePercentage,
      other: entity.other,
      otherPercentage: entity.otherPercentage,
    );
  }
}

extension GenderDistributionModelExtension on GenderDistributionModel {
  GenderDistributionEntity toEntity() {
    return GenderDistributionEntity(
      male: male,
      malePercentage: malePercentage,
      female: female,
      femalePercentage: femalePercentage,
      other: other,
      otherPercentage: otherPercentage,
    );
  }
}
