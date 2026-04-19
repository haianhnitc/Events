import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class OrganizationProfileUpdateParams {
  final int? organizationId;
  final String? organizationName;
  final OrganizationType? organizationType;
  final String? address;
  final String? logoUrl;
  final String? description;
  final VerificationStatus? verificationStatus;

  const OrganizationProfileUpdateParams({
    this.organizationId,
    this.organizationName,
    this.organizationType,
    this.address,
    this.logoUrl,
    this.description,
    this.verificationStatus,
  });

  Map<String, dynamic> toJson() => {
        if (organizationId != null) 'organizationId': organizationId,
        if (organizationName != null) 'organizationName': organizationName,
        if (organizationType != null) 'organizationType': organizationType?.apiValue,
        if (address != null) 'address': address,
        if (logoUrl != null) 'logoUrl': logoUrl,
        if (description != null) 'description': description,
        if (verificationStatus != null)
          'verificationStatus': verificationStatus?.apiValue,
      };
}
