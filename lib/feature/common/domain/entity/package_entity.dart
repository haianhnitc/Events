class PackageEntity {
  final int? packageId;
  final String? packageName;
  final String? name;
  final String? description;
  final int? price;
  final int? duration;
  final int? durationDays;
  final bool? isActive;

  PackageEntity({
    this.packageId,
    this.packageName,
    this.name,
    this.description,
    this.price,
    this.duration,
    this.durationDays,
    this.isActive,
  });
}
