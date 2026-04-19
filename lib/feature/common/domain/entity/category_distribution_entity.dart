class CategoryDistributionEntity {
  final String? name;
  final int? count;
  final double? percentage;

  CategoryDistributionEntity({
    this.name,
    this.count,
    this.percentage,
  });

  CategoryDistributionEntity copyWith({
    String? name,
    int? count,
    double? percentage,
  }) {
    return CategoryDistributionEntity(
      name: name ?? this.name,
      count: count ?? this.count,
      percentage: percentage ?? this.percentage,
    );
  }

  @override
  String toString() =>
      'CategoryDistributionEntity(name: $name, count: $count, percentage: $percentage)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryDistributionEntity &&
        other.name == name &&
        other.count == count;
  }

  @override
  int get hashCode => Object.hash(name, count);
}
