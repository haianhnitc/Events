import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/user_management/domain/entity/user_profile_entity.dart';
import 'package:events_app/feature/user_management/domain/entity/organization_profile_entity.dart';
import 'package:events_app/feature/user_management/domain/entity/verification_document_entity.dart';

class UserEntity {
  final int? userId;
  final String email;
  final String firebaseUid;
  final String? phoneNumber;
  final UserRole? role;
  final UserStatus? status;
  final int currentCoin;
  final DateTime? createdTime;
  final UserProfileEntity? userProfile;
  final OrganizationProfileEntity? organizationProfile;
  final List<VerificationDocumentEntity>? verificationDocuments;

  UserEntity({
    this.userId,
    required this.email,
    required this.firebaseUid,
    this.phoneNumber,
    this.role,
    this.status,
    required this.currentCoin,
    this.createdTime,
    this.userProfile,
    this.organizationProfile,
    this.verificationDocuments,
  });

  UserEntity copyWith({
    int? userId,
    String? email,
    String? firebaseUid,
    String? phoneNumber,
    UserRole? role,
    UserStatus? status,
    int? currentCoin,
    DateTime? createdTime,
    UserProfileEntity? userProfile,
    OrganizationProfileEntity? organizationProfile,
    List<VerificationDocumentEntity>? verificationDocuments,
  }) {
    return UserEntity(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      firebaseUid: firebaseUid ?? this.firebaseUid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      status: status ?? this.status,
      currentCoin: currentCoin ?? this.currentCoin,
      createdTime: createdTime ?? this.createdTime,
      userProfile: userProfile ?? this.userProfile,
      organizationProfile: organizationProfile ?? this.organizationProfile,
      verificationDocuments: verificationDocuments ?? this.verificationDocuments,
    );
  }

  @override
  String toString() {
    return 'UserEntity(userId: $userId, email: $email, firebaseUid: $firebaseUid, '
        'phoneNumber: $phoneNumber, role: $role, status: $status, '
        'currentCoin: $currentCoin, '
        'createdTime: $createdTime, userProfile: $userProfile, '
        'organizationProfile: $organizationProfile, '
        'verificationDocuments: $verificationDocuments)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity &&
        other.userId == userId &&
        other.email == email &&
        other.firebaseUid == firebaseUid &&
        other.phoneNumber == phoneNumber &&
        other.role == role &&
        other.status == status &&
        other.currentCoin == currentCoin &&
        other.createdTime == createdTime &&
        other.userProfile == userProfile &&
        other.organizationProfile == organizationProfile &&
        _listEquals(other.verificationDocuments, verificationDocuments);
  }

  static bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null) return false;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode {
    return Object.hash(
      userId,
      email,
      firebaseUid,
      phoneNumber,
      role,
      status,
      currentCoin,
      createdTime,
      userProfile,
      organizationProfile,
      verificationDocuments == null
          ? null
          : Object.hashAll(verificationDocuments!),
    );
  }
}
