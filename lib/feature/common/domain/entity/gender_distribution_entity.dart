class GenderDistributionEntity {
  final int? male;
  final double? malePercentage;
  final int? female;
  final double? femalePercentage;
  final int? other;
  final double? otherPercentage;

  GenderDistributionEntity({
    this.male,
    this.malePercentage,
    this.female,
    this.femalePercentage,
    this.other,
    this.otherPercentage,
  });

  GenderDistributionEntity copyWith({
    int? male,
    double? malePercentage,
    int? female,
    double? femalePercentage,
    int? other,
    double? otherPercentage,
  }) {
    return GenderDistributionEntity(
      male: male ?? this.male,
      malePercentage: malePercentage ?? this.malePercentage,
      female: female ?? this.female,
      femalePercentage: femalePercentage ?? this.femalePercentage,
      other: other ?? this.other,
      otherPercentage: otherPercentage ?? this.otherPercentage,
    );
  }

  @override
  String toString() =>
      'GenderDistributionEntity(male: $male, female: $female, other: $other)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GenderDistributionEntity &&
        other.male == male &&
        other.female == female &&
        other.other == other;
  }

  @override
  int get hashCode => Object.hash(male, female, other);
}
