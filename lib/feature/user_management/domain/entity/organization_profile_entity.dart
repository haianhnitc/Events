import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class OrganizationProfileEntity {
  final int? userId;
  final String? organizationName;
  final OrganizationType? organizationType;
  final String? address;
  final String? logoUrl;
  final String? description;
  final VerificationStatus? verificationStatus;
  final DateTime? verifiedTime;

  OrganizationProfileEntity({
    this.userId,
    this.organizationName,
    this.organizationType,
    this.address,
    this.logoUrl,
    this.description,
    this.verificationStatus,
    this.verifiedTime,
  });
}
