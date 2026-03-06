class PackageEntity {
  final int? packageId;
  final String? name;
  final String? description;
  final int? price;
  final int? durationDays;
  final bool? isActive;
  final DateTime? createdTime;

  PackageEntity({
    this.packageId,
    this.name,
    this.description,
    this.price,
    this.durationDays,
    this.isActive,
    this.createdTime,
  });
}
