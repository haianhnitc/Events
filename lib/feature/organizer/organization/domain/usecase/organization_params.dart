import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class OrganizationProfileUpdateParams {
  final String? organizationName;
  final OrganizationType? organizationType;
  final String? address;
  final int? logoFileId;
  final String? description;

  const OrganizationProfileUpdateParams({
    this.organizationName,
    this.organizationType,
    this.address,
    this.logoFileId,
    this.description,
  });

  Map<String, dynamic> toJson() => {
        if (organizationName != null) 'organizationName': organizationName,
        if (organizationType != null) 'organizationType': organizationType?.apiValue,
        if (address != null) 'address': address,
        if (logoFileId != null) 'logoFileId': logoFileId,
        if (description != null) 'description': description,
      };
}
