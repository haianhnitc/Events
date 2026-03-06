import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class UserEntity {
  final int? userId;
  final String email;
  final String firebaseUid;
  final String? phoneNumber;
  final UserRole? role;
  final UserStatus? status;
  final int? currentCoin;
  final int remainingFreePortfolios;
  final DateTime? createdTime;

  UserEntity({
    this.userId,
    required this.email,
    required this.firebaseUid,
    this.phoneNumber,
    this.role,
    this.status,
    this.currentCoin,
    required this.remainingFreePortfolios,
    this.createdTime,
  });
}
