import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class UserSummaryEntity {
  final int? userId;
  final String? fullName;
  final String? email;
  final String? avatarUrl;
  final UserRole? role;
  final UserStatus? status;
  final DateTime? joinedAt;

  UserSummaryEntity({
    this.userId,
    this.fullName,
    this.email,
    this.avatarUrl,
    this.role,
    this.status,
    this.joinedAt,
  });

  UserSummaryEntity copyWith({
    int? userId,
    String? fullName,
    String? email,
    String? avatarUrl,
    UserRole? role,
    UserStatus? status,
    DateTime? joinedAt,
  }) {
    return UserSummaryEntity(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      status: status ?? this.status,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  @override
  String toString() =>
      'UserSummaryEntity(userId: $userId, fullName: $fullName, role: $role)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserSummaryEntity &&
        other.userId == userId &&
        other.fullName == fullName &&
        other.avatarUrl == avatarUrl &&
        other.role == role;
  }

  @override
  int get hashCode => Object.hash(userId, fullName, email, avatarUrl, role);
}
