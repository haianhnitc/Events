import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import '../../domain/entity/organization_profile_entity.dart';

part 'organization_profile_model.freezed.dart';
part 'organization_profile_model.g.dart';

@freezed
class OrganizationProfileModel with _$OrganizationProfileModel {
  const factory OrganizationProfileModel({
    int? userId,
    String? organizationName,
    String? description,
    OrganizationType? organizationType,
    String? logoUrl,
    VerificationStatus? verificationStatus,
    DateTime? verifiedTime,
    String? address,
  }) = _OrganizationProfileModel;

  factory OrganizationProfileModel.fromJson(Map<String, dynamic> json) =>
      _$OrganizationProfileModelFromJson(json);

  factory OrganizationProfileModel.fromEntity(
      OrganizationProfileEntity entity) {
    return OrganizationProfileModel(
      userId: entity.userId,
      organizationName: entity.organizationName,
      description: entity.description,
      organizationType: entity.organizationType,
      logoUrl: entity.logoUrl,
      verificationStatus: entity.verificationStatus,
      verifiedTime: entity.verifiedTime,
      address: entity.address,
    );
  }
}

extension OrganizationProfileModelExtension on OrganizationProfileModel {
  OrganizationProfileEntity toEntity() {
    return OrganizationProfileEntity(
      userId: userId,
      organizationName: organizationName,
      description: description,
      organizationType: organizationType,
      logoUrl: logoUrl,
      verificationStatus: verificationStatus,
      verifiedTime: verifiedTime,
      address: address,
    );
  }
}
