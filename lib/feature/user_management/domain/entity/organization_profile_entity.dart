import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class OrganizationProfileEntity {
  final int? userId;
  final String? organizationName;
  final String? description;
  final OrganizationType? organizationType;
  final String? logoUrl;
  final VerificationStatus? verificationStatus;
  final DateTime? verifiedTime;
  final String? address;

  OrganizationProfileEntity({
    this.userId,
    this.organizationName,
    this.description,
    this.organizationType,
    this.logoUrl,
    this.verificationStatus,
    this.verifiedTime,
    this.address,
  });

  OrganizationProfileEntity copyWith({
    int? userId,
    String? organizationName,
    String? description,
    OrganizationType? organizationType,
    String? logoUrl,
    VerificationStatus? verificationStatus,
    DateTime? verifiedTime,
    String? address,
  }) {
    return OrganizationProfileEntity(
      userId: userId ?? this.userId,
      organizationName: organizationName ?? this.organizationName,
      description: description ?? this.description,
      organizationType: organizationType ?? this.organizationType,
      logoUrl: logoUrl ?? this.logoUrl,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      verifiedTime: verifiedTime ?? this.verifiedTime,
      address: address ?? this.address,
    );
  }

  @override
  String toString() {
    return 'OrganizationProfileEntity(userId: $userId, organizationName: $organizationName, '
        'description: $description, organizationType: $organizationType, '
        'logoUrl: $logoUrl, verificationStatus: $verificationStatus, '
        'verifiedTime: $verifiedTime, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrganizationProfileEntity &&
        other.userId == userId &&
        other.organizationName == organizationName &&
        other.description == description &&
        other.organizationType == organizationType &&
        other.logoUrl == logoUrl &&
        other.verificationStatus == verificationStatus &&
        other.verifiedTime == verifiedTime &&
        other.address == address;
  }

  @override
  int get hashCode {
    return Object.hash(
      userId,
      organizationName,
      description,
      organizationType,
      logoUrl,
      verificationStatus,
      verifiedTime,
      address,
    );
  }
}
