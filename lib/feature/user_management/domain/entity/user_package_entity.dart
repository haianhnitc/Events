import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class UserPackageEntity {
  final int? userPackageId;
  final int? userId;
  final int? packageId;
  final String? packageName;
  final UserPackageStatus? status;
  final DateTime? startTime;
  final DateTime? endTime;
  final num? price;
  final DateTime? createdTime;
  final bool? autoRenew;

  UserPackageEntity({
    this.userPackageId,
    this.userId,
    this.packageId,
    this.packageName,
    this.status,
    this.startTime,
    this.endTime,
    this.price,
    this.createdTime,
    this.autoRenew,
  });
}
