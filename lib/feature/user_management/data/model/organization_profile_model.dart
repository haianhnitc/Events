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
    OrganizationType? organizationType,
    String? address,
    String? logoUrl,
    String? description,
    @Default(VerificationStatus.pending) VerificationStatus? verificationStatus,
    DateTime? verifiedTime,
  }) = _OrganizationProfileModel;

  factory OrganizationProfileModel.fromJson(Map<String, dynamic> json) =>
      _$OrganizationProfileModelFromJson(json);

  factory OrganizationProfileModel.fromEntity(
      OrganizationProfileEntity entity) {
    return OrganizationProfileModel(
      userId: entity.userId,
      organizationName: entity.organizationName,
      organizationType: entity.organizationType,
      address: entity.address,
      logoUrl: entity.logoUrl,
      description: entity.description,
      verificationStatus: entity.verificationStatus,
      verifiedTime: entity.verifiedTime,
    );
  }
}

extension OrganizationProfileModelExtension on OrganizationProfileModel {
  OrganizationProfileEntity toEntity() {
    return OrganizationProfileEntity(
      userId: userId,
      organizationName: organizationName,
      organizationType: organizationType,
      address: address,
      logoUrl: logoUrl,
      description: description,
      verificationStatus: verificationStatus,
      verifiedTime: verifiedTime,
    );
  }
}
