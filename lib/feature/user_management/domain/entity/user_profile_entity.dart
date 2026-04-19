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
  final int remainingFreePortfolios;

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
    this.remainingFreePortfolios = 0,
  });

  UserProfileEntity copyWith({
    int? userId,
    String? fullName,
    String? gender,
    DateTime? dateOfBirth,
    String? university,
    String? faculty,
    String? major,
    String? studentCode,
    String? avatarUrl,
    int? remainingFreePortfolios,
  }) {
    return UserProfileEntity(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      university: university ?? this.university,
      faculty: faculty ?? this.faculty,
      major: major ?? this.major,
      studentCode: studentCode ?? this.studentCode,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      remainingFreePortfolios:
          remainingFreePortfolios ?? this.remainingFreePortfolios,
    );
  }

  @override
  String toString() {
    return 'UserProfileEntity(userId: $userId, fullName: $fullName, gender: $gender, '
        'dateOfBirth: $dateOfBirth, university: $university, faculty: $faculty, '
        'major: $major, studentCode: $studentCode, avatarUrl: $avatarUrl, '
        'remainingFreePortfolios: $remainingFreePortfolios)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfileEntity &&
        other.userId == userId &&
        other.fullName == fullName &&
        other.gender == gender &&
        other.dateOfBirth == dateOfBirth &&
        other.university == university &&
        other.faculty == faculty &&
        other.major == major &&
        other.studentCode == studentCode &&
        other.avatarUrl == avatarUrl &&
        other.remainingFreePortfolios == remainingFreePortfolios;
  }

  @override
  int get hashCode {
    return Object.hash(
      userId,
      fullName,
      gender,
      dateOfBirth,
      university,
      faculty,
      major,
      studentCode,
      avatarUrl,
      remainingFreePortfolios,
    );
  }
}
