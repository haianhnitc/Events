import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/user_profile_entity.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

@freezed
class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    int? userId,
    String? fullName,
    String? avatarUrl,
    String? gender,
    DateTime? dateOfBirth,
    String? university,
    String? faculty,
    String? major,
    String? studentCode,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  factory UserProfileModel.fromEntity(UserProfileEntity entity) {
    return UserProfileModel(
      userId: entity.userId,
      fullName: entity.fullName,
      avatarUrl: entity.avatarUrl,
      gender: entity.gender,
      dateOfBirth: entity.dateOfBirth,
      university: entity.university,
      faculty: entity.faculty,
      major: entity.major,
      studentCode: entity.studentCode,
    );
  }
}

extension UserProfileModelExtension on UserProfileModel {
  UserProfileEntity toEntity() {
    return UserProfileEntity(
      userId: userId,
      fullName: fullName,
      avatarUrl: avatarUrl,
      gender: gender,
      dateOfBirth: dateOfBirth,
      university: university,
      faculty: faculty,
      major: major,
      studentCode: studentCode,
    );
  }
}
