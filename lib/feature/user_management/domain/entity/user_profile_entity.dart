class UserProfileEntity {
  final int? userId;
  final String? fullName;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? university;
  final String? faculty;
  final String? major;
  final String? studentCode;
  final String? avatarUrl;

  UserProfileEntity({
    this.userId,
    this.fullName,
    this.gender,
    this.dateOfBirth,
    this.university,
    this.faculty,
    this.major,
    this.studentCode,
    this.avatarUrl,
  });
}
