import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class UserPackageEntity {
  final int? userPackageId;
  final int? userId;
  final int? packageId;
  final UserPackageStatus? status;
  final DateTime? startTime;
  final DateTime? endTime;
  final bool? autoRenew;
  final DateTime? createdTime;

  UserPackageEntity({
    this.userPackageId,
    this.userId,
    this.packageId,
    this.status,
    this.startTime,
    this.endTime,
    this.autoRenew,
    this.createdTime,
  });
}
