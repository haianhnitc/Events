import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:events_app/feature/user_management/domain/entity/user_entity.dart';
import 'package:events_app/feature/user_management/domain/repository/user_repository.dart';
import 'package:injectable/injectable.dart';

class UpdateCurrentUserParams {
  final String? fullName;
  final String? gender;
  final DateTime? dateOfBirth;
  final int? avatarFileId;
  final String? address;
  final String? logoUrl;
  final String? description;

  const UpdateCurrentUserParams({
    this.fullName,
    this.gender,
    this.dateOfBirth,
    this.avatarFileId,
    this.address,
    this.logoUrl,
    this.description,
  });

  Map<String, dynamic> toJson() => {
        if (fullName != null) 'fullName': fullName,
        if (gender != null) 'gender': gender,
        if (dateOfBirth != null) 'dateOfBirth': dateOfBirth!.toIso8601String().split('T').first,
        if (avatarFileId != null) 'avatarFileId': avatarFileId,
        if (address != null) 'address': address,
        if (logoUrl != null) 'logoUrl': logoUrl,
        if (description != null) 'description': description,
      };

  bool get isEmpty =>
      fullName == null &&
      gender == null &&
      dateOfBirth == null &&
      avatarFileId == null &&
      address == null &&
      logoUrl == null &&
      description == null;
}

@injectable
class UpdateCurrentUserUsecase implements UseCase<UserEntity?, UpdateCurrentUserParams> {
  final UserRepository _repository;

  UpdateCurrentUserUsecase(this._repository);

  @override
  Future<Either<FailureEntity, UserEntity?>> call(UpdateCurrentUserParams params) async {
    return await _repository.updateCurrentUser(params);
  }
}
