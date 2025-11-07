import 'package:events_app/authentication/domain/entity/user_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    String? email,
    String? displayName,
  }) = _UserModel;

  // Enable json serialization generation
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromFirebaseUser(dynamic user) {
    return UserModel(
        uid: user.uid, email: user.email, displayName: user.displayName);
  }
}

extension UserModeToEntity on UserModel {
  UserEntity toEntity() {
    return UserEntity(uid: uid, email: email, displayName: displayName);
  }
}
