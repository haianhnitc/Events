import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class SignupParams {
  final String idToken;
  final bool isUser;
  final String email;
  final String? phoneNumber;
  final SignupUserProfileParams? userProfile;
  final SignupOrganizationProfileParams? organizationProfile;
  final List<int> verificationDocumentIds;

  const SignupParams({
    required this.idToken,
    required this.isUser,
    required this.email,
    this.phoneNumber,
    this.userProfile,
    this.organizationProfile,
    this.verificationDocumentIds = const [],
  });

  factory SignupParams.withIdToken(String newIdToken, SignupParams instance) {
    return SignupParams._(
      idToken: newIdToken,
      isUser: instance.isUser,
      email: instance.email,
      phoneNumber: instance.phoneNumber,
      userProfile: instance.userProfile,
      organizationProfile: instance.organizationProfile,
      verificationDocumentIds: instance.verificationDocumentIds,
    );
  }

  SignupParams._({
    required this.idToken,
    required this.isUser,
    required this.email,
    this.phoneNumber,
    this.userProfile,
    this.organizationProfile,
    this.verificationDocumentIds = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'firebaseIdToken': idToken,
      'isUser': isUser,
      'email': email,
      'phoneNumber': phoneNumber,
      'userProfile': userProfile?.toJson(),
      'organizationProfile': organizationProfile?.toJson(),
      'verificationDocumentIds': verificationDocumentIds,
    };
  }
}

class SignupUserProfileParams {
  final String? fullName;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? studentCode;
  final String? university;
  final String? faculty;
  final String? major;
  final int? avatarFileId;

  const SignupUserProfileParams({
    this.fullName,
    this.gender,
    this.dateOfBirth,
    this.studentCode,
    this.university,
    this.faculty,
    this.major,
    this.avatarFileId,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.toIso8601String().split('T').first,
      'studentCode': studentCode,
      'university': university,
      'faculty': faculty,
      'major': major,
      'avatarFileId': avatarFileId,
    };
  }
}

class SignupOrganizationProfileParams {
  final String organizationName;
  final OrganizationType organizationType;
  final String? address;
  final int? logoFileId;
  final String? description;

  const SignupOrganizationProfileParams({
    required this.organizationName,
    required this.organizationType,
    this.address,
    this.logoFileId,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'organizationName': organizationName,
      'organizationType': organizationType.apiValue,
      'address': address,
      'logoFileId': logoFileId,
      'description': description,
    };
  }
}
