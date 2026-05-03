import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/user_management/domain/entity/user_summary_entity.dart';

part 'user_summary_model.freezed.dart';
part 'user_summary_model.g.dart';

@freezed
class UserSummaryModel with _$UserSummaryModel {
  const factory UserSummaryModel({
    int? userId,
    String? fullName,
    String? email,
    String? avatarUrl,
    UserRole? role,
    UserStatus? status,
    DateTime? joinedAt,
  }) = _UserSummaryModel;

  factory UserSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$UserSummaryModelFromJson(json);

  factory UserSummaryModel.fromEntity(UserSummaryEntity entity) {
    return UserSummaryModel(
      userId: entity.userId,
      fullName: entity.fullName,
      email: entity.email,
      avatarUrl: entity.avatarUrl,
      role: entity.role,
      status: entity.status,
      joinedAt: entity.joinedAt,
    );
  }
}

extension UserSummaryModelExtension on UserSummaryModel {
  UserSummaryEntity toEntity() {
    return UserSummaryEntity(
      userId: userId,
      fullName: fullName,
      email: email,
      avatarUrl: avatarUrl,
      role: role,
      status: status,
      joinedAt: joinedAt,
    );
  }
}
